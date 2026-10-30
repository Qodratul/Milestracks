import type { LoopRouteRequest, RoutePoint, RouteResult, RoutingProvider } from "./types";
import { RoutingProviderError } from "./types";

const DEFAULT_CANDIDATE_COUNT = 3;
const DEFAULT_MAX_ADJUSTMENTS = 2;
const DEFAULT_MAX_SNAP_DISTANCE_METERS = 250;
const DEFAULT_DISTANCE_TOLERANCE_RATIO = 0.15;
const INITIAL_DISTANCE_RATIO = 0.67;
const ROUND_TRIP_SEEDS = [7, 31, 89] as const;
const U_TURN_SIGNS = new Set([-98, -8, 8]);

export interface LoopGenerationInput {
  readonly start: RoutePoint;
  readonly targetDistanceMeters: number;
  readonly candidateCount?: number;
  readonly seedOffset?: number | undefined;
  readonly maxAdjustments?: number;
  readonly maxSnapDistanceMeters?: number;
  readonly distanceToleranceRatio?: number;
}

export interface LoopCandidate {
  readonly id: string;
  readonly valid: boolean;
  readonly failureReason:
    "SNAP_TOO_FAR" | "DISTANCE_OUT_OF_TOLERANCE" | "ROUTING_FAILED" | null;
  readonly routingErrorCode?: RoutingProviderError["code"];
  readonly routingStatusCode?: number;
  readonly routingRateLimitInfo?: Readonly<Record<string, string>>;
  readonly attempts: number;
  readonly latencySamplesMs: readonly number[];
  readonly distanceSamplesMeters: readonly number[];
  readonly requestedDistanceMeters: number;
  readonly snapDistanceMeters: number | null;
  readonly distanceErrorRatio: number | null;
  readonly turnsPerKm: number | null;
  readonly uTurnCount: number | null;
  readonly route: RouteResult | null;
}

export async function generateLoopCandidates(
  provider: RoutingProvider,
  input: LoopGenerationInput,
): Promise<readonly LoopCandidate[]> {
  validateInput(input);
  const candidateCount = input.candidateCount ?? DEFAULT_CANDIDATE_COUNT;
  const seedOffset = input.seedOffset ?? 0;
  if (!Number.isSafeInteger(seedOffset) || seedOffset < 0) {
    throw new RangeError("Seed offset must be a non-negative safe integer.");
  }
  const maxAdjustments = input.maxAdjustments ?? DEFAULT_MAX_ADJUSTMENTS;
  const maxSnapDistance = input.maxSnapDistanceMeters ?? DEFAULT_MAX_SNAP_DISTANCE_METERS;
  const distanceTolerance =
    input.distanceToleranceRatio ?? DEFAULT_DISTANCE_TOLERANCE_RATIO;
  if (!Number.isSafeInteger(candidateCount) || candidateCount < 2 || candidateCount > 3) {
    throw new RangeError("Candidate count must be 2 or 3.");
  }
  if (!Number.isSafeInteger(maxAdjustments) || maxAdjustments < 0 || maxAdjustments > 2) {
    throw new RangeError("At most two distance adjustments are allowed.");
  }
  return Promise.all(
    Array.from({ length: candidateCount }, (_, index) =>
      buildCandidate(provider, input, {
        index,
        maxAdjustments,
        maxSnapDistance,
        distanceTolerance,
      }),
    ),
  );
}

async function buildCandidate(
  provider: RoutingProvider,
  input: LoopGenerationInput,
  options: {
    readonly index: number;
    readonly maxAdjustments: number;
    readonly maxSnapDistance: number;
    readonly distanceTolerance: number;
  },
): Promise<LoopCandidate> {
  const candidateId = "loop-" + (options.index + 1);
  const baseSeed = ROUND_TRIP_SEEDS[options.index];
  const seed = baseSeed === undefined ? undefined : baseSeed + (input.seedOffset ?? 0);
  if (seed === undefined || !Number.isSafeInteger(seed))
    throw new RangeError("No deterministic seed exists for this candidate.");
  let requestedDistanceMeters = input.targetDistanceMeters * INITIAL_DISTANCE_RATIO;
  let route: RouteResult | null = null;
  let snapDistanceMeters: number | null = null;
  let distanceErrorRatio: number | null = null;
  let attempts = 0;
  const latencySamplesMs: number[] = [];
  const distanceSamplesMeters: number[] = [];

  for (let adjustment = 0; adjustment <= options.maxAdjustments; adjustment += 1) {
    attempts += 1;
    try {
      const request: LoopRouteRequest = {
        start: input.start,
        targetDistanceMeters: requestedDistanceMeters,
        seed,
      };
      route = await provider.routeLoop(request);
      latencySamplesMs.push(route.providerLatencyMs);
      distanceSamplesMeters.push(route.distanceMeters);
    } catch (error) {
      if (
        error instanceof RoutingProviderError &&
        error.providerLatencyMs !== undefined
      ) {
        latencySamplesMs.push(error.providerLatencyMs);
      }
      return failedCandidate(
        candidateId,
        attempts,
        requestedDistanceMeters,
        latencySamplesMs,
        distanceSamplesMeters,
        error,
      );
    }
    const snappedStart = route.snappedWaypoints[0] ?? route.geometry[0];
    snapDistanceMeters = snappedStart ? distanceBetween(input.start, snappedStart) : null;
    if (snapDistanceMeters === null || snapDistanceMeters > options.maxSnapDistance) {
      return {
        ...candidateBase(
          candidateId,
          attempts,
          latencySamplesMs,
          distanceSamplesMeters,
          requestedDistanceMeters,
        ),
        valid: false,
        failureReason: "SNAP_TOO_FAR",
        snapDistanceMeters,
        distanceErrorRatio: null,
        turnsPerKm: null,
        uTurnCount: countUTurns(route),
        route,
      };
    }
    distanceErrorRatio =
      Math.abs(route.distanceMeters - input.targetDistanceMeters) /
      input.targetDistanceMeters;
    if (distanceErrorRatio <= options.distanceTolerance) {
      return {
        ...candidateBase(
          candidateId,
          attempts,
          latencySamplesMs,
          distanceSamplesMeters,
          requestedDistanceMeters,
        ),
        valid: true,
        failureReason: null,
        snapDistanceMeters,
        distanceErrorRatio,
        turnsPerKm: calculateTurnsPerKm(route),
        uTurnCount: countUTurns(route),
        route,
      };
    }
    if (adjustment < options.maxAdjustments && route.distanceMeters > 0) {
      requestedDistanceMeters = Math.max(
        100,
        Math.min(
          input.targetDistanceMeters,
          requestedDistanceMeters *
            Math.sqrt(input.targetDistanceMeters / route.distanceMeters),
        ),
      );
    }
  }

  return {
    ...candidateBase(
      candidateId,
      attempts,
      latencySamplesMs,
      distanceSamplesMeters,
      requestedDistanceMeters,
    ),
    valid: false,
    failureReason: "DISTANCE_OUT_OF_TOLERANCE",
    snapDistanceMeters,
    distanceErrorRatio,
    turnsPerKm: route ? calculateTurnsPerKm(route) : null,
    uTurnCount: route ? countUTurns(route) : null,
    route,
  };
}

function validateInput(input: LoopGenerationInput): void {
  if (!Number.isFinite(input.targetDistanceMeters) || input.targetDistanceMeters <= 0) {
    throw new RangeError("Target distance must be positive.");
  }
}

function candidateBase(
  id: string,
  attempts: number,
  latencySamplesMs: readonly number[],
  distanceSamplesMeters: readonly number[],
  requestedDistanceMeters: number,
): Pick<
  LoopCandidate,
  | "id"
  | "attempts"
  | "latencySamplesMs"
  | "distanceSamplesMeters"
  | "requestedDistanceMeters"
> {
  return {
    id,
    attempts,
    latencySamplesMs,
    distanceSamplesMeters,
    requestedDistanceMeters,
  };
}

function calculateTurnsPerKm(route: RouteResult): number {
  if (route.distanceMeters <= 0) return 0;
  const turns = route.instructions.filter(
    (instruction) =>
      instruction.sign !== undefined && ![0, 4, 5, 6].includes(instruction.sign),
  ).length;
  return turns / (route.distanceMeters / 1_000);
}

function countUTurns(route: RouteResult): number {
  return route.instructions.filter(
    (instruction) => instruction.sign !== undefined && U_TURN_SIGNS.has(instruction.sign),
  ).length;
}

function failedCandidate(
  id: string,
  attempts: number,
  requestedDistanceMeters: number,
  latencySamplesMs: readonly number[],
  distanceSamplesMeters: readonly number[],
  error: unknown,
): LoopCandidate {
  const routingError = error instanceof RoutingProviderError ? error : undefined;
  return {
    ...candidateBase(
      id,
      attempts,
      latencySamplesMs,
      distanceSamplesMeters,
      requestedDistanceMeters,
    ),
    valid: false,
    failureReason: "ROUTING_FAILED",
    ...(routingError ? { routingErrorCode: routingError.code } : {}),
    ...(routingError?.statusCode === undefined
      ? {}
      : { routingStatusCode: routingError.statusCode }),
    ...(routingError?.rateLimitInfo
      ? { routingRateLimitInfo: routingError.rateLimitInfo }
      : {}),
    snapDistanceMeters: null,
    distanceErrorRatio: null,
    turnsPerKm: null,
    uTurnCount: null,
    route: null,
  };
}

function distanceBetween(first: RoutePoint, second: RoutePoint): number {
  const latitudeDelta = ((second.lat - first.lat) * Math.PI) / 180;
  const longitudeDelta = ((second.lng - first.lng) * Math.PI) / 180;
  const firstLatitude = (first.lat * Math.PI) / 180;
  const secondLatitude = (second.lat * Math.PI) / 180;
  const haversine =
    Math.sin(latitudeDelta / 2) ** 2 +
    Math.cos(firstLatitude) *
      Math.cos(secondLatitude) *
      Math.sin(longitudeDelta / 2) ** 2;
  return 6_371_008.8 * 2 * Math.asin(Math.sqrt(haversine));
}

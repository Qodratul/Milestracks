import { z } from "zod";
import { env } from "../../config/env";
import type { LoopRouteRequest, RoutePoint, RouteResult, RoutingProvider } from "./types";
import { RoutingProviderError } from "./types";

const lineSchema = z.object({ coordinates: z.array(z.array(z.number()).min(2)) });
const pathDetailSchema = z.array(
  z.tuple([z.number().int(), z.number().int(), z.string().nullable()]),
);
const graphHopperResponseSchema = z.object({
  paths: z
    .array(
      z.object({
        distance: z.number().finite().nonnegative(),
        time: z.number().finite().nonnegative(),
        points: lineSchema,
        snapped_waypoints: lineSchema.optional(),
        instructions: z
          .array(
            z.object({
              text: z.string(),
              distance: z.number().finite().nonnegative(),
              sign: z.number().int().optional(),
            }),
          )
          .optional(),
        details: z.record(z.string(), pathDetailSchema).optional(),
      }),
    )
    .min(1),
});

export interface GraphHopperRoutingOptions {
  readonly apiKey?: string;
  readonly baseUrl?: string;
  readonly profile?: string;
  readonly timeoutMs?: number;
  readonly creditsPerMinute?: number;
  readonly minRequestIntervalMs?: number;
  readonly request?: typeof fetch;
}

interface CreditReservation {
  readonly createdAt: number;
  readonly credits: number;
}

const creditReservations: CreditReservation[] = [];
let graphHopperRequestQueue: Promise<void> = Promise.resolve();
let lastGraphHopperRequestAt = 0;

export class GraphHopperRoutingProvider implements RoutingProvider {
  public constructor(private readonly options: GraphHopperRoutingOptions = {}) {}

  public async route(waypoints: readonly RoutePoint[]): Promise<RouteResult> {
    if (waypoints.length < 2)
      throw new TypeError("A route needs at least two waypoints.");
    const url = this.buildUrl(waypoints);
    return this.requestRoute(url, 1, waypoints.length);
  }

  public async routeLoop(request: LoopRouteRequest): Promise<RouteResult> {
    if (request.targetDistanceMeters <= 0) {
      throw new RangeError("Loop target distance must be positive.");
    }
    if (!Number.isSafeInteger(request.seed)) {
      throw new RangeError("Round-trip seed must be a safe integer.");
    }
    const url = this.buildUrl([request.start]);
    url.searchParams.set("algorithm", "round_trip");
    url.searchParams.set(
      "round_trip.distance",
      String(Math.round(request.targetDistanceMeters)),
    );
    url.searchParams.set("round_trip.seed", String(request.seed));
    return this.requestRoute(url, 2, 1);
  }

  private async requestRoute(
    requestUrl: URL,
    creditCost: number,
    waypointCount: number,
  ): Promise<RouteResult> {
    const apiKey = this.options.apiKey ?? env.GRAPHOPPER_API_KEY;
    if (!apiKey) throw new RoutingProviderError("NOT_CONFIGURED");
    const startedAt = performance.now();
    const releaseRequestSlot = await acquireGraphHopperRequestSlot();
    try {
      await reserveGraphHopperCredits(
        creditCost,
        this.options.creditsPerMinute ?? env.GRAPHOPPER_CREDITS_PER_MINUTE,
      );
      const minimumInterval = this.options.minRequestIntervalMs ?? 1_500;
      const waitMs = lastGraphHopperRequestAt + minimumInterval - Date.now();
      if (waitMs > 0) await new Promise<void>((resolve) => setTimeout(resolve, waitMs));
      lastGraphHopperRequestAt = Date.now();
      let response: Response;
      try {
        response = await (this.options.request ?? fetch)(requestUrl, {
          headers: { "User-Agent": "Milestracks/1.0 (route provider)" },
          signal: AbortSignal.timeout(
            this.options.timeoutMs ?? env.GRAPHOPPER_TIMEOUT_MS,
          ),
        });
      } catch (error) {
        const code =
          error instanceof Error && error.name === "TimeoutError"
            ? "TIMEOUT"
            : "REQUEST_FAILED";
        throw new RoutingProviderError(code, undefined, performance.now() - startedAt);
      }
      const payload: unknown = await response.json().catch(() => undefined);
      if (!response.ok) {
        throw new RoutingProviderError(
          "REQUEST_FAILED",
          response.status,
          performance.now() - startedAt,
          response.status === 429 ? readRateLimitInfo(response) : undefined,
        );
      }
      const parsed = graphHopperResponseSchema.safeParse(payload);
      if (!parsed.success || !parsed.data.paths[0]) {
        throw new RoutingProviderError(
          "INVALID_RESPONSE",
          response.status,
          performance.now() - startedAt,
        );
      }
      return toRouteResult(parsed.data.paths[0], waypointCount, startedAt);
    } finally {
      releaseRequestSlot();
    }
  }

  private buildUrl(waypoints: readonly RoutePoint[]): URL {
    const base = this.options.baseUrl ?? env.GRAPHOPPER_BASE_URL;
    const url = new URL("route", base.endsWith("/") ? base : base + "/");
    for (const point of waypoints) {
      url.searchParams.append("point", point.lat + "," + point.lng);
    }
    url.searchParams.set("profile", this.options.profile ?? env.GRAPHOPPER_PROFILE);
    url.searchParams.set("points_encoded", "false");
    url.searchParams.set("instructions", "true");
    for (const detail of ["road_class", "road_environment"]) {
      url.searchParams.append("details", detail);
    }
    url.searchParams.set("key", this.options.apiKey ?? env.GRAPHOPPER_API_KEY ?? "");
    return url;
  }
}

async function acquireGraphHopperRequestSlot(): Promise<() => void> {
  const previous = graphHopperRequestQueue;
  let release!: () => void;
  graphHopperRequestQueue = new Promise<void>((resolve) => {
    release = resolve;
  });
  await previous;
  return release;
}

function readRateLimitInfo(response: Response): Readonly<Record<string, string>> {
  const names = [
    "x-ratelimit-limit",
    "x-ratelimit-remaining",
    "x-ratelimit-reset",
    "x-ratelimit-credits",
  ];
  return Object.fromEntries(
    names.flatMap((name) => {
      const value = response.headers.get(name);
      return value === null ? [] : [[name, value]];
    }),
  );
}

async function reserveGraphHopperCredits(
  credits: number,
  creditsPerMinute: number,
): Promise<void> {
  while (true) {
    const now = Date.now();
    removeExpiredReservations(now);
    const reserved = creditReservations.reduce((sum, item) => sum + item.credits, 0);
    if (reserved + credits <= creditsPerMinute) {
      creditReservations.push({ createdAt: now, credits });
      return;
    }
    const oldest = creditReservations[0];
    if (!oldest)
      throw new RangeError("Request cost exceeds the configured credit limit.");
    await new Promise<void>((resolve) => {
      setTimeout(resolve, Math.max(1, oldest.createdAt + 60_000 - now));
    });
  }
}

function removeExpiredReservations(now: number): void {
  while (creditReservations[0] && creditReservations[0].createdAt <= now - 60_000) {
    creditReservations.shift();
  }
}

function toRouteResult(
  path: z.infer<typeof graphHopperResponseSchema>["paths"][number],
  waypointCount: number,
  startedAt: number,
): RouteResult {
  const geometry = path.points.coordinates.map(toRoutePoint);
  const snapped = (path.snapped_waypoints?.coordinates ?? []).map(toRoutePoint);
  return {
    distanceMeters: path.distance,
    timeMs: path.time,
    geometry,
    snappedWaypoints: snapped.length > 0 ? snapped : geometry.slice(0, waypointCount),
    instructions: (path.instructions ?? []).map((instruction) => ({
      text: instruction.text,
      distanceMeters: instruction.distance,
      ...(instruction.sign === undefined ? {} : { sign: instruction.sign }),
    })),
    ...(path.details
      ? { roadDetails: summarizeRoadDetails(path.details, geometry.length) }
      : {}),
    providerLatencyMs: performance.now() - startedAt,
  };
}

function summarizeRoadDetails(
  details: Readonly<
    Record<string, readonly (readonly [number, number, string | null])[]>
  >,
  pointCount: number,
) {
  const roadClasses = detailValues(details.road_class);
  const roadEnvironments = detailValues(details.road_environment);
  const surfaces = detailValues(details.surface);
  const edgeCount = Math.max(1, pointCount - 1);
  const coveragePermil = Math.round(
    (detailCoverage(details.road_class, edgeCount) +
      detailCoverage(details.road_environment, edgeCount) +
      detailCoverage(details.surface, edgeCount)) /
      3,
  );
  return { roadClasses, roadEnvironments, surfaces, coveragePermil };
}

function detailValues(
  segments: readonly (readonly [number, number, string | null])[] | undefined,
): readonly string[] {
  return [...new Set((segments ?? []).flatMap(([, , value]) => (value ? [value] : [])))];
}

function detailCoverage(
  segments: readonly (readonly [number, number, string | null])[] | undefined,
  edgeCount: number,
): number {
  const coveredEdges = new Set<number>();
  for (const [from, to, value] of segments ?? []) {
    if (value === null) continue;
    for (let edge = Math.max(0, from); edge < Math.min(edgeCount, to); edge += 1) {
      coveredEdges.add(edge);
    }
  }
  return Math.round((coveredEdges.size / edgeCount) * 1000);
}

function toRoutePoint(coordinate: readonly number[]): RoutePoint {
  const longitude = coordinate[0];
  const latitude = coordinate[1];
  if (latitude === undefined || longitude === undefined) {
    throw new RoutingProviderError("INVALID_RESPONSE");
  }
  return { lat: latitude, lng: longitude };
}

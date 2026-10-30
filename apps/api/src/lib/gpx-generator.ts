import { distanceBetween } from "./route-geometry";
import type { RoutePoint } from "../types/routes";
import type { GpxPoint, GpxTrack } from "./gpx";

export const GPX_SCENARIOS = [
  "steady",
  "variable-pace",
  "pause",
  "signal-loss",
  "vehicle",
  "teleport",
  "shortcut",
  "too-smooth",
  "duplicate",
  "replay",
  "mocked",
  "clock-skew",
] as const;

export type GpxScenario = (typeof GPX_SCENARIOS)[number];

export interface GpxGeneratorOptions {
  readonly scenario: GpxScenario;
  readonly seed: number;
  readonly startedAtMs: number;
  readonly paceSecPerKm?: number;
  readonly paceVariationPermil?: number;
  readonly noiseMinMeters?: number;
  readonly noiseMaxMeters?: number;
  readonly accuracyMinMeters?: number;
  readonly accuracyMaxMeters?: number;
  readonly signalLossPermil?: number;
  readonly pauseDurationSec?: number;
}

interface RouteShape {
  readonly points: readonly GpxPoint[];
  readonly cumulativeMeters: readonly number[];
  readonly lengthMeters: number;
}

export function generateSyntheticTrack(
  route: GpxTrack,
  options: GpxGeneratorOptions,
): GpxTrack {
  if (!Number.isInteger(options.seed)) throw new RangeError("Seed must be an integer.");
  if (!Number.isFinite(options.startedAtMs))
    throw new RangeError("Start time must be finite.");
  const shape = buildRouteShape(route.points);
  const rng = createRandom(options.seed);
  const scenario = options.scenario;
  const defaultPace = scenario === "vehicle" ? 55 : 420;
  const paceSecPerKm = options.paceSecPerKm ?? defaultPace;
  if (paceSecPerKm < 30 || paceSecPerKm > 1800) {
    throw new RangeError("Pace must be between 30 and 1800 seconds per kilometer.");
  }
  const defaultVariation =
    scenario === "too-smooth" ? 0 : scenario === "variable-pace" ? 180 : 60;
  const paceVariationPermil = options.paceVariationPermil ?? defaultVariation;
  const defaultNoise = scenario === "too-smooth" ? 0 : 3;
  const noiseMinMeters = options.noiseMinMeters ?? defaultNoise;
  const noiseMaxMeters = options.noiseMaxMeters ?? (scenario === "too-smooth" ? 0 : 8);
  const defaultAccuracy = scenario === "too-smooth" ? 1 : 5;
  const accuracyMinMeters = options.accuracyMinMeters ?? defaultAccuracy;
  const accuracyMaxMeters =
    options.accuracyMaxMeters ?? (scenario === "too-smooth" ? 1 : 30);
  const signalLossPermil =
    options.signalLossPermil ?? (scenario === "signal-loss" ? 120 : 0);
  const pauseDurationSec = options.pauseDurationSec ?? (scenario === "pause" ? 60 : 0);

  assertRange(noiseMinMeters, noiseMaxMeters, "GPS noise");
  assertRange(accuracyMinMeters, accuracyMaxMeters, "GPS accuracy");
  assertPermil(signalLossPermil, "Signal loss");
  assertPermil(paceVariationPermil, "Pace variation");
  if (
    !Number.isInteger(pauseDurationSec) ||
    pauseDurationSec < 0 ||
    pauseDurationSec > 3600
  ) {
    throw new RangeError("Pause duration must be an integer from 0 to 3600 seconds.");
  }

  const raw: GpxPoint[] = [];
  const durationLimitSec =
    Math.ceil((shape.lengthMeters * paceSecPerKm * 2) / 1000) + pauseDurationSec + 120;
  let distanceMeters = 0;
  let elapsedSec = 0;
  let paused = false;
  let currentPaceBlock = -1;
  let paceFactor = 1;
  const sampleNoise = createNoiseSampler(noiseMinMeters, noiseMaxMeters, rng);

  while (distanceMeters < shape.lengthMeters && elapsedSec <= durationLimitSec) {
    const progress = Math.min(1, distanceMeters / shape.lengthMeters);
    const base = routePosition(shape, distanceMeters);
    const currentPoint =
      scenario === "teleport" && progress >= 0.5 && progress < 0.502
        ? routePosition(shape, distanceMeters + shape.lengthMeters * 0.4)
        : scenario === "shortcut"
          ? shortcutPosition(shape, progress, base)
          : base;
    const observed = sampleNoise(currentPoint, elapsedSec);
    const paceBlock = Math.floor(elapsedSec / 60);
    if (paceBlock !== currentPaceBlock) {
      const variation = ((rng() * 2 - 1) * paceVariationPermil) / 1000;
      paceFactor = 1 + variation;
      currentPaceBlock = paceBlock;
    }
    const speedMps = 1000 / (paceSecPerKm * paceFactor);
    const point: GpxPoint = {
      ...observed,
      timestampMs: options.startedAtMs + elapsedSec * 1000,
      elevationMeters: routeElevation(shape, distanceMeters),
      accuracyMeters: accuracyMinMeters + rng() * (accuracyMaxMeters - accuracyMinMeters),
      speedMps,
      mocked: scenario === "mocked",
      segmentIndex: 0,
    };
    if (elapsedSec === 0 || !isSignalLost(elapsedSec, scenario, signalLossPermil, rng))
      raw.push(point);

    if (!paused && pauseDurationSec > 0 && progress >= 0.4) {
      paused = true;
      const stoppedAt = raw[raw.length - 1] ?? point;
      for (let pauseSecond = 1; pauseSecond <= pauseDurationSec; pauseSecond += 1) {
        raw.push({
          ...stoppedAt,
          timestampMs: options.startedAtMs + (elapsedSec + pauseSecond) * 1000,
          speedMps: 0,
        });
      }
      elapsedSec += pauseDurationSec;
    }

    distanceMeters += 1000 / (paceSecPerKm * paceFactor);
    elapsedSec += 1;
  }
  if (raw.length < 2) throw new Error("Generator produced too few samples.");
  let points = raw;

  if (scenario === "duplicate") {
    const duplicateIndex = Math.floor(points.length / 3);
    const source = points[duplicateIndex];
    if (source) points = insertAt(points, duplicateIndex + 1, source);
  }
  if (scenario === "replay") {
    points = [...points, ...points.slice(0, Math.min(40, points.length))];
  }
  if (scenario === "clock-skew") {
    const skewIndex = Math.floor(points.length / 2);
    points = points.map((point, index) =>
      index < skewIndex || point.timestampMs === null
        ? point
        : { ...point, timestampMs: point.timestampMs - 120_000 },
    );
  }

  return {
    name: "milestride-" + scenario + "-seed-" + options.seed,
    description:
      "label=" +
      (scenario === "steady" ||
      scenario === "variable-pace" ||
      scenario === "pause" ||
      scenario === "signal-loss"
        ? "valid"
        : "cheat") +
      "; scenario=" +
      scenario +
      "; seed=" +
      options.seed,
    points,
  };
}

function buildRouteShape(points: readonly GpxPoint[]): RouteShape {
  const unique = points.filter(
    (point, index) => index === 0 || distanceBetween(points[index - 1]!, point) > 0.5,
  );
  if (unique.length > 1 && distanceBetween(unique[0]!, unique[unique.length - 1]!) < 1) {
    unique.pop();
  }
  if (unique.length < 3)
    throw new RangeError("Route GPX needs at least three unique points.");
  const cumulative = [0];
  let lengthMeters = 0;
  for (let index = 0; index < unique.length; index += 1) {
    const next = unique[(index + 1) % unique.length]!;
    lengthMeters += distanceBetween(unique[index]!, next);
    cumulative.push(lengthMeters);
  }
  if (lengthMeters < 100)
    throw new RangeError("Route loop must be at least 100 meters long.");
  return {
    points: unique,
    cumulativeMeters: cumulative,
    lengthMeters,
  };
}

function routePosition(shape: RouteShape, distanceMeters: number): RoutePoint {
  const offset =
    ((distanceMeters % shape.lengthMeters) + shape.lengthMeters) % shape.lengthMeters;
  for (let index = 0; index < shape.points.length; index += 1) {
    const startDistance = shape.cumulativeMeters[index]!;
    const endDistance = shape.cumulativeMeters[index + 1]!;
    if (offset > endDistance) continue;
    const start = shape.points[index]!;
    const end = shape.points[(index + 1) % shape.points.length]!;
    const fraction =
      endDistance === startDistance
        ? 0
        : (offset - startDistance) / (endDistance - startDistance);
    return interpolate(start, end, fraction);
  }
  return shape.points[0]!;
}

function routeElevation(shape: RouteShape, distanceMeters: number): number {
  const offset =
    ((distanceMeters % shape.lengthMeters) + shape.lengthMeters) % shape.lengthMeters;
  for (let index = 0; index < shape.points.length; index += 1) {
    const startDistance = shape.cumulativeMeters[index]!;
    const endDistance = shape.cumulativeMeters[index + 1]!;
    if (offset > endDistance) continue;
    const start = shape.points[index]!;
    const end = shape.points[(index + 1) % shape.points.length]!;
    const fraction =
      endDistance === startDistance
        ? 0
        : (offset - startDistance) / (endDistance - startDistance);
    const startElevation = start.elevationMeters ?? end.elevationMeters ?? 0;
    const endElevation = end.elevationMeters ?? start.elevationMeters ?? 0;
    return startElevation + (endElevation - startElevation) * fraction;
  }
  return 0;
}

function shortcutPosition(
  shape: RouteShape,
  progress: number,
  normal: RoutePoint,
): RoutePoint {
  if (progress < 0.2 || progress > 0.8) return normal;
  const start = routePosition(shape, shape.lengthMeters * 0.2);
  const end = routePosition(shape, shape.lengthMeters * 0.8);
  return interpolate(start, end, (progress - 0.2) / 0.6);
}

function interpolate(start: RoutePoint, end: RoutePoint, fraction: number): RoutePoint {
  return {
    lat: start.lat + (end.lat - start.lat) * fraction,
    lng: start.lng + (end.lng - start.lng) * fraction,
  };
}

function createNoiseSampler(
  minimumMeters: number,
  maximumMeters: number,
  rng: () => number,
): (point: RoutePoint, sampleIndex: number) => RoutePoint {
  let activeBlock = -1;
  let startNorth = 0;
  let startEast = 0;
  let targetNorth = 0;
  let targetEast = 0;
  return (point, sampleIndex) => {
    if (maximumMeters === 0) return point;
    const block = Math.floor(sampleIndex / 10);
    if (block !== activeBlock) {
      startNorth = activeBlock < 0 ? 0 : targetNorth;
      startEast = activeBlock < 0 ? 0 : targetEast;
      const radius = minimumMeters + rng() * (maximumMeters - minimumMeters);
      const angle = rng() * Math.PI * 2;
      targetNorth = Math.cos(angle) * radius;
      targetEast = Math.sin(angle) * radius;
      if (activeBlock < 0) {
        startNorth = targetNorth;
        startEast = targetEast;
      }
      activeBlock = block;
    }
    const fraction = (sampleIndex % 10) / 10;
    const northMeters = startNorth + (targetNorth - startNorth) * fraction;
    const eastMeters = startEast + (targetEast - startEast) * fraction;
    const metersPerLongitudeDegree =
      111_320 * Math.max(0.01, Math.cos((point.lat * Math.PI) / 180));
    return {
      lat: point.lat + northMeters / 111_320,
      lng: point.lng + eastMeters / metersPerLongitudeDegree,
    };
  };
}

function isSignalLost(
  elapsedSec: number,
  scenario: GpxScenario,
  lossPermil: number,
  rng: () => number,
): boolean {
  if (scenario === "signal-loss" && elapsedSec >= 120 && elapsedSec < 140) return true;
  return rng() * 1000 < lossPermil;
}

function insertAt<T>(values: readonly T[], index: number, value: T): T[] {
  return [...values.slice(0, index), value, ...values.slice(index)];
}

function assertRange(minimum: number, maximum: number, label: string): void {
  if (
    !Number.isFinite(minimum) ||
    !Number.isFinite(maximum) ||
    minimum < 0 ||
    maximum < minimum
  ) {
    throw new RangeError(label + " range is invalid.");
  }
}

function assertPermil(value: number, label: string): void {
  if (!Number.isInteger(value) || value < 0 || value > 1000) {
    throw new RangeError(label + " must be an integer from 0 to 1000.");
  }
}

function createRandom(seed: number): () => number {
  let state = seed >>> 0;
  return () => {
    state += 0x6d2b79f5;
    let value = state;
    value = Math.imul(value ^ (value >>> 15), value | 1);
    value ^= value + Math.imul(value ^ (value >>> 7), value | 61);
    return ((value ^ (value >>> 14)) >>> 0) / 4_294_967_296;
  };
}

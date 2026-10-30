import { z } from "zod";
import { env } from "../../config/env";
import { logger } from "../../lib/logger";
import type { RoutePoint } from "../routing/types";

const ELEVATION_CELL_DEGREES = 0.009;
const SAMPLE_SPACING_METERS = 100;
const MAX_COORDINATES_PER_REQUEST = 100;
const CACHE_TTL_MS = 6 * 60 * 60 * 1_000;
const MAX_CACHE_ENTRIES = 5_000;
const responseSchema = z.object({ elevation: z.array(z.number().finite()) });

export interface ElevationSample extends RoutePoint {
  readonly elevationMeters: number;
}

export interface ElevationProfile {
  readonly available: boolean;
  readonly samples: readonly ElevationSample[];
  readonly gainMeters: number;
  readonly lossMeters: number;
  readonly maxGradePercent: number;
}

export interface OpenMeteoElevationOptions {
  readonly endpoint?: string;
  readonly apiKey?: string;
  readonly timeoutMs?: number;
  readonly request?: typeof fetch;
}

interface CachedElevation {
  readonly elevationMeters: number;
  readonly expiresAt: number;
}

const elevationCache = new Map<string, CachedElevation>();

export class OpenMeteoElevationProvider {
  public constructor(private readonly options: OpenMeteoElevationOptions = {}) {}

  public async getProfile(points: readonly RoutePoint[]): Promise<ElevationProfile> {
    const sampledPoints = sampleRoute(points, SAMPLE_SPACING_METERS);
    if (sampledPoints.length === 0) return emptyProfile();

    try {
      const elevations = await this.resolveElevations(sampledPoints);
      return buildProfile(sampledPoints, elevations);
    } catch (error) {
      const statusCode = error instanceof OpenMeteoError ? error.statusCode : undefined;
      logger.warn(
        { provider: "open-meteo", statusCode },
        "Elevation unavailable; returning profile without elevation data",
      );
      return emptyProfile();
    }
  }

  private async resolveElevations(
    points: readonly RoutePoint[],
  ): Promise<readonly number[]> {
    const now = Date.now();
    const cellByPoint = points.map(elevationCellKey);
    const missing = new Map<string, RoutePoint>();
    for (const [index, key] of cellByPoint.entries()) {
      const cached = elevationCache.get(key);
      if (cached && cached.expiresAt > now) continue;
      if (cached) elevationCache.delete(key);
      if (!missing.has(key)) missing.set(key, points[index]!);
    }

    const missingEntries = [...missing.entries()];
    for (
      let offset = 0;
      offset < missingEntries.length;
      offset += MAX_COORDINATES_PER_REQUEST
    ) {
      const batch = missingEntries.slice(offset, offset + MAX_COORDINATES_PER_REQUEST);
      const values = await requestElevations(
        batch.map((entry) => entry[1]),
        this.options,
      );
      if (values.length !== batch.length) throw new OpenMeteoError();
      batch.forEach(([key], index) => {
        const value = values[index];
        if (value === undefined) throw new OpenMeteoError();
        rememberElevation(key, value, now);
      });
    }

    return cellByPoint.map((key) => {
      const cached = elevationCache.get(key);
      if (!cached || cached.expiresAt <= now) throw new OpenMeteoError();
      return cached.elevationMeters;
    });
  }
}

async function requestElevations(
  points: readonly RoutePoint[],
  options: OpenMeteoElevationOptions,
): Promise<readonly number[]> {
  const url = new URL(options.endpoint ?? env.OPEN_METEO_ELEVATION_URL);
  url.searchParams.set("latitude", points.map((point) => point.lat.toFixed(5)).join(","));
  url.searchParams.set(
    "longitude",
    points.map((point) => point.lng.toFixed(5)).join(","),
  );
  const apiKey = options.apiKey ?? env.OPEN_METEO_API_KEY;
  if (apiKey) url.searchParams.set("apikey", apiKey);

  let response: Response;
  try {
    response = await (options.request ?? fetch)(url, {
      signal: AbortSignal.timeout(options.timeoutMs ?? env.OPEN_METEO_TIMEOUT_MS),
    });
  } catch {
    throw new OpenMeteoError();
  }
  if (!response.ok) throw new OpenMeteoError(response.status);
  const payload: unknown = await response.json().catch(() => undefined);
  const parsed = responseSchema.safeParse(payload);
  if (!parsed.success) throw new OpenMeteoError(response.status);
  return parsed.data.elevation;
}

function rememberElevation(key: string, value: number, now: number): void {
  elevationCache.delete(key);
  elevationCache.set(key, { elevationMeters: value, expiresAt: now + CACHE_TTL_MS });
  while (elevationCache.size > MAX_CACHE_ENTRIES) {
    const oldestKey = elevationCache.keys().next().value;
    if (oldestKey === undefined) return;
    elevationCache.delete(oldestKey);
  }
}

function elevationCellKey(point: RoutePoint): string {
  const longitudeScale = Math.max(0.1, Math.cos((point.lat * Math.PI) / 180));
  const latitudeCell = Math.floor(point.lat / ELEVATION_CELL_DEGREES);
  const longitudeCellWidth = ELEVATION_CELL_DEGREES / longitudeScale;
  const longitudeCell = Math.floor(point.lng / longitudeCellWidth);
  const latitudeSampleCell = Math.floor(point.lat / 0.0009);
  const longitudeSampleCell = Math.floor(point.lng / (0.0009 / longitudeScale));
  return (
    latitudeCell +
    ":" +
    longitudeCell +
    ":" +
    latitudeSampleCell +
    ":" +
    longitudeSampleCell
  );
}

function sampleRoute(
  points: readonly RoutePoint[],
  spacingMeters: number,
): readonly RoutePoint[] {
  if (points.length === 0) return [];
  const samples: RoutePoint[] = [{ ...points[0]! }];
  let traversedMeters = 0;
  let nextSampleMeters = spacingMeters;

  for (let index = 1; index < points.length; index += 1) {
    const start = points[index - 1]!;
    const end = points[index]!;
    const segmentMeters = distanceBetween(start, end);
    while (segmentMeters > 0 && traversedMeters + segmentMeters >= nextSampleMeters) {
      const fraction = (nextSampleMeters - traversedMeters) / segmentMeters;
      samples.push(interpolate(start, end, fraction));
      nextSampleMeters += spacingMeters;
    }
    traversedMeters += segmentMeters;
  }

  const last = points[points.length - 1]!;
  const lastSample = samples[samples.length - 1]!;
  if (distanceBetween(last, lastSample) > 1) samples.push({ ...last });
  return samples;
}

function buildProfile(
  points: readonly RoutePoint[],
  elevations: readonly number[],
): ElevationProfile {
  const samples = points.map((point, index) => ({
    ...point,
    elevationMeters: elevations[index]!,
  }));
  let gainMeters = 0;
  let lossMeters = 0;
  let maxGradePercent = 0;

  for (let index = 1; index < samples.length; index += 1) {
    const previous = samples[index - 1]!;
    const current = samples[index]!;
    const elevationDelta = current.elevationMeters - previous.elevationMeters;
    const horizontalDistance = distanceBetween(previous, current);
    if (elevationDelta > 0) gainMeters += elevationDelta;
    if (elevationDelta < 0) lossMeters -= elevationDelta;
    if (horizontalDistance > 0) {
      maxGradePercent = Math.max(
        maxGradePercent,
        (Math.abs(elevationDelta) / horizontalDistance) * 100,
      );
    }
  }

  return {
    available: true,
    samples,
    gainMeters: Math.round(gainMeters),
    lossMeters: Math.round(lossMeters),
    maxGradePercent: roundToOneDecimal(maxGradePercent),
  };
}

function interpolate(start: RoutePoint, end: RoutePoint, fraction: number): RoutePoint {
  return {
    lat: start.lat + (end.lat - start.lat) * fraction,
    lng: start.lng + (end.lng - start.lng) * fraction,
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

function roundToOneDecimal(value: number): number {
  return Math.round(value * 10) / 10;
}

function emptyProfile(): ElevationProfile {
  return {
    available: false,
    samples: [],
    gainMeters: 0,
    lossMeters: 0,
    maxGradePercent: 0,
  };
}

class OpenMeteoError extends Error {
  public constructor(public readonly statusCode?: number) {
    super("Open-Meteo elevation request failed.");
    this.name = "OpenMeteoError";
  }
}

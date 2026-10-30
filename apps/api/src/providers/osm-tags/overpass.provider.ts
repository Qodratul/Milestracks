import { z } from "zod";
import { env } from "../../config/env";
import { logger } from "../../lib/logger";
import type { RoutePoint } from "../routing/types";

const MAX_ROUTE_SAMPLE_POINTS = 5;
const SEARCH_RADIUS_METERS = 75;
const CACHE_TTL_MS = 10 * 60 * 1_000;
const MAX_CACHE_ENTRIES = 1_000;
const MAX_REQUEST_ATTEMPTS = 2;
const responseSchema = z.object({
  elements: z.array(
    z
      .object({
        tags: z.record(z.string(), z.unknown()).optional(),
      })
      .passthrough(),
  ),
});

export interface OsmRouteTags {
  readonly available: boolean;
  readonly dataConfidence: number;
  readonly wayCount: number;
  readonly roadTypes: readonly string[];
  readonly surfaces: readonly string[];
  readonly sidewalkCoverage: "yes" | "no" | "unknown";
  readonly lightingCoverage: "yes" | "no" | "unknown";
  readonly areaHints: readonly string[];
  readonly hasConstruction: boolean;
  readonly hasSteps: boolean;
  readonly hasFerry: boolean;
  readonly hasFord: boolean;
  readonly hasPrimaryRoad: boolean;
  readonly hasUnpavedSurface: boolean;
}

export interface OverpassOsmTagsOptions {
  readonly enabled?: boolean;
  readonly endpoint?: string;
  readonly fallbackEndpoint?: string;
  readonly timeoutMs?: number;
  readonly requestIntervalMs?: number;
  readonly request?: typeof fetch;
}

interface CachedTags {
  readonly value: OsmRouteTags;
  readonly expiresAt: number;
}

const tagCache = new Map<string, CachedTags>();
let nextRequestAt = 0;

export class OverpassOsmTagsProvider {
  public constructor(private readonly options: OverpassOsmTagsOptions = {}) {}

  public async getRouteTags(points: readonly RoutePoint[]): Promise<OsmRouteTags> {
    if (this.options.enabled === false || env.OSM_TAGS_PROVIDER === "none")
      return emptyTags();
    const samples = samplePoints(points, MAX_ROUTE_SAMPLE_POINTS);
    if (samples.length === 0) return emptyTags();
    const cacheKey = samples.map(cellKey).sort().join("|");
    const cached = tagCache.get(cacheKey);
    if (cached && cached.expiresAt > Date.now()) return cached.value;
    if (cached) tagCache.delete(cacheKey);

    const primaryEndpoint = this.options.endpoint ?? env.OVERPASS_API_URL;
    const fallbackEndpoint =
      this.options.fallbackEndpoint ??
      (this.options.endpoint ? undefined : env.OVERPASS_FALLBACK_API_URL);
    const endpoints = [primaryEndpoint];
    if (fallbackEndpoint && fallbackEndpoint !== primaryEndpoint) {
      endpoints.push(fallbackEndpoint);
    }

    let lastError: unknown;
    for (const [endpointIndex, endpoint] of endpoints.entries()) {
      const attempts = endpointIndex === 0 ? MAX_REQUEST_ATTEMPTS : 1;
      for (let attempt = 1; attempt <= attempts; attempt += 1) {
        try {
          await this.waitForRequestSlot();
          const tags = await requestTags(samples, this.options, endpoint);
          rememberTags(cacheKey, tags);
          if (endpointIndex > 0) {
            logger.info(
              { provider: "overpass", endpoint },
              "OSM tags loaded from fallback endpoint",
            );
          }
          return tags;
        } catch (error) {
          lastError = error;
          const statusCode =
            error instanceof OverpassError ? error.statusCode : undefined;
          const transient =
            statusCode === undefined || statusCode === 429 || statusCode >= 500;
          if (attempt < attempts && transient) {
            logger.warn(
              { provider: "overpass", statusCode, attempt },
              "Temporary OSM tag failure; retrying the configured endpoint",
            );
            await new Promise<void>((resolve) => setTimeout(resolve, 750));
            continue;
          }
          logger.warn(
            {
              provider: "overpass",
              endpoint,
              statusCode,
              fallbackAvailable: endpointIndex < endpoints.length - 1,
            },
            "OSM tag endpoint request failed",
          );
          break;
        }
      }
    }
    logger.warn(
      {
        provider: "overpass",
        statusCode: lastError instanceof OverpassError ? lastError.statusCode : undefined,
      },
      "OSM tags unavailable; returning low-confidence route data",
    );
    return emptyTags();
  }

  private async waitForRequestSlot(): Promise<void> {
    const now = Date.now();
    const waitMs = Math.max(0, nextRequestAt - now);
    nextRequestAt =
      Math.max(now, nextRequestAt) +
      (this.options.requestIntervalMs ?? env.OVERPASS_REQUEST_INTERVAL_MS);
    if (waitMs > 0) {
      await new Promise<void>((resolve) => setTimeout(resolve, waitMs));
    }
  }
}

async function requestTags(
  points: readonly RoutePoint[],
  options: OverpassOsmTagsOptions,
  endpoint: string,
): Promise<OsmRouteTags> {
  const queryPoints = points.map(
    (point) =>
      "way(around:" +
      SEARCH_RADIUS_METERS +
      "," +
      point.lat.toFixed(5) +
      "," +
      point.lng.toFixed(5) +
      ")[highway];",
  );
  const query =
    "[out:json][timeout:10];\n(\n" + queryPoints.join("\n") + "\n);\nout tags;";
  let response: Response;
  try {
    response = await (options.request ?? fetch)(endpoint, {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "User-Agent": "Milestracks/1.0 (OSM route attribute provider)",
      },
      body: new URLSearchParams({ data: query }),
      signal: AbortSignal.timeout(options.timeoutMs ?? env.OVERPASS_TIMEOUT_MS),
    });
  } catch {
    throw new OverpassError();
  }
  if (!response.ok) throw new OverpassError(response.status);
  const payload: unknown = await response.json().catch(() => undefined);
  const parsed = responseSchema.safeParse(payload);
  if (!parsed.success) throw new OverpassError(response.status);
  return summarizeTags(parsed.data.elements.map((element) => element.tags ?? {}));
}

function summarizeTags(tags: readonly Readonly<Record<string, unknown>>[]): OsmRouteTags {
  const roadTypes = uniqueStrings(tags, "highway");
  const surfaces = uniqueStrings(tags, "surface");
  const sidewalkValues = uniqueStrings(tags, "sidewalk");
  const lightingValues = uniqueStrings(tags, "lit");
  const areaHints = [
    ...uniqueStrings(tags, "leisure"),
    ...uniqueStrings(tags, "landuse"),
  ].filter((value) =>
    ["park", "garden", "grass", "forest", "residential"].includes(value),
  );
  const wayCount = tags.length;
  return {
    available: wayCount > 0,
    dataConfidence: Math.min(1, wayCount / 5),
    wayCount,
    roadTypes,
    surfaces,
    sidewalkCoverage: coverage(sidewalkValues),
    lightingCoverage: coverage(lightingValues),
    areaHints: [...new Set(areaHints)],
    hasConstruction: tags.some(
      (tag) => tag.highway === "construction" || tag.construction === "yes",
    ),
    hasSteps: roadTypes.includes("steps"),
    hasFerry: roadTypes.includes("ferry") || tags.some((tag) => tag.route === "ferry"),
    hasFord: tags.some((tag) => tag.ford === "yes") || roadTypes.includes("ford"),
    hasPrimaryRoad: roadTypes.some((road) =>
      ["primary", "secondary", "tertiary", "trunk", "motorway"].includes(road),
    ),
    hasUnpavedSurface: surfaces.some((surface) =>
      ["unpaved", "gravel", "dirt", "ground", "sand", "mud", "grass"].includes(surface),
    ),
  };
}

function uniqueStrings(
  tags: readonly Readonly<Record<string, unknown>>[],
  key: string,
): readonly string[] {
  return [...new Set(tags.map((tag) => tag[key]).filter(isString))];
}

function coverage(values: readonly string[]): "yes" | "no" | "unknown" {
  if (values.some((value) => value === "yes" || value === "both")) return "yes";
  if (values.some((value) => value === "no" || value === "none")) return "no";
  return "unknown";
}

function isString(value: unknown): value is string {
  return typeof value === "string" && value.length > 0;
}

function samplePoints(
  points: readonly RoutePoint[],
  maxPoints: number,
): readonly RoutePoint[] {
  if (points.length <= maxPoints) return points.map((point) => ({ ...point }));
  const samples: RoutePoint[] = [];
  for (let index = 0; index < maxPoints; index += 1) {
    const pointIndex = Math.round((index * (points.length - 1)) / (maxPoints - 1));
    samples.push({ ...points[pointIndex]! });
  }
  return samples;
}

function cellKey(point: RoutePoint): string {
  const latitudeCell = Math.floor(point.lat / 0.009);
  const longitudeStep = 0.009 / Math.max(0.1, Math.cos((point.lat * Math.PI) / 180));
  const longitudeCell = Math.floor(point.lng / longitudeStep);
  return latitudeCell + ":" + longitudeCell;
}

function rememberTags(key: string, value: OsmRouteTags): void {
  tagCache.delete(key);
  tagCache.set(key, { value, expiresAt: Date.now() + CACHE_TTL_MS });
  while (tagCache.size > MAX_CACHE_ENTRIES) {
    const oldestKey = tagCache.keys().next().value;
    if (oldestKey === undefined) return;
    tagCache.delete(oldestKey);
  }
}

function emptyTags(): OsmRouteTags {
  return {
    available: false,
    dataConfidence: 0,
    wayCount: 0,
    roadTypes: [],
    surfaces: [],
    sidewalkCoverage: "unknown",
    lightingCoverage: "unknown",
    areaHints: [],
    hasConstruction: false,
    hasSteps: false,
    hasFerry: false,
    hasFord: false,
    hasPrimaryRoad: false,
    hasUnpavedSurface: false,
  };
}

class OverpassError extends Error {
  public constructor(public readonly statusCode?: number) {
    super("Overpass query failed.");
    this.name = "OverpassError";
  }
}

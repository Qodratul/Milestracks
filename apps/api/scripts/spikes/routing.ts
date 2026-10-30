import "dotenv/config";
import { mkdirSync, writeFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { performance } from "node:perf_hooks";
import { env } from "../../src/config/env";
import {
  generateLoopCandidates,
  GraphHopperRoutingProvider,
  MockRoutingProvider,
} from "../../src/providers/routing";
import type { LoopCandidate } from "../../src/providers/routing";
import { OpenMeteoElevationProvider } from "../../src/providers/elevation";
import { OverpassOsmTagsProvider } from "../../src/providers/osm-tags";

const TARGET_DISTANCE_METERS = 1_500;
const locations = [
  { id: "jakarta-01", city: "Jakarta", category: "urban", lat: -6.2088, lng: 106.8456 },
  { id: "jakarta-02", city: "Jakarta", category: "urban", lat: -6.1754, lng: 106.8272 },
  { id: "jakarta-03", city: "Jakarta", category: "urban", lat: -6.1944, lng: 106.8229 },
  { id: "jakarta-04", city: "Jakarta", category: "urban", lat: -6.2246, lng: 106.8348 },
  { id: "jakarta-05", city: "Jakarta", category: "urban", lat: -6.1939, lng: 106.823 },
  { id: "jakarta-06", city: "Jakarta", category: "urban", lat: -6.2297, lng: 106.827 },
  { id: "bandung-01", city: "Bandung", category: "urban", lat: -6.9175, lng: 107.6191 },
  { id: "bandung-02", city: "Bandung", category: "urban", lat: -6.8895, lng: 107.61 },
  { id: "bandung-03", city: "Bandung", category: "urban", lat: -6.9147, lng: 107.6098 },
  { id: "bandung-04", city: "Bandung", category: "urban", lat: -6.9363, lng: 107.6051 },
  { id: "bandung-05", city: "Bandung", category: "urban", lat: -6.9017, lng: 107.6188 },
  { id: "bandung-06", city: "Bandung", category: "urban", lat: -6.925, lng: 107.6327 },
  {
    id: "yogyakarta-01",
    city: "Yogyakarta",
    category: "urban",
    lat: -7.7956,
    lng: 110.3695,
  },
  {
    id: "yogyakarta-02",
    city: "Yogyakarta",
    category: "urban",
    lat: -7.7829,
    lng: 110.3671,
  },
  {
    id: "yogyakarta-03",
    city: "Yogyakarta",
    category: "urban",
    lat: -7.8014,
    lng: 110.3644,
  },
  {
    id: "yogyakarta-04",
    city: "Yogyakarta",
    category: "urban",
    lat: -7.81,
    lng: 110.363,
  },
  {
    id: "yogyakarta-05",
    city: "Yogyakarta",
    category: "urban",
    lat: -7.77,
    lng: 110.377,
  },
  {
    id: "yogyakarta-06",
    city: "Yogyakarta",
    category: "urban",
    lat: -7.8534,
    lng: 110.3486,
  },
  {
    id: "gunungkidul-01",
    city: "Gunungkidul",
    category: "sparse",
    lat: -7.847,
    lng: 110.543,
  },
  {
    id: "gunungkidul-02",
    city: "Gunungkidul",
    category: "sparse",
    lat: -7.979,
    lng: 110.616,
  },
] as const;

interface SpikeSummary {
  readonly distanceFitPercent: number;
  readonly requestCoveragePercent: number;
  readonly p95RouteCallMs: number;
  readonly elevationAvailableCount: number;
  readonly osmAvailableCount: number;
  readonly p95ElevationCachedMs: number;
  readonly p95OsmCachedMs: number;
  readonly maxGenerationMs: number;
  readonly candidateCount: number;
  readonly candidatesWithAtMostOneUTurn: number;
}

async function main(): Promise<void> {
  const useMock = process.argv.includes("--mock");
  const skipEnrichment = process.argv.includes("--skip-enrichment");
  const routing = useMock ? new MockRoutingProvider() : new GraphHopperRoutingProvider();
  const elevation = skipEnrichment ? null : new OpenMeteoElevationProvider();
  const osm = skipEnrichment ? null : new OverpassOsmTagsProvider();
  const startedAt = performance.now();
  const rows: Record<string, unknown>[] = [];
  const routeLatencies: number[] = [];
  const generationLatencies: number[] = [];
  const elevationLatencies: number[] = [];
  const osmLatencies: number[] = [];
  const elevationCachedLatencies: number[] = [];
  const osmCachedLatencies: number[] = [];
  let totalCalls = 0;
  let elevationAvailableCount = 0;
  let osmAvailableCount = 0;
  let osmConfidenceSum = 0;

  const selectedLocations = selectLocations(process.argv.slice(2));
  for (const location of selectedLocations) {
    const generationStartedAt = performance.now();
    const candidates = await generateLoopCandidates(routing, {
      start: { lat: location.lat, lng: location.lng },
      targetDistanceMeters: TARGET_DISTANCE_METERS,
      candidateCount: 2,
      maxAdjustments: 2,
      maxSnapDistanceMeters: 250,
      distanceToleranceRatio: 0.15,
    });
    const generationMs = Math.round(performance.now() - generationStartedAt);
    generationLatencies.push(generationMs);
    for (const candidate of candidates) {
      totalCalls += candidate.latencySamplesMs.length;
      routeLatencies.push(...candidate.latencySamplesMs);
    }

    const validCandidates = candidates.filter(
      (candidate) => candidate.valid && candidate.route,
    );
    const selected = chooseRouteForEnrichment(candidates);
    let elevationSummary: Record<string, unknown> = { available: false };
    let osmSummary: Record<string, unknown> = { available: false, dataConfidence: 0 };
    if (selected?.route && elevation && osm) {
      const elevationStartedAt = performance.now();
      const profile = await elevation.getProfile(selected.route.geometry);
      elevationLatencies.push(performance.now() - elevationStartedAt);
      elevationSummary = {
        available: profile.available,
        sampleCount: profile.samples.length,
        gainMeters: profile.gainMeters,
        lossMeters: profile.lossMeters,
        maxGradePercent: profile.maxGradePercent,
      };
      if (profile.available) {
        elevationAvailableCount += 1;
        const cachedStartedAt = performance.now();
        await elevation.getProfile(selected.route.geometry);
        elevationCachedLatencies.push(performance.now() - cachedStartedAt);
      }

      const osmStartedAt = performance.now();
      const tags = await osm.getRouteTags(selected.route.geometry);
      osmLatencies.push(performance.now() - osmStartedAt);
      osmSummary = {
        available: tags.available,
        dataConfidence: tags.dataConfidence,
        wayCount: tags.wayCount,
        roadTypes: tags.roadTypes,
        surfaces: tags.surfaces,
        sidewalkCoverage: tags.sidewalkCoverage,
        lightingCoverage: tags.lightingCoverage,
        areaHints: tags.areaHints,
      };
      if (tags.available) {
        osmAvailableCount += 1;
        const cachedStartedAt = performance.now();
        await osm.getRouteTags(selected.route.geometry);
        osmCachedLatencies.push(performance.now() - cachedStartedAt);
      }
      osmConfidenceSum += tags.dataConfidence;
    }

    rows.push({
      id: location.id,
      city: location.city,
      category: location.category,
      validCandidateCount: validCandidates.length,
      candidateSummaries: candidates.map((candidate) => ({
        id: candidate.id,
        valid: candidate.valid,
        failureReason: candidate.failureReason,
        routingErrorCode: candidate.routingErrorCode ?? null,
        routingStatusCode: candidate.routingStatusCode ?? null,
        attempts: candidate.attempts,
        distanceErrorRatio: round(candidate.distanceErrorRatio),
        snapDistanceMeters: round(candidate.snapDistanceMeters),
        turnsPerKm: round(candidate.turnsPerKm),
        uTurnCount: candidate.uTurnCount,
        distanceMeters: candidate.route
          ? Math.round(candidate.route.distanceMeters)
          : null,
        latencySamplesMs: candidate.latencySamplesMs.map(Math.round),
        distanceSamplesMeters: candidate.distanceSamplesMeters.map(Math.round),
      })),
      elevation: elevationSummary,
      osm: osmSummary,
      generationMs,
    });
  }

  const candidates = rows.flatMap(
    (row) => row.candidateSummaries as Record<string, unknown>[],
  );
  const fittingCount = candidates.filter((candidate) => candidate.valid).length;
  const coveredStarts = rows.filter((row) => Number(row.validCandidateCount) >= 2).length;
  const summary: SpikeSummary & Record<string, number | string | boolean> = {
    executionMode: useMock ? "mock" : "live",
    enrichmentSkipped: skipEnrichment,
    profile: useMock ? "mock" : env.GRAPHOPPER_PROFILE,
    locationCount: selectedLocations.length,
    cityCount: new Set(selectedLocations.map((location) => location.city)).size,
    sparseLocationCount: selectedLocations.filter(
      (location) => location.category === "sparse",
    ).length,
    candidateCount: candidates.length,
    routeRequestCount: totalCalls,
    estimatedGraphHopperCredits: totalCalls * 2,
    configuredGraphHopperCreditsPerMinute: env.GRAPHOPPER_CREDITS_PER_MINUTE,
    validCandidateCount: fittingCount,
    distanceFitPercent: percent(fittingCount, candidates.length),
    startsWithAtLeastTwoValidCandidates: coveredStarts,
    requestCoveragePercent: percent(coveredStarts, selectedLocations.length),
    p95RouteCallMs: percentile(routeLatencies, 0.95),
    p95GenerationMs: percentile(generationLatencies, 0.95),
    maxGenerationMs: Math.round(Math.max(...generationLatencies)),
    p95ElevationCallMs: percentile(elevationLatencies, 0.95),
    p95ElevationCachedMs: percentile(elevationCachedLatencies, 0.95),
    p95OsmCallMs: percentile(osmLatencies, 0.95),
    p95OsmCachedMs: percentile(osmCachedLatencies, 0.95),
    elevationAvailableCount,
    osmAvailableCount,
    meanOsmDataConfidence: round(osmConfidenceSum / rows.length) ?? 0,
    candidatesWithAtMostOneUTurn: candidates.filter(
      (candidate) => candidate.valid && Number(candidate.uTurnCount) <= 1,
    ).length,
    totalElapsedMs: Math.round(performance.now() - startedAt),
  };
  const report = {
    generatedAt: new Date().toISOString(),
    targetDistanceMeters: TARGET_DISTANCE_METERS,
    candidateCountPerStart: 2,
    diagnosticSubset: selectedLocations.length !== locations.length,
    maxRadiusAdjustments: 2,
    thresholds: {
      maxSnapDistanceMeters: 250,
      maxDistanceDeviationPercent: 15,
      requiredDistanceFitPercent: 80,
      maximumAcceptedUturnsPerCandidate: 1,
      requiredRequestCoveragePercent: 80,
      maxP95RouteCallMs: 3_000,
      maxGenerationMs: 10_000,
      requiredCandidatesWithAtMostOneUturnPercent: 80,
      maxCachedElevationCallMs: 1_000,
      maxCachedOsmCallMs: 1_000,
    },
    summary,
    locations: rows,
    containsRawCoordinates: false,
  };
  const outputName =
    selectedLocations.length === locations.length
      ? "provider-spike-routing.json"
      : "provider-spike-routing-diagnostic.json";
  const outputPath = resolve("docs/adr/" + outputName);
  mkdirSync(dirname(outputPath), { recursive: true });
  writeFileSync(outputPath, JSON.stringify(report, null, 2) + "\n", "utf8");
  process.stdout.write(JSON.stringify({ outputPath, summary }, null, 2) + "\n");
  if (!thresholdsPass(summary)) process.exitCode = 1;
}

function selectLocations(args: readonly string[]) {
  const idIndex = args.indexOf("--location-id");
  if (idIndex < 0) return locations;
  const id = args[idIndex + 1];
  const selected = locations.filter((location) => location.id === id);
  if (selected.length === 0) throw new Error("Unknown --location-id.");
  return selected;
}

function chooseRouteForEnrichment(
  candidates: readonly LoopCandidate[],
): LoopCandidate | undefined {
  return [...candidates]
    .filter((candidate) => candidate.route !== null)
    .sort((first, second) => {
      if (first.valid !== second.valid) return first.valid ? -1 : 1;
      return (
        (first.distanceErrorRatio ?? Number.MAX_SAFE_INTEGER) -
        (second.distanceErrorRatio ?? Number.MAX_SAFE_INTEGER)
      );
    })[0];
}

function percentile(values: readonly number[], quantile: number): number {
  if (values.length === 0) return 0;
  const sorted = [...values].sort((first, second) => first - second);
  return Math.round(sorted[Math.ceil(sorted.length * quantile) - 1] ?? 0);
}

function percent(part: number, total: number): number {
  return total === 0 ? 0 : Math.round((part / total) * 1_000) / 10;
}

function round(value: number | null): number | null {
  return value === null ? null : Math.round(value * 10) / 10;
}

function thresholdsPass(summary: SpikeSummary): boolean {
  return (
    summary.distanceFitPercent >= 80 &&
    summary.requestCoveragePercent >= 80 &&
    summary.p95RouteCallMs <= 3_000 &&
    summary.maxGenerationMs <= 10_000 &&
    (summary.elevationAvailableCount === 0 || summary.p95ElevationCachedMs <= 1_000) &&
    (summary.osmAvailableCount === 0 || summary.p95OsmCachedMs <= 1_000) &&
    summary.candidatesWithAtMostOneUTurn >= Math.ceil(summary.candidateCount * 0.8)
  );
}

void main().catch((error: unknown) => {
  process.stderr.write(
    "Routing spike failed: " +
      (error instanceof Error ? error.name : "unknown error") +
      "\n",
  );
  process.exitCode = 1;
});

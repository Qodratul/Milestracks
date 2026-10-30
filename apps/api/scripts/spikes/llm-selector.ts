import "dotenv/config";
import { mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { performance } from "node:perf_hooks";
import { z } from "zod";
import { env } from "../../src/config/env";
import { getFastModelCapabilities } from "../../src/providers/llm/model-catalog";
import { NebiusLLMProvider } from "../../src/providers/llm/nebius.provider";
import type { RouteCandidate, SupportedLanguage } from "../../src/providers/llm/types";

const routingReportSchema = z.object({
  locations: z
    .array(
      z.object({
        id: z.string(),
        city: z.string(),
        elevation: z
          .object({
            available: z.boolean(),
            gainMeters: z.number().optional(),
            maxGradePercent: z.number().optional(),
          })
          .passthrough(),
        osm: z
          .object({
            available: z.boolean(),
            dataConfidence: z.number(),
            surfaces: z.array(z.string()).optional(),
            areaHints: z.array(z.string()).optional(),
          })
          .passthrough(),
        candidateSummaries: z.array(
          z
            .object({
              id: z.string(),
              valid: z.boolean(),
              distanceMeters: z.number().nullable(),
              turnsPerKm: z.number().nullable(),
            })
            .passthrough(),
        ),
      }),
    )
    .min(1),
});

const ROUTING_REPORT_PATH = "docs/adr/provider-spike-routing.json";
const DEFAULT_REQUESTS_PER_LANGUAGE = 25;
const MILESTONE_COUNT = 3;
const TARGET_DISTANCE_KM = 1.5;
const routeProvider = new NebiusLLMProvider();

async function main(): Promise<void> {
  const args = process.argv.slice(2);
  const delayMs = parseDelay(args);
  const requestsPerLanguage = parseSampleCount(args);
  const reportPayload: unknown = JSON.parse(readFileSync(ROUTING_REPORT_PATH, "utf8"));
  const routeReport = routingReportSchema.parse(reportPayload);
  const candidates = buildCandidateSummaries(routeReport.locations);
  const candidateIds = candidates.map((candidate) => candidate.id);
  const capabilities = await getFastModelCapabilities();
  const firstAttemptLatencies: number[] = [];
  const fallbackCount: Record<SupportedLanguage, number> = { id: 0, en: 0 };
  const firstAttemptCounts: Record<SupportedLanguage, number> = { id: 0, en: 0 };
  const validOutputCounts: Record<SupportedLanguage, number> = { id: 0, en: 0 };
  const retrySuccessCounts: Record<SupportedLanguage, number> = { id: 0, en: 0 };
  let selectedCandidateValidCount = 0;
  let milestoneDialogueCountValidCount = 0;
  const samples: Record<SupportedLanguage, unknown[]> = { id: [], en: [] };
  const languages: readonly SupportedLanguage[] = ["id", "en"];
  const startedAt = performance.now();

  for (const language of languages) {
    for (let index = 0; index < requestsPerLanguage; index += 1) {
      const requestStartedAt = performance.now();
      const result = await routeProvider.generateTrackNarrativeDetailed({
        userLevel: "Intermediate",
        totalDistanceKm: TARGET_DISTANCE_KM,
        milestoneCount: MILESTONE_COUNT,
        language,
        weatherCondition: language === "id" ? "Hangat, 29 C" : "Warm, 29 C",
        candidates,
      });
      firstAttemptLatencies.push(performance.now() - requestStartedAt);
      if (candidateIds.includes(result.output.selectedRouteId))
        selectedCandidateValidCount += 1;
      if (result.output.milestoneDialogues.length === MILESTONE_COUNT) {
        milestoneDialogueCountValidCount += 1;
      }
      if (result.validFirstAttempt && !result.usedFallback) {
        firstAttemptCounts[language] += 1;
      }
      if (result.usedFallback) {
        fallbackCount[language] += 1;
      } else {
        validOutputCounts[language] += 1;
        if (result.attempts === 2) retrySuccessCounts[language] += 1;
        if (samples[language].length < 3) {
          samples[language].push({
            selectedRouteId: result.output.selectedRouteId,
            selectionReason: result.output.selectionReason,
            trackTitle: result.output.trackTitle,
            mysteryBrief: result.output.mysteryBrief,
            preRunTip: result.output.preRunTip,
            milestoneDialogues: result.output.milestoneDialogues,
          });
        }
      }
      if (index + 1 < requestsPerLanguage) await delay(delayMs);
    }
  }

  const totalRequests = requestsPerLanguage * languages.length;
  const validFirstCount = firstAttemptCounts.id + firstAttemptCounts.en;
  const validOutputCount = validOutputCounts.id + validOutputCounts.en;
  const retriesSucceeded = retrySuccessCounts.id + retrySuccessCounts.en;
  const fallbacks = fallbackCount.id + fallbackCount.en;
  const summary = {
    executionMode: "live",
    modelId: env.LLM_MODEL_FAST ?? null,
    modelAvailable: capabilities.available,
    modelFeatures: capabilities.supportedFeatures,
    jsonSchemaRequested: capabilities.supportsJsonSchema,
    toolCallRequested: !capabilities.supportsJsonSchema && capabilities.supportsTools,
    requestCount: totalRequests,
    requestsPerLanguage,
    validFirstAttemptCount: validFirstCount,
    validFirstAttemptPercent: percentage(validFirstCount, totalRequests),
    retrySuccessCount: retriesSucceeded,
    validOutputCount,
    validOutputPercent: percentage(validOutputCount, totalRequests),
    fallbackCount: fallbacks,
    selectedCandidateValidCount,
    selectedCandidateValidPercent: percentage(selectedCandidateValidCount, totalRequests),
    milestoneDialogueCountValidCount,
    milestoneDialogueCountValidPercent: percentage(
      milestoneDialogueCountValidCount,
      totalRequests,
    ),
    p95RequestMs: percentile(firstAttemptLatencies, 0.95),
    elapsedMs: Math.round(performance.now() - startedAt),
    perLanguage: {
      id: {
        validFirstAttemptCount: firstAttemptCounts.id,
        retrySuccessCount: retrySuccessCounts.id,
        fallbackCount: fallbackCount.id,
      },
      en: {
        validFirstAttemptCount: firstAttemptCounts.en,
        retrySuccessCount: retrySuccessCounts.en,
        fallbackCount: fallbackCount.en,
      },
    },
  };
  const output = {
    generatedAt: new Date().toISOString(),
    targetDistanceKm: TARGET_DISTANCE_KM,
    milestoneCount: MILESTONE_COUNT,
    candidateSummaries: candidates,
    thresholds: {
      validFirstAttemptPercent: 95,
      validOutputPercentAfterRetry: 99,
      selectedRouteMustBeCandidate: true,
      milestoneCountMustMatch: true,
      maxDialogueWords: 12,
      p95RequestMs: 5_000,
    },
    summary,
    languageReviewSamples: samples,
    manualLanguageReviewRequired: true,
    containsRawCoordinates: false,
  };
  const outputPath = resolve("docs/adr/provider-spike-llm.json");
  mkdirSync(dirname(outputPath), { recursive: true });
  writeFileSync(outputPath, JSON.stringify(output, null, 2) + "\n", "utf8");
  process.stdout.write(JSON.stringify({ outputPath, summary }, null, 2) + "\n");
  if (
    summary.validFirstAttemptPercent < 95 ||
    summary.validOutputPercent < 99 ||
    summary.p95RequestMs > 5_000 ||
    summary.selectedCandidateValidPercent < 99 ||
    summary.milestoneDialogueCountValidPercent < 100 ||
    validOutputCount < totalRequests
  ) {
    process.exitCode = 1;
  }
}

function buildCandidateSummaries(
  locations: readonly z.infer<typeof routingReportSchema>["locations"][number][],
): readonly RouteCandidate[] {
  const location =
    locations.find(
      (entry) =>
        entry.candidateSummaries.filter((candidate) => candidate.valid).length >= 3,
    ) ?? locations[0];
  if (!location) throw new Error("Routing report has no locations.");
  const selected = location.candidateSummaries
    .filter((candidate) => candidate.valid && candidate.distanceMeters !== null)
    .slice(0, 3);
  if (selected.length < 2)
    throw new Error("Routing report needs at least two valid candidates.");

  return selected.map((candidate, index) => ({
    id: "candidate-" + (index + 1),
    distanceKm: round((candidate.distanceMeters ?? 0) / 1_000),
    elevationGain: location.elevation.available
      ? String(location.elevation.gainMeters ?? 0) + " m"
      : "unknown",
    maxGradePercent: location.elevation.maxGradePercent ?? 0,
    turnsPerKm: candidate.turnsPerKm ?? 0,
    dataConfidence: location.osm.dataConfidence,
    surfaceDesc: location.osm.surfaces?.join(", ") || "pedestrian route",
    areaHints: location.osm.areaHints ?? [],
  }));
}

function parseSampleCount(args: readonly string[]): number {
  const flagIndex = args.indexOf("--samples-per-language");
  if (flagIndex < 0) return DEFAULT_REQUESTS_PER_LANGUAGE;
  const value = Number(args[flagIndex + 1]);
  if (
    !Number.isSafeInteger(value) ||
    value < 1 ||
    value > DEFAULT_REQUESTS_PER_LANGUAGE
  ) {
    throw new RangeError("Use --samples-per-language with a value from 1 to 25.");
  }
  return value;
}

function parseDelay(args: readonly string[]): number {
  const flagIndex = args.indexOf("--delay-ms");
  if (flagIndex < 0) return 250;
  const value = Number(args[flagIndex + 1]);
  if (!Number.isSafeInteger(value) || value < 0 || value > 5_000) {
    throw new RangeError("Use --delay-ms with a value from 0 to 5000.");
  }
  return value;
}

async function delay(durationMs: number): Promise<void> {
  await new Promise<void>((resolveDelay) => setTimeout(resolveDelay, durationMs));
}

function percentile(values: readonly number[], quantile: number): number {
  if (values.length === 0) return 0;
  const sorted = [...values].sort((first, second) => first - second);
  return Math.round(sorted[Math.ceil(sorted.length * quantile) - 1] ?? 0);
}

function percentage(part: number, total: number): number {
  return total === 0 ? 0 : Math.round((part / total) * 1_000) / 10;
}

function round(value: number): number {
  return Math.round(value * 10) / 10;
}

void main().catch((error: unknown) => {
  const details =
    error instanceof z.ZodError
      ? JSON.stringify(
          error.issues.map((issue) => ({
            path: issue.path.map(String),
            code: issue.code,
          })),
        )
      : error instanceof Error
        ? error.name
        : "unknown error";
  process.stderr.write("Nebius selector spike failed: " + details + "\n");
  process.exitCode = 1;
});

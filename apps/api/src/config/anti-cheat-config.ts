import { z } from "zod";
import type { AntiCheatPolicy } from "../domain/anti-cheat";

const positiveInteger = z.number().int().positive().max(Number.MAX_SAFE_INTEGER);
const nonNegativeInteger = z.number().int().nonnegative().max(Number.MAX_SAFE_INTEGER);

export const AntiCheatPolicySchema = z
  .object({
    rollingWindowMs: positiveInteger,
    rejectSpeedThresholdMmPerSec: positiveInteger,
    rejectSustainedMs: positiveInteger,
    flagRollingSpeedThresholdMmPerSec: positiveInteger,
    jumpDistanceThresholdMm: positiveInteger,
    jumpMaxDeltaMs: positiveInteger,
    maxSampleGapMs: positiveInteger,
    maxAllowedGaps: nonNegativeInteger,
    maxAllowedDuplicates: nonNegativeInteger,
    maxAllowedMockedSamples: nonNegativeInteger,
    maxAllowedOutOfOrderSamples: nonNegativeInteger,
  })
  .strict() satisfies z.ZodType<AntiCheatPolicy>;

export const AntiCheatConfigSchema = z
  .object({
    version: z.number().int().positive(),
    mode: z.enum(["shadow", "enforce"]),
    thresholds: AntiCheatPolicySchema,
  })
  .strict();

export type AntiCheatConfig = z.infer<typeof AntiCheatConfigSchema>;

// Initial shadow policy follows README.md §11; the other limits preserve the
// pre-calibration safeguards already used by the run service.
export const INITIAL_ANTI_CHEAT_CONFIG: AntiCheatConfig = AntiCheatConfigSchema.parse({
  version: 1,
  mode: "shadow",
  thresholds: {
    rollingWindowMs: 60_000,
    rejectSpeedThresholdMmPerSec: 12_000,
    rejectSustainedMs: 10_000,
    flagRollingSpeedThresholdMmPerSec: 7_500,
    jumpDistanceThresholdMm: 150_000,
    jumpMaxDeltaMs: 5_000,
    maxSampleGapMs: 120_000,
    maxAllowedGaps: 2,
    maxAllowedDuplicates: 0,
    maxAllowedMockedSamples: 0,
    maxAllowedOutOfOrderSamples: 0,
  },
});

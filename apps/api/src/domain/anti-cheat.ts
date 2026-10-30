import {
  assertNonNegativeInteger,
  assertPositiveInteger,
  floorDiv,
  multiplySafeIntegers,
  roundDiv,
  sumSafeIntegers,
} from "./math";
import type { Integrity } from "../types/game";

export interface AntiCheatSample {
  readonly sequence: number;
  readonly timestampMs: number;
  readonly latitudeE7: number;
  readonly longitudeE7: number;
  // Repository supplies this integer distance from its authoritative geometry check.
  readonly distanceFromPreviousMm: number;
  readonly mocked: boolean;
}

export interface AntiCheatPolicy {
  readonly rollingWindowMs: number;
  readonly rejectSpeedThresholdMmPerSec: number;
  readonly rejectSustainedMs: number;
  readonly flagRollingSpeedThresholdMmPerSec: number;
  readonly jumpDistanceThresholdMm: number;
  readonly jumpMaxDeltaMs: number;
  readonly maxSampleGapMs: number;
  readonly maxAllowedGaps: number;
  readonly maxAllowedDuplicates: number;
  readonly maxAllowedMockedSamples: number;
  readonly maxAllowedOutOfOrderSamples: number;
}

export interface AntiCheatMetrics {
  readonly maxRollingSpeedMmPerSec: number;
  readonly maxContinuousSpeedDurationMs: number;
  readonly maxJumpDistanceMm: number;
  readonly jumpCount: number;
  readonly gapCount: number;
  readonly duplicateCount: number;
  readonly mockedCount: number;
  readonly outOfOrderCount: number;
}

export interface AntiCheatResult {
  readonly integrity: Integrity;
  readonly reasonCodes: readonly string[];
  readonly metrics: AntiCheatMetrics;
}

interface Segment {
  readonly startMs: number;
  readonly endMs: number;
  readonly durationMs: number;
  readonly distanceMm: number;
  readonly speedMmPerSec: number;
}

function validatePolicy(policy: AntiCheatPolicy): void {
  assertPositiveInteger(policy.rollingWindowMs, "rollingWindowMs");
  assertPositiveInteger(
    policy.rejectSpeedThresholdMmPerSec,
    "rejectSpeedThresholdMmPerSec",
  );
  assertPositiveInteger(policy.rejectSustainedMs, "rejectSustainedMs");
  assertPositiveInteger(
    policy.flagRollingSpeedThresholdMmPerSec,
    "flagRollingSpeedThresholdMmPerSec",
  );
  assertPositiveInteger(policy.jumpDistanceThresholdMm, "jumpDistanceThresholdMm");
  assertPositiveInteger(policy.jumpMaxDeltaMs, "jumpMaxDeltaMs");
  assertPositiveInteger(policy.maxSampleGapMs, "maxSampleGapMs");
  assertNonNegativeInteger(policy.maxAllowedGaps, "maxAllowedGaps");
  assertNonNegativeInteger(policy.maxAllowedDuplicates, "maxAllowedDuplicates");
  assertNonNegativeInteger(policy.maxAllowedMockedSamples, "maxAllowedMockedSamples");
  assertNonNegativeInteger(
    policy.maxAllowedOutOfOrderSamples,
    "maxAllowedOutOfOrderSamples",
  );
}

function validateSample(sample: AntiCheatSample): void {
  assertPositiveInteger(sample.sequence, "sample.sequence");
  assertNonNegativeInteger(sample.timestampMs, "sample.timestampMs");
  assertNonNegativeInteger(
    sample.distanceFromPreviousMm,
    "sample.distanceFromPreviousMm",
  );
  if (
    !Number.isSafeInteger(sample.latitudeE7) ||
    sample.latitudeE7 < -900_000_000 ||
    sample.latitudeE7 > 900_000_000
  ) {
    throw new RangeError("sample.latitudeE7 is outside the valid range.");
  }
  if (
    !Number.isSafeInteger(sample.longitudeE7) ||
    sample.longitudeE7 < -1_800_000_000 ||
    sample.longitudeE7 > 1_800_000_000
  ) {
    throw new RangeError("sample.longitudeE7 is outside the valid range.");
  }
}

function duplicateKey(sample: AntiCheatSample): string {
  return [sample.timestampMs, sample.latitudeE7, sample.longitudeE7].join(":");
}

function collectSegments(
  samples: readonly AntiCheatSample[],
  policy: AntiCheatPolicy,
): {
  readonly segments: readonly Segment[];
  readonly duplicateCount: number;
  readonly mockedCount: number;
  readonly outOfOrderCount: number;
  readonly gapCount: number;
  readonly jumpCount: number;
  readonly maxJumpDistanceMm: number;
  readonly maxContinuousSpeedDurationMs: number;
} {
  const seen = new Set<string>();
  let duplicateCount = 0;
  let mockedCount = 0;
  let outOfOrderCount = 0;
  let gapCount = 0;
  let jumpCount = 0;
  let maxJumpDistanceMm = 0;
  let continuousSpeedDurationMs = 0;
  let maxContinuousSpeedDurationMs = 0;
  const segments: Segment[] = [];

  samples.forEach((sample) => {
    validateSample(sample);
    const key = duplicateKey(sample);
    if (seen.has(key)) duplicateCount += 1;
    else seen.add(key);
    if (sample.mocked) mockedCount += 1;
  });

  for (let index = 1; index < samples.length; index += 1) {
    const previous = samples[index - 1];
    const current = samples[index];
    if (!previous || !current) continue;
    const durationMs = current.timestampMs - previous.timestampMs;
    if (durationMs <= 0) {
      if (durationMs < 0 || duplicateKey(previous) !== duplicateKey(current)) {
        outOfOrderCount += 1;
      }
      continuousSpeedDurationMs = 0;
      continue;
    }
    const distanceMm = current.distanceFromPreviousMm;
    const speedMmPerSec = roundDiv(
      multiplySafeIntegers(distanceMm, 1000, "sample speed"),
      durationMs,
    );
    segments.push({
      startMs: previous.timestampMs,
      endMs: current.timestampMs,
      durationMs,
      distanceMm,
      speedMmPerSec,
    });
    if (durationMs > policy.maxSampleGapMs) gapCount += 1;
    if (
      distanceMm > policy.jumpDistanceThresholdMm &&
      durationMs <= policy.jumpMaxDeltaMs
    ) {
      jumpCount += 1;
      maxJumpDistanceMm = Math.max(maxJumpDistanceMm, distanceMm);
    }
    const isRejectSpeed =
      multiplySafeIntegers(distanceMm, 1000, "sample speed threshold") >=
      multiplySafeIntegers(
        policy.rejectSpeedThresholdMmPerSec,
        durationMs,
        "sample speed threshold",
      );
    if (durationMs <= policy.maxSampleGapMs && isRejectSpeed) {
      continuousSpeedDurationMs += durationMs;
      maxContinuousSpeedDurationMs = Math.max(
        maxContinuousSpeedDurationMs,
        continuousSpeedDurationMs,
      );
    } else {
      continuousSpeedDurationMs = 0;
    }
  }

  return {
    segments,
    duplicateCount,
    mockedCount,
    outOfOrderCount,
    gapCount,
    jumpCount,
    maxJumpDistanceMm,
    maxContinuousSpeedDurationMs,
  };
}

function distanceInWindow(
  segments: readonly Segment[],
  windowStartMs: number,
  windowEndMs: number,
): number {
  const distances = segments.map((segment) => {
    const overlapMs = Math.max(
      0,
      Math.min(segment.endMs, windowEndMs) - Math.max(segment.startMs, windowStartMs),
    );
    if (overlapMs === 0) return 0;
    return floorDiv(
      multiplySafeIntegers(segment.distanceMm, overlapMs, "rolling window distance"),
      segment.durationMs,
    );
  });
  return sumSafeIntegers(distances, "rolling window distance");
}

function maxRollingSpeed(input: {
  readonly samples: readonly AntiCheatSample[];
  readonly segments: readonly Segment[];
  readonly windowMs: number;
  readonly flagThresholdMmPerSec: number;
}): { readonly speedMmPerSec: number; readonly exceedsFlagThreshold: boolean } {
  const first = input.samples[0];
  const last = input.samples[input.samples.length - 1];
  if (!first || !last || last.timestampMs - first.timestampMs < input.windowMs) {
    return { speedMmPerSec: 0, exceedsFlagThreshold: false };
  }
  const candidates = new Set<number>();
  for (const sample of input.samples) {
    candidates.add(sample.timestampMs);
    candidates.add(sample.timestampMs + input.windowMs);
  }
  let maximum = 0;
  let exceedsFlagThreshold = false;
  for (const windowEndMs of candidates) {
    if (
      windowEndMs < first.timestampMs + input.windowMs ||
      windowEndMs > last.timestampMs
    ) {
      continue;
    }
    const windowStartMs = windowEndMs - input.windowMs;
    const distanceMm = distanceInWindow(input.segments, windowStartMs, windowEndMs);
    const distancePerSecondNumerator = multiplySafeIntegers(
      distanceMm,
      1000,
      "rolling speed",
    );
    const thresholdNumerator = multiplySafeIntegers(
      input.flagThresholdMmPerSec,
      input.windowMs,
      "rolling speed threshold",
    );
    if (distancePerSecondNumerator > thresholdNumerator) {
      exceedsFlagThreshold = true;
    }
    maximum = Math.max(maximum, roundDiv(distancePerSecondNumerator, input.windowMs));
  }
  return { speedMmPerSec: maximum, exceedsFlagThreshold };
}

export function analyzeAntiCheat(
  samples: readonly AntiCheatSample[],
  policy: AntiCheatPolicy,
): AntiCheatResult {
  validatePolicy(policy);
  const collected = collectSegments(samples, policy);
  const rolling = maxRollingSpeed({
    samples,
    segments: collected.segments,
    windowMs: policy.rollingWindowMs,
    flagThresholdMmPerSec: policy.flagRollingSpeedThresholdMmPerSec,
  });
  const metrics: AntiCheatMetrics = {
    maxRollingSpeedMmPerSec: rolling.speedMmPerSec,
    maxContinuousSpeedDurationMs: collected.maxContinuousSpeedDurationMs,
    maxJumpDistanceMm: collected.maxJumpDistanceMm,
    jumpCount: collected.jumpCount,
    gapCount: collected.gapCount,
    duplicateCount: collected.duplicateCount,
    mockedCount: collected.mockedCount,
    outOfOrderCount: collected.outOfOrderCount,
  };
  const reasonCodes: string[] = [];
  const sustainedHighSpeed =
    metrics.maxContinuousSpeedDurationMs >= policy.rejectSustainedMs;
  if (sustainedHighSpeed) reasonCodes.push("sustained_high_speed");
  if (rolling.exceedsFlagThreshold) {
    reasonCodes.push("rolling_speed");
  }
  if (metrics.jumpCount > 0) reasonCodes.push("teleport_jump");
  if (metrics.gapCount > policy.maxAllowedGaps) reasonCodes.push("time_gap");
  if (metrics.duplicateCount > policy.maxAllowedDuplicates) {
    reasonCodes.push("duplicate_samples");
  }
  if (metrics.mockedCount > policy.maxAllowedMockedSamples) {
    reasonCodes.push("mocked_location");
  }
  if (metrics.outOfOrderCount > policy.maxAllowedOutOfOrderSamples) {
    reasonCodes.push("out_of_order_samples");
  }
  const hasFlag = reasonCodes.length > 0;
  return {
    integrity: sustainedHighSpeed ? "rejected" : hasFlag ? "flagged" : "clean",
    reasonCodes,
    metrics,
  };
}

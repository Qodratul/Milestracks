import { distanceBetween } from "./route-geometry";
import type { GpxTrack } from "./gpx";

export interface GpxAnalysisOptions {
  readonly jumpSpeedThresholdMps?: number;
  readonly timeGapThresholdSec?: number;
}

export interface GpxSpeedWindow {
  readonly startTime: string;
  readonly samples: number;
  readonly distanceMeters: number;
  readonly durationSec: number;
  readonly speedMps: number;
  readonly paceSecPerKm: number;
}

export interface GpxJump {
  readonly fromSample: number;
  readonly toSample: number;
  readonly timestamp: string | null;
  readonly distanceMeters: number;
  readonly durationSec: number | null;
  readonly speedMps: number | null;
  readonly segmentBoundary: boolean;
}

export interface GpxAnalysis {
  readonly name: string;
  readonly description: string;
  readonly sampleCount: number;
  readonly timedSampleCount: number;
  readonly distanceMeters: number;
  readonly elapsedDurationSec: number;
  readonly samplesPerKm: number | null;
  readonly speedWindows60Sec: readonly GpxSpeedWindow[];
  readonly speedWindowDistributionMps: {
    readonly p50: number | null;
    readonly p95: number | null;
    readonly max: number | null;
  };
  readonly jumps: readonly GpxJump[];
  readonly timeGapCount: number;
  readonly timeReversalCount: number;
  readonly duplicateCount: number;
  readonly mockedSampleCount: number;
  readonly accuracyMeters: {
    readonly sampleCount: number;
    readonly missingCount: number;
    readonly min: number | null;
    readonly p50: number | null;
    readonly p95: number | null;
    readonly max: number | null;
  };
}

interface WindowAccumulator {
  samples: number;
  distanceMeters: number;
  durationSec: number;
}

export function analyzeGpx(
  track: GpxTrack,
  options: GpxAnalysisOptions = {},
): GpxAnalysis {
  const jumpSpeedThresholdMps = options.jumpSpeedThresholdMps ?? 12;
  const timeGapThresholdSec = options.timeGapThresholdSec ?? 10;
  if (!Number.isFinite(jumpSpeedThresholdMps) || jumpSpeedThresholdMps <= 0) {
    throw new RangeError("Jump speed threshold must be positive.");
  }
  if (!Number.isFinite(timeGapThresholdSec) || timeGapThresholdSec <= 0) {
    throw new RangeError("Time gap threshold must be positive.");
  }

  const points = track.points;
  const times = points
    .map((point) => point.timestampMs)
    .filter((value): value is number => value !== null);
  const baseTime = times[0] ?? 0;
  const windows = new Map<number, WindowAccumulator>();
  const jumps: GpxJump[] = [];
  const accuracies = points
    .map((point) => point.accuracyMeters)
    .filter((value): value is number => value !== null && Number.isFinite(value))
    .sort((left, right) => left - right);
  let distanceMeters = 0;
  let elapsedDurationSec = 0;
  let timeGapCount = 0;
  let timeReversalCount = 0;
  let duplicateCount = 0;

  for (let index = 1; index < points.length; index += 1) {
    const previous = points[index - 1]!;
    const current = points[index]!;
    const segmentBoundary = previous.segmentIndex !== current.segmentIndex;
    const segmentDistance = distanceBetween(previous, current);
    distanceMeters += segmentDistance;
    const deltaSec =
      previous.timestampMs === null || current.timestampMs === null
        ? null
        : (current.timestampMs - previous.timestampMs) / 1000;

    if (deltaSec === null) continue;
    if (deltaSec < 0) {
      timeReversalCount += 1;
      continue;
    }
    if (deltaSec === 0) {
      if (segmentDistance < 0.05) duplicateCount += 1;
      if (segmentDistance > 0.05) {
        jumps.push({
          fromSample: index,
          toSample: index + 1,
          timestamp:
            current.timestampMs === null
              ? null
              : new Date(current.timestampMs).toISOString(),
          distanceMeters: round(segmentDistance, 1),
          durationSec: 0,
          speedMps: null,
          segmentBoundary,
        });
      }
      continue;
    }

    elapsedDurationSec += deltaSec;
    if (deltaSec > timeGapThresholdSec) timeGapCount += 1;
    const speedMps = segmentDistance / deltaSec;
    const windowIndex = Math.floor(
      ((previous.timestampMs ?? baseTime) - baseTime) / 60_000,
    );
    const window = windows.get(windowIndex) ?? {
      samples: 0,
      distanceMeters: 0,
      durationSec: 0,
    };
    window.samples += 1;
    window.distanceMeters += segmentDistance;
    window.durationSec += deltaSec;
    windows.set(windowIndex, window);

    if (speedMps > jumpSpeedThresholdMps) {
      jumps.push({
        fromSample: index,
        toSample: index + 1,
        timestamp:
          current.timestampMs === null
            ? null
            : new Date(current.timestampMs).toISOString(),
        distanceMeters: round(segmentDistance, 1),
        durationSec: round(deltaSec, 2),
        speedMps: round(speedMps, 2),
        segmentBoundary,
      });
    }
  }

  const speedWindows60Sec = [...windows.entries()]
    .sort(([left], [right]) => left - right)
    .map(([windowIndex, window]) => {
      const speedMps =
        window.durationSec > 0 ? window.distanceMeters / window.durationSec : 0;
      return {
        startTime: new Date(baseTime + windowIndex * 60_000).toISOString(),
        samples: window.samples,
        distanceMeters: round(window.distanceMeters, 1),
        durationSec: round(window.durationSec, 1),
        speedMps: round(speedMps, 3),
        paceSecPerKm: speedMps > 0 ? round(1000 / speedMps, 1) : 0,
      };
    });
  const windowSpeeds = speedWindows60Sec
    .map((window) => window.speedMps)
    .sort((a, b) => a - b);

  return {
    name: track.name,
    description: track.description,
    sampleCount: points.length,
    timedSampleCount: times.length,
    distanceMeters: round(distanceMeters, 1),
    elapsedDurationSec: round(elapsedDurationSec, 1),
    samplesPerKm:
      distanceMeters > 0 ? round(points.length / (distanceMeters / 1000), 1) : null,
    speedWindows60Sec,
    speedWindowDistributionMps: {
      p50: percentile(windowSpeeds, 0.5),
      p95: percentile(windowSpeeds, 0.95),
      max: windowSpeeds.at(-1) ?? null,
    },
    jumps,
    timeGapCount,
    timeReversalCount,
    duplicateCount,
    mockedSampleCount: points.filter((point) => point.mocked === true).length,
    accuracyMeters: {
      sampleCount: accuracies.length,
      missingCount: points.length - accuracies.length,
      min: accuracies[0] ?? null,
      p50: percentile(accuracies, 0.5),
      p95: percentile(accuracies, 0.95),
      max: accuracies.at(-1) ?? null,
    },
  };
}

export function renderGpxMarkdown(
  analyses: readonly { readonly file: string; readonly analysis: GpxAnalysis }[],
): string {
  const rows = analyses.map(({ file, analysis }) => {
    const p50 = analysis.speedWindowDistributionMps.p50;
    const p95 = analysis.speedWindowDistributionMps.p95;
    const cells = [
      markdownCell(file),
      markdownCell(analysis.description || "unlabeled"),
      String(analysis.sampleCount),
      (analysis.distanceMeters / 1000).toFixed(2),
      analysis.samplesPerKm === null ? "n/a" : analysis.samplesPerKm.toFixed(1),
      p50 === null ? "n/a" : (p50 * 3.6).toFixed(1),
      p95 === null ? "n/a" : (p95 * 3.6).toFixed(1),
      analysis.accuracyMeters.p95 === null
        ? "n/a"
        : analysis.accuracyMeters.p95.toFixed(1),
      String(analysis.jumps.length),
      String(analysis.timeGapCount),
      String(analysis.timeReversalCount),
      String(analysis.mockedSampleCount),
    ];
    return "| " + cells.join(" | ") + " |";
  });
  return [
    "# GPX analysis",
    "",
    "Window speed values use consecutive timed trackpoints grouped into 60-second windows.",
    "Speed columns are km/h; distance, sample counts, and accuracy come from the GPX points.",
    "",
    "| File | Label | Samples | Distance km | Samples/km | Speed p50 km/h | Speed p95 km/h | Accuracy p95 m | Jumps | Gaps | Clock reversals | Mocked |",
    "| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |",
    ...rows,
    "",
  ].join("\n");
}

function percentile(sortedValues: readonly number[], proportion: number): number | null {
  if (sortedValues.length === 0) return null;
  const index = Math.max(0, Math.ceil(sortedValues.length * proportion) - 1);
  return round(sortedValues[index]!, 3);
}

function round(value: number, precision: number): number {
  const factor = 10 ** precision;
  return Math.round(value * factor) / factor;
}

function markdownCell(value: string): string {
  return value.replace(/\|/g, "\\|").replace(/\r?\n/g, " ");
}

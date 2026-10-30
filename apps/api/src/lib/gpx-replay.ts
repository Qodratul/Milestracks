import { randomUUID } from "node:crypto";
import { distanceBetween } from "./route-geometry";
import type { GpxPoint, GpxTrack } from "./gpx";

export interface GpxReplayOptions {
  readonly baseUrl: string;
  readonly accessToken: string;
  readonly routeId: string;
  readonly speedMultiplier?: number;
  readonly pauseAtSequence?: number;
  readonly startTimeMs?: number;
  readonly sampleIntervalMs?: number;
  readonly fetchImpl?: typeof fetch;
}

export interface GpxReplaySummary {
  readonly runId: string;
  readonly uploadedSamples: number;
  readonly locationBatches: number;
  readonly reportedMilestones: number;
  readonly distanceMeters: number;
  readonly operationStatuses: Readonly<Record<string, number>>;
}

interface ReplaySample {
  readonly point: GpxPoint;
  readonly sequence: number;
  readonly timestampMs: number;
  readonly segmentIndex: number;
}

interface ReplayMilestone {
  readonly id: string;
  readonly distanceMeters: number;
}

const MAX_BATCH_SIZE = 100;

export async function replayGpx(
  track: GpxTrack,
  options: GpxReplayOptions,
): Promise<GpxReplaySummary> {
  if (!options.accessToken.trim()) throw new TypeError("An access token is required.");
  if (!options.routeId.trim()) throw new TypeError("A route ID is required.");
  const speedMultiplier = options.speedMultiplier ?? 0;
  if (!Number.isFinite(speedMultiplier) || speedMultiplier < 0) {
    throw new RangeError("Speed multiplier must be zero or greater.");
  }
  if (options.pauseAtSequence !== undefined) {
    if (
      !Number.isInteger(options.pauseAtSequence) ||
      options.pauseAtSequence < 1 ||
      options.pauseAtSequence >= track.points.length
    ) {
      throw new RangeError("Pause sequence must be between 1 and the final sample.");
    }
  }

  const samples = materializeSamples(track, options);
  const fetchImpl = options.fetchImpl ?? fetch;
  const base = apiBase(options.baseUrl);
  const operationStatuses: Record<string, number> = {};
  let locationBatches = 0;
  let reportedMilestones = 0;
  let cumulativeDistance = 0;
  const distanceAtSequence = new Map<number, number>();
  let previousPoint: GpxPoint | undefined;
  for (const sample of samples) {
    if (previousPoint) cumulativeDistance += distanceBetween(previousPoint, sample.point);
    distanceAtSequence.set(sample.sequence, cumulativeDistance);
    previousPoint = sample.point;
  }

  const request = async (
    method: "POST",
    path: string,
    body?: Record<string, unknown>,
    idempotency = false,
  ): Promise<{ readonly status: number; readonly data: unknown }> => {
    const response = await fetchImpl(new URL(base + path), {
      method,
      headers: {
        Authorization: "Bearer " + options.accessToken,
        ...(body ? { "Content-Type": "application/json" } : {}),
        ...(idempotency ? { "Idempotency-Key": randomUUID() } : {}),
      },
      ...(body ? { body: JSON.stringify(body) } : {}),
    });
    let payload: unknown;
    try {
      payload = await response.json();
    } catch {
      throw new Error(method + " " + path + " returned non-JSON HTTP " + response.status);
    }
    if (!response.ok) {
      const code = readErrorCode(payload);
      throw new Error(
        method +
          " " +
          path +
          " returned HTTP " +
          response.status +
          (code ? " (" + code + ")" : ""),
      );
    }
    operationStatuses[path] = response.status;
    return { status: response.status, data: readData(payload) };
  };

  const startSample = samples[0]!;
  const started = await request(
    "POST",
    "/runs",
    {
      routeId: options.routeId,
      boostItemCode: null,
      modifierItemCode: null,
      units: "metric",
      startLocation: {
        lat: startSample.point.lat,
        lng: startSample.point.lng,
        accuracyMeters: positiveAccuracy(startSample.point),
      },
      clientCapabilities: {
        platform: "android",
        appVersion: "gpx-tooling",
        backgroundLocation: true,
        mockLocationEnabled: samples.some((sample) => sample.point.mocked === true),
      },
    },
    true,
  );
  const startData = asRecord(started.data);
  const runId = stringValue(startData?.runId);
  if (!runId) throw new TypeError("POST /runs response did not include data.runId.");
  const milestones = parseMilestones(startData?.milestones);
  const reached = new Set<string>();
  const wallStartMs = Date.now();
  const firstTrackTimeMs = samples[0]!.timestampMs;
  let chunk: ReplaySample[] = [];

  const pauseAndResume = async (): Promise<void> => {
    await request("POST", "/runs/" + encodeURIComponent(runId) + "/pause");
    await request("POST", "/runs/" + encodeURIComponent(runId) + "/resume");
  };

  const flush = async (): Promise<void> => {
    if (chunk.length === 0) return;
    const first = chunk[0]!;
    if (speedMultiplier > 0) {
      const targetMs =
        wallStartMs + Math.max(0, first.timestampMs - firstTrackTimeMs) / speedMultiplier;
      const delayMs = targetMs - Date.now();
      if (delayMs > 0) await delay(delayMs);
    }
    await request("POST", "/runs/" + encodeURIComponent(runId) + "/locations", {
      samples: chunk.map(toApiSample),
    });
    locationBatches += 1;
    for (const milestone of milestones) {
      if (reached.has(milestone.id)) continue;
      const crossing = chunk.find(
        (sample) =>
          (distanceAtSequence.get(sample.sequence) ?? 0) >= milestone.distanceMeters,
      );
      if (!crossing) continue;
      await request(
        "POST",
        "/runs/" +
          encodeURIComponent(runId) +
          "/milestones/" +
          encodeURIComponent(milestone.id) +
          "/reach",
        {
          reachedAt: new Date(crossing.timestampMs).toISOString(),
          location: {
            lat: crossing.point.lat,
            lng: crossing.point.lng,
            accuracyMeters: positiveAccuracy(crossing.point),
          },
          lastSampleSequence: crossing.sequence,
        },
        true,
      );
      reached.add(milestone.id);
      reportedMilestones += 1;
    }
    chunk = [];
  };

  let previousSegment = samples[0]!.segmentIndex;
  let pauseApplied = false;
  for (const sample of samples) {
    if (sample.segmentIndex !== previousSegment) {
      await flush();
      await pauseAndResume();
      previousSegment = sample.segmentIndex;
    }
    if (
      options.pauseAtSequence !== undefined &&
      !pauseApplied &&
      sample.sequence === options.pauseAtSequence + 1
    ) {
      await flush();
      await pauseAndResume();
      pauseApplied = true;
    }
    chunk.push(sample);
    if (chunk.length >= MAX_BATCH_SIZE) await flush();
    if (options.pauseAtSequence === sample.sequence && !pauseApplied) {
      await flush();
      await pauseAndResume();
      pauseApplied = true;
    }
  }
  await flush();

  const firstTime = samples[0]!.timestampMs;
  const lastTime = samples[samples.length - 1]!.timestampMs;
  const totalDistanceMeters = distanceAtSequence.get(samples.length) ?? 0;
  const finish = await request(
    "POST",
    "/runs/" + encodeURIComponent(runId) + "/finish",
    {
      endedAt: new Date(lastTime).toISOString(),
      lastSampleSequence: samples.length,
      clientSummary: {
        distanceMeters: round(totalDistanceMeters, 1),
        durationSec: Math.max(0, Math.round((lastTime - firstTime) / 1000)),
      },
    },
    true,
  );
  const finishData = asRecord(finish.data);
  const claimId = stringValue(finishData?.claimId);
  if (claimId) {
    await request(
      "POST",
      "/runs/" + encodeURIComponent(runId) + "/claim",
      { claimId },
      true,
    );
  }

  return {
    runId,
    uploadedSamples: samples.length,
    locationBatches,
    reportedMilestones,
    distanceMeters: round(totalDistanceMeters, 1),
    operationStatuses,
  };
}

function materializeSamples(
  track: GpxTrack,
  options: GpxReplayOptions,
): readonly ReplaySample[] {
  if (track.points.length === 0) throw new RangeError("GPX contains no samples.");
  const interval = options.sampleIntervalMs ?? 1000;
  if (!Number.isInteger(interval) || interval <= 0) {
    throw new RangeError("Sample interval must be a positive integer.");
  }
  const firstTimedIndex = track.points.findIndex((point) => point.timestampMs !== null);
  const firstExplicitTime =
    firstTimedIndex < 0 ? null : (track.points[firstTimedIndex]?.timestampMs ?? null);
  const fallbackStart =
    options.startTimeMs ??
    (firstExplicitTime === null
      ? Date.now()
      : firstExplicitTime - Math.max(0, firstTimedIndex) * interval);
  let previousTime = fallbackStart - interval;
  return track.points.map((point, index) => {
    const timestampMs = point.timestampMs ?? previousTime + interval;
    previousTime = timestampMs;
    return {
      point,
      sequence: index + 1,
      timestampMs,
      segmentIndex: point.segmentIndex,
    };
  });
}

function toApiSample(sample: ReplaySample): Record<string, unknown> {
  return {
    sequence: sample.sequence,
    t: sample.timestampMs,
    lat: sample.point.lat,
    lng: sample.point.lng,
    accuracyMeters: positiveAccuracy(sample.point),
    ...(sample.point.speedMps === null ? {} : { speedMps: sample.point.speedMps }),
    ...(sample.point.elevationMeters === null
      ? {}
      : { altitudeMeters: sample.point.elevationMeters }),
    ...(sample.point.mocked === null ? {} : { mocked: sample.point.mocked }),
  };
}

function parseMilestones(value: unknown): readonly ReplayMilestone[] {
  if (!Array.isArray(value)) return [];
  return value.flatMap((item) => {
    const record = asRecord(item);
    const id = stringValue(record?.id);
    const distanceMeters = numberValue(record?.distanceMeters);
    return id && distanceMeters !== null ? [{ id, distanceMeters }] : [];
  });
}

function positiveAccuracy(point: GpxPoint): number {
  return point.accuracyMeters !== null && point.accuracyMeters > 0
    ? point.accuracyMeters
    : 10;
}

function apiBase(value: string): string {
  const normalized = value.replace(/\/+$/, "");
  if (!/^https?:\/\//i.test(normalized)) {
    throw new TypeError("API base URL must use http or https.");
  }
  return normalized.endsWith("/api/v1") ? normalized : normalized + "/api/v1";
}

function readData(value: unknown): unknown {
  return asRecord(value)?.data;
}

function readErrorCode(value: unknown): string | null {
  const error = asRecord(asRecord(value)?.error);
  return stringValue(error?.code);
}

function asRecord(value: unknown): Record<string, unknown> | null {
  if (typeof value !== "object" || value === null || Array.isArray(value)) return null;
  return value as Record<string, unknown>;
}

function stringValue(value: unknown): string | null {
  return typeof value === "string" && value.length > 0 ? value : null;
}

function numberValue(value: unknown): number | null {
  return typeof value === "number" && Number.isFinite(value) ? value : null;
}

function round(value: number, precision: number): number {
  const factor = 10 ** precision;
  return Math.round(value * factor) / factor;
}

async function delay(durationMs: number): Promise<void> {
  await new Promise<void>((resolve) => setTimeout(resolve, durationMs));
}

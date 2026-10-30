import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import { describe, expect, it } from "vitest";
import supertest from "supertest";
import { app } from "../../src/app";
import { analyzeGpx } from "../../src/lib/gpx-analysis";
import { generateSyntheticTrack } from "../../src/lib/gpx-generator";
import { parseGpx, serializeGpx } from "../../src/lib/gpx";
import { replayGpx } from "../../src/lib/gpx-replay";

const routeFixture = parseGpx(
  readFileSync(resolve("tests/fixtures/gpx/routes/senayan-loop.gpx"), "utf8"),
);
const validFixture = parseGpx(
  readFileSync(resolve("tests/fixtures/gpx/runs/valid-steady.gpx"), "utf8"),
);
const startTimeMs = Date.parse("2026-10-27T00:00:00.000Z");

describe("GPX parser and serializer", () => {
  it("parses GPX route points and round-trips generated extension data", () => {
    expect(routeFixture.points).toHaveLength(4);
    expect(routeFixture.points[0]?.elevationMeters).toBe(12);
    const reparsed = parseGpx(serializeGpx(validFixture));
    expect(reparsed.name).toBe(validFixture.name);
    expect(reparsed.description).toBe(validFixture.description);
    expect(reparsed.points).toHaveLength(validFixture.points.length);
    expect(reparsed.points[0]?.timestampMs).toBe(validFixture.points[0]?.timestampMs);
    expect(reparsed.points[0]?.accuracyMeters).toBeGreaterThanOrEqual(5);
    expect(reparsed.points[0]?.mocked).toBe(false);
  });

  it("accepts GPX without timestamps for route geometry input", () => {
    expect(routeFixture.points.every((point) => point.timestampMs === null)).toBe(true);
  });

  it("rejects malformed XML, document type declarations, and invalid coordinates", () => {
    expect(() => parseGpx("<gpx><trk></gpx>")).toThrow(/Invalid GPX XML/);
    expect(() => parseGpx('<!DOCTYPE gpx [<!ENTITY x "x">]><gpx><trk/></gpx>')).toThrow(
      /cannot declare/,
    );
    expect(() =>
      parseGpx('<gpx><trk><trkseg><trkpt lat="95" lon="0"/></trkseg></trk></gpx>'),
    ).toThrow(/valid latitude and longitude/);
  });
});

describe("synthetic GPX generation and analysis", () => {
  it("is deterministic for the same route, scenario, start time, and seed", () => {
    const options = {
      scenario: "variable-pace" as const,
      seed: 4242,
      startedAtMs: startTimeMs,
    };
    const first = generateSyntheticTrack(routeFixture, options);
    const second = generateSyntheticTrack(routeFixture, options);
    expect(serializeGpx(first)).toBe(serializeGpx(second));
    const deltas = first.points.slice(1).map((point, index) => {
      return point.timestampMs! - first.points[index]!.timestampMs!;
    });
    expect(deltas.every((delta) => delta === 1000)).toBe(true);
    expect(first.points.every((point) => point.accuracyMeters! >= 5)).toBe(true);
    expect(first.points.every((point) => point.accuracyMeters! <= 30)).toBe(true);
  });

  it("supports 1 Hz noise, pause insertion, and burst signal loss", () => {
    const paused = generateSyntheticTrack(routeFixture, {
      scenario: "pause",
      seed: 17,
      startedAtMs: startTimeMs,
    });
    const pauseSamples = paused.points.filter((point) => point.speedMps === 0);
    expect(pauseSamples.length).toBe(60);

    const signalLoss = analyzeGpx(
      generateSyntheticTrack(routeFixture, {
        scenario: "signal-loss",
        seed: 19,
        startedAtMs: startTimeMs,
      }),
    );
    expect(signalLoss.timeGapCount).toBeGreaterThanOrEqual(1);
    expect(signalLoss.speedWindows60Sec.length).toBeGreaterThan(1);
  });

  it("records cheat signatures in deterministic scenarios", () => {
    const duplicate = analyzeGpx(
      generateSyntheticTrack(routeFixture, {
        scenario: "duplicate",
        seed: 1,
        startedAtMs: startTimeMs,
      }),
    );
    const mocked = analyzeGpx(
      generateSyntheticTrack(routeFixture, {
        scenario: "mocked",
        seed: 2,
        startedAtMs: startTimeMs,
      }),
    );
    const clockSkew = analyzeGpx(
      generateSyntheticTrack(routeFixture, {
        scenario: "clock-skew",
        seed: 3,
        startedAtMs: startTimeMs,
      }),
    );
    const replay = analyzeGpx(
      generateSyntheticTrack(routeFixture, {
        scenario: "replay",
        seed: 4,
        startedAtMs: startTimeMs,
      }),
    );
    const vehicle = analyzeGpx(
      generateSyntheticTrack(routeFixture, {
        scenario: "vehicle",
        seed: 5,
        startedAtMs: startTimeMs,
      }),
    );
    const teleport = analyzeGpx(
      generateSyntheticTrack(routeFixture, {
        scenario: "teleport",
        seed: 6,
        startedAtMs: startTimeMs,
      }),
    );
    const shortcut = analyzeGpx(
      generateSyntheticTrack(routeFixture, {
        scenario: "shortcut",
        seed: 7,
        startedAtMs: startTimeMs,
      }),
    );
    const smooth = analyzeGpx(
      generateSyntheticTrack(routeFixture, {
        scenario: "too-smooth",
        seed: 8,
        startedAtMs: startTimeMs,
      }),
    );

    expect(duplicate.duplicateCount).toBe(1);
    expect(mocked.mockedSampleCount).toBe(mocked.sampleCount);
    expect(clockSkew.timeReversalCount).toBe(1);
    expect(replay.timeReversalCount).toBeGreaterThanOrEqual(1);
    expect(vehicle.jumps.length).toBeGreaterThan(0);
    expect(teleport.jumps.length).toBeGreaterThan(0);
    expect(shortcut.distanceMeters).toBeLessThan(
      analyzeGpx(validFixture).distanceMeters * 0.9,
    );
    expect(smooth.accuracyMeters.p95).toBe(1);
  });

  it("reports 60-second speeds, accuracy distribution, sample density, and clock anomalies", () => {
    const analysis = analyzeGpx(parseGpx(serializeGpx(validFixture)));
    expect(analysis.speedWindows60Sec.length).toBeGreaterThan(1);
    expect(analysis.speedWindowDistributionMps.p95).not.toBeNull();
    expect(analysis.accuracyMeters.p50).not.toBeNull();
    expect(analysis.samplesPerKm).toBeGreaterThan(0);
    expect(analysis.timeReversalCount).toBe(0);
  });
});

describe("GPX replay against the HTTP stub", () => {
  it("starts a run, uploads bounded batches, reaches milestones, pauses, finishes, and claims", async () => {
    const calls: Array<{
      readonly path: string;
      readonly body: Record<string, unknown> | null;
    }> = [];
    const fetchImpl: typeof fetch = async (input, init) => {
      const url =
        typeof input === "string"
          ? new URL(input)
          : input instanceof URL
            ? input
            : new URL(input.url);
      const headers = new Headers(init?.headers);
      let call = supertest(app).post(url.pathname);
      headers.forEach((value, key) => call.set(key, value));
      const body =
        typeof init?.body === "string"
          ? (JSON.parse(init.body) as Record<string, unknown>)
          : null;
      if (typeof init?.body === "string") call = call.send(init.body);
      const response = await call;
      calls.push({ path: url.pathname, body });
      return new Response(JSON.stringify(response.body), {
        status: response.status,
        headers: { "Content-Type": "application/json" },
      });
    };

    const summary = await replayGpx(validFixture, {
      baseUrl: "http://stub.local/api/v1",
      accessToken: "contract-test-token",
      routeId: "route_456",
      pauseAtSequence: 100,
      fetchImpl,
    });

    expect(summary.runId).toBe("run_123");
    expect(summary.uploadedSamples).toBe(validFixture.points.length);
    expect(summary.locationBatches).toBeGreaterThan(1);
    expect(summary.reportedMilestones).toBeGreaterThan(0);
    expect(calls.some((call) => call.path.endsWith("/pause"))).toBe(true);
    expect(calls.some((call) => call.path.endsWith("/resume"))).toBe(true);
    expect(calls.some((call) => call.path.endsWith("/finish"))).toBe(true);
    expect(calls.some((call) => call.path.endsWith("/claim"))).toBe(true);

    const locationCalls = calls.filter((call) => call.path.endsWith("/locations"));
    const uploaded = locationCalls.flatMap((call) => {
      const bodySamples = call.body?.samples;
      return Array.isArray(bodySamples) ? bodySamples : [];
    });
    expect(
      locationCalls.every((call) => {
        const bodySamples = call.body?.samples;
        return Array.isArray(bodySamples) && bodySamples.length <= 100;
      }),
    ).toBe(true);
    expect(uploaded.map((sample) => (sample as { t: number }).t)).toEqual(
      validFixture.points.map((point) => point.timestampMs),
    );
  });
});

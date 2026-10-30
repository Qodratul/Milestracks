import { describe, expect, it } from "vitest";
import {
  activeSecondsAt,
  distanceBetweenMeters,
  gpsQuality,
  runDistanceMeters,
  verifyRunMilestones,
} from "../../src/domain/run";

describe("run domain", () => {
  it("measures GPS distance and quality from samples", () => {
    const samples = [
      { sequence: 1, t: 1_000, lat: -6.2, lng: 106.8, accuracyMeters: 6 },
      { sequence: 2, t: 2_000, lat: -6.1999, lng: 106.8, accuracyMeters: 8 },
    ];
    expect(distanceBetweenMeters(samples[0]!, samples[1]!)).toBeGreaterThan(10);
    expect(runDistanceMeters(samples)).toBeGreaterThan(10);
    expect(gpsQuality(samples)).toBe("strong");
    expect(gpsQuality([{ ...samples[0]!, accuracyMeters: 35 }])).toBe("weak");
  });

  it("subtracts paused intervals from active time", () => {
    expect(
      activeSecondsAt({
        startedAtMs: 1_000,
        timestampMs: 11_000,
        pausePeriods: [{ pausedAt: 4_000, resumedAt: 7_000 }],
      }),
    ).toBe(7);
  });

  it("verifies milestones in route order against server samples", () => {
    const samples = [
      { sequence: 1, t: 10_000, lat: 0, lng: 0, accuracyMeters: 3 },
      { sequence: 2, t: 20_000, lat: 0, lng: 0.001, accuracyMeters: 5 },
    ];
    const milestones = [
      {
        id: "ms_1",
        ordinal: 1,
        distanceMeters: 100,
        exp: 50,
        radiusMeters: 25,
        routeProgress: 0.2,
        latitude: 0,
        longitude: 0,
      },
      {
        id: "ms_2",
        ordinal: 2,
        distanceMeters: 200,
        exp: 50,
        radiusMeters: 25,
        routeProgress: 0.8,
        latitude: 0,
        longitude: 0.001,
      },
    ];
    const result = verifyRunMilestones({
      samples,
      milestones,
      startedAtMs: 10_000,
      pausePeriods: [],
    });
    expect(result.map((item) => item.id)).toEqual(["ms_1", "ms_2"]);
    expect(result[1]?.activeSecAtReach).toBe(10);
  });
});

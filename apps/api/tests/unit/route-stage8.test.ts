import { describe, expect, it } from "vitest";
import {
  decodeGeometryCursor,
  distanceBetween,
  encodeGeometryCursor,
  encodePolyline,
  routeBounds,
  simplifyPolyline,
} from "../../src/lib/route-geometry";
import { statusAfterRouteReport } from "../../src/domain/report-policy";
import {
  RouteSelectionService,
  type SelectableRoute,
} from "../../src/services/route-selection.service";
import type {
  LLMProvider,
  RoutePromptInput,
  TrackNarrativeOutput,
} from "../../src/providers/llm";

describe("route geometry helpers", () => {
  it("encodes the standard polyline example", () => {
    expect(
      encodePolyline([
        { lat: 38.5, lng: -120.2 },
        { lat: 40.7, lng: -120.95 },
        { lat: 43.252, lng: -126.453 },
      ]),
    ).toBe("_p~iF~ps|U_ulLnnqC_mqNvxq" + String.fromCharCode(96) + "@");
  });

  it("simplifies a line while keeping its endpoints", () => {
    const points = Array.from({ length: 101 }, (_value, index) => ({
      lat: -6.2 + index / 1_000_000,
      lng: 106.8 + index / 1_000_000,
    }));
    const result = simplifyPolyline(points, 10);
    expect(result.length).toBeLessThanOrEqual(10);
    expect(result[0]).toEqual(points[0]);
    expect(result.at(-1)).toEqual(points.at(-1));
  });

  it("calculates bounds and haversine distance", () => {
    const points = [
      { lat: -6.2, lng: 106.8 },
      { lat: -6.1, lng: 106.9 },
    ];
    expect(routeBounds(points)).toEqual({
      north: -6.1,
      south: -6.2,
      east: 106.9,
      west: 106.8,
    });
    expect(distanceBetween(points[0]!, points[1]!)).toBeGreaterThan(0);
  });

  it("rejects cursors bound to another route", () => {
    const cursor = encodeGeometryCursor("route_a", 500);
    expect(decodeGeometryCursor(cursor, "route_a")).toBe(500);
    expect(decodeGeometryCursor(cursor, "route_b")).toBeUndefined();
  });
});

describe("route report policy", () => {
  it("suspends a template after three distinct safety reports", () => {
    expect(
      statusAfterRouteReport({
        currentStatus: "active",
        uniqueSafetyConcernReporters: 3,
      }),
    ).toBe("suspended");
  });

  it("flags a template after one safety report", () => {
    expect(
      statusAfterRouteReport({
        currentStatus: "active",
        uniqueSafetyConcernReporters: 1,
      }),
    ).toBe("flagged");
  });
});

describe("route selection", () => {
  const candidates: readonly SelectableRoute[] = [
    {
      id: "route_low",
      distanceMeters: 1_500,
      scorePermil: 700,
      safetyScore: 0.8,
      dataConfidence: 0.9,
      elevationGainMeters: 8,
      maxGradePercent: 2,
      surfaces: ["paved"],
      areaHints: ["park"],
    },
    {
      id: "route_high",
      distanceMeters: 1_480,
      scorePermil: 900,
      safetyScore: 0.95,
      dataConfidence: 0.9,
      elevationGainMeters: 5,
      maxGradePercent: 1,
      surfaces: ["paved"],
      areaHints: ["greenway"],
    },
  ];

  it("retries an invalid choice once without sending raw coordinates", async () => {
    let attempts = 0;
    let prompt: RoutePromptInput | undefined;
    const llm: LLMProvider = {
      async generateTrackNarrative(input) {
        attempts += 1;
        prompt = input;
        return narrative(attempts === 1 ? "outside_candidate" : "route_low");
      },
      async evaluateRunnerSafety() {
        return {
          recommendSafeStop: false,
          applyRestShield: false,
          kilaAdvice: "Keep a steady pace.",
          riskLevel: "low",
        };
      },
    };
    const result = await new RouteSelectionService(llm).select({
      userLevel: "Beginner",
      totalDistanceMeters: 1_500,
      milestoneCount: 2,
      language: "en",
      candidates,
    });
    expect(attempts).toBe(2);
    expect(result.selected.id).toBe("route_low");
    expect(result.usedFallback).toBe(false);
    expect(JSON.stringify(prompt)).not.toMatch(/lat|lng|coordinates/i);
  });

  it("uses the highest score when both LLM choices are invalid", async () => {
    const llm: LLMProvider = {
      async generateTrackNarrative() {
        return narrative("outside_candidate");
      },
      async evaluateRunnerSafety() {
        return {
          recommendSafeStop: false,
          applyRestShield: false,
          kilaAdvice: "Keep a steady pace.",
          riskLevel: "low",
        };
      },
    };
    const result = await new RouteSelectionService(llm).select({
      userLevel: "Beginner",
      totalDistanceMeters: 1_500,
      milestoneCount: 2,
      language: "en",
      candidates,
    });
    expect(result.selected.id).toBe("route_high");
    expect(result.narrative.selectedRouteId).toBe("route_high");
    expect(result.usedFallback).toBe(true);
  });

  it("falls back to the highest score when the LLM is unavailable", async () => {
    const llm: LLMProvider = {
      async generateTrackNarrative() {
        throw new Error("LLM is unavailable.");
      },
      async evaluateRunnerSafety() {
        return {
          recommendSafeStop: false,
          applyRestShield: false,
          kilaAdvice: "Keep a steady pace.",
          riskLevel: "low",
        };
      },
    };
    const result = await new RouteSelectionService(llm).select({
      userLevel: "Beginner",
      totalDistanceMeters: 1_500,
      milestoneCount: 2,
      language: "en",
      candidates,
    });
    expect(result.selected.id).toBe("route_high");
    expect(result.usedFallback).toBe(true);
  });
});

function narrative(selectedRouteId: string): TrackNarrativeOutput {
  return {
    selectedRouteId,
    selectionReason: "Balanced route.",
    trackTitle: "Quiet Greenway",
    mysteryBrief: "Follow the quiet path.",
    preRunTip: "Warm up first.",
    milestoneDialogues: [1, 2].map((milestoneOrder) => ({
      milestoneOrder,
      cheerLine: "Nice work.",
      continuePrompt: "Keep going.",
      restPrompt: "Take a break if needed.",
      warnLine: "Watch the path.",
    })),
  };
}

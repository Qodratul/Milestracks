import { afterEach, describe, expect, it, vi } from "vitest";
import { OpenMeteoElevationProvider } from "../../src/providers/elevation";
import { OverpassOsmTagsProvider } from "../../src/providers/osm-tags";
import {
  generateLoopCandidates,
  GraphHopperRoutingProvider,
  MockRoutingProvider,
} from "../../src/providers/routing";
import { buildRouteUserPrompt } from "../../src/providers/llm/prompts";

afterEach(() => {
  vi.unstubAllGlobals();
});

describe("routing providers and loop generation", () => {
  it("maps GraphHopper coordinates and snapped waypoints without logging the key", async () => {
    const request = vi.fn<typeof fetch>(
      async () =>
        new Response(
          JSON.stringify({
            paths: [
              {
                distance: 1_500,
                time: 600_000,
                points: {
                  type: "LineString",
                  coordinates: [
                    [106.8, -6.2],
                    [106.81, -6.21],
                  ],
                },
                snapped_waypoints: {
                  type: "LineString",
                  coordinates: [
                    [106.8001, -6.2001],
                    [106.8099, -6.2099],
                  ],
                },
                instructions: [{ text: "Continue", distance: 1_500, sign: 0 }],
              },
            ],
          }),
          { status: 200 },
        ),
    );
    const provider = new GraphHopperRoutingProvider({
      apiKey: "stage7-test-secret",
      baseUrl: "https://graphhopper.test/api/1",
      profile: "foot",
      creditsPerMinute: 60_000,
      request,
    });

    const result = await provider.route([
      { lat: -6.2, lng: 106.8 },
      { lat: -6.21, lng: 106.81 },
    ]);
    const url = new URL(String(request.mock.calls[0]?.[0]));

    expect(url.searchParams.getAll("point")).toEqual(["-6.2,106.8", "-6.21,106.81"]);
    expect(url.searchParams.get("key")).toBe("stage7-test-secret");
    expect(result.geometry[0]).toEqual({ lat: -6.2, lng: 106.8 });
    expect(result.snappedWaypoints[0]).toEqual({ lat: -6.2001, lng: 106.8001 });
  });

  it("requests a round-trip loop with an account-supported seed", async () => {
    const request = vi.fn<typeof fetch>(
      async () =>
        new Response(
          JSON.stringify({
            paths: [
              {
                distance: 1_500,
                time: 600_000,
                points: {
                  type: "LineString",
                  coordinates: [
                    [106.8, -6.2],
                    [106.81, -6.21],
                    [106.8, -6.2],
                  ],
                },
                snapped_waypoints: {
                  type: "LineString",
                  coordinates: [[106.8001, -6.2001]],
                },
                instructions: [{ text: "Continue", distance: 1_500, sign: 0 }],
              },
            ],
          }),
          { status: 200 },
        ),
    );
    const provider = new GraphHopperRoutingProvider({
      apiKey: "round-trip-test-secret",
      baseUrl: "https://graphhopper.test/api/1",
      profile: "foot",
      creditsPerMinute: 60_000,
      request,
    });

    const result = await provider.routeLoop({
      start: { lat: -6.2, lng: 106.8 },
      targetDistanceMeters: 1_000,
      seed: 31,
    });
    const url = new URL(String(request.mock.calls[0]?.[0]));

    expect(url.searchParams.get("algorithm")).toBe("round_trip");
    expect(url.searchParams.get("round_trip.distance")).toBe("1000");
    expect(url.searchParams.get("round_trip.seed")).toBe("31");
    expect(url.searchParams.get("pass_through")).toBeNull();
    expect(result.snappedWaypoints[0]).toEqual({ lat: -6.2001, lng: 106.8001 });
  });

  it("hides vendor keys in GraphHopper errors", async () => {
    const provider = new GraphHopperRoutingProvider({
      apiKey: "stage7-hidden-secret",
      creditsPerMinute: 60_000,
      request: async () =>
        new Response(JSON.stringify({ message: "invalid key" }), { status: 401 }),
    });

    await expect(
      provider.route([
        { lat: -6.2, lng: 106.8 },
        { lat: -6.21, lng: 106.81 },
      ]),
    ).rejects.toMatchObject({
      code: "REQUEST_FAILED",
      statusCode: 401,
      message: expect.not.stringContaining("stage7-hidden-secret"),
    });
  });

  it("builds three deterministic loop candidates within two adjustments", async () => {
    const provider = new MockRoutingProvider();
    const input = {
      start: { lat: -6.2, lng: 106.8 },
      targetDistanceMeters: 1_500,
      candidateCount: 3,
      maxAdjustments: 2,
    } as const;

    const first = await generateLoopCandidates(provider, input);
    const second = await generateLoopCandidates(provider, input);

    expect(first).toHaveLength(3);
    expect(first.every((candidate) => candidate.valid)).toBe(true);
    expect(first.every((candidate) => candidate.attempts === 1)).toBe(true);
    expect(first.map((candidate) => candidate.route?.distanceMeters)).toEqual(
      second.map((candidate) => candidate.route?.distanceMeters),
    );
  });

  it("counts U-turns from GraphHopper instruction signs, not polyline corners", async () => {
    const provider = {
      route: async (waypoints: readonly { lat: number; lng: number }[]) => ({
        distanceMeters: 1_500,
        timeMs: 600_000,
        geometry: [
          { lat: 0, lng: 0 },
          { lat: 0.001, lng: 0 },
        ],
        snappedWaypoints: [waypoints[0]!],
        instructions: [{ text: "U-turn", distanceMeters: 10, sign: -98 }],
        providerLatencyMs: 0,
      }),
      routeLoop: async (input: {
        start: { lat: number; lng: number };
        targetDistanceMeters: number;
        seed: number;
      }) => ({
        distanceMeters: input.targetDistanceMeters / 0.67,
        timeMs: 600_000,
        geometry: [
          { lat: input.start.lat, lng: input.start.lng },
          { lat: input.start.lat + 0.001, lng: input.start.lng },
        ],
        snappedWaypoints: [input.start],
        instructions: [{ text: "U-turn", distanceMeters: 10, sign: -98 }],
        providerLatencyMs: 0,
      }),
    };
    const candidates = await generateLoopCandidates(provider, {
      start: { lat: -6.2, lng: 106.8 },
      targetDistanceMeters: 1_500,
      candidateCount: 2,
      maxAdjustments: 0,
    });

    expect(candidates.every((candidate) => candidate.uTurnCount === 1)).toBe(true);
  });
});

describe("optional route enrichment providers", () => {
  it("samples elevation around 100m and reuses cached samples", async () => {
    const request = vi.fn<typeof fetch>(async (input) => {
      const url = new URL(String(input));
      const count = url.searchParams.get("latitude")?.split(",").length ?? 0;
      return new Response(
        JSON.stringify({
          elevation: Array.from({ length: count }, (_, index) => index * 5),
        }),
        { status: 200 },
      );
    });
    const provider = new OpenMeteoElevationProvider({
      endpoint: "https://elevation.test/v1/elevation",
      apiKey: "",
      timeoutMs: 1_000,
      request,
    });
    const route = [
      { lat: 10, lng: 20 },
      { lat: 10.0018, lng: 20 },
    ];

    const first = await provider.getProfile(route);
    const second = await provider.getProfile(route);

    expect(first.available).toBe(true);
    expect(first.samples).toHaveLength(3);
    expect(first.gainMeters).toBe(10);
    expect(first.lossMeters).toBe(0);
    expect(first.maxGradePercent).toBeGreaterThan(4);
    expect(second.samples).toEqual(first.samples);
    expect(request).toHaveBeenCalledTimes(1);
  });

  it("falls back to no elevation when Open-Meteo is unavailable", async () => {
    const provider = new OpenMeteoElevationProvider({
      endpoint: "https://elevation.test/v1/elevation",
      apiKey: "",
      timeoutMs: 1_000,
      request: async () => new Response("unavailable", { status: 503 }),
    });

    await expect(provider.getProfile([{ lat: 30, lng: 40 }])).resolves.toMatchObject({
      available: false,
      samples: [],
      gainMeters: 0,
    });
  });

  it("uses Overpass POST, identifies the caller, summarizes tags, and caches results", async () => {
    const request = vi.fn<typeof fetch>(async (_input, init) => {
      const headers = new Headers(init?.headers);
      expect(init?.method).toBe("POST");
      expect(headers.get("User-Agent")).toContain("Milestracks/1.0");
      return new Response(
        JSON.stringify({
          elements: [
            {
              tags: {
                highway: "footway",
                surface: "paved",
                sidewalk: "yes",
                lit: "yes",
                leisure: "park",
              },
            },
            {
              tags: {
                highway: "residential",
                surface: "asphalt",
                sidewalk: "no",
                lit: "yes",
                landuse: "residential",
              },
            },
          ],
        }),
        { status: 200 },
      );
    });
    const provider = new OverpassOsmTagsProvider({
      endpoint: "https://overpass.test/api/interpreter",
      timeoutMs: 1_000,
      requestIntervalMs: 0,
      request,
    });
    const route = [
      { lat: 1.1, lng: 1.1 },
      { lat: 1.101, lng: 1.102 },
    ];

    const first = await provider.getRouteTags(route);
    const second = await provider.getRouteTags(route);

    expect(first.available).toBe(true);
    expect(first.dataConfidence).toBe(0.4);
    expect(first.surfaces).toEqual(["paved", "asphalt"]);
    expect(first.sidewalkCoverage).toBe("yes");
    expect(first.lightingCoverage).toBe("yes");
    expect(first.areaHints).toContain("park");
    expect(second).toEqual(first);
    expect(request).toHaveBeenCalledTimes(1);
  });

  it("returns no OSM data when the provider is disabled", async () => {
    const request = vi.fn<typeof fetch>();
    const provider = new OverpassOsmTagsProvider({ enabled: false, request });

    await expect(
      provider.getRouteTags([
        { lat: -10, lng: 30 },
        { lat: -10.001, lng: 30.001 },
      ]),
    ).resolves.toMatchObject({ available: false, dataConfidence: 0 });
    expect(request).not.toHaveBeenCalled();
  });

  it("sends narrative candidates as summaries without coordinates", () => {
    const prompt = buildRouteUserPrompt({
      userLevel: "Beginner",
      totalDistanceKm: 1.5,
      milestoneCount: 3,
      language: "en",
      candidates: [
        {
          id: "candidate-1",
          distanceKm: 1.48,
          elevationGain: "5 m",
          maxGradePercent: 1.1,
          turnsPerKm: 4,
          surfaceDesc: "paved path",
          areaHints: ["park"],
        },
      ],
    });

    expect(prompt).toContain("candidate-1");
    expect(prompt).not.toContain("-6.2088");
    expect(prompt).not.toContain("106.8456");
  });
});

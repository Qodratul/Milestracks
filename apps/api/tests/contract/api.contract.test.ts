import { describe, expect, it } from "vitest";
import request from "supertest";
import { API_ENDPOINTS } from "../../src/contracts/endpoint.contracts";
import { openApiDocument } from "../../src/openapi/document";
import { app } from "../../src/app";

describe("API stub contract", () => {
  it.each(API_ENDPOINTS)(
    "$method $openApiPath matches its Zod/OpenAPI response schema",
    async (contract) => {
      const call =
        contract.method === "get"
          ? request(app).get(contract.testPath)
          : contract.method === "post"
            ? request(app).post(contract.testPath)
            : request(app).patch(contract.testPath);

      if (contract.protected) call.set("Authorization", "Bearer contract-test-token");
      if (contract.idempotencyRequired) {
        call.set("Idempotency-Key", "2f81e6df-9498-4c4d-96e4-5e9f686b31cf");
      }
      if (contract.bodyExample !== undefined) call.send(contract.bodyExample);

      const response = await call;
      expect(response.status).toBe(contract.statusCode);
      expect(contract.responseSchema.safeParse(response.body).success).toBe(true);
    },
  );

  it("documents every stub endpoint in OpenAPI", () => {
    const paths = openApiDocument.paths ?? {};
    const expectedPaths = [
      ...new Set([
        "/healthz",
        "/readyz",
        ...API_ENDPOINTS.map((endpoint) => endpoint.openApiPath),
      ]),
    ].sort();
    expect(Object.keys(paths).sort()).toEqual(expectedPaths);
    for (const endpoint of API_ENDPOINTS) {
      const operation = paths[endpoint.openApiPath]?.[endpoint.method];
      expect(operation).toBeDefined();
      expect(operation?.operationId).toBe(endpoint.operationId);
      if (endpoint.bodySchema) {
        const requestBody = operation?.requestBody;
        expect(
          requestBody && "required" in requestBody ? requestBody.required : undefined,
        ).toBe(endpoint.bodyRequired);
      }
      if (endpoint.operationId === "generateMysteryRoute") {
        expect(operation?.responses).toHaveProperty("200");
        expect(operation?.responses).toHaveProperty("202");
      }
      if (endpoint.idempotencyAccepted) {
        const idempotencyParameter = operation?.parameters?.find(
          (parameter) => "name" in parameter && parameter.name === "Idempotency-Key",
        );
        expect(
          idempotencyParameter && "in" in idempotencyParameter
            ? idempotencyParameter.in
            : undefined,
        ).toBe("header");
        expect(
          idempotencyParameter && "required" in idempotencyParameter
            ? idempotencyParameter.required
            : undefined,
        ).toBe(endpoint.idempotencyRequired);
      }
    }
  });

  it("serves Swagger UI and the generated OpenAPI document", async () => {
    const docs = await request(app).get("/docs/");
    expect(docs.status).toBe(200);
    expect(docs.text).toContain("Swagger UI");

    const document = await request(app).get("/openapi.json");
    expect(document.status).toBe(200);
    expect(document.body).toEqual(openApiDocument);
  });

  it("documents documented response variants", () => {
    const meta = { requestId: "req_contract", timestamp: "2026-10-25T09:30:00Z" };
    const today = API_ENDPOINTS.find(
      (endpoint) => endpoint.operationId === "getTodaysMysteryRoute",
    );
    const geometry = API_ENDPOINTS.find(
      (endpoint) => endpoint.operationId === "getRouteGeometry",
    );
    const finish = API_ENDPOINTS.find((endpoint) => endpoint.operationId === "finishRun");
    const getRun = API_ENDPOINTS.find((endpoint) => endpoint.operationId === "getRun");
    const claim = API_ENDPOINTS.find(
      (endpoint) => endpoint.operationId === "claimRunRewards",
    );

    expect(today?.responseSchema.safeParse({ data: null, meta }).success).toBe(true);
    expect(
      geometry?.responseSchema.safeParse({
        data: {
          routeId: "route_456",
          revealed: false,
          encoding: "polyline",
          precision: 5,
          coordinates: null,
          bounds: { north: -6.2163, south: -6.2185, east: 106.8034, west: 106.8012 },
        },
        meta,
      }).success,
    ).toBe(true);
    expect(
      geometry?.responseSchema.safeParse({
        data: {
          routeId: "route_456",
          revealed: true,
          encoding: "polyline",
          precision: 5,
          segments: [{ ordinal: 0, coordinates: "_p~iF~ps|U_ulLnnqC" }],
        },
        meta: { ...meta, nextCursor: null, limit: 500 },
      }).success,
    ).toBe(true);
    expect(
      finish?.responseSchema.safeParse({
        data: {
          runId: "run_123",
          status: "rejected",
          integrity: "rejected",
          reasonCodes: ["SPEED_ANOMALY"],
          claimId: null,
          rewardPreview: { coins: 0, rp: 0, exp: 0 },
          claimed: false,
        },
        meta,
      }).success,
    ).toBe(true);
    expect(
      getRun?.responseSchema.safeParse({
        data: {
          runId: "run_123",
          routeId: "route_456",
          status: "completed",
          startedAt: "2026-10-25T09:30:00Z",
          elapsedSec: 300,
          activeSec: 300,
          distanceMeters: 640,
          gpsQuality: "strong",
          milestones: { reached: 1, total: 3, nextMilestoneId: "ms_2" },
          lastSampleSequence: 245,
          loadout: { boostItemCode: null, modifierItemCode: "less_compensation" },
          claim: { claimId: "claim_123", claimed: false },
        },
        meta,
      }).success,
    ).toBe(true);
    expect(
      claim?.responseSchema.safeParse({
        data: {
          claimId: "claim_123",
          runId: "run_123",
          claimed: true,
          awarded: { exp: 675, coins: 1, rp: 500 },
          capsRemaining: null,
          wallet: { coins: 5, coinProgress: 0.2 },
          streak: null,
          level: {
            levelCode: "master",
            levelName: "Master",
            totalExp: 500000,
            levelStartExp: 300000,
            nextLevelAtExp: null,
            progress: 1,
            mascotForm: "kila_legend",
          },
          events: [],
        },
        meta,
      }).success,
    ).toBe(true);
  });

  it("keeps health and readiness envelopes valid", async () => {
    const health = await request(app).get("/healthz");
    expect(health.status).toBe(200);
    expect(health.body).toMatchObject({
      data: { status: "ok", uptimeSec: expect.any(Number), version: expect.any(String) },
      meta: { requestId: expect.any(String), timestamp: expect.any(String) },
    });

    const readiness = await request(app).get("/readyz");
    if (readiness.status === 200) {
      expect(readiness.body.data.checks).toEqual({ postgres: "ok" });
    } else {
      expect(readiness.status).toBe(503);
      expect(readiness.body.error).toMatchObject({
        code: "SERVICE_UNAVAILABLE",
        details: { checks: { postgres: "unavailable" } },
      });
    }
  });

  it("rejects protected stubs without a bearer token", async () => {
    const response = await request(app).get("/api/v1/me");
    expect(response.status).toBe(401);
    expect(response.body.error.code).toBe("UNAUTHORIZED");
  });

  it("rejects a missing idempotency key", async () => {
    const response = await request(app)
      .post("/api/v1/routes/mystery/generate")
      .set("Authorization", "Bearer contract-test-token")
      .send({ location: { lat: -6.2185, lng: 106.8021, accuracyMeters: 12 } });
    expect(response.status).toBe(400);
    expect(response.body.error.details.fields[0].path).toBe("header.Idempotency-Key");
  });

  it("accepts an omitted optional idempotency key and rejects a malformed one", async () => {
    const path = "/api/v1/runs/run_123/milestones/ms_1/reach";
    const body = {
      reachedAt: "2026-10-25T09:34:05Z",
      location: { lat: -6.2171, lng: 106.8034, accuracyMeters: 7 },
      lastSampleSequence: 245,
    };
    const withoutKey = await request(app)
      .post(path)
      .set("Authorization", "Bearer contract-test-token")
      .send(body);
    expect(withoutKey.status).toBe(200);

    const malformedKey = await request(app)
      .post(path)
      .set("Authorization", "Bearer contract-test-token")
      .set("Idempotency-Key", "not-a-uuid")
      .send(body);
    expect(malformedKey.status).toBe(400);
    expect(malformedKey.body.error.details.fields[0].path).toBe("header.Idempotency-Key");
  });

  it("rejects an out-of-range geometry page size", async () => {
    const response = await request(app)
      .get("/api/v1/routes/route_456/geometry?limit=501")
      .set("Authorization", "Bearer contract-test-token");
    expect(response.status).toBe(400);
    expect(response.body.error.details.fields[0].path).toBe("query.limit");
  });

  it("returns paginated geometry when preview mode is not requested", async () => {
    const response = await request(app)
      .get("/api/v1/routes/route_456/geometry?limit=250")
      .set("Authorization", "Bearer contract-test-token");
    const contract = API_ENDPOINTS.find(
      (endpoint) => endpoint.operationId === "getRouteGeometry",
    );
    expect(response.status).toBe(200);
    expect(contract?.responseSchema.safeParse(response.body).success).toBe(true);
    expect(response.body.meta).toMatchObject({ nextCursor: null, limit: 250 });
  });
});

import { execFileSync } from "node:child_process";
import { randomUUID } from "node:crypto";
import { resolve } from "node:path";
import { PrismaClient } from "@prisma/client";
import type { Express } from "express";
import request from "supertest";
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import { seedGameConfigV2 } from "../../prisma/seed";
import type { RoutingProvider } from "../../src/providers/routing/types";
import type { RouteCandidateService as RouteCandidateServiceInstance } from "../../src/services/route-candidate.service";
import type { RouteGenerationService as RouteGenerationServiceInstance } from "../../src/services/route-generation.service";
import { createId } from "../../src/lib/ids";
import { startPostgis } from "../helpers/postgis";

const enabled = process.env.RUN_DATABASE_INTEGRATION === "true";
const API_DIRECTORY = resolve(__dirname, "../..");
const TEST_JWT_SECRET = "stage8-integration-secret-with-at-least-32-chars";
const START = { lat: -6.2, lng: 106.8167, accuracyMeters: 10 };

interface TestAccount {
  readonly id: string;
  readonly token: string;
}

describe.skipIf(!enabled)("Stage 8 Mystery Track integration", () => {
  let database: Awaited<ReturnType<typeof startPostgis>>;
  let client: PrismaClient;
  let app: Express;
  let RouteCandidateServiceConstructor: new (options?: {
    readonly routing?: RoutingProvider;
    readonly demoMode?: boolean;
  }) => RouteCandidateServiceInstance;
  let RouteGenerationServiceConstructor: new (
    candidates?: RouteCandidateServiceInstance,
  ) => RouteGenerationServiceInstance;
  const originalEnvironment = new Map<string, string | undefined>();

  beforeAll(async () => {
    database = await startPostgis();
    for (const name of [
      "DATABASE_URL",
      "DIRECT_URL",
      "STUB_MODE",
      "JWT_SECRET",
      "DEMO_MODE",
      "ROUTING_PROVIDER",
      "LLM_API_KEY",
    ]) {
      originalEnvironment.set(name, process.env[name]);
    }
    process.env.DATABASE_URL = database.connectionString;
    process.env.DIRECT_URL = database.connectionString;
    process.env.STUB_MODE = "false";
    process.env.JWT_SECRET = TEST_JWT_SECRET;
    process.env.DEMO_MODE = "true";
    process.env.ROUTING_PROVIDER = "mock";
    process.env.LLM_API_KEY = "";
    deployMigrations(database.connectionString);
    client = new PrismaClient({ datasourceUrl: database.connectionString });
    await seedGameConfigV2(client);
    ({ app } = await import("../../src/app.js"));
    const candidateModule = await import("../../src/services/route-candidate.service.js");
    const generationModule =
      await import("../../src/services/route-generation.service.js");
    RouteCandidateServiceConstructor = candidateModule.RouteCandidateService;
    RouteGenerationServiceConstructor = generationModule.RouteGenerationService;
  }, 120_000);

  afterAll(async () => {
    if (client) await client.$disconnect();
    const { closePrisma } = await import("../../src/lib/prisma.js");
    await closePrisma();
    if (database) await database.stop();
    for (const [name, value] of originalEnvironment) restoreEnvironment(name, value);
  }, 30_000);

  it("generates, reuses, reports, and hides templates while providing safe fallbacks", async () => {
    const first = await createAccount(1);
    const second = await createAccount(2);
    const third = await createAccount(3);
    const libraryFailureAccount = await createAccount(4);
    const emptyLibraryAccount = await createAccount(5);

    const generated = await generate(first);
    expect(generated.status).toBe(202);
    const firstReady = await pollReady(first);
    expect(firstReady.routeId).toBe(generated.body.data.routeId);
    expect(firstReady.revealMode).toBe("next_milestone");
    expect(firstReady.startPoint.distanceMeters).toBeLessThanOrEqual(250);
    expect(firstReady).not.toHaveProperty("geometry");
    expect(firstReady).not.toHaveProperty("milestones");
    expect(firstReady).not.toHaveProperty("coordinates");

    const hiddenGeometry = await request(app)
      .get("/api/v1/routes/" + firstReady.routeId + "/geometry?detail=preview")
      .set("Authorization", "Bearer " + first.token);
    expect(hiddenGeometry.status).toBe(200);
    expect(hiddenGeometry.body.data).toMatchObject({
      revealed: false,
      coordinates: null,
    });

    const reused = await generate(second);
    expect(reused.status).toBe(200);
    expect(reused.body.data.status).toBe("ready");
    const secondReady = reused.body.data as { routeId: string; status: string };
    const firstRoute = await client.route.findUnique({
      where: { id: firstReady.routeId },
      select: { templateId: true },
    });
    const secondRoute = await client.route.findUnique({
      where: { id: secondReady.routeId },
      select: { templateId: true },
    });
    expect(firstRoute?.templateId).toBe(secondRoute?.templateId);
    if (!firstRoute?.templateId) throw new Error("Generated route has no template.");
    const [{ readTemplateGeometry, hasDuplicateGeometry }, { withTransaction }] =
      await Promise.all([
        import("../../src/repositories/route-template.repository.js"),
        import("../../src/lib/prisma.js"),
      ]);
    const storedGeometry = await withTransaction((tx) =>
      readTemplateGeometry(tx, firstRoute.templateId!),
    );
    if (!storedGeometry) throw new Error("Generated template has no stored geometry.");
    const geometryCoordinates = (
      JSON.parse(storedGeometry.geometryJson) as { coordinates: number[][] }
    ).coordinates;
    const routePoints = geometryCoordinates.map((coordinate) => ({
      lng: coordinate[0]!,
      lat: coordinate[1]!,
    }));
    const exactGeometryIsDuplicate = await withTransaction((tx) =>
      hasDuplicateGeometry(tx, {
        levelCode: "advanced",
        points: routePoints,
        bufferMeters: 20,
        overlapPermil: 850,
      }),
    );
    expect(exactGeometryIsDuplicate).toBe(true);

    const unavailableRouter: RoutingProvider = {
      async routeLoop() {
        throw new Error("routing provider is offline");
      },
      async route() {
        throw new Error("routing provider is offline");
      },
    };
    const candidateService = new RouteCandidateServiceConstructor({
      routing: unavailableRouter,
      demoMode: true,
    });
    const generationService = new RouteGenerationServiceConstructor(candidateService);
    const fallbackRouteId = await createGenerationJob(libraryFailureAccount, START);
    await generationService.generate(fallbackRouteId);
    const fallbackRoute = await client.route.findUnique({
      where: { id: fallbackRouteId },
      select: { status: true, templateId: true },
    });
    expect(fallbackRoute?.status).toBe("ready");
    expect(fallbackRoute?.templateId).toBe(firstRoute?.templateId);

    const farLocation = { lat: 35.6762, lng: 139.6503, accuracyMeters: 10 };
    const failedRouteId = await createGenerationJob(emptyLibraryAccount, farLocation);
    await generationService.generate(failedRouteId);
    const failedRoute = await client.route.findUnique({
      where: { id: failedRouteId },
      select: { status: true, generationFailure: true },
    });
    expect(failedRoute?.status).toBe("failed");
    expect(failedRoute?.generationFailure).toMatchObject({
      code: "ROUTE_UNAVAILABLE",
      retryable: true,
    });

    const firstReport = await report(first, firstReady.routeId);
    expect(firstReport.status).toBe(201);
    expect(firstReport.body.data.status).toBe("received");
    const duplicateReport = await report(first, firstReady.routeId);
    expect(duplicateReport.status).toBe(409);
    expect(duplicateReport.body.error.code).toBe("ALREADY_REPORTED");
    const hiddenAfterReport = await request(app)
      .get("/api/v1/routes/" + firstReady.routeId + "/geometry")
      .set("Authorization", "Bearer " + first.token);
    expect(hiddenAfterReport.status).toBe(404);

    const secondReport = await report(second, secondReady.routeId);
    expect(secondReport.status).toBe(201);
    const thirdGenerated = await generate(third);
    expect(thirdGenerated.status).toBe(200);
    const thirdReady = thirdGenerated.body.data as { routeId: string; status: string };
    const thirdReport = await report(third, thirdReady.routeId);
    expect(thirdReport.status).toBe(201);

    const moderated = await client.routeTemplate.findUnique({
      where: { id: firstRoute?.templateId ?? "" },
      select: { status: true },
    });
    expect(moderated?.status).toBe("suspended");
    const hiddenForOtherRunner = await request(app)
      .get("/api/v1/routes/" + secondReady.routeId + "/geometry")
      .set("Authorization", "Bearer " + second.token);
    expect(hiddenForOtherRunner.status).toBe(404);
  });

  it("replays regeneration by idempotency key and enforces the UTC daily quota", async () => {
    const account = await createAccount(6);
    const tokyo = { lat: 35.6762, lng: 139.6503, accuracyMeters: 10 };
    const singapore = { lat: 1.3521, lng: 103.8198, accuracyMeters: 10 };
    const kualaLumpur = { lat: 3.139, lng: 101.6869, accuracyMeters: 10 };
    const initial = await generateAt(account, tokyo);
    expect(initial.status).toBe(202);
    await pollReady(account);

    const firstKey = randomUUID();
    const firstRegeneration = await regenerateAt(account, singapore, firstKey);
    expect(firstRegeneration.status).toBe(202);
    const firstRouteId = firstRegeneration.body.data.route.routeId as string;
    const replay = await regenerateAt(account, singapore, firstKey);
    expect(replay.status).toBe(firstRegeneration.status);
    expect(replay.body.data.route.routeId).toBe(firstRouteId);

    const secondRegeneration = await regenerateAt(account, kualaLumpur, randomUUID());
    expect(secondRegeneration.status).toBe(202);
    await pollReady(account);
    const overQuota = await regenerateAt(account, kualaLumpur, randomUUID());
    expect(overQuota.status).toBe(429);
    expect(overQuota.body.error.code).toBe("REGENERATE_LIMIT_REACHED");
  });

  async function createAccount(index: number): Promise<TestAccount> {
    const response = await request(app)
      .post("/api/v1/auth/register")
      .send({
        displayName: "Runner " + index,
        email: "stage8-runner-" + index + "-" + randomUUID() + "@example.test",
        password: "Stage8-test-password-123",
        locale: "en",
        timezone: "Asia/Jakarta",
      });
    expect(response.status).toBe(201);
    const id = response.body.data.user.id as string;
    await client.profile.update({
      where: { userId: id },
      data: { totalExp: 40_000, levelCode: "advanced" },
    });
    return { id, token: response.body.data.accessToken as string };
  }

  async function generate(account: TestAccount) {
    return generateAt(account, START);
  }

  async function generateAt(account: TestAccount, location: typeof START) {
    return request(app)
      .post("/api/v1/routes/mystery/generate")
      .set("Authorization", "Bearer " + account.token)
      .set("Idempotency-Key", randomUUID())
      .send({ location, preferredDistanceMeters: 6000 });
  }

  async function regenerateAt(
    account: TestAccount,
    location: typeof START,
    idempotencyKey: string,
  ) {
    return request(app)
      .post("/api/v1/routes/mystery/regenerate")
      .set("Authorization", "Bearer " + account.token)
      .set("Idempotency-Key", idempotencyKey)
      .send({ location });
  }

  async function pollReady(account: TestAccount): Promise<
    Record<string, unknown> & {
      routeId: string;
      revealMode: string;
      startPoint: { distanceMeters: number };
    }
  > {
    let response = await request(app)
      .get("/api/v1/routes/mystery/today")
      .set("Authorization", "Bearer " + account.token);
    for (let attempt = 0; attempt < 100; attempt += 1) {
      const data: unknown = response.body.data;
      if (
        typeof data === "object" &&
        data !== null &&
        Reflect.get(data, "status") === "ready"
      ) {
        return data as Record<string, unknown> & {
          routeId: string;
          revealMode: string;
          startPoint: { distanceMeters: number };
        };
      }
      if (
        typeof data === "object" &&
        data !== null &&
        Reflect.get(data, "status") === "failed"
      ) {
        throw new Error("Route generation failed in the demo provider integration.");
      }
      await new Promise<void>((resolvePromise) => setTimeout(resolvePromise, 100));
      response = await request(app)
        .get("/api/v1/routes/mystery/today")
        .set("Authorization", "Bearer " + account.token);
    }
    throw new Error("Route generation did not complete within the integration timeout.");
  }

  async function createGenerationJob(
    account: TestAccount,
    location: typeof START,
  ): Promise<string> {
    const routeId = createId("route");
    await client.route.create({
      data: {
        id: routeId,
        userId: account.id,
        configVersion: 2,
        status: "generating",
        revealMode: "next_milestone",
        generationInput: {
          location,
          targetDistanceMeters: 6000,
          levelCode: "advanced",
          locale: "en",
        },
        expiresAt: new Date(Date.now() + 24 * 60 * 60 * 1000),
      },
    });
    return routeId;
  }

  async function report(account: TestAccount, routeId: string) {
    return request(app)
      .post("/api/v1/routes/" + routeId + "/reports")
      .set("Authorization", "Bearer " + account.token)
      .send({ reason: "safety_concern" });
  }
});

function deployMigrations(connectionString: string): void {
  const command = process.platform === "win32" ? "pnpm.cmd" : "pnpm";
  try {
    execFileSync(command, ["exec", "prisma", "migrate", "deploy"], {
      cwd: API_DIRECTORY,
      env: {
        ...process.env,
        DATABASE_URL: connectionString,
        DIRECT_URL: connectionString,
      },
      stdio: "pipe",
      shell: process.platform === "win32",
    });
  } catch {
    throw new Error("Prisma migrations failed against the disposable PostGIS database.");
  }
}

function restoreEnvironment(name: string, value: string | undefined): void {
  if (value === undefined) {
    delete process.env[name];
    return;
  }
  process.env[name] = value;
}

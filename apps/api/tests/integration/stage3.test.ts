import { execFileSync } from "node:child_process";
import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import { Prisma, PrismaClient } from "@prisma/client";
import type { Express } from "express";
import type { idempotencyService as IdempotencyService } from "../../src/services/idempotency.service";
import { GameConfigSchema } from "../../src/config/game-config.schema";
import request from "supertest";
import express from "express";
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import { seedGameConfigV1 } from "../../prisma/seed";
import { startPostgis } from "../helpers/postgis";

const enabled = process.env.RUN_DATABASE_INTEGRATION === "true";
const API_DIRECTORY = resolve(__dirname, "../..");

describe.skipIf(!enabled)("Stage 3 database integration", () => {
  let database: Awaited<ReturnType<typeof startPostgis>>;
  let client: PrismaClient;
  let originalDatabaseUrl: string | undefined;
  let originalDirectUrl: string | undefined;
  let originalStubMode: string | undefined;
  let originalJwtSecret: string | undefined;
  let stage3AccessToken: string;
  let app: Express;
  let idempotencyServiceForTest: typeof IdempotencyService;

  beforeAll(async () => {
    database = await startPostgis();
    originalDatabaseUrl = process.env.DATABASE_URL;
    originalDirectUrl = process.env.DIRECT_URL;
    originalStubMode = process.env.STUB_MODE;
    originalJwtSecret = process.env.JWT_SECRET;
    process.env.JWT_SECRET = "stage3-integration-secret-with-at-least-32-chars";
    process.env.DATABASE_URL = database.connectionString;
    process.env.DIRECT_URL = database.connectionString;
    process.env.STUB_MODE = "false";
    deployMigrations(database.connectionString);
    client = new PrismaClient({ datasourceUrl: database.connectionString });
    await client.user.create({
      data: {
        id: "usr_stage3_auth",
        email: "stage3-auth@example.test",
        passwordHash: "test-hash",
      },
    });
    const { signAccessToken } = await import("../../src/lib/auth-token.js");
    stage3AccessToken = await signAccessToken("usr_stage3_auth", new Date());
    ({ app } = await import("../../src/app.js"));
    ({ idempotencyService: idempotencyServiceForTest } =
      await import("../../src/services/idempotency.service.js"));
  }, 120_000);

  afterAll(async () => {
    if (client) await client.$disconnect();
    const { closePrisma } = await import("../../src/lib/prisma.js");
    await closePrisma();
    if (database) await database.stop();
    restoreEnvironment("DATABASE_URL", originalDatabaseUrl);
    restoreEnvironment("DIRECT_URL", originalDirectUrl);
    restoreEnvironment("STUB_MODE", originalStubMode);
    restoreEnvironment("JWT_SECRET", originalJwtSecret);
  }, 30_000);

  it("deploys the full schema and exposes PostGIS spatial functions", async () => {
    const tables = await client.$queryRaw<Array<{ count: bigint }>>(Prisma.sql`
      SELECT COUNT(*) AS count
      FROM information_schema.tables
      WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
    `);
    const spatial = await client.$transaction(async (transaction) => {
      await transaction.$executeRaw`SET LOCAL search_path TO public, extensions`;
      return transaction.$queryRaw<Array<{ withinRadius: boolean }>>(Prisma.sql`
        SELECT ST_DWithin(
          ST_SetSRID(ST_MakePoint(0, 0), 4326)::geography,
          ST_SetSRID(ST_MakePoint(0.0001, 0), 4326)::geography,
          25
        ) AS "withinRadius"
      `);
    });

    expect(Number(tables[0]?.count)).toBeGreaterThanOrEqual(20);
    expect(spatial[0]?.withinRadius).toBe(true);
  });

  it("seeds the active game config twice without duplicates", async () => {
    await seedGameConfigV1(client);
    await seedGameConfigV1(client);

    await expect(client.gameConfigVersion.count()).resolves.toBe(1);
    await expect(
      client.gameConfigVersion.findUnique({
        where: { version: 1 },
        select: { isActive: true },
      }),
    ).resolves.toEqual({ isActive: true });
  });

  it("serves the active configuration through the real API route", async () => {
    const response = await request(app)
      .get("/api/v1/config/game")
      .set("Authorization", "Bearer " + stage3AccessToken);

    expect(response.status).toBe(200);
    const expected = GameConfigSchema.parse(
      JSON.parse(
        readFileSync(resolve(API_DIRECTORY, "prisma/game-config.v1.json"), "utf8"),
      ) as unknown,
    );
    expect(response.body.data).toEqual(expected);
  });

  it("replays through the HTTP middleware and rejects payload changes", async () => {
    const { idempotency, requireIdempotencyKey } =
      await import("../../src/middleware/idempotency.middleware.js");
    const { errorMiddleware } = await import("../../src/middleware/error.middleware.js");
    const { sendOk } = await import("../../src/middleware/response.js");
    const idempotencyApp = express();
    let endpointCalls = 0;
    await client.user.create({
      data: {
        id: "usr_stage3_middleware",
        email: "stage3-middleware@example.test",
        passwordHash: "test-hash",
      },
    });
    idempotencyApp.use(express.json());
    idempotencyApp.use((request, _response, next) => {
      request.user = { id: "usr_stage3_middleware" };
      next();
    });
    idempotencyApp.post(
      "/runs/:runId/claim",
      requireIdempotencyKey(),
      idempotency,
      (_request, response) => {
        endpointCalls += 1;
        sendOk(response, { execution: endpointCalls });
      },
    );
    idempotencyApp.use(errorMiddleware);

    const key = "8d695e45-3f63-4b13-b678-36fb30e44b09";
    const first = await request(idempotencyApp)
      .post("/runs/run_stage3/claim")
      .set("Idempotency-Key", key)
      .send({ claimId: "claim_stage3" });
    const replay = await request(idempotencyApp)
      .post("/runs/run_stage3/claim")
      .set("Idempotency-Key", key)
      .send({ claimId: "claim_stage3" });
    const mismatch = await request(idempotencyApp)
      .post("/runs/run_stage3/claim")
      .set("Idempotency-Key", key)
      .send({ claimId: "different_claim" });

    expect(first.status).toBe(200);
    expect(replay.status).toBe(200);
    expect(replay.body).toEqual(first.body);
    expect(endpointCalls).toBe(1);
    expect(mismatch.status).toBe(422);
    expect(mismatch.body.error.code).toBe("IDEMPOTENCY_KEY_REUSED");
  });

  it("replays completed responses and rejects payload changes", async () => {
    await client.user.create({
      data: {
        id: "usr_stage3_idempotency",
        email: "stage3-idempotency@example.test",
        passwordHash: "test-hash",
      },
    });
    const input = {
      userId: "usr_stage3_idempotency",
      key: "8d695e45-3f63-4b13-b678-36fb30e44b09",
      route: "POST:/api/v1/runs/run_stage3/claim",
      requestHash: "a".repeat(64),
    };
    const reservation = await idempotencyServiceForTest.reserve(input);
    expect(reservation.kind).toBe("reserved");
    if (reservation.kind !== "reserved") throw new Error("Expected a new reservation.");

    const response: Prisma.InputJsonValue = {
      data: { claimId: "claim_stage3" },
      meta: { requestId: "req_stage3", timestamp: "2026-10-26T12:00:00.000Z" },
    };
    await idempotencyServiceForTest.complete({
      id: reservation.id,
      response,
      statusCode: 200,
    });

    await expect(idempotencyServiceForTest.reserve(input)).resolves.toEqual({
      kind: "replay",
      response,
      statusCode: 200,
    });
    await expect(
      idempotencyServiceForTest.reserve({ ...input, requestHash: "b".repeat(64) }),
    ).rejects.toMatchObject({ code: "IDEMPOTENCY_KEY_REUSED", statusCode: 422 });
  });
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

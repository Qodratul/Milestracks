import { execFileSync } from "node:child_process";
import { resolve } from "node:path";
import { PrismaClient } from "@prisma/client";
import type { Express } from "express";
import request from "supertest";
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import { seedGameConfigV2 } from "../../prisma/seed";
import { createId } from "../../src/lib/ids";
import { startPostgis } from "../helpers/postgis";

const enabled = process.env.RUN_DATABASE_INTEGRATION === "true";
const API_DIRECTORY = resolve(__dirname, "../..");
const TEST_JWT_SECRET = "stage11-integration-secret-with-at-least-32-chars";

describe.skipIf(!enabled)("Stage 11 badges, streak, shop, and history API", () => {
  let database: Awaited<ReturnType<typeof startPostgis>> | undefined;
  let client: PrismaClient;
  let app: Express;
  let userId: string;
  let token: string;
  let originalDatabaseUrl: string | undefined;
  let originalDirectUrl: string | undefined;
  let originalStubMode: string | undefined;
  let originalJwtSecret: string | undefined;

  beforeAll(async () => {
    database = await startPostgis();
    originalDatabaseUrl = process.env.DATABASE_URL;
    originalDirectUrl = process.env.DIRECT_URL;
    originalStubMode = process.env.STUB_MODE;
    originalJwtSecret = process.env.JWT_SECRET;
    process.env.DATABASE_URL = database.connectionString;
    process.env.DIRECT_URL = database.connectionString;
    process.env.STUB_MODE = "false";
    process.env.JWT_SECRET = TEST_JWT_SECRET;
    deployMigrations(database.connectionString);
    client = new PrismaClient({ datasourceUrl: database.connectionString });
    await seedGameConfigV2(client);
    userId = createId("usr");
    await client.user.create({
      data: {
        id: userId,
        email: `${userId}@example.test`,
        passwordHash: "integration-test",
        profile: {
          create: {
            displayName: "Stage 11",
            locale: "id",
            timezone: "Asia/Jakarta",
            coinBalance: 40,
          },
        },
        inventory: {
          create: [
            { itemCode: "exp_boost", quantity: 3 },
            { itemCode: "less_compensation", quantity: 3 },
            { itemCode: "gain_more", quantity: 3 },
          ],
        },
      },
    });
    const { signAccessToken } = await import("../../src/lib/auth-token.js");
    token = await signAccessToken(userId, new Date());
    await createHistoricalRun(client, userId);
    ({ app } = await import("../../src/app.js"));
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

  it("serves localized achievements, streak, and cursor-paginated history", async () => {
    const [badges, streak, runs, details, trace] = await Promise.all([
      request(app).get("/api/v1/badges").set("Authorization", `Bearer ${token}`),
      request(app).get("/api/v1/streak").set("Authorization", `Bearer ${token}`),
      request(app).get("/api/v1/runs?limit=1").set("Authorization", `Bearer ${token}`),
      request(app)
        .get("/api/v1/runs/run_stage11_history/summary")
        .set("Authorization", `Bearer ${token}`),
      request(app)
        .get("/api/v1/runs/run_stage11_history/trace")
        .set("Authorization", `Bearer ${token}`),
    ]);

    expect(badges.status).toBe(200);
    expect(
      badges.body.data.find((badge: { id: string }) => badge.id === "first_run"),
    ).toMatchObject({
      name: "Langkah Pertama",
      unlocked: true,
      progress: 1,
    });
    expect(streak.status).toBe(200);
    expect(streak.body.data.currentDays).toBeGreaterThanOrEqual(1);
    expect(runs.status).toBe(200);
    expect(runs.body.data[0]).toMatchObject({
      runId: "run_stage11_history",
      status: "completed",
      distanceMeters: 5200,
    });
    expect(details.status).toBe(200);
    expect(details.body.data.streakAfter.currentDays).toBeGreaterThanOrEqual(1);
    expect(trace.status).toBe(200);
    expect(trace.body.data).toEqual([]);
  });

  it("purchases with coins once for a repeated idempotency key", async () => {
    const catalog = await request(app)
      .get("/api/v1/shop/items")
      .set("Authorization", `Bearer ${token}`);
    expect(catalog.status).toBe(200);
    expect(
      catalog.body.data.find((item: { id: string }) => item.id === "exp_boost"),
    ).toMatchObject({
      priceCoins: 8,
      available: true,
      maxStock: 5,
    });

    const key = "51100000-0000-4000-8000-000000000001";
    const first = await request(app)
      .post("/api/v1/shop/purchase")
      .set("Authorization", `Bearer ${token}`)
      .set("Idempotency-Key", key)
      .send({ itemId: "exp_boost" });
    const replay = await request(app)
      .post("/api/v1/shop/purchase")
      .set("Authorization", `Bearer ${token}`)
      .set("Idempotency-Key", key)
      .send({ itemId: "exp_boost" });

    expect([first.status, replay.status]).toEqual([200, 200]);
    expect(first.body.data).toEqual(replay.body.data);
    await expect(
      client.inventory.findUnique({
        where: { userId_itemCode: { userId, itemCode: "exp_boost" } },
        select: { quantity: true },
      }),
    ).resolves.toEqual({ quantity: 4 });
    await expect(
      client.coinLedger.count({ where: { userId, reason: "shop_purchase" } }),
    ).resolves.toBe(1);

    const ledger = await request(app)
      .get("/api/v1/coins/ledger?limit=1")
      .set("Authorization", `Bearer ${token}`);
    expect(ledger.status).toBe(200);
    expect(ledger.body.data[0].amount).toBe(-8);
  });

  it("rejects a coin purchase without changing the wallet or stock", async () => {
    await client.profile.update({ where: { userId }, data: { coinBalance: 0 } });
    const response = await request(app)
      .post("/api/v1/shop/purchase")
      .set("Authorization", `Bearer ${token}`)
      .set("Idempotency-Key", "51100000-0000-4000-8000-000000000002")
      .send({ itemId: "less_compensation" });

    expect(response.status).toBe(409);
    expect(response.body.error.code).toBe("INSUFFICIENT_COINS");
    await expect(
      client.inventory.findUnique({
        where: { userId_itemCode: { userId, itemCode: "less_compensation" } },
        select: { quantity: true },
      }),
    ).resolves.toEqual({ quantity: 3 });
  });
});

async function createHistoricalRun(client: PrismaClient, userId: string): Promise<void> {
  const routeId = "route_stage11_history";
  const runId = "run_stage11_history";
  const endedAt = new Date();
  const startedAt = new Date(endedAt.getTime() - 30 * 60_000);
  await client.route.create({
    data: {
      id: routeId,
      userId,
      configVersion: 2,
      status: "used",
      revealMode: "full",
      expiresAt: new Date(endedAt.getTime() + 86_400_000),
      usedAt: startedAt,
    },
  });
  await client.run.create({
    data: {
      id: runId,
      userId,
      routeId,
      configVersion: 2,
      status: "completed",
      integrity: "clean",
      lockedLoadout: { pausePeriods: [] },
      startedAt,
      endedAt,
      result: {
        summary: {
          distanceMeters: 5200,
          durationSec: 1800,
          avgPaceSecPerKm: 346,
          estimatedCalories: 312,
          milestones: { reached: 3, total: 3 },
          expEarnedBase: 3000,
          expMultiplier: 1,
          expPenalty: 0,
          levelExpGained: 3000,
          coinsGained: 3,
          rpGained: 500,
          itemsUsed: [],
        },
      },
    },
  });
}

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

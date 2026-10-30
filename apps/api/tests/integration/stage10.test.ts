import { execFileSync } from "node:child_process";
import { randomUUID } from "node:crypto";
import { resolve } from "node:path";
import { Prisma, PrismaClient } from "@prisma/client";
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import { seedAntiCheatConfig, seedGameConfigV2 } from "../../prisma/seed";
import { startPostgis } from "../helpers/postgis";
import type { runService as RunServiceType } from "../../src/services/run.service";

const enabled = process.env.RUN_DATABASE_INTEGRATION === "true";
const API_DIRECTORY = resolve(__dirname, "../..");

describe.skipIf(!enabled)("Stage 10 run cycle integration", () => {
  let database: Awaited<ReturnType<typeof startPostgis>> | undefined;
  let client: PrismaClient;
  let originalDatabaseUrl: string | undefined;
  let originalDirectUrl: string | undefined;
  let originalStubMode: string | undefined;
  let userId: string;
  let routeId: string;
  let templateId: string;
  let runService: typeof RunServiceType;

  beforeAll(async () => {
    database = await startPostgis();
    originalDatabaseUrl = process.env.DATABASE_URL;
    originalDirectUrl = process.env.DIRECT_URL;
    originalStubMode = process.env.STUB_MODE;
    process.env.DATABASE_URL = database.connectionString;
    process.env.DIRECT_URL = database.connectionString;
    process.env.STUB_MODE = "false";
    deployMigrations(database.connectionString);
    client = new PrismaClient({ datasourceUrl: database.connectionString });
    await seedGameConfigV2(client);
    await seedAntiCheatConfig(client);

    userId = "usr_stage10_" + Date.now().toString(36);
    routeId = "route_stage10_" + Date.now().toString(36);
    templateId = "template_stage10_" + Date.now().toString(36);
    await client.user.create({
      data: {
        id: userId,
        email: userId + "@example.test",
        passwordHash: "integration-test",
        profile: { create: { displayName: "Stage 10" } },
        inventory: { create: { itemCode: "less_compensation", quantity: 1 } },
      },
    });

    const coordinates = [
      [106.8, -6.2],
      [106.803, -6.2],
    ];
    await client.$executeRaw(Prisma.sql`
      INSERT INTO route_templates (
        id, level_code, distance_meters, estimated_duration_sec, estimated_calories,
        geometry, start_point, safety_score, data_confidence, status, algorithm_version,
        instructions, created_at, updated_at
      ) VALUES (
        ${templateId}, 'beginner'::level_code, 300, 180, 20,
        ST_SetSRID(ST_GeomFromGeoJSON(${JSON.stringify({
          type: "LineString",
          coordinates,
        })}), 4326),
        ST_SetSRID(ST_MakePoint(106.8, -6.2), 4326),
        0.9, 0.9, 'active'::template_status, 'stage10-test',
        ${JSON.stringify([
          { text: "Continue onto Start Way", distanceMeters: 10, sign: 0 },
          { text: "Turn left onto River Road", distanceMeters: 20, sign: -2 },
        ])}::jsonb,
        NOW(), NOW()
      )
    `);
    for (const [ordinal, fraction] of [
      [1, 0.02],
      [2, 0.04],
      [3, 0.06],
    ] as const) {
      await client.$executeRaw(Prisma.sql`
        INSERT INTO route_template_milestones (
          template_id, ordinal, milestone_id, location, distance_meters, radius_meters, exp
        ) VALUES (
          ${templateId}, ${ordinal}, ${"ms_stage10_" + ordinal},
          ST_LineInterpolatePoint(
            ST_SetSRID(ST_GeomFromGeoJSON(${JSON.stringify({
              type: "LineString",
              coordinates,
            })}), 4326),
            ${fraction}
          ),
          ${ordinal * 10}, 25, 100
        )
      `);
    }
    await client.routeTemplateNarration.create({
      data: {
        id: "narration_" + templateId,
        templateId,
        locale: "en",
        title: "Test route",
        mysteryBrief: "Test mystery",
        preRunTip: "Take it easy.",
        selectionReason: "integration",
        dialogues: [
          {
            milestoneId: "ms_stage10_1",
            ordinal: 1,
            cheerLine: "Good start.",
            continuePrompt: "Keep going.",
            restPrompt: "Rest if needed.",
            warnLine: "Slow down if needed.",
          },
        ],
      },
    });
    await client.route.create({
      data: {
        id: routeId,
        userId,
        templateId,
        configVersion: 2,
        status: "ready",
        revealMode: "full",
        expiresAt: new Date(Date.now() + 60 * 60 * 1000),
      },
    });

    ({ runService } = await import("../../src/services/run.service.js"));
  }, 120_000);

  afterAll(async () => {
    if (client) await client.$disconnect();
    const { closePrisma } = await import("../../src/lib/prisma.js");
    await closePrisma();
    if (database) await database.stop();
    restoreEnvironment("DATABASE_URL", originalDatabaseUrl);
    restoreEnvironment("DIRECT_URL", originalDirectUrl);
    restoreEnvironment("STUB_MODE", originalStubMode);
  }, 30_000);

  it("starts, replays locations, pauses, verifies milestones in PostGIS, and claims once", async () => {
    const start = await runService.start(userId, {
      routeId,
      boostItemCode: null,
      modifierItemCode: "less_compensation",
      units: "metric",
      startLocation: { lat: -6.2, lng: 106.8, accuracyMeters: 5 },
      clientCapabilities: {
        platform: "android",
        appVersion: "test",
        backgroundLocation: true,
        mockLocationEnabled: false,
      },
    });
    expect(start.status).toBe("active");
    expect(start.penaltyFreeRun).toBe(true);
    expect(start.milestones).toHaveLength(3);

    await expect(
      runService.finish(userId, start.runId, {
        endedAt: new Date().toISOString(),
        lastSampleSequence: 1,
      }),
    ).rejects.toMatchObject({ code: "SAMPLES_MISSING" });

    const runStartedAt = new Date(start.startedAt).getTime();
    const points = await client.$queryRaw<
      Array<{ sequence: number; lat: number; lng: number }>
    >(Prisma.sql`
      WITH line AS (
        SELECT ST_SetSRID(ST_GeomFromGeoJSON(${JSON.stringify({
          type: "LineString",
          coordinates: [
            [106.8, -6.2],
            [106.803, -6.2],
          ],
        })}), 4326) AS geometry
      )
      SELECT 1 AS sequence, -6.2::float8 AS lat, 106.8::float8 AS lng
      UNION ALL
      SELECT ordinal + 1 AS sequence,
        ST_Y(ST_LineInterpolatePoint(line.geometry, ordinal * 0.02))::float8 AS lat,
        ST_X(ST_LineInterpolatePoint(line.geometry, ordinal * 0.02))::float8 AS lng
      FROM line CROSS JOIN generate_series(1, 3) AS ordinal
      ORDER BY sequence
    `);
    const sampleBody = {
      samples: points.map((point) => ({
        sequence: point.sequence,
        t: runStartedAt - 9_000 + (point.sequence - 1) * 5_000,
        lat: point.lat,
        lng: point.lng,
        accuracyMeters: 5,
        mocked: false,
      })),
    };
    const uploaded = await runService.uploadLocations(userId, start.runId, sampleBody);
    expect(uploaded.acceptedCount).toBe(4);
    const replay = await runService.uploadLocations(userId, start.runId, sampleBody);
    expect(replay).toMatchObject({
      acceptedCount: 0,
      duplicateCount: 4,
      lastSequence: 4,
    });

    const paused = await runService.pause(userId, start.runId);
    expect(paused.status).toBe("paused");
    const resumed = await runService.resume(userId, start.runId);
    expect(resumed.status).toBe("active");

    const guidance = await runService.guidance(userId, start.runId);
    expect(guidance.steps.map((step) => step.maneuver)).toEqual(["depart", "turn_left"]);
    expect(guidance.steps[1]?.streetName).toBe("River Road");
    expect(guidance.dialogues).toHaveLength(1);

    const provisional = await runService.reachMilestone(
      userId,
      start.runId,
      "ms_stage10_1",
      {
        reachedAt: new Date(runStartedAt - 4_000).toISOString(),
        location: { lat: points[1]!.lat, lng: points[1]!.lng, accuracyMeters: 5 },
        lastSampleSequence: 2,
      },
    );
    expect(provisional.verification).toBe("provisional");

    const finishBody = {
      endedAt: new Date().toISOString(),
      lastSampleSequence: 4,
      clientSummary: { distanceMeters: 1, durationSec: 1 },
    };
    const firstFinish = await runService.finish(userId, start.runId, finishBody);
    const repeatedFinish = await runService.finish(userId, start.runId, finishBody);
    expect(repeatedFinish).toEqual(firstFinish);
    expect(firstFinish).toMatchObject({
      status: "completed",
      integrity: "clean",
      rewardPreview: { exp: 300 },
      claimed: false,
    });
    const integrityMetric = await client.runIntegrityMetric.findUniqueOrThrow({
      where: { runId: start.runId },
    });
    expect(integrityMetric.mode).toBe("shadow");
    expect(integrityMetric.metrics).toMatchObject({ configVersion: 1 });
    expect(JSON.stringify(integrityMetric.metrics)).not.toMatch(
      /"(?:lat|lng|latitude|longitude)"/,
    );

    const claimId = firstFinish.claimId;
    if (typeof claimId !== "string") throw new Error("Expected a claim id.");
    const [claimA, claimB] = await Promise.all([
      runService.claim(userId, start.runId, { claimId }),
      runService.claim(userId, start.runId, { claimId }),
    ]);
    expect(claimA).toEqual(claimB);
    expect(claimA).toMatchObject({
      claimed: true,
      awarded: { exp: 300 },
    });

    const profile = await client.profile.findUniqueOrThrow({ where: { userId } });
    const [expTotal, coinTotal] = await Promise.all([
      client.expLedger.aggregate({ where: { userId }, _sum: { delta: true } }),
      client.coinLedger.aggregate({ where: { userId }, _sum: { delta: true } }),
    ]);
    expect(profile.totalExp).toBe(expTotal._sum.delta);
    expect(profile.coinBalance).toBe(coinTotal._sum.delta);
    await expect(
      client.inventory.findUnique({
        where: { userId_itemCode: { userId, itemCode: "less_compensation" } },
        select: { quantity: true },
      }),
    ).resolves.toEqual({ quantity: 0 });
    await expect(
      client.expLedger.count({ where: { userId, runId: start.runId } }),
    ).resolves.toBe(1);
    await expect(
      client.coinLedger.count({ where: { userId, runId: start.runId } }),
    ).resolves.toBe(1);
  });

  it("enforces the first-five-run waiver and the weekly safe-stop quota", async () => {
    await client.profile.update({
      where: { userId },
      data: { completedRuns: 4 },
    });

    const fourthRunRouteId = "route_stage10_fourth_" + Date.now().toString(36);
    await createReadyRoute(client, fourthRunRouteId, userId, templateId);
    const fourthRun = await runService.start(userId, startBody(fourthRunRouteId));
    expect(fourthRun.penaltyFreeRun).toBe(true);
    const firstStop = await runService.safeStop(userId, fourthRun.runId, {
      reason: "tired",
      lastSampleSequence: 0,
    });
    expect(firstStop.safeStop).toMatchObject({
      usedThisWeek: 1,
      quota: 2,
      withinQuota: true,
    });

    await client.profile.update({
      where: { userId },
      data: { completedRuns: 5 },
    });
    const sixthRunRouteId = "route_stage10_sixth_" + Date.now().toString(36);
    await createReadyRoute(client, sixthRunRouteId, userId, templateId);
    const sixthRun = await runService.start(userId, startBody(sixthRunRouteId));
    expect(sixthRun.penaltyFreeRun).toBe(false);
    const secondStop = await runService.safeStop(userId, sixthRun.runId, {
      reason: "unsafe",
      lastSampleSequence: 0,
    });
    expect(secondStop.safeStop).toMatchObject({
      usedThisWeek: 2,
      quota: 2,
      withinQuota: true,
    });

    const outsideQuotaRouteId = "route_stage10_outside_quota_" + Date.now().toString(36);
    await createReadyRoute(client, outsideQuotaRouteId, userId, templateId);
    const outsideQuotaRun = await runService.start(
      userId,
      startBody(outsideQuotaRouteId),
    );
    const thirdStop = await runService.safeStop(userId, outsideQuotaRun.runId, {
      reason: "injury",
      lastSampleSequence: 0,
    });
    expect(thirdStop.safeStop).toMatchObject({
      usedThisWeek: 3,
      quota: 2,
      withinQuota: false,
    });
  });

  it("allows a delayed claim and records a level-up in the same reward transaction", async () => {
    const suffix = randomUUID();
    const levelUpUserId = "usr_stage10_level_" + suffix;
    await createRunUser(client, levelUpUserId, suffix);
    await client.profile.update({
      where: { userId: levelUpUserId },
      data: { totalExp: 9_900, completedRuns: 5 },
    });
    await client.expLedger.create({
      data: {
        id: "evt_stage10_seed_" + suffix,
        userId: levelUpUserId,
        delta: 9_900,
        reason: "test_fixture",
        idempotencyKey: "stage10-seed:" + suffix,
      },
    });

    const levelUpRouteId = "route_stage10_level_" + suffix;
    await createReadyRoute(client, levelUpRouteId, levelUpUserId, templateId);
    const start = await runService.start(levelUpUserId, startBody(levelUpRouteId));
    const runStartedAt = new Date(start.startedAt).getTime();
    const points = await getFixtureSamples(client);
    await runService.uploadLocations(levelUpUserId, start.runId, {
      samples: points.map((point) => ({
        sequence: point.sequence,
        t: runStartedAt - 9_000 + (point.sequence - 1) * 5_000,
        lat: point.lat,
        lng: point.lng,
        accuracyMeters: 5,
        mocked: false,
      })),
    });
    const finished = await runService.finish(levelUpUserId, start.runId, {
      endedAt: new Date().toISOString(),
      lastSampleSequence: points.length,
    });
    expect(finished).toMatchObject({
      status: "completed",
      integrity: "clean",
      rewardPreview: { exp: 300 },
      claimed: false,
    });
    const claimId = finished.claimId;
    if (typeof claimId !== "string") throw new Error("Expected a claim id.");

    expect(await runService.summary(levelUpUserId, start.runId)).toMatchObject({
      claim: { claimId, claimed: false },
    });
    await expect(
      client.profile.findUniqueOrThrow({ where: { userId: levelUpUserId } }),
    ).resolves.toMatchObject({ totalExp: 9_900 });

    const claim = await runService.claim(levelUpUserId, start.runId, { claimId });
    expect(claim).toMatchObject({
      awarded: { exp: 300 },
      level: { levelCode: "intermediate", totalExp: 10_200 },
      events: [{ type: "level_up", levelCode: "intermediate" }],
    });
    const [profile, ledger] = await Promise.all([
      client.profile.findUniqueOrThrow({ where: { userId: levelUpUserId } }),
      client.expLedger.aggregate({
        where: { userId: levelUpUserId },
        _sum: { delta: true },
      }),
    ]);
    expect(profile.totalExp).toBe(ledger._sum.delta);
  });

  it("rejects an enforced high-speed run without issuing a claim", async () => {
    const suffix = randomUUID();
    const rejectedUserId = "usr_stage10_rejected_" + suffix;
    await createRunUser(client, rejectedUserId, suffix);
    await client.antiCheatConfig.update({
      where: { version: 1 },
      data: { mode: "enforce" },
    });
    const rejectedRouteId = "route_stage10_rejected_" + suffix;
    await createReadyRoute(client, rejectedRouteId, rejectedUserId, templateId);
    const start = await runService.start(rejectedUserId, startBody(rejectedRouteId));
    const runStartedAt = new Date(start.startedAt).getTime();
    await runService.uploadLocations(rejectedUserId, start.runId, {
      samples: [
        {
          sequence: 1,
          t: runStartedAt - 10_000,
          lat: -6.2,
          lng: 106.8,
          accuracyMeters: 5,
          mocked: false,
        },
        {
          sequence: 2,
          t: Date.now(),
          lat: -6.2,
          lng: 106.803,
          accuracyMeters: 5,
          mocked: false,
        },
      ],
    });
    const finished = await runService.finish(rejectedUserId, start.runId, {
      endedAt: new Date().toISOString(),
      lastSampleSequence: 2,
    });
    expect(finished).toMatchObject({
      status: "rejected",
      integrity: "rejected",
      claimId: null,
      rewardPreview: { coins: 0, rp: 0, exp: 0 },
    });
    await expect(
      runService.claim(rejectedUserId, start.runId, { claimId: "claim_unavailable" }),
    ).rejects.toMatchObject({ code: "NOT_FOUND" });
    await expect(
      client.run.findUniqueOrThrow({ where: { id: start.runId } }),
    ).resolves.toMatchObject({ claimId: null, status: "rejected" });
  });
});

async function createReadyRoute(
  client: PrismaClient,
  routeId: string,
  userId: string,
  templateId: string,
): Promise<void> {
  await client.route.create({
    data: {
      id: routeId,
      userId,
      templateId,
      configVersion: 2,
      status: "ready",
      revealMode: "full",
      expiresAt: new Date(Date.now() + 60 * 60 * 1000),
    },
  });
}

async function createRunUser(
  client: PrismaClient,
  userId: string,
  suffix: string,
): Promise<void> {
  await client.user.create({
    data: {
      id: userId,
      email: "stage10-" + suffix + "@example.test",
      passwordHash: "integration-test",
      profile: { create: { displayName: "Stage 10 " + suffix.slice(0, 10) } },
    },
  });
}

async function getFixtureSamples(
  client: PrismaClient,
): Promise<readonly { sequence: number; lat: number; lng: number }[]> {
  return client.$queryRaw<
    Array<{ sequence: number; lat: number; lng: number }>
  >(Prisma.sql`
    WITH line AS (
      SELECT ST_SetSRID(ST_GeomFromGeoJSON(${JSON.stringify({
        type: "LineString",
        coordinates: [
          [106.8, -6.2],
          [106.803, -6.2],
        ],
      })}), 4326) AS geometry
    )
    SELECT 1 AS sequence, -6.2::float8 AS lat, 106.8::float8 AS lng
    UNION ALL
    SELECT ordinal + 1 AS sequence,
      ST_Y(ST_LineInterpolatePoint(line.geometry, ordinal * 0.02))::float8 AS lat,
      ST_X(ST_LineInterpolatePoint(line.geometry, ordinal * 0.02))::float8 AS lng
    FROM line CROSS JOIN generate_series(1, 3) AS ordinal
    ORDER BY sequence
  `);
}

function startBody(routeId: string) {
  return {
    routeId,
    boostItemCode: null,
    modifierItemCode: null,
    units: "metric" as const,
    startLocation: { lat: -6.2, lng: 106.8, accuracyMeters: 5 },
    clientCapabilities: {
      platform: "android" as const,
      appVersion: "test",
      backgroundLocation: true,
      mockLocationEnabled: false,
    },
  };
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

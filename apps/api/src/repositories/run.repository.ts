import { Prisma } from "@prisma/client";
import { createId } from "../lib/ids";
import type { Tx } from "../lib/prisma";
import { prisma } from "../lib/prisma";

export async function lockRunUser(transaction: Tx, userId: string): Promise<boolean> {
  const rows = await transaction.$queryRaw<Array<{ id: string }>>(Prisma.sql`
    SELECT id FROM users WHERE id = ${userId} FOR UPDATE
  `);
  return rows.length === 1;
}

export async function findActiveRun(tx: Tx, userId: string): Promise<string | null> {
  const run = await tx.run.findFirst({
    where: { userId, status: { in: ["active", "paused"] } },
    select: { id: true },
  });
  return run?.id ?? null;
}

export function findRunStartProfile(tx: Tx, userId: string) {
  return tx.profile.findUnique({
    where: { userId },
    select: { levelCode: true, completedRuns: true, locale: true },
  });
}

export async function lockRun(
  transaction: Tx,
  userId: string,
  runId: string,
): Promise<boolean> {
  const rows = await transaction.$queryRaw<Array<{ id: string }>>(Prisma.sql`
    SELECT id FROM runs WHERE id = ${runId} AND user_id = ${userId} FOR UPDATE
  `);
  return rows.length === 1;
}

export function findOwnedRoute(transaction: Tx, userId: string, routeId: string) {
  return transaction.route.findFirst({
    where: { id: routeId, userId },
    select: {
      id: true,
      userId: true,
      templateId: true,
      configVersion: true,
      status: true,
      revealMode: true,
      expiresAt: true,
      usedAt: true,
      template: {
        select: {
          id: true,
          levelCode: true,
          distanceMeters: true,
          estimatedDurationSec: true,
          estimatedCalories: true,
          status: true,
          milestones: {
            orderBy: { ordinal: "asc" },
            select: {
              ordinal: true,
              milestoneId: true,
              distanceMeters: true,
              radiusMeters: true,
              exp: true,
            },
          },
          narrations: {
            select: { locale: true, preRunTip: true, dialogues: true },
          },
        },
      },
    },
  });
}

export async function findMilestoneSampleMatches(
  transaction: Tx,
  runId: string,
  lastSequence: number,
): Promise<
  readonly {
    readonly milestoneId: string;
    readonly ordinal: number;
    readonly sequence: number;
    readonly timestampMs: number;
  }[]
> {
  return transaction.$queryRaw(Prisma.sql`
    WITH run_route AS (
      SELECT template.id AS template_id, template.geometry
      FROM runs run
      JOIN routes route ON route.id = run.route_id
      JOIN route_templates template ON template.id = route.template_id
      WHERE run.id = ${runId}
    ),
    samples AS (
      SELECT
        (entry.sample->>'sequence')::int AS sequence,
        (entry.sample->>'t')::double precision AS timestamp_ms,
        (entry.sample->>'accuracyMeters')::double precision AS accuracy_meters,
        ST_SetSRID(ST_MakePoint(
          (entry.sample->>'lng')::double precision,
          (entry.sample->>'lat')::double precision
        ), 4326) AS point
      FROM run_location_batches batch
      CROSS JOIN LATERAL jsonb_array_elements(batch.samples) AS entry(sample)
      WHERE batch.run_id = ${runId}
        AND (entry.sample->>'sequence')::int <= ${lastSequence}
    )
    SELECT milestone.milestone_id AS "milestoneId",
           milestone.ordinal,
           sample.sequence,
           sample.timestamp_ms AS "timestampMs"
    FROM run_route
    JOIN route_template_milestones milestone
      ON milestone.template_id = run_route.template_id
    JOIN samples sample ON
      ST_DWithin(
        sample.point::geography,
        milestone.location::geography,
        milestone.radius_meters + LEAST(sample.accuracy_meters, 50)
      )
      AND ST_LineLocatePoint(run_route.geometry, sample.point) >=
          ST_LineLocatePoint(run_route.geometry, milestone.location) - 0.02
    ORDER BY milestone.ordinal, sample.sequence
  `);
}

export async function findRouteStartAndMilestones(
  transaction: Tx,
  routeId: string,
): Promise<{
  readonly startLat: number;
  readonly startLng: number;
  readonly milestones: readonly {
    readonly milestoneId: string;
    readonly ordinal: number;
    readonly distanceMeters: number;
    readonly radiusMeters: number;
    readonly exp: number;
    readonly latitude: number;
    readonly longitude: number;
    readonly routeProgress: number;
  }[];
} | null> {
  const starts = await transaction.$queryRaw<
    Array<{ startLat: number; startLng: number }>
  >(Prisma.sql`
    SELECT ST_Y(template.start_point)::float8 AS "startLat",
           ST_X(template.start_point)::float8 AS "startLng"
    FROM routes route
    JOIN route_templates template ON template.id = route.template_id
    WHERE route.id = ${routeId}
  `);
  const start = starts[0];
  if (!start) return null;
  const milestones = await transaction.$queryRaw<
    Array<{
      milestoneId: string;
      ordinal: number;
      distanceMeters: number;
      radiusMeters: number;
      exp: number;
      latitude: number;
      longitude: number;
      routeProgress: number;
    }>
  >(Prisma.sql`
    SELECT milestone.milestone_id AS "milestoneId", milestone.ordinal,
           milestone.distance_meters AS "distanceMeters", milestone.radius_meters AS "radiusMeters",
           milestone.exp, ST_Y(milestone.location)::float8 AS latitude,
           ST_X(milestone.location)::float8 AS longitude,
           ST_LineLocatePoint(template.geometry, milestone.location)::float8 AS "routeProgress"
    FROM route_template_milestones milestone
    JOIN routes route ON route.template_id = milestone.template_id
    JOIN route_templates template ON template.id = milestone.template_id
    WHERE route.id = ${routeId}
    ORDER BY milestone.ordinal
  `);
  return { ...start, milestones };
}

export function createRunRecord(
  transaction: Tx,
  input: {
    readonly id: string;
    readonly userId: string;
    readonly routeId: string;
    readonly configVersion: number;
    readonly lockedLoadout: Prisma.InputJsonValue;
    readonly startedAt: Date;
  },
) {
  return transaction.run.create({
    data: {
      id: input.id,
      userId: input.userId,
      routeId: input.routeId,
      configVersion: input.configVersion,
      lockedLoadout: input.lockedLoadout,
      startedAt: input.startedAt,
      createdAt: input.startedAt,
      updatedAt: input.startedAt,
    },
  });
}

export function createMilestoneRecords(
  transaction: Tx,
  runId: string,
  milestones: readonly {
    readonly milestoneId: string;
    readonly ordinal: number;
  }[],
  timestamp: Date,
) {
  if (milestones.length === 0) return Promise.resolve({ count: 0 });
  return transaction.runMilestoneResult.createMany({
    data: milestones.map((milestone) => ({
      id: createId("ms"),
      runId,
      milestoneId: milestone.milestoneId,
      ordinal: milestone.ordinal,
      status: "pending",
      createdAt: timestamp,
      updatedAt: timestamp,
    })),
  });
}

export async function updateRouteUsed(transaction: Tx, routeId: string, timestamp: Date) {
  const updated = await transaction.route.updateMany({
    where: { id: routeId, status: "ready", usedAt: null },
    data: { status: "used", usedAt: timestamp, updatedAt: timestamp },
  });
  return updated.count === 1;
}

export function findRun(transaction: Tx, userId: string, runId: string) {
  return transaction.run.findFirst({
    where: { id: runId, userId },
    include: { milestoneResults: { orderBy: { ordinal: "asc" } } },
  });
}

export function findRunOutsideTransaction(userId: string, runId: string) {
  return prisma.run.findFirst({
    where: { id: runId, userId },
    include: { milestoneResults: { orderBy: { ordinal: "asc" } } },
  });
}

export async function listRunSamplesOutside(runId: string) {
  const batches = await prisma.runLocationBatch.findMany({
    where: { runId },
    orderBy: { firstSequence: "asc" },
    select: { samples: true },
  });
  return batches.flatMap((batch) => (Array.isArray(batch.samples) ? batch.samples : []));
}

export async function listRunSamples(transaction: Tx, runId: string) {
  const batches = await transaction.runLocationBatch.findMany({
    where: { runId },
    orderBy: { firstSequence: "asc" },
    select: { samples: true },
  });
  return batches.flatMap((batch) => (Array.isArray(batch.samples) ? batch.samples : []));
}

export async function saveSampleBatch(
  transaction: Tx,
  input: {
    readonly id: string;
    readonly runId: string;
    readonly firstSequence: number;
    readonly lastSequence: number;
    readonly samples: Prisma.InputJsonArray;
    readonly receivedAt: Date;
  },
): Promise<void> {
  await transaction.runLocationBatch.create({
    data: {
      id: input.id,
      runId: input.runId,
      firstSequence: input.firstSequence,
      lastSequence: input.lastSequence,
      sampleCount: input.samples.length,
      samples: input.samples,
      receivedAt: input.receivedAt,
    },
  });
}

export function updateRun(
  transaction: Tx,
  runId: string,
  data: {
    readonly status?: "active" | "paused" | "completed" | "safe_stopped" | "rejected";
    readonly lockedLoadout?: Prisma.InputJsonValue;
    readonly lastSequence?: number;
    readonly endedAt?: Date | null;
    readonly integrity?: "clean" | "flagged" | "rejected";
    readonly reasonCodes?: Prisma.InputJsonValue;
    readonly claimId?: string | null;
    readonly claimedAt?: Date | null;
    readonly result?: Prisma.InputJsonValue | null;
    readonly updatedAt: Date;
  },
) {
  return transaction.run.update({
    where: { id: runId },
    data: {
      ...(data.status === undefined ? {} : { status: data.status }),
      ...(data.lockedLoadout === undefined ? {} : { lockedLoadout: data.lockedLoadout }),
      ...(data.lastSequence === undefined ? {} : { lastSequence: data.lastSequence }),
      ...(data.endedAt === undefined ? {} : { endedAt: data.endedAt }),
      ...(data.integrity === undefined ? {} : { integrity: data.integrity }),
      ...(data.reasonCodes === undefined ? {} : { reasonCodes: data.reasonCodes }),
      ...(data.claimId === undefined ? {} : { claimId: data.claimId }),
      ...(data.claimedAt === undefined ? {} : { claimedAt: data.claimedAt }),
      ...(data.result === undefined
        ? {}
        : { result: data.result === null ? Prisma.DbNull : data.result }),
      updatedAt: data.updatedAt,
    },
  });
}

export function updateMilestoneResult(
  transaction: Tx,
  runId: string,
  milestoneId: string,
  data: {
    readonly clientReachedAt?: Date | null;
    readonly clientLocation?: Prisma.InputJsonValue | null;
    readonly lastSampleSequence?: number | null;
    readonly status: string;
    readonly verification?: string;
    readonly verifiedAt?: Date | null;
    readonly activeSecAtReach?: number | null;
    readonly earnedExp?: number;
    readonly protected?: boolean;
    readonly updatedAt: Date;
  },
) {
  return transaction.runMilestoneResult.update({
    where: { runId_milestoneId: { runId, milestoneId } },
    data: {
      ...(data.clientReachedAt === undefined
        ? {}
        : { clientReachedAt: data.clientReachedAt }),
      ...(data.clientLocation === undefined
        ? {}
        : {
            clientLocation:
              data.clientLocation === null ? Prisma.DbNull : data.clientLocation,
          }),
      ...(data.lastSampleSequence === undefined
        ? {}
        : { lastSampleSequence: data.lastSampleSequence }),
      status: data.status,
      ...(data.verification === undefined ? {} : { verification: data.verification }),
      ...(data.verifiedAt === undefined ? {} : { verifiedAt: data.verifiedAt }),
      ...(data.activeSecAtReach === undefined
        ? {}
        : { activeSecAtReach: data.activeSecAtReach }),
      ...(data.earnedExp === undefined ? {} : { earnedExp: data.earnedExp }),
      ...(data.protected === undefined ? {} : { protected: data.protected }),
      updatedAt: data.updatedAt,
    },
  });
}

export async function writeIntegrityMetrics(
  transaction: Tx,
  input: {
    readonly runId: string;
    readonly metrics: Prisma.InputJsonValue;
    readonly reasonCodes: Prisma.InputJsonValue;
    readonly mode: "shadow" | "enforce";
    readonly calculatedAt: Date;
  },
): Promise<void> {
  await transaction.runIntegrityMetric.upsert({
    where: { runId: input.runId },
    create: input,
    update: {
      metrics: input.metrics,
      reasonCodes: input.reasonCodes,
      mode: input.mode,
      calculatedAt: input.calculatedAt,
    },
  });
}

export function findRunGuidance(
  tx: Tx,
  input: { readonly routeId: string; readonly locale: "id" | "en" },
) {
  return tx.$queryRaw<
    Array<{
      readonly geometryJson: string | null;
      readonly tip: string | null;
      readonly dialogues: unknown;
      readonly instructions: Prisma.JsonValue;
    }>
  >(Prisma.sql`
    SELECT ST_AsGeoJSON(template.geometry) AS "geometryJson",
           template.instructions, narration.pre_run_tip AS tip, narration.dialogues
    FROM routes route
    JOIN route_templates template ON template.id = route.template_id
    LEFT JOIN route_template_narrations narration
      ON narration.template_id = template.id AND narration.locale = ${input.locale}::locale
    WHERE route.id = ${input.routeId}
  `);
}

export function countSafeStopsInWindow(
  tx: Tx,
  input: { readonly userId: string; readonly startsAt: Date; readonly endsAt: Date },
) {
  return tx.run.count({
    where: {
      userId: input.userId,
      status: "safe_stopped",
      endedAt: { gte: input.startsAt, lt: input.endsAt },
    },
  });
}

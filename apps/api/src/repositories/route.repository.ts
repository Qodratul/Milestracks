import {
  Prisma,
  type Locale,
  type RevealMode,
  type RouteStatus,
  type TemplateStatus,
} from "@prisma/client";
import { ROUTE_ALGORITHM_VERSION } from "../config/route-algorithm";
import { prisma, type Tx } from "../lib/prisma";
import type { RouteGenerationInput } from "../types/routes";

export async function lockUser(tx: Tx, userId: string): Promise<void> {
  await tx.$queryRaw(Prisma.sql`SELECT id FROM users WHERE id = ${userId} FOR UPDATE`);
}

export async function expireDueRoutes(
  tx: Tx,
  userId: string,
  timestamp: Date,
): Promise<void> {
  await tx.route.updateMany({
    where: {
      userId,
      status: { in: ["generating", "ready"] },
      expiresAt: { lte: timestamp },
    },
    data: { status: "expired", updatedAt: timestamp },
  });
}

export async function expireRoute(
  tx: Tx,
  routeId: string,
  timestamp: Date,
): Promise<void> {
  await tx.route.update({
    where: { id: routeId },
    data: { status: "expired", updatedAt: timestamp },
  });
}

export function findRoutePublishState(tx: Tx, routeId: string) {
  return tx.route.findUnique({
    where: { id: routeId },
    select: { status: true, expiresAt: true },
  });
}

export function expireExpiredRoutes(timestamp: Date) {
  return prisma.route.updateMany({
    where: { status: { in: ["generating", "ready"] }, expiresAt: { lte: timestamp } },
    data: { status: "expired", updatedAt: timestamp },
  });
}

export function findRecoverableRoutes(createdBefore: Date, timestamp: Date) {
  return prisma.route.findMany({
    where: {
      status: "generating",
      expiresAt: { gt: timestamp },
      createdAt: { gt: createdBefore },
    },
    select: { id: true },
  });
}

export async function findCurrentRoute(
  tx: Tx,
  userId: string,
  timestamp: Date,
): Promise<{
  readonly id: string;
  readonly status: "generating" | "ready";
  readonly algorithmVersion: string | null;
} | null> {
  const route = await tx.route.findFirst({
    where: {
      userId,
      status: { in: ["generating", "ready"] },
      expiresAt: { gt: timestamp },
    },
    orderBy: { createdAt: "desc" },
    select: {
      id: true,
      status: true,
      template: { select: { algorithmVersion: true } },
    },
  });
  if (!route || (route.status !== "generating" && route.status !== "ready")) return null;
  return {
    id: route.id,
    status: route.status,
    algorithmVersion: route.template?.algorithmVersion ?? null,
  };
}

export async function findTodayRoute(userId: string, timestamp: Date) {
  const active = await prisma.route.findFirst({
    where: {
      userId,
      status: { in: ["generating", "ready"] },
      expiresAt: { gt: timestamp },
      OR: [
        { status: "generating" },
        {
          status: "ready",
          template: { is: { algorithmVersion: ROUTE_ALGORITHM_VERSION } },
        },
      ],
    },
    orderBy: { createdAt: "desc" },
    select: { id: true, status: true, expiresAt: true, generationFailure: true },
  });
  if (active) return active;
  return prisma.route.findFirst({
    where: { userId, status: "failed", expiresAt: { gt: timestamp } },
    orderBy: { createdAt: "desc" },
    select: { id: true, status: true, expiresAt: true, generationFailure: true },
  });
}

export function findLatestFailedRoute(
  userId: string,
  timestamp: Date,
): Promise<{ readonly id: string } | null> {
  return prisma.route.findFirst({
    where: { userId, status: "failed", expiresAt: { gt: timestamp } },
    orderBy: { createdAt: "desc" },
    select: { id: true },
  });
}

export interface CreateRouteInput {
  readonly id: string;
  readonly userId: string;
  readonly templateId: string | null;
  readonly configVersion: number;
  readonly status: RouteStatus;
  readonly revealMode: RevealMode;
  readonly selectionReason?: string | undefined;
  readonly weatherHint?: unknown;
  readonly generationInput?: RouteGenerationInput | undefined;
  readonly replacesRouteId?: string | undefined;
  readonly expiresAt: Date;
  readonly timestamp: Date;
}

export async function createRoute(tx: Tx, input: CreateRouteInput): Promise<void> {
  await tx.route.create({
    data: {
      id: input.id,
      userId: input.userId,
      templateId: input.templateId,
      configVersion: input.configVersion,
      status: input.status,
      revealMode: input.revealMode,
      ...(input.selectionReason === undefined
        ? {}
        : { selectionReason: input.selectionReason }),
      ...(input.weatherHint === undefined
        ? {}
        : { weatherHint: input.weatherHint as Prisma.InputJsonValue }),
      ...(input.generationInput === undefined
        ? {}
        : { generationInput: input.generationInput as unknown as Prisma.InputJsonValue }),
      ...(input.replacesRouteId === undefined
        ? {}
        : { replacesRouteId: input.replacesRouteId }),
      expiresAt: input.expiresAt,
      createdAt: input.timestamp,
      updatedAt: input.timestamp,
    },
  });
}

export function findRouteDetails(routeId: string, userId: string, locale: Locale) {
  return prisma.route.findFirst({
    where: { id: routeId, userId },
    select: {
      id: true,
      userId: true,
      templateId: true,
      configVersion: true,
      status: true,
      revealMode: true,
      selectionReason: true,
      weatherHint: true,
      generationFailure: true,
      generationInput: true,
      replacesRouteId: true,
      expiresAt: true,
      usedAt: true,
      createdAt: true,
      updatedAt: true,
      template: {
        select: {
          id: true,
          levelCode: true,
          distanceMeters: true,
          estimatedDurationSec: true,
          estimatedCalories: true,
          safetyScore: true,
          dataConfidence: true,
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
            where: { locale },
            take: 1,
            select: {
              locale: true,
              title: true,
              mysteryBrief: true,
              preRunTip: true,
              warning: true,
              selectionReason: true,
              dialogues: true,
            },
          },
        },
      },
    },
  });
}

export type RouteDetails = NonNullable<Awaited<ReturnType<typeof findRouteDetails>>>;

export function findRouteGenerationWork(routeId: string) {
  return prisma.route.findUnique({
    where: { id: routeId },
    select: {
      id: true,
      userId: true,
      configVersion: true,
      status: true,
      expiresAt: true,
      generationInput: true,
      replacesRouteId: true,
    },
  });
}

export async function updateRouteReady(
  tx: Tx,
  routeId: string,
  templateId: string,
  selectionReason: string,
  timestamp: Date,
): Promise<boolean> {
  const result = await tx.route.updateMany({
    where: { id: routeId, status: "generating", expiresAt: { gt: timestamp } },
    data: {
      templateId,
      status: "ready",
      selectionReason,
      updatedAt: timestamp,
    },
  });
  return result.count === 1;
}

export async function markRouteFailed(
  routeId: string,
  failureCode: string,
  timestamp: Date,
): Promise<void> {
  await prisma.route.updateMany({
    where: { id: routeId, status: "generating" },
    data: {
      status: "failed",
      generationFailure: { code: failureCode, retryable: true },
      updatedAt: timestamp,
    },
  });
}

export async function failPendingRoutes(
  tx: Tx,
  failureCode: string,
  timestamp: Date,
  createdBefore: Date,
): Promise<number> {
  const result = await tx.route.updateMany({
    where: { status: "generating", createdAt: { lte: createdBefore } },
    data: {
      status: "failed",
      generationFailure: { code: failureCode, retryable: true },
      updatedAt: timestamp,
    },
  });
  return result.count;
}

export function findRouteForRegeneration(tx: Tx, userId: string, timestamp: Date) {
  return tx.route.findFirst({
    where: {
      userId,
      status: { in: ["ready", "generating"] },
      expiresAt: { gt: timestamp },
    },
    orderBy: { createdAt: "desc" },
    select: {
      id: true,
      templateId: true,
      generationInput: true,
      template: { select: { levelCode: true, distanceMeters: true } },
    },
  });
}

export function countRegenerations(
  tx: Tx,
  userId: string,
  start: Date,
  end: Date,
): Promise<number> {
  return tx.route.count({
    where: {
      userId,
      replacesRouteId: { not: null },
      createdAt: { gte: start, lt: end },
    },
  });
}

export async function findRouteReportTarget(
  tx: Tx,
  routeId: string,
  userId: string,
  timestamp: Date,
): Promise<{
  readonly id: string;
  readonly templateId: string;
  readonly templateStatus: TemplateStatus;
  readonly status: RouteStatus;
} | null> {
  const rows = await tx.$queryRaw<
    Array<{
      id: string;
      templateId: string;
      templateStatus: TemplateStatus;
      status: RouteStatus;
    }>
  >(Prisma.sql`
    SELECT route.id, route.template_id AS "templateId", route.status,
           template.status AS "templateStatus"
    FROM routes route
    JOIN route_templates template ON template.id = route.template_id
    WHERE route.id = ${routeId} AND route.user_id = ${userId}
      AND route.status IN ('ready'::route_status, 'used'::route_status)
      AND (route.status = 'used'::route_status OR route.expires_at > ${timestamp})
    FOR UPDATE OF route, template
  `);
  return rows[0] ?? null;
}

export async function createRouteReport(
  tx: Tx,
  input: {
    readonly id: string;
    readonly routeId: string;
    readonly templateId: string;
    readonly userId: string;
    readonly reason: "safety_concern" | "incorrect_map" | "inaccessible" | "other";
    readonly details?: string | undefined;
    readonly timestamp: Date;
  },
): Promise<void> {
  await tx.routeReport.create({
    data: {
      id: input.id,
      routeId: input.routeId,
      templateId: input.templateId,
      userId: input.userId,
      reason: input.reason,
      ...(input.details === undefined ? {} : { details: input.details }),
      createdAt: input.timestamp,
      updatedAt: input.timestamp,
    },
  });
}

export async function countSafetyReporters(tx: Tx, templateId: string): Promise<number> {
  const rows = await tx.$queryRaw<Array<{ reporterCount: number }>>(Prisma.sql`
    SELECT COUNT(DISTINCT user_id)::int AS "reporterCount"
    FROM route_reports
    WHERE template_id = ${templateId}
      AND reason = 'safety_concern'::report_reason
  `);
  return rows[0]?.reporterCount ?? 0;
}

export async function hasReportedRoute(
  routeId: string,
  userId: string,
): Promise<boolean> {
  return (await prisma.routeReport.count({ where: { routeId, userId } })) > 0;
}

export async function hasReportedRouteInTransaction(
  tx: Tx,
  routeId: string,
  userId: string,
): Promise<boolean> {
  return (await tx.routeReport.count({ where: { routeId, userId } })) > 0;
}

export async function expireReadyRoute(
  tx: Tx,
  input: { readonly routeId: string; readonly userId: string; readonly timestamp: Date },
): Promise<void> {
  await tx.route.updateMany({
    where: { id: input.routeId, userId: input.userId, status: "ready" },
    data: { status: "expired", updatedAt: input.timestamp },
  });
}

export async function findGeometryRecord(routeId: string, userId: string) {
  const rows = await prisma.$queryRaw<
    Array<{
      routeId: string;
      status: RouteStatus;
      revealMode: RevealMode;
      expiresAt: Date;
      templateStatus: TemplateStatus | null;
      geometryJson: string | null;
      startLat: number | null;
      startLng: number | null;
      hasRun: boolean;
      reported: boolean;
    }>
  >(Prisma.sql`
    SELECT route.id AS "routeId", route.status, route.reveal_mode AS "revealMode",
           route.expires_at AS "expiresAt", template.status AS "templateStatus",
           ST_AsGeoJSON(template.geometry) AS "geometryJson",
           ST_Y(template.start_point) AS "startLat",
           ST_X(template.start_point) AS "startLng",
           EXISTS (SELECT 1 FROM runs WHERE route_id = route.id) AS "hasRun",
           EXISTS (
             SELECT 1 FROM route_reports
             WHERE route_id = route.id AND user_id = ${userId}
           ) AS reported
    FROM routes route
    LEFT JOIN route_templates template ON template.id = route.template_id
    WHERE route.id = ${routeId} AND route.user_id = ${userId}
  `);
  return rows[0] ?? null;
}

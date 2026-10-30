import type { RouteStatus } from "@prisma/client";
import { levelByCode } from "../config/game-config";
import { gameConfigService } from "./game-config.service";
import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { idMessages } from "../i18n";
import { now } from "../lib/clock";
import {
  decodeGeometryCursor,
  distanceBetween,
  encodeGeometryCursor,
  encodePolyline,
  routeBounds,
  simplifyPolyline,
} from "../lib/route-geometry";
import { createId } from "../lib/ids";
import { withTransaction } from "../lib/prisma";
import { findProfileByUserId } from "../repositories/profile.repository";
import {
  findRouteDetails,
  findTodayRoute,
  findGeometryRecord,
  hasReportedRoute,
} from "../repositories/route.repository";
import {
  insertNarration,
  readTemplateStart,
} from "../repositories/route-template.repository";
import { RouteGenerationJobInputSchema } from "../validators/api.validator";
import type { RoutePoint } from "../providers/routing";
import { llmProvider, type RunnerLevel } from "../providers/llm";
import { RouteSelectionService } from "./route-selection.service";

const POLYLINE_PRECISION = 5;
const PREVIEW_POINT_LIMIT = 250;
const DEFAULT_GEOMETRY_PAGE_SIZE = 500;
const selection = new RouteSelectionService(llmProvider);

export interface RouteGeneratingSummary {
  readonly routeId: string;
  readonly status: "generating";
  readonly pollAfterMs: number;
}

export interface RouteFailedSummary {
  readonly routeId: string;
  readonly status: "failed";
  readonly failure: { readonly code: string; readonly retryable: boolean };
}

export interface ReadyRouteSummary {
  readonly routeId: string;
  readonly status: "ready";
  readonly level: string;
  readonly title: string;
  readonly mysteryBrief: string;
  readonly distanceMeters: number;
  readonly estimatedDurationSec: number;
  readonly estimatedCalories: number;
  readonly milestoneCount: number;
  readonly expPerMilestone: number;
  readonly startPoint: {
    readonly label: string;
    readonly distanceMeters: number;
    readonly location: RoutePoint;
  };
  readonly safetyScore: number;
  readonly dataConfidence: number;
  readonly warning: string | null;
  readonly revealMode: "full" | "next_milestone" | "blind";
  readonly selectionReason: string;
  readonly expiresAt: string;
}

export type RouteTodaySummary =
  ReadyRouteSummary | RouteGeneratingSummary | RouteFailedSummary | null;

export type GeometryResult =
  | {
      readonly kind: "single";
      readonly data: {
        readonly routeId: string;
        readonly revealed: boolean;
        readonly encoding: "polyline";
        readonly precision: number;
        readonly coordinates: string | null;
        readonly bounds: ReturnType<typeof routeBounds>;
      };
    }
  | {
      readonly kind: "page";
      readonly data: {
        readonly routeId: string;
        readonly revealed: true;
        readonly encoding: "polyline";
        readonly precision: number;
        readonly segments: readonly {
          readonly ordinal: number;
          readonly coordinates: string;
        }[];
      };
      readonly nextCursor: string | null;
      readonly limit: number;
    };

export const routeReadService = {
  async today(userId: string): Promise<RouteTodaySummary> {
    const route = await findTodayRoute(userId, now());
    if (!route) return null;
    if (route.status === "generating") {
      return { routeId: route.id, status: "generating", pollAfterMs: 1500 };
    }
    if (route.status === "failed") {
      return {
        routeId: route.id,
        status: "failed",
        failure: readFailure(route.generationFailure),
      };
    }
    return this.readySummary(route.id, userId);
  },

  async readySummary(routeId: string, userId: string): Promise<ReadyRouteSummary> {
    const record = await loadReadyRecord(routeId, userId);
    const narration = await ensureNarration(record, userId);
    const template = record.template;
    if (!template) throw notFound();
    const start = await withTransaction((tx) => readTemplateStart(tx, template.id));
    if (!start) throw notFound();
    const input = RouteGenerationJobInputSchema.safeParse(record.generationInput);
    const requestedStart = input.success ? input.data.location : start;
    const firstMilestone = template.milestones[0];
    const profile = await findProfileByUserId(userId);
    return {
      routeId: record.id,
      status: "ready",
      level: template.levelCode,
      title: narration.title,
      mysteryBrief: narration.mysteryBrief,
      distanceMeters: template.distanceMeters,
      estimatedDurationSec: template.estimatedDurationSec,
      estimatedCalories: template.estimatedCalories,
      milestoneCount: template.milestones.length,
      expPerMilestone: firstMilestone?.exp ?? 0,
      startPoint: {
        label: profile?.locale === "en" ? "Nearby mapped start" : "Titik awal terdekat",
        distanceMeters: Math.round(distanceBetween(requestedStart, start)),
        location: start,
      },
      safetyScore: template.safetyScore,
      dataConfidence: template.dataConfidence,
      warning: narration.warning,
      revealMode: record.revealMode,
      selectionReason: record.selectionReason ?? narration.selectionReason,
      expiresAt: record.expiresAt.toISOString(),
    };
  },

  async preview(routeId: string, userId: string) {
    const record = await loadReadyRecord(routeId, userId);
    const narration = await ensureNarration(record, userId);
    const template = record.template;
    if (!template) throw notFound();
    const start = await withTransaction((tx) => readTemplateStart(tx, template.id));
    if (!start) throw notFound();
    const input = RouteGenerationJobInputSchema.safeParse(record.generationInput);
    const requestedStart = input.success ? input.data.location : start;
    const profile = await findProfileByUserId(userId);
    return {
      routeId: record.id,
      status: "ready" as const,
      title: narration.title,
      mysteryBrief: narration.mysteryBrief,
      distanceMeters: template.distanceMeters,
      estimatedDurationSec: template.estimatedDurationSec,
      estimatedCalories: template.estimatedCalories,
      milestoneCount: template.milestones.length,
      expPerMilestone: template.milestones[0]?.exp ?? 0,
      milestones: template.milestones.map((milestone) => ({
        id: milestone.milestoneId,
        ordinal: milestone.ordinal,
        distanceMeters: milestone.distanceMeters,
        exp: milestone.exp,
      })),
      startPoint: {
        label: profile?.locale === "en" ? "Nearby mapped start" : "Titik awal terdekat",
        distanceMeters: Math.round(distanceBetween(requestedStart, start)),
        location: start,
      },
      safetyScore: template.safetyScore,
      dataConfidence: template.dataConfidence,
      warning: narration.warning,
      preRunTip: narration.preRunTip,
      revealMode: record.revealMode,
    };
  },

  async geometry(
    routeId: string,
    userId: string,
    query: {
      readonly detail?: "preview" | undefined;
      readonly cursor?: string | undefined;
      readonly limit?: number | undefined;
    },
  ): Promise<GeometryResult> {
    const record = await findGeometryRecord(routeId, userId);
    if (!record) throw notFound();
    assertRouteVisible(
      record.status,
      record.expiresAt,
      record.templateStatus,
      record.reported,
      record.geometryJson,
    );
    const geometry = parseGeometry(record.geometryJson);
    const bounds = routeBounds(geometry);
    const revealed = record.revealMode === "full" || record.hasRun;
    if (!revealed) {
      return {
        kind: "single",
        data: {
          routeId,
          revealed: false,
          encoding: "polyline",
          precision: POLYLINE_PRECISION,
          coordinates: null,
          bounds,
        },
      };
    }
    if (query.detail === "preview") {
      return {
        kind: "single",
        data: {
          routeId,
          revealed: true,
          encoding: "polyline",
          precision: POLYLINE_PRECISION,
          coordinates: encodePolyline(
            simplifyPolyline(geometry, PREVIEW_POINT_LIMIT),
            POLYLINE_PRECISION,
          ),
          bounds,
        },
      };
    }
    const limit = query.limit ?? DEFAULT_GEOMETRY_PAGE_SIZE;
    const offset = query.cursor ? decodeGeometryCursor(query.cursor, routeId) : 0;
    if (offset === undefined) {
      throw validationError("query.cursor", "Cursor is invalid for this route.");
    }
    const points = geometry.slice(offset, offset + limit);
    const nextOffset = offset + points.length;
    return {
      kind: "page",
      data: {
        routeId,
        revealed: true,
        encoding: "polyline",
        precision: POLYLINE_PRECISION,
        segments: points.length
          ? [
              {
                ordinal: Math.floor(offset / limit),
                coordinates: encodePolyline(points, POLYLINE_PRECISION),
              },
            ]
          : [],
      },
      nextCursor:
        nextOffset < geometry.length ? encodeGeometryCursor(routeId, nextOffset) : null,
      limit,
    };
  },
};

async function loadReadyRecord(routeId: string, userId: string) {
  const profile = await findProfileByUserId(userId);
  if (!profile) throw notFound();
  const record = await findRouteDetails(routeId, userId, profile.locale);
  if (!record) throw notFound();
  assertReady(record.status, record.expiresAt);
  if (await hasReportedRoute(routeId, userId)) throw notFound();
  if (record.template?.status === "suspended") throw notFound();
  if (!record.template) throw routeNotReady(record.status);
  return record;
}

async function ensureNarration(
  record: NonNullable<Awaited<ReturnType<typeof findRouteDetails>>>,
  userId: string,
) {
  const existing = record.template?.narrations[0];
  if (existing) return existing;
  const template = record.template;
  if (!template) throw notFound();
  const [config, profile] = await Promise.all([
    gameConfigService.version(record.configVersion),
    findProfileByUserId(userId),
  ]);
  const level = levelByCode(config, template.levelCode);
  const input = {
    userLevel: runnerLevel(level.name),
    totalDistanceMeters: template.distanceMeters,
    milestoneCount: template.milestones.length,
    language: profile?.locale ?? "id",
    candidates: [
      {
        id: template.id,
        distanceMeters: template.distanceMeters,
        scorePermil: Math.round(template.safetyScore * 1000),
        safetyScore: template.safetyScore,
        dataConfidence: template.dataConfidence,
        elevationGainMeters: 0,
        maxGradePercent: 0,
        surfaces: [],
        areaHints: [],
      },
    ],
  };
  const generated = await selection.select(input);
  const narration = {
    locale: input.language,
    title: generated.narrative.trackTitle,
    mysteryBrief: generated.narrative.mysteryBrief,
    preRunTip: generated.narrative.preRunTip,
    warning: null,
    selectionReason: generated.narrative.selectionReason,
    dialogues: generated.narrative.milestoneDialogues,
  };
  await withTransaction((tx) =>
    insertNarration(tx, template.id, createId("rt"), narration, now()),
  );
  return narration;
}

function runnerLevel(name: string): RunnerLevel {
  const levels: Readonly<Record<string, RunnerLevel>> = {
    Beginner: "Beginner",
    Intermediate: "Intermediate",
    Advanced: "Advanced",
    Professional: "Professional",
    Master: "Master",
  };
  const value = levels[name];
  if (!value) throw new Error("Game config contains an unsupported level name.");
  return value;
}

function assertReady(status: RouteStatus, expiresAt: Date): void {
  if (status === "expired" || expiresAt <= now()) {
    throw new AppError(409, ERROR_CODES.ROUTE_EXPIRED, idMessages.errors.routeExpired);
  }
  if (status !== "ready" && status !== "used") throw routeNotReady(status);
}

function assertRouteVisible(
  status: RouteStatus,
  expiresAt: Date,
  templateStatus: "active" | "flagged" | "suspended" | null,
  reported: boolean,
  geometryJson: string | null,
): asserts geometryJson is string {
  if (reported || templateStatus === "suspended" || !geometryJson) throw notFound();
  if (status === "expired" || (status === "ready" && expiresAt <= now())) {
    throw new AppError(409, ERROR_CODES.ROUTE_EXPIRED, idMessages.errors.routeExpired);
  }
  if (status !== "ready" && status !== "used") throw routeNotReady(status);
}

function parseGeometry(value: string): readonly RoutePoint[] {
  let parsed: unknown;
  try {
    parsed = JSON.parse(value);
  } catch {
    throw new Error("Stored route geometry is invalid.");
  }
  if (
    typeof parsed !== "object" ||
    parsed === null ||
    !Array.isArray(Reflect.get(parsed, "coordinates"))
  ) {
    throw new Error("Stored route geometry is invalid.");
  }
  const coordinates: unknown[] = Reflect.get(parsed, "coordinates");
  const points = coordinates.map((coordinate): RoutePoint => {
    if (
      !Array.isArray(coordinate) ||
      typeof coordinate[0] !== "number" ||
      typeof coordinate[1] !== "number"
    ) {
      throw new Error("Stored route geometry is invalid.");
    }
    return { lng: coordinate[0], lat: coordinate[1] };
  });
  if (points.length < 2) throw new Error("Stored route geometry is invalid.");
  return points;
}

function readFailure(value: unknown): { code: string; retryable: boolean } {
  if (typeof value === "object" && value !== null) {
    const code = Reflect.get(value, "code");
    const retryable = Reflect.get(value, "retryable");
    return {
      code: typeof code === "string" ? code : ERROR_CODES.ROUTE_UNAVAILABLE,
      retryable: typeof retryable === "boolean" ? retryable : true,
    };
  }
  return { code: ERROR_CODES.ROUTE_UNAVAILABLE, retryable: true };
}

function routeNotReady(status: RouteStatus): AppError {
  return new AppError(409, ERROR_CODES.ROUTE_NOT_READY, idMessages.errors.routeNotReady, {
    status,
  });
}

function notFound(): AppError {
  return new AppError(404, ERROR_CODES.NOT_FOUND, idMessages.errors.notFound);
}

function validationError(path: string, message: string): AppError {
  return new AppError(400, ERROR_CODES.VALIDATION_ERROR, idMessages.errors.validation, {
    fields: [{ path, message }],
  });
}

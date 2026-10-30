import { env } from "../config/env";
import { ROUTE_ALGORITHM_VERSION } from "../config/route-algorithm";
import { levelFor, levelByCode } from "../config/game-config";
import { gameConfigService } from "./game-config.service";
import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { idMessages } from "../i18n";
import { now } from "../lib/clock";
import { createId } from "../lib/ids";
import { logger } from "../lib/logger";
import { prisma, withTransaction } from "../lib/prisma";
import { routeJobs } from "../lib/route-jobs";
import {
  createRoute,
  countRegenerations,
  expireDueRoutes,
  findCurrentRoute,
  findRouteForRegeneration,
  findRouteGenerationWork,
  failPendingRoutes,
  lockUser,
  markRouteFailed,
  updateRouteReady,
} from "../repositories/route.repository";
import { findActiveRun } from "../repositories/run.repository";
import {
  findReusableTemplate,
  readTemplateGeometry,
} from "../repositories/route-template.repository";
import { findProfileByUserId } from "../repositories/profile.repository";
import {
  RouteGenerationJobInputSchema,
  type GenerateRouteBody,
} from "../validators/api.validator";
import type { RouteGenerationInput } from "../types/routes";
import { RouteCandidateService } from "./route-candidate.service";
import { utcDayWindow } from "../utils/time";

const ROUTE_DISTANCE_TOLERANCE_PERMIL = 150;
const ROUTE_REUSE_WINDOW_DAYS = 30;

export interface RouteActionResult {
  readonly routeId: string;
  readonly status: "generating" | "ready";
  readonly regenerationsRemaining?: number;
}

export class RouteGenerationService {
  public constructor(private readonly candidates = new RouteCandidateService()) {}

  public async recoverPendingJobs(): Promise<number> {
    const timestamp = now();
    const createdBefore = new Date(
      timestamp.getTime() - env.ROUTE_GENERATION_STALE_AFTER_MS,
    );
    try {
      await withTransaction((tx) =>
        failPendingRoutes(tx, ERROR_CODES.ROUTE_UNAVAILABLE, timestamp, createdBefore),
      );
    } catch (error: unknown) {
      throw new AppError(
        503,
        ERROR_CODES.SERVICE_UNAVAILABLE,
        idMessages.errors.serviceUnavailable,
        { dependency: "route_jobs" },
        error,
      );
    }
    await prisma.route.updateMany({
      where: {
        status: { in: ["generating", "ready"] },
        expiresAt: { lte: timestamp },
      },
      data: { status: "expired", updatedAt: timestamp },
    });
    const pending = await prisma.route.findMany({
      where: {
        status: "generating",
        expiresAt: { gt: timestamp },
        createdAt: { gt: createdBefore },
      },
      select: { id: true },
    });
    for (const route of pending) this.enqueue(route.id);
    return pending.length;
  }

  public async request(
    userId: string,
    request: GenerateRouteBody,
  ): Promise<RouteActionResult> {
    let stage = "profile_lookup";
    try {
      const profile = await findProfileByUserId(userId);
      if (!profile) throw notFound();
      stage = "active_game_config";
      const config = await gameConfigService.active();
      stage = "level_selection";
      const level = levelFor(config, profile.totalExp);
      const targetDistanceMeters = Math.round(
        request.preferredDistanceMeters ?? level.distanceMinMeters,
      );
      assertDistanceInLevelRange(
        targetDistanceMeters,
        level.distanceMinMeters,
        level.distanceMaxMeters,
      );
      const timestamp = now();
      const generationInput: RouteGenerationInput = {
        location: request.location,
        targetDistanceMeters,
        levelCode: level.code,
        locale: profile.locale,
        ...(request.weather ? { weather: request.weather } : {}),
      };
      const result = await withTransaction(async (tx) => {
        stage = "lock_user";
        await lockUser(tx, userId);
        stage = "expire_due_routes";
        await expireDueRoutes(tx, userId, timestamp);
        stage = "check_active_run";
        const activeRunId = await findActiveRun(tx, userId);
        if (activeRunId) throw activeRunExists(activeRunId);
        stage = "find_current_route";
        const current = await findCurrentRoute(tx, userId, timestamp);
        if (current?.status === "generating") return current;
        if (
          current?.status === "ready" &&
          current.algorithmVersion === ROUTE_ALGORITHM_VERSION
        ) {
          return current;
        }
        if (current?.status === "ready") {
          await tx.route.update({
            where: { id: current.id },
            data: { status: "expired", updatedAt: timestamp },
          });
        }
        stage = "find_reusable_template";
        const template = await findReusableTemplate(
          tx,
          reusableQuery({
            userId,
            generationInput,
            radiusMeters: config.rules.trackStartRadiusMeters,
            timestamp,
          }),
        );
        stage = "create_route";
        const routeId = createId("route");
        const status: "ready" | "generating" = template ? "ready" : "generating";
        await createRoute(tx, {
          id: routeId,
          userId,
          templateId: template?.id ?? null,
          configVersion: config.configVersion,
          status,
          revealMode: level.defaultRevealMode,
          selectionReason: template ? "Reused route from the library." : undefined,
          weatherHint: request.weather,
          generationInput,
          expiresAt: nextRouteExpiry(timestamp, config.routeExpiryHourUtc),
          timestamp,
        });
        return { id: routeId, status };
      });
      if (result.status === "generating") {
        stage = "enqueue_generation";
        this.enqueue(result.id);
      }
      return { routeId: result.id, status: result.status };
    } catch (error: unknown) {
      logger.error(
        { stage, errorType: error instanceof Error ? error.name : typeof error },
        "Mystery route request failed",
      );
      throw error;
    }
  }

  public async regenerate(
    userId: string,
    request: {
      readonly location?: GenerateRouteBody["location"] | undefined;
      readonly weather?: GenerateRouteBody["weather"];
    } = {},
  ): Promise<RouteActionResult> {
    const profile = await findProfileByUserId(userId);
    if (!profile) throw notFound();
    const config = await gameConfigService.active();
    const timestamp = now();
    const day = utcDayWindow(timestamp.getTime());
    const result = await withTransaction(async (tx) => {
      await lockUser(tx, userId);
      await expireDueRoutes(tx, userId, timestamp);
      const activeRunId = await findActiveRun(tx, userId);
      if (activeRunId) throw activeRunExists(activeRunId);

      const previous = await findRouteForRegeneration(tx, userId, timestamp);
      if (!previous) throw notFound();
      const regenerationCount = await countRegenerations(
        tx,
        userId,
        new Date(day.startEpochMs),
        new Date(day.endEpochMs),
      );
      if (regenerationCount >= config.rules.regenerationsPerDay) {
        throw regenerateLimitReached(new Date(day.endEpochMs));
      }
      const priorInput = parsePriorInput(previous.generationInput);
      const location =
        request.location ??
        priorInput?.location ??
        (await templateStart(tx, previous.templateId));
      if (!location) throw routeNotReady("generating");
      const levelCode =
        previous.template?.levelCode ?? priorInput?.levelCode ?? profile.levelCode;
      const level = levelByCode(config, levelCode);
      const targetDistanceMeters =
        previous.template?.distanceMeters ??
        priorInput?.targetDistanceMeters ??
        level.distanceMinMeters;
      const generationInput: RouteGenerationInput = {
        location,
        targetDistanceMeters,
        levelCode,
        locale: profile.locale,
        ...((previous.templateId ?? priorInput?.excludedTemplateId)
          ? { excludedTemplateId: previous.templateId ?? priorInput?.excludedTemplateId }
          : {}),
        ...((request.weather ?? priorInput?.weather)
          ? { weather: request.weather ?? priorInput?.weather }
          : {}),
      };
      await tx.route.update({
        where: { id: previous.id },
        data: { status: "expired", updatedAt: timestamp },
      });
      const template = await findReusableTemplate(
        tx,
        reusableQuery({
          userId,
          generationInput,
          radiusMeters: config.rules.trackStartRadiusMeters,
          timestamp,
        }),
      );
      const routeId = createId("route");
      const status: "ready" | "generating" = template ? "ready" : "generating";
      await createRoute(tx, {
        id: routeId,
        userId,
        templateId: template?.id ?? null,
        configVersion: config.configVersion,
        status,
        revealMode: level.defaultRevealMode,
        ...(template ? { selectionReason: "Replacement route from the library." } : {}),
        ...(generationInput.weather ? { weatherHint: generationInput.weather } : {}),
        generationInput,
        replacesRouteId: previous.id,
        expiresAt: nextRouteExpiry(timestamp, config.routeExpiryHourUtc),
        timestamp,
      });
      return {
        id: routeId,
        status,
        regenerationsRemaining: Math.max(
          0,
          config.rules.regenerationsPerDay - regenerationCount - 1,
        ),
      };
    });
    if (result.status === "generating") this.enqueue(result.id);
    return {
      routeId: result.id,
      status: result.status,
      regenerationsRemaining: result.regenerationsRemaining,
    };
  }

  public async generate(routeId: string): Promise<void> {
    logger.info({ routeId }, "Route generation job started");
    const route = await findRouteGenerationWork(routeId);
    if (!route || route.status !== "generating" || route.expiresAt <= now()) {
      logger.warn(
        { routeId },
        "Route generation job skipped because it is no longer active",
      );
      return;
    }
    const parsedInput = RouteGenerationJobInputSchema.safeParse(route.generationInput);
    if (!parsedInput.success) {
      await this.fail(routeId);
      return;
    }
    const input = parsedInput.data;
    const [config, profile] = await Promise.all([
      gameConfigService.version(route.configVersion),
      findProfileByUserId(route.userId),
    ]);
    if (!profile) {
      await this.fail(routeId);
      return;
    }
    const built = await this.candidates.build({
      routeId,
      userId: route.userId,
      levelCode: input.levelCode,
      targetDistanceMeters: input.targetDistanceMeters,
      location: input.location,
      locale: input.locale,
      timezone: profile.timezone,
      seed: seedFromRouteId(routeId),
      ...(input.weather ? { weatherTemperatureC: input.weather.temperatureC } : {}),
      config,
    });
    if (!built) {
      logger.warn({ routeId }, "No safe route candidate found; checking route library");
      const fallback = await this.findLibraryFallback(route.userId, input, config);
      if (fallback) {
        await withTransaction((tx) =>
          updateRouteReady(
            tx,
            routeId,
            fallback.id,
            "Used a matching library route after generation failed.",
            now(),
          ),
        );
        logger.info(
          { routeId, outcome: "ready_from_library" },
          "Route generation job completed",
        );
        return;
      }
      await this.fail(routeId);
      logger.warn(
        { routeId, outcome: "failed_no_safe_candidate" },
        "Route generation job failed",
      );
      return;
    }
    const published = await withTransaction(async (tx) => {
      const current = await tx.route.findUnique({
        where: { id: routeId },
        select: { status: true, expiresAt: true },
      });
      const timestamp = now();
      if (!current || current.status !== "generating" || current.expiresAt <= timestamp) {
        throw new Error("Route generation was superseded.");
      }
      const templateId = await this.candidates.persist(tx, built);
      if (!templateId) return false;
      const updated = await updateRouteReady(
        tx,
        routeId,
        templateId,
        built.selectionReason,
        timestamp,
      );
      if (!updated) throw new Error("Route generation was superseded.");
      return true;
    });
    if (published) {
      logger.info({ routeId, outcome: "ready" }, "Route generation job completed");
      return;
    }
    const duplicateFallback = await this.findLibraryFallback(route.userId, input, config);
    if (duplicateFallback) {
      await withTransaction((tx) =>
        updateRouteReady(
          tx,
          routeId,
          duplicateFallback.id,
          "Used an existing matching route after deduplication.",
          now(),
        ),
      );
      logger.info(
        { routeId, outcome: "ready_after_deduplication" },
        "Route generation job completed",
      );
      return;
    }
    await this.fail(routeId);
    logger.warn(
      { routeId, outcome: "failed_after_deduplication" },
      "Route generation job failed",
    );
  }

  public recover(routeId: string): void {
    this.enqueue(routeId);
  }

  public async fail(routeId: string): Promise<void> {
    await markRouteFailed(routeId, ERROR_CODES.ROUTE_UNAVAILABLE, now());
  }

  private enqueue(routeId: string): void {
    routeJobs.enqueue(routeId, async () => {
      try {
        await this.generate(routeId);
      } catch (error: unknown) {
        logger.error(
          {
            routeId,
            errorType: error instanceof Error ? error.name : typeof error,
            ...(error instanceof AppError ? { errorCode: error.code } : {}),
          },
          "Route generation job crashed",
        );
        await this.fail(routeId);
      }
    });
  }

  private async findLibraryFallback(
    userId: string,
    input: RouteGenerationInput,
    config: Awaited<ReturnType<typeof gameConfigService.active>>,
  ) {
    return withTransaction((tx) =>
      findReusableTemplate(
        tx,
        reusableQuery({
          userId,
          generationInput: input,
          radiusMeters: config.rules.trackStartRadiusMeters,
          timestamp: now(),
        }),
      ),
    );
  }
}

export const routeGenerationService = new RouteGenerationService();

function reusableQuery(input: {
  readonly userId: string;
  readonly generationInput: RouteGenerationInput;
  readonly radiusMeters: number;
  readonly timestamp: Date;
}) {
  return {
    userId: input.userId,
    levelCode: input.generationInput.levelCode,
    targetDistanceMeters: input.generationInput.targetDistanceMeters,
    tolerancePermil: ROUTE_DISTANCE_TOLERANCE_PERMIL,
    start: input.generationInput.location,
    radiusMeters: input.radiusMeters,
    algorithmVersion: ROUTE_ALGORITHM_VERSION,
    usedAfter: new Date(
      input.timestamp.getTime() - ROUTE_REUSE_WINDOW_DAYS * 24 * 60 * 60 * 1000,
    ),
    ...(input.generationInput.excludedTemplateId
      ? { excludedTemplateId: input.generationInput.excludedTemplateId }
      : {}),
  };
}

function parsePriorInput(value: unknown): RouteGenerationInput | undefined {
  const parsed = RouteGenerationJobInputSchema.safeParse(value);
  return parsed.success ? parsed.data : undefined;
}

async function templateStart(
  tx: Parameters<typeof readTemplateGeometry>[0],
  templateId: string | null,
) {
  if (!templateId) return undefined;
  const record = await readTemplateGeometry(tx, templateId);
  return record
    ? { lat: record.startLat, lng: record.startLng, accuracyMeters: 1 }
    : undefined;
}

function seedFromRouteId(routeId: string): number {
  let seed = 0;
  for (const character of routeId) {
    seed = (seed * 31 + character.charCodeAt(0)) % 2_147_483_647;
  }
  return seed;
}
function assertDistanceInLevelRange(
  distanceMeters: number,
  minMeters: number,
  maxMeters: number,
): void {
  if (distanceMeters >= minMeters && distanceMeters <= maxMeters) return;
  throw new AppError(422, ERROR_CODES.VALIDATION_ERROR, idMessages.errors.validation, {
    fields: [
      {
        path: "body.preferredDistanceMeters",
        message: "Distance must be inside the active level range.",
      },
    ],
  });
}

function nextRouteExpiry(timestamp: Date, expiryHourUtc: number): Date {
  const expiry = new Date(
    Date.UTC(
      timestamp.getUTCFullYear(),
      timestamp.getUTCMonth(),
      timestamp.getUTCDate(),
      expiryHourUtc,
    ),
  );
  if (expiry <= timestamp) expiry.setUTCDate(expiry.getUTCDate() + 1);
  return expiry;
}

function activeRunExists(runId: string): AppError {
  return new AppError(
    409,
    ERROR_CODES.ACTIVE_RUN_EXISTS,
    idMessages.errors.activeRunExists,
    { runId },
  );
}

function regenerateLimitReached(resetAt: Date): AppError {
  return new AppError(
    429,
    ERROR_CODES.REGENERATE_LIMIT_REACHED,
    idMessages.errors.regenerateLimitReached,
    { resetAt: resetAt.toISOString() },
  );
}

function routeNotReady(status: string): AppError {
  return new AppError(409, ERROR_CODES.ROUTE_NOT_READY, idMessages.errors.routeNotReady, {
    status,
  });
}

function notFound(): AppError {
  return new AppError(404, ERROR_CODES.NOT_FOUND, idMessages.errors.notFound);
}

import type { Prisma } from "@prisma/client";
import { analyzeAntiCheat } from "../domain/anti-cheat";
import { convertExpToCoins } from "../domain/coin";
import { calculateRunExp } from "../domain/exp";
import { milestoneMultiplierPermil } from "../domain/multiplier";
import { buildGuidanceSteps } from "../domain/route-guidance";
import { calculateRunRp } from "../domain/rp";
import type { RouteGuidanceInstruction } from "../types/routes";
import {
  activeSecondsAt,
  distanceBetweenMeters,
  gpsQuality,
  runDistanceMeters,
} from "../domain/run";
import type {
  RunLocationSample,
  RunPausePeriod,
  RunMilestoneCandidate,
  VerifiedRunMilestone,
} from "../domain/run";
import { transitionRunState } from "../domain/run-state";
import { AppError } from "../errors/app-error";
import { now } from "../lib/clock";
import { createId } from "../lib/ids";
import { withTransaction, type Tx } from "../lib/prisma";
import { utcWeekWindow } from "../utils/time";
import type { GameLoadout, ItemCode, RunStatus } from "../types/game";
import type {
  ClaimBodySchema,
  FinishBodySchema,
  LocationsBodySchema,
  ReachMilestoneBodySchema,
  SafeStopBodySchema,
  StartRunBodySchema,
} from "../validators/api.validator";
import type { z } from "zod";
import { gameConfigService } from "./game-config.service";
import { itemService } from "./item.service";
import { ledgerService } from "./ledger.service";
import { antiCheatConfigService } from "./anti-cheat-config.service";
import { streakService } from "./streak.service";
import {
  countSafeStopsInWindow,
  createMilestoneRecords,
  createRunRecord,
  findActiveRun,
  findRunGuidance,
  findOwnedRoute,
  findRunStartProfile,
  findRouteStartAndMilestones,
  findMilestoneSampleMatches,
  findRun,
  findRunOutsideTransaction,
  listRunSamples,
  listRunSamplesOutside,
  lockRun,
  lockRunUser,
  saveSampleBatch,
  updateMilestoneResult,
  updateRouteUsed,
  updateRun,
  writeIntegrityMetrics,
} from "../repositories/run.repository";

type StartBody = z.infer<typeof StartRunBodySchema>;
type LocationsBody = z.infer<typeof LocationsBodySchema>;
type ReachBody = z.infer<typeof ReachMilestoneBodySchema>;
type FinishBody = z.infer<typeof FinishBodySchema>;
type SafeStopBody = z.infer<typeof SafeStopBodySchema>;
type ClaimBody = z.infer<typeof ClaimBodySchema>;

type Metadata = GameLoadout & {
  readonly units: "metric" | "imperial";
  readonly clientCapabilities: StartBody["clientCapabilities"];
  readonly startLocation: StartBody["startLocation"];
  readonly penaltyFreeRun: boolean;
  readonly levelCode: string;
  readonly locale: "id" | "en";
  readonly pausePeriods: readonly RunPausePeriod[];
};
type StoredResult = Record<string, unknown> & {
  readonly summary?: Record<string, unknown>;
  readonly finishResponse?: Record<string, unknown>;
  readonly claimResponse?: Record<string, unknown>;
};

export const runService = {
  async getActive(userId: string) {
    const runId = await withTransaction((tx) => findActiveRun(tx, userId));
    if (!runId) return { run: null };
    try {
      const [run, record] = await Promise.all([
        this.get(userId, runId),
        findRunOutsideTransaction(userId, runId),
      ]);
      if (!record || (record.status !== "active" && record.status !== "paused")) {
        return { run: null };
      }
      return {
        run: {
          runId: run.runId,
          routeId: run.routeId,
          status: run.status,
          startedAt: run.startedAt,
          elapsedSec: run.elapsedSec,
          activeSec: run.activeSec,
          distanceMeters: run.distanceMeters,
          lastSampleSequence: run.lastSampleSequence,
          reachedMilestoneIds: record.milestoneResults
            .filter((milestone) => milestone.status === "reached")
            .map((milestone) => milestone.milestoneId),
        },
      };
    } catch (error) {
      // A run can finish between the active lookup and detail query.
      if (error instanceof AppError && error.statusCode === 404) {
        return { run: null };
      }
      throw error;
    }
  },

  async start(userId: string, body: StartBody) {
    const timestamp = now();
    return withTransaction(async (tx) => {
      if (!(await lockRunUser(tx, userId))) throw notFound();
      const activeRunId = await findActiveRun(tx, userId);
      if (activeRunId)
        throw new AppError(
          409,
          "ACTIVE_RUN_EXISTS",
          "Pengguna sudah memiliki lari aktif.",
          { runId: activeRunId },
        );

      const route = await findOwnedRoute(tx, userId, body.routeId);
      if (!route || !route.template) throw notFound();
      if (route.expiresAt <= timestamp)
        throw new AppError(409, "ROUTE_EXPIRED", "Rute sudah kedaluwarsa.");
      if (
        route.status !== "ready" ||
        route.usedAt ||
        route.template.status !== "active"
      ) {
        throw new AppError(409, "ROUTE_NOT_READY", "Rute belum siap untuk dimulai.");
      }
      const config = await gameConfigService.version(route.configVersion);
      const profile = await findRunStartProfile(tx, userId);
      if (!profile) throw notFound();
      const level = config.levels.find((entry) => entry.code === profile.levelCode);
      if (!level) throw new Error("Profile level is missing from its game config.");
      if (route.template.distanceMeters < config.rules.minimumDistanceMeters) {
        throw new AppError(
          409,
          "ROUTE_NOT_READY",
          "Jarak rute lebih pendek dari minimum.",
        );
      }

      const geometry = await findRouteStartAndMilestones(tx, route.id);
      if (!geometry) throw notFound();
      const startDistance = distanceBetweenMeters(body.startLocation, {
        lat: geometry.startLat,
        lng: geometry.startLng,
      });
      if (startDistance > config.rules.startMaxDistanceMeters) {
        throw new AppError(422, "START_TOO_FAR", "Terlalu jauh dari titik mulai.", {
          distanceToStartMeters: Math.round(startDistance),
          maxMeters: config.rules.startMaxDistanceMeters,
        });
      }
      const loadout: GameLoadout = {
        boostItemCode: body.boostItemCode,
        modifierItemCode: body.modifierItemCode,
      };
      await itemService.consumeForRun(userId, loadout, tx);
      const runId = createId("run");
      const metadata: Metadata = {
        ...loadout,
        units: body.units,
        clientCapabilities: body.clientCapabilities,
        startLocation: body.startLocation,
        penaltyFreeRun: profile.completedRuns < config.rules.penaltyFreeRuns,
        levelCode: profile.levelCode,
        locale: profile.locale,
        pausePeriods: [],
      };
      await createRunRecord(tx, {
        id: runId,
        userId,
        routeId: route.id,
        configVersion: route.configVersion,
        lockedLoadout: metadata as unknown as Prisma.InputJsonValue,
        startedAt: timestamp,
      });
      await createMilestoneRecords(tx, runId, geometry.milestones, timestamp);
      if (!(await updateRouteUsed(tx, route.id, timestamp))) {
        throw new AppError(409, "ROUTE_NOT_READY", "Rute sudah digunakan.");
      }
      const usedThisWeek = await countSafeStops(tx, userId, timestamp);
      return {
        runId,
        routeId: route.id,
        status: "active" as const,
        startedAt: timestamp.toISOString(),
        minimumDistanceMeters: config.rules.minimumDistanceMeters,
        revealMode: route.revealMode,
        loadout,
        quota: {
          safeStopsRemaining: Math.max(0, level.safeStopPerWeek - usedThisWeek),
          expRemaining: null,
          rpRemaining: null,
          coinsRemaining: null,
        },
        penaltyFreeRun: metadata.penaltyFreeRun,
        milestones: geometry.milestones.map((milestone) => ({
          id: milestone.milestoneId,
          ordinal: milestone.ordinal,
          status: "pending" as const,
          distanceMeters: milestone.distanceMeters,
          exp: milestone.exp,
          location: { lat: milestone.latitude, lng: milestone.longitude },
          radiusMeters: milestone.radiusMeters,
        })),
      };
    });
  },

  async get(userId: string, runId: string) {
    const timestamp = now();
    const run = await findRunOutsideTransaction(userId, runId);
    if (!run) throw notFound();
    const metadata = readMetadata(run.lockedLoadout);
    const samples = parseSamples(await listRunSamplesOutside(runId));
    const activeSec =
      run.status === "active" || run.status === "paused"
        ? activeSecondsAt({
            startedAtMs: run.startedAt.getTime(),
            timestampMs: timestamp.getTime(),
            pausePeriods: metadata.pausePeriods,
          })
        : readNumber(readResult(run.result).summary?.activeDurationSec, 0);
    const reached = run.milestoneResults.filter((entry) => entry.status === "reached");
    const next = run.milestoneResults.find((entry) => entry.status === "pending");
    return {
      runId,
      routeId: run.routeId,
      status: run.status,
      startedAt: run.startedAt.toISOString(),
      elapsedSec: Math.max(
        0,
        Math.floor((timestamp.getTime() - run.startedAt.getTime()) / 1000),
      ),
      activeSec,
      distanceMeters: runDistanceMeters(samples),
      gpsQuality: gpsQuality(samples),
      milestones: {
        reached: reached.length,
        total: run.milestoneResults.length,
        nextMilestoneId: next?.milestoneId ?? null,
      },
      lastSampleSequence: run.lastSequence,
      loadout: {
        boostItemCode: metadata.boostItemCode,
        modifierItemCode: metadata.modifierItemCode,
      },
      claim: run.claimId
        ? { claimId: run.claimId, claimed: run.claimedAt !== null }
        : null,
    };
  },

  async getTrace(userId: string, runId: string) {
    const run = await findRunOutsideTransaction(userId, runId);
    if (!run) throw notFound();
    const samples = parseSamples(await listRunSamplesOutside(runId));
    return samples.map((sample) => ({ ...sample }));
  },

  async pause(userId: string, runId: string) {
    return withTransaction(async (tx) => {
      const run = await lockAndFind(tx, userId, runId);
      const transition = transitionRunState(run.status as RunStatus, "pause");
      if (!transition.allowed) throw invalidState();
      const timestamp = now();
      const metadata = readMetadata(run.lockedLoadout);
      const pausePeriods = [
        ...metadata.pausePeriods,
        { pausedAt: timestamp.getTime(), resumedAt: null },
      ];
      await updateRun(tx, runId, {
        status: transition.status,
        lockedLoadout: { ...metadata, pausePeriods } as unknown as Prisma.InputJsonValue,
        updatedAt: timestamp,
      });
      return { runId, status: "paused" as const, pausedAt: timestamp.toISOString() };
    });
  },

  async resume(userId: string, runId: string) {
    return withTransaction(async (tx) => {
      const run = await lockAndFind(tx, userId, runId);
      const transition = transitionRunState(run.status as RunStatus, "resume");
      if (!transition.allowed) throw invalidState();
      const timestamp = now();
      const metadata = readMetadata(run.lockedLoadout);
      const pausePeriods = [...metadata.pausePeriods];
      const last = pausePeriods[pausePeriods.length - 1];
      if (!last || last.resumedAt !== null) throw invalidState();
      const pausedDurationSec = Math.max(
        0,
        Math.floor((timestamp.getTime() - last.pausedAt) / 1000),
      );
      pausePeriods[pausePeriods.length - 1] = { ...last, resumedAt: timestamp.getTime() };
      await updateRun(tx, runId, {
        status: transition.status,
        lockedLoadout: { ...metadata, pausePeriods } as unknown as Prisma.InputJsonValue,
        updatedAt: timestamp,
      });
      return {
        runId,
        status: "active" as const,
        resumedAt: timestamp.toISOString(),
        pausedDurationSec,
      };
    });
  },

  async uploadLocations(userId: string, runId: string, body: LocationsBody) {
    return withTransaction(async (tx) => {
      const run = await lockAndFind(tx, userId, runId);
      if (run.status !== "active") throw invalidState();
      const timestamp = now();
      const accepted: RunLocationSample[] = [];
      let duplicateCount = 0;
      let lastSequence = run.lastSequence;
      for (const sample of body.samples) {
        if (sample.sequence <= lastSequence) {
          duplicateCount += 1;
          continue;
        }
        if (sample.sequence !== lastSequence + 1) {
          throw new AppError(400, "VALIDATION_ERROR", "Nomor sampel harus berurutan.", {
            expectedSequence: lastSequence + 1,
          });
        }
        if (
          sample.t < run.startedAt.getTime() - 10_000 ||
          sample.t > timestamp.getTime() + 30_000
        ) {
          throw new AppError(
            400,
            "VALIDATION_ERROR",
            "Waktu sampel di luar rentang run.",
          );
        }
        accepted.push({
          sequence: sample.sequence,
          t: sample.t,
          lat: sample.lat,
          lng: sample.lng,
          accuracyMeters: sample.accuracyMeters,
          ...(sample.speedMps === undefined ? {} : { speedMps: sample.speedMps }),
          ...(sample.mocked === undefined ? {} : { mocked: sample.mocked }),
        });
        lastSequence = sample.sequence;
      }
      if (accepted.length) {
        await saveSampleBatch(tx, {
          id: createId("req"),
          runId,
          firstSequence: accepted[0]!.sequence,
          lastSequence: accepted[accepted.length - 1]!.sequence,
          samples: accepted as unknown as Prisma.InputJsonArray,
          receivedAt: timestamp,
        });
        await updateRun(tx, runId, { lastSequence, updatedAt: timestamp });
      }
      const allSamples = parseSamples(await listRunSamples(tx, runId));
      return {
        acceptedCount: accepted.length,
        duplicateCount,
        lastSequence,
        gpsQuality: gpsQuality(allSamples),
        distanceMeters: runDistanceMeters(allSamples),
      };
    });
  },

  async reachMilestone(
    userId: string,
    runId: string,
    milestoneId: string,
    body: ReachBody,
  ) {
    return withTransaction(async (tx) => {
      const run = await lockAndFind(tx, userId, runId);
      if (run.status !== "active") throw invalidState();
      const target = run.milestoneResults.find(
        (entry) => entry.milestoneId === milestoneId,
      );
      if (!target) throw notFound();
      if (target.status === "reached")
        return milestoneResponse(run.milestoneResults, target);
      if (
        run.milestoneResults.some(
          (entry) => entry.ordinal < target.ordinal && entry.status !== "reached",
        )
      ) {
        throw new AppError(
          409,
          "MILESTONE_ORDER_INVALID",
          "Milestone harus dicapai berurutan.",
        );
      }
      const config = await gameConfigService.version(run.configVersion);
      const geometry = await findRouteStartAndMilestones(tx, run.routeId);
      const candidate = geometry?.milestones.find(
        (entry) => entry.milestoneId === milestoneId,
      );
      if (!candidate) throw notFound();
      const metadata = readMetadata(run.lockedLoadout);
      const reachedAt = new Date(body.reachedAt);
      const activeSec = activeSecondsAt({
        startedAtMs: run.startedAt.getTime(),
        timestampMs: reachedAt.getTime(),
        pausePeriods: metadata.pausePeriods,
      });
      const earnedExp = Math.round(
        (candidate.exp *
          milestoneMultiplierPermil({
            itemCodes: itemCodes(metadata),
            activeSecAtReach: activeSec,
            rules: config.rules,
          })) /
          1000,
      );
      const updated = await updateMilestoneResult(tx, runId, milestoneId, {
        clientReachedAt: reachedAt,
        clientLocation: body.location as unknown as Prisma.InputJsonValue,
        lastSampleSequence: body.lastSampleSequence,
        status: "reached",
        verification: "provisional",
        earnedExp,
        protected: true,
        updatedAt: now(),
      });
      return milestoneResponse(
        run.milestoneResults.map((entry) =>
          entry.milestoneId === milestoneId ? updated : entry,
        ),
        updated,
      );
    });
  },

  finish(userId: string, runId: string, body: FinishBody) {
    return completeRun(userId, runId, {
      kind: "finish",
      lastSequence: body.lastSampleSequence,
    });
  },

  safeStop(userId: string, runId: string, body: SafeStopBody) {
    return completeRun(userId, runId, {
      kind: "safe_stop",
      lastSequence: body.lastSampleSequence,
      safeStopReason: body.reason,
    });
  },

  async summary(userId: string, runId: string) {
    const run = await findRunOutsideTransaction(userId, runId);
    if (!run) throw notFound();
    const result = readResult(run.result);
    if (
      !result.summary ||
      !["completed", "safe_stopped", "rejected"].includes(run.status)
    )
      throw invalidState();
    const streakAfter = await streakService.get(userId);
    const summary = { ...result.summary, streakAfter };
    delete (summary as Record<string, unknown>).activeDurationSec;
    delete (summary as Record<string, unknown>).coinBasis;
    delete (summary as Record<string, unknown>).expPerCoin;
    delete (summary as Record<string, unknown>).coinCarryAfter;
    return {
      ...summary,
      claim: run.claimId
        ? { claimId: run.claimId, claimed: run.claimedAt !== null }
        : null,
    };
  },

  async guidance(userId: string, runId: string) {
    const run = await findRunOutsideTransaction(userId, runId);
    if (!run) throw notFound();
    if (run.status !== "active" && run.status !== "paused") throw invalidState();
    const rows = await withTransaction((tx) =>
      findRunGuidance(tx, {
        routeId: run.routeId,
        locale: readMetadata(run.lockedLoadout).locale,
      }),
    );
    const geometry = rows[0];
    if (!geometry?.geometryJson) throw notFound();
    const parsed = JSON.parse(geometry.geometryJson) as {
      coordinates?: readonly (readonly [number, number])[];
    };
    const coordinates = (parsed.coordinates ?? []).map(([lng, lat]) => ({ lat, lng }));
    const storedInstructions = parseGuidanceInstructions(geometry.instructions);
    const steps = buildGuidanceSteps(coordinates, storedInstructions);
    return {
      runId,
      preRunTip: geometry.tip ?? "",
      steps,
      dialogues: geometry.dialogues ?? [],
    };
  },

  async claim(userId: string, runId: string, body: ClaimBody) {
    return withTransaction(async (tx) => {
      const run = await lockAndFind(tx, userId, runId);
      const result = readResult(run.result);
      if (run.claimedAt && result.claimResponse && run.claimId === body.claimId)
        return result.claimResponse;
      if (
        !["completed", "safe_stopped"].includes(run.status) ||
        !run.claimId ||
        run.claimId !== body.claimId ||
        !result.summary
      )
        throw notFound();
      const config = await gameConfigService.version(run.configVersion);
      const summary = result.summary;
      const timestamp = now();
      const response = await ledgerService.creditRunRewards(tx, {
        userId,
        runId,
        claimId: run.claimId,
        exp: readNumber(summary.levelExpGained, 0),
        coinsBasis: readNumber(summary.coinBasis, 0),
        rp: run.integrity === "clean" ? readNumber(summary.rpGained, 0) : 0,
        expPerCoin: readNumber(summary.expPerCoin, 1),
        config,
        timestamp,
      });
      await updateRun(tx, runId, {
        claimedAt: timestamp,
        result: {
          ...result,
          claimResponse: response,
        } as unknown as Prisma.InputJsonValue,
        updatedAt: timestamp,
      });
      return response;
    });
  },
};

async function completeRun(
  userId: string,
  runId: string,
  input: {
    readonly kind: "finish" | "safe_stop";
    readonly lastSequence: number;
    readonly safeStopReason?: string;
  },
) {
  return withTransaction(async (tx) => {
    const run = await lockAndFind(tx, userId, runId);
    if (run.result) {
      const previous = readResult(run.result).finishResponse;
      if (previous) return previous;
    }
    if (run.status !== "active" && run.status !== "paused") throw invalidState();
    const timestamp = now();
    const samplesAll = parseSamples(await listRunSamples(tx, runId));
    assertSamples(
      samplesAll,
      input.lastSequence,
      run.lastSequence,
      input.kind === "safe_stop",
    );
    if (input.kind === "finish" && input.lastSequence < run.lastSequence) {
      throw new AppError(
        409,
        "SAMPLES_MISSING",
        "Selesaikan dengan seluruh sampel yang sudah diterima.",
        { missingFromSequence: input.lastSequence + 1 },
      );
    }
    const finalSequence = input.kind === "finish" ? run.lastSequence : input.lastSequence;
    if (input.kind === "finish" && input.lastSequence > run.lastSequence) {
      throw new AppError(409, "SAMPLES_MISSING", "Sampel lokasi belum lengkap.", {
        missingFromSequence: run.lastSequence + 1,
      });
    }
    const samples = samplesAll.filter((sample) => sample.sequence <= finalSequence);
    const geometry = await findRouteStartAndMilestones(tx, run.routeId);
    if (!geometry) throw notFound();
    const metadata = readMetadata(run.lockedLoadout);
    const config = await gameConfigService.version(run.configVersion);
    const safeStop =
      input.kind === "safe_stop"
        ? await safeStopQuota(
            tx,
            userId,
            timestamp,
            metadata.levelCode,
            config,
            input.safeStopReason ?? "other",
          )
        : null;

    let integrity: "clean" | "flagged" | "rejected" = "clean";
    let reasonCodes: readonly string[] = [];
    if (input.kind === "finish") {
      const configured = await antiCheatConfigService.active(tx, timestamp);
      const antiCheat = analyzeAntiCheat(
        toAntiCheatSamples(samples),
        configured.thresholds,
      );
      integrity =
        configured.mode === "enforce"
          ? antiCheat.integrity
          : antiCheat.integrity === "rejected"
            ? "flagged"
            : antiCheat.integrity;
      reasonCodes = antiCheat.reasonCodes;
      const recordedMetrics = {
        ...antiCheat.metrics,
        configVersion: configured.version,
      };
      await writeIntegrityMetrics(tx, {
        runId,
        metrics: recordedMetrics as unknown as Prisma.InputJsonValue,
        reasonCodes: reasonCodes as unknown as Prisma.InputJsonValue,
        mode: configured.mode,
        calculatedAt: timestamp,
      });
    }
    const candidates = geometry.milestones.map((item) => ({
      ...item,
      id: item.milestoneId,
    }));
    const matches = await findMilestoneSampleMatches(tx, runId, finalSequence);
    const verified = verifyPostgisMilestones({
      candidates,
      matches,
      startedAtMs: run.startedAt.getTime(),
      pausePeriods: metadata.pausePeriods,
    });
    for (const milestone of run.milestoneResults) {
      const reached = verified.find(
        (candidate) => candidate.id === milestone.milestoneId,
      );
      await updateMilestoneResult(tx, runId, milestone.milestoneId, {
        status: reached ? "reached" : "missed",
        verification: reached ? "verified" : "unverified",
        verifiedAt: reached ? timestamp : null,
        activeSecAtReach: reached?.activeSecAtReach ?? null,
        earnedExp: reached?.exp ?? 0,
        protected: Boolean(reached),
        updatedAt: timestamp,
      });
    }
    const level = config.levels.find((entry) => entry.code === metadata.levelCode);
    if (!level) throw new Error("Run level is missing from its game config.");
    const exp = calculateRunExp({
      expPerMilestone: geometry.milestones[0]?.exp ?? 1,
      totalMilestones: geometry.milestones.length,
      reachedActiveSeconds: verified.map((milestone) => milestone.activeSecAtReach),
      itemCodes: itemCodes(metadata),
      penaltyFreeRun: metadata.penaltyFreeRun,
      completion: input.kind,
      safeStopWithinQuota: safeStop?.withinQuota ?? false,
      rules: config.rules,
    });
    const summary = buildSummary({
      run,
      samples,
      milestones: candidates,
      verified,
      metadata,
      config,
      exp,
      integrity,
      reasonCodes,
      completedAt: timestamp,
      safeStop,
    });
    const rejected = integrity === "rejected";
    const finalSummary = rejected
      ? {
          ...summary,
          status: "rejected",
          levelExpGained: 0,
          coinsGained: 0,
          rpGained: 0,
          rpStatus: "rejected",
          claim: null,
        }
      : summary;
    const claimId = rejected ? null : createId("claim");
    const response =
      input.kind === "safe_stop"
        ? {
            runId,
            status: "safe_stopped",
            integrity,
            reasonCodes,
            claimId,
            safeStop,
            rewardPreview: {
              coins: finalSummary.coinsGained,
              rp: finalSummary.rpGained,
              exp: finalSummary.levelExpGained,
            },
            claimed: false,
          }
        : {
            runId,
            status: rejected ? "rejected" : "completed",
            integrity,
            reasonCodes,
            claimId,
            rewardPreview: rejected
              ? { coins: 0, rp: 0, exp: 0 }
              : {
                  coins: finalSummary.coinsGained,
                  rp: finalSummary.rpGained,
                  exp: finalSummary.levelExpGained,
                },
            claimed: false,
          };
    await updateRun(tx, runId, {
      status: rejected
        ? "rejected"
        : input.kind === "safe_stop"
          ? "safe_stopped"
          : "completed",
      endedAt: timestamp,
      integrity,
      reasonCodes: reasonCodes as unknown as Prisma.InputJsonValue,
      claimId,
      result: {
        summary: finalSummary,
        finishResponse: response,
      } as unknown as Prisma.InputJsonValue,
      updatedAt: timestamp,
    });
    return response;
  });
}

function parseGuidanceInstructions(value: Prisma.JsonValue): RouteGuidanceInstruction[] {
  if (!Array.isArray(value)) return [];
  return value.flatMap((entry) => {
    if (entry === null || Array.isArray(entry) || typeof entry !== "object") return [];
    const record = entry as Prisma.JsonObject;
    if (typeof record.text !== "string" || typeof record.distanceMeters !== "number")
      return [];
    return [
      {
        text: record.text,
        distanceMeters: record.distanceMeters,
        ...(typeof record.sign === "number" ? { sign: record.sign } : {}),
      },
    ];
  });
}

function verifyPostgisMilestones(input: {
  readonly candidates: readonly RunMilestoneCandidate[];
  readonly matches: readonly {
    readonly milestoneId: string;
    readonly ordinal: number;
    readonly sequence: number;
    readonly timestampMs: number;
  }[];
  readonly startedAtMs: number;
  readonly pausePeriods: readonly RunPausePeriod[];
}): readonly VerifiedRunMilestone[] {
  let previousSequence = 0;
  let previousProgress = -1;
  const verified: VerifiedRunMilestone[] = [];
  for (const candidate of [...input.candidates].sort((a, b) => a.ordinal - b.ordinal)) {
    if (candidate.routeProgress < previousProgress) continue;
    const match = input.matches.find(
      (row) => row.milestoneId === candidate.id && row.sequence > previousSequence,
    );
    if (!match) continue;
    verified.push({
      ...candidate,
      sequence: match.sequence,
      timestampMs: match.timestampMs,
      activeSecAtReach: activeSecondsAt({
        startedAtMs: input.startedAtMs,
        timestampMs: match.timestampMs,
        pausePeriods: input.pausePeriods,
      }),
    });
    previousSequence = match.sequence;
    previousProgress = candidate.routeProgress;
  }
  return verified;
}

function buildSummary(input: {
  readonly run: Awaited<ReturnType<typeof findRun>>;
  readonly samples: readonly RunLocationSample[];
  readonly milestones: readonly RunMilestoneCandidate[];
  readonly verified: readonly VerifiedRunMilestone[];
  readonly metadata: Metadata;
  readonly config: Awaited<ReturnType<typeof gameConfigService.version>>;
  readonly exp: ReturnType<typeof calculateRunExp>;
  readonly integrity: string;
  readonly reasonCodes: readonly string[];
  readonly completedAt: Date;
  readonly safeStop: Record<string, unknown> | null;
}) {
  const run = input.run;
  if (!run) throw notFound();
  const distanceMeters = runDistanceMeters(input.samples);
  const activeDurationSec = activeSecondsAt({
    startedAtMs: run.startedAt.getTime(),
    timestampMs: input.completedAt.getTime(),
    pausePeriods: input.metadata.pausePeriods,
  });
  const level = input.config.levels.find(
    (entry) => entry.code === input.metadata.levelCode,
  );
  const expPerCoin = level?.expPerCoin ?? 1;
  const coin = convertExpToCoins({ basis: input.exp.basis, carryMilli: 0, expPerCoin });
  const base = input.exp.failedMilestoneCount * (input.milestones[0]?.exp ?? 0);
  const rpGained = calculateRunRp(input.exp.basis);
  return {
    runId: run.id,
    status: input.safeStop ? "safe_stopped" : "completed",
    integrity: input.integrity,
    reasonCodes: input.reasonCodes,
    startedAt: run.startedAt.toISOString(),
    endedAt: input.completedAt.toISOString(),
    distanceMeters,
    durationSec: Math.max(
      0,
      Math.floor((input.completedAt.getTime() - run.startedAt.getTime()) / 1000),
    ),
    movingTimeSec: activeDurationSec,
    avgPaceSecPerKm: distanceMeters
      ? Math.round((activeDurationSec * 1000) / distanceMeters)
      : null,
    estimatedCalories: Math.round((distanceMeters * input.config.rules.kcalPerKm) / 1000),
    milestones: {
      reached: input.verified.length,
      total: input.milestones.length,
      items: input.milestones.map((milestone) => ({
        id: milestone.id,
        ordinal: milestone.ordinal,
        status: input.verified.some((entry) => entry.id === milestone.id)
          ? "reached"
          : "missed",
        exp: input.verified.some((entry) => entry.id === milestone.id)
          ? milestone.exp
          : 0,
      })),
    },
    expEarnedBase: input.exp.earnedBase,
    expMultiplier: input.exp.earnedBase ? input.exp.earned / input.exp.earnedBase : 1,
    expPenalty: input.exp.penalty,
    penaltyFactor: base ? input.exp.penalty / base : 0,
    runResult: input.exp.runResult,
    levelExpGained: input.exp.levelExpGained,
    coinsGained: coin.coinsGained,
    rpGained,
    rpStatus: input.integrity === "flagged" ? "held" : "counted",
    streakAfter: null,
    capsRemaining: null,
    itemsUsed: itemCodes(input.metadata),
    penaltyFreeRun: input.metadata.penaltyFreeRun,
    safeStop: input.safeStop,
    claim: null,
    activeDurationSec,
    coinBasis: input.exp.basis,
    expPerCoin,
  };
}

function milestoneResponse(
  milestones: readonly { milestoneId: string; status: string }[],
  target: {
    milestoneId: string;
    clientReachedAt: Date | null;
    earnedExp: number;
    protected: boolean;
  },
) {
  const next = milestones.find((entry) => entry.status === "pending");
  return {
    milestoneId: target.milestoneId,
    status: "reached",
    verification: "provisional",
    reachedAt: target.clientReachedAt?.toISOString() ?? null,
    earnedExp: target.earnedExp,
    protected: target.protected,
    progress: {
      reached: milestones.filter((entry) => entry.status === "reached").length,
      total: milestones.length,
      nextMilestoneId: next?.milestoneId ?? null,
    },
    expRemaining: null,
  };
}

function itemCodes(metadata: GameLoadout): ItemCode[] {
  return [metadata.boostItemCode, metadata.modifierItemCode].filter(
    (code): code is ItemCode => code !== null,
  );
}

function readMetadata(value: Prisma.JsonValue): Metadata {
  if (value === null || Array.isArray(value) || typeof value !== "object")
    throw new Error("Run metadata is invalid.");
  const record = value as Record<string, unknown>;
  const pausePeriods = Array.isArray(record.pausePeriods)
    ? record.pausePeriods.map((period) => {
        const item = period as Record<string, unknown>;
        return {
          pausedAt: readNumber(item.pausedAt, 0),
          resumedAt: item.resumedAt === null ? null : readNumber(item.resumedAt, 0),
        };
      })
    : [];
  return {
    boostItemCode: isItem(record.boostItemCode) ? record.boostItemCode : null,
    modifierItemCode: isItem(record.modifierItemCode) ? record.modifierItemCode : null,
    units: record.units === "imperial" ? "imperial" : "metric",
    clientCapabilities: record.clientCapabilities as StartBody["clientCapabilities"],
    startLocation: record.startLocation as StartBody["startLocation"],
    locale: record.locale === "en" ? "en" : "id",
    penaltyFreeRun: record.penaltyFreeRun === true,
    levelCode: typeof record.levelCode === "string" ? record.levelCode : "beginner",
    pausePeriods,
  };
}

function readResult(value: Prisma.JsonValue | null): StoredResult {
  return value !== null && typeof value === "object" && !Array.isArray(value)
    ? (value as StoredResult)
    : {};
}

function parseSamples(values: readonly unknown[]): RunLocationSample[] {
  return values.map((value) => {
    const sample = value as Record<string, unknown>;
    return {
      sequence: readNumber(sample.sequence, 0),
      t: readNumber(sample.t, 0),
      lat: readNumber(sample.lat, 0),
      lng: readNumber(sample.lng, 0),
      accuracyMeters: readNumber(sample.accuracyMeters, 100),
      ...(typeof sample.speedMps === "number" ? { speedMps: sample.speedMps } : {}),
      ...(typeof sample.mocked === "boolean" ? { mocked: sample.mocked } : {}),
    };
  });
}

function toAntiCheatSamples(samples: readonly RunLocationSample[]) {
  return samples.map((sample, index) => {
    const previous = samples[index - 1];
    return {
      sequence: sample.sequence,
      timestampMs: sample.t,
      latitudeE7: Math.round(sample.lat * 10_000_000),
      longitudeE7: Math.round(sample.lng * 10_000_000),
      distanceFromPreviousMm: previous
        ? Math.round(distanceBetweenMeters(previous, sample) * 1000)
        : 0,
      mocked: sample.mocked === true,
    };
  });
}

function assertSamples(
  samples: readonly RunLocationSample[],
  requested: number,
  latest: number,
  allowEmpty: boolean,
) {
  if (requested > latest)
    throw new AppError(409, "SAMPLES_MISSING", "Sampel lokasi belum lengkap.", {
      missingFromSequence: latest + 1,
    });
  if (!allowEmpty && requested === 0)
    throw new AppError(409, "SAMPLES_MISSING", "Sampel lokasi belum lengkap.", {
      missingFromSequence: 1,
    });
  const sequences = new Set(samples.map((sample) => sample.sequence));
  for (let sequence = 1; sequence <= requested; sequence += 1) {
    if (!sequences.has(sequence))
      throw new AppError(409, "SAMPLES_MISSING", "Sampel lokasi belum lengkap.", {
        missingFromSequence: sequence,
      });
  }
}

async function lockAndFind(tx: Tx, userId: string, runId: string) {
  if (!(await lockRun(tx, userId, runId))) throw notFound();
  const run = await findRun(tx, userId, runId);
  if (!run) throw notFound();
  return run;
}

async function countSafeStops(tx: Tx, userId: string, timestamp: Date) {
  const week = utcWeekWindow(timestamp.getTime());
  return countSafeStopsInWindow(tx, {
    userId,
    startsAt: new Date(week.startEpochMs),
    endsAt: new Date(week.endEpochMs),
  });
}

async function safeStopQuota(
  tx: Tx,
  userId: string,
  timestamp: Date,
  levelCode: string,
  config: Awaited<ReturnType<typeof gameConfigService.version>>,
  reason: string,
) {
  const level = config.levels.find((entry) => entry.code === levelCode);
  if (!level) throw new Error("Run level is missing from its game config.");
  const usedThisWeek = await countSafeStops(tx, userId, timestamp);
  return {
    reason,
    usedThisWeek: usedThisWeek + 1,
    quota: level.safeStopPerWeek,
    withinQuota: usedThisWeek < level.safeStopPerWeek,
  };
}

function readNumber(value: unknown, fallback: number) {
  return typeof value === "number" && Number.isFinite(value) ? value : fallback;
}

function isItem(value: unknown): value is ItemCode {
  return value === "exp_boost" || value === "less_compensation" || value === "gain_more";
}

function invalidState() {
  return new AppError(
    409,
    "RUN_INVALID_STATE",
    "Status lari tidak mengizinkan tindakan ini.",
  );
}

function notFound() {
  return new AppError(404, "NOT_FOUND", "Data tidak ditemukan.");
}

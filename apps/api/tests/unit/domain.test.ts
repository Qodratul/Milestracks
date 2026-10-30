import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import { describe, expect, it } from "vitest";
import { GameConfigSchema } from "../../src/config/game-config.schema";
import {
  analyzeAntiCheat,
  calculateRunExp,
  calculateRunRp,
  clampInteger,
  convertExpToCoins,
  evaluateRouteSafety,
  floorDiv,
  levelForExp,
  levelProgress,
  levelsCrossed,
  mergeLoadout,
  penaltyMultiplierPermil,
  planMilestones,
  resolveSafeStopQuota,
  roundDiv,
  scoreRouteCandidate,
  stackMultipliersPermil,
  transitionRunState,
  validateLoadout,
} from "../../src/domain";
import type {
  AntiCheatPolicy,
  AntiCheatSample,
  LevelProgress,
  RouteSafetyPolicy,
  RunExpInput,
} from "../../src/domain";
import { utcWeekWindow } from "../../src/utils/time";
import type { GameConfig } from "../../src/config/game-config.schema";
import type {
  GameItemRule,
  GameLoadout,
  GameRules,
  ItemCode,
  LevelCode,
} from "../../src/types/game";

const gameConfig = GameConfigSchema.parse(
  JSON.parse(
    readFileSync(resolve(__dirname, "../../prisma/game-config.v1.json"), "utf8"),
  ) as unknown,
);

interface NamedVector<T> {
  readonly name: string;
  readonly input: T;
  readonly expected: Readonly<Record<string, unknown>>;
}

interface AntiCheatVector {
  readonly name: string;
  readonly policy: AntiCheatPolicy;
  readonly samples: readonly AntiCheatSample[];
  readonly expected: Readonly<Record<string, unknown>>;
}

function vectors<T>(fileName: string): readonly NamedVector<T>[] {
  const parsed: unknown = JSON.parse(
    readFileSync(resolve(__dirname, "../vectors", fileName), "utf8"),
  );
  if (!Array.isArray(parsed)) {
    throw new TypeError("Vector file must contain an array.");
  }
  return parsed as NamedVector<T>[];
}

function rawVectors<T>(fileName: string): readonly T[] {
  const parsed: unknown = JSON.parse(
    readFileSync(resolve(__dirname, "../vectors", fileName), "utf8"),
  );
  if (!Array.isArray(parsed)) {
    throw new TypeError("Vector file must contain an array.");
  }
  return parsed as T[];
}

describe("integer helpers", () => {
  it("rounds non-negative integer division half up", () => {
    expect(roundDiv(5, 2)).toBe(3);
    expect(roundDiv(4, 2)).toBe(2);
    expect(roundDiv(1, 3)).toBe(0);
  });

  it("floors division and clamps integer ranges", () => {
    expect(floorDiv(5, 2)).toBe(2);
    expect(clampInteger(-2, 0, 4)).toBe(0);
    expect(clampInteger(7, 0, 4)).toBe(4);
    expect(clampInteger(2, 0, 4)).toBe(2);
  });

  it("rejects unsafe, negative, zero-divisor and invalid clamp inputs", () => {
    expect(() => roundDiv(-1, 2)).toThrow(RangeError);
    expect(() => roundDiv(1, 0)).toThrow(RangeError);
    expect(() => floorDiv(Number.MAX_SAFE_INTEGER + 1, 2)).toThrow(RangeError);
    expect(() => clampInteger(1, 3, 2)).toThrow(RangeError);
  });

  it("stacks additive integer multipliers and applies their cap", () => {
    expect(stackMultipliersPermil([], 3000)).toBe(1000);
    expect(stackMultipliersPermil([1500, 2000], 3000)).toBe(2500);
    expect(stackMultipliersPermil([2000, 2000], 2500)).toBe(2500);
    expect(() => stackMultipliersPermil([999], 3000)).toThrow(RangeError);
  });
});

describe("level vectors", () => {
  it.each(vectors<{ totalExp: number }>("level.json"))("$name", ({ input, expected }) => {
    const progress = levelProgress(input.totalExp, gameConfig.levels);
    expect({
      levelCode: progress.level.code,
      nextLevelCode: progress.nextLevel?.code ?? null,
      expIntoLevel: progress.expIntoLevel,
      expToNextLevel: progress.expToNextLevel,
      progressPermil: progress.progressPermil,
    }).toEqual(expected);
    expect(levelForExp(input.totalExp, gameConfig.levels)).toEqual(progress.level);
  });

  it("reports every level crossed when EXP jumps over multiple thresholds", () => {
    expect(
      levelsCrossed(0, 150000, gameConfig.levels).map((level) => level.code),
    ).toEqual(["intermediate", "advanced", "professional"]);
    expect(levelsCrossed(10000, 10000, gameConfig.levels)).toEqual([]);
    expect(() => levelsCrossed(10, 9, gameConfig.levels)).toThrow(RangeError);
  });

  it("rejects a broken level threshold table", () => {
    expect(() => levelForExp(0, [])).toThrow(RangeError);
    expect(() =>
      levelForExp(0, [{ ...gameConfig.levels[0]!, nextLevelAtExp: 9999 }]),
    ).toThrow(RangeError);
  });
});

describe("milestone vectors", () => {
  it.each(
    vectors<{ levelCode: LevelCode; distanceMeters: number }>("milestone-plan.json"),
  )("$name", ({ input, expected }) => {
    const level = gameConfig.levels.find((entry) => entry.code === input.levelCode);
    if (!level) throw new Error("Unknown vector level.");
    expect(planMilestones(input.distanceMeters, level)).toEqual(expected);
  });
});

describe("EXP vectors", () => {
  it.each(vectors<Omit<RunExpInput, "rules">>("exp.json"))(
    "$name",
    ({ input, expected }) => {
      expect(calculateRunExp({ ...input, rules: gameConfig.rules })).toEqual(expected);
    },
  );

  it("uses the configured penalty rate for each modifier", () => {
    expect(penaltyMultiplierPermil(null, gameConfig.rules)).toBe(1000);
    expect(penaltyMultiplierPermil("less_compensation", gameConfig.rules)).toBe(650);
    expect(penaltyMultiplierPermil("gain_more", gameConfig.rules)).toBe(1750);
  });

  it("does not apply Boost after its active-time window", () => {
    const result = calculateRunExp({
      expPerMilestone: 500,
      totalMilestones: 1,
      reachedActiveSeconds: [1441],
      itemCodes: ["exp_boost"],
      penaltyFreeRun: false,
      completion: "finish",
      safeStopWithinQuota: false,
      rules: gameConfig.rules,
    });
    expect(result.earned).toBe(500);
  });

  it("rejects impossible completion inputs and duplicate items", () => {
    expect(() =>
      calculateRunExp({
        expPerMilestone: 500,
        totalMilestones: 1,
        reachedActiveSeconds: [100, 200],
        itemCodes: [],
        penaltyFreeRun: false,
        completion: "finish",
        safeStopWithinQuota: false,
        rules: gameConfig.rules,
      }),
    ).toThrow(RangeError);
    expect(() =>
      calculateRunExp({
        expPerMilestone: 500,
        totalMilestones: 1,
        reachedActiveSeconds: [],
        itemCodes: [],
        penaltyFreeRun: false,
        completion: "finish",
        safeStopWithinQuota: true,
        rules: gameConfig.rules,
      }),
    ).toThrow(RangeError);
    expect(() =>
      calculateRunExp({
        expPerMilestone: 500,
        totalMilestones: 1,
        reachedActiveSeconds: [10],
        itemCodes: ["exp_boost", "exp_boost"],
        penaltyFreeRun: false,
        completion: "finish",
        safeStopWithinQuota: false,
        rules: gameConfig.rules,
      }),
    ).toThrow(RangeError);
  });
});

describe("coin vectors", () => {
  it.each(
    vectors<{ basis: number; carryMilli: number; expPerCoin: number }>("coin.json"),
  )("$name", ({ input, expected }) => {
    expect(convertExpToCoins(input)).toEqual(expected);
  });
});

describe("RP vectors", () => {
  it.each(vectors<{ basis: number }>("rp.json"))("$name", ({ input, expected }) => {
    expect({ rpGained: calculateRunRp(input.basis) }).toEqual(expected);
  });
});

describe("Safe Stop and UTC week vectors", () => {
  it.each(vectors<{ usedThisWeek: number; quota: number }>("safe-stop.json"))(
    "$name",
    ({ input, expected }) => {
      expect(resolveSafeStopQuota(input)).toMatchObject(expected);
    },
  );

  it("uses Monday 00:00 UTC as the global week boundary", () => {
    const beforeBoundary = utcWeekWindow(Date.parse("2026-11-01T23:59:59.999Z"));
    const atBoundary = utcWeekWindow(Date.parse("2026-11-02T00:00:00.000Z"));
    expect(new Date(beforeBoundary.startEpochMs).toISOString()).toBe(
      "2026-10-26T00:00:00.000Z",
    );
    expect(new Date(atBoundary.startEpochMs).toISOString()).toBe(
      "2026-11-02T00:00:00.000Z",
    );
    expect(atBoundary.endEpochMs - atBoundary.startEpochMs).toBe(604800000);
  });
});

describe("item vectors", () => {
  it.each(
    vectors<{
      loadout: {
        boostItemCode: ItemCode | null;
        modifierItemCode: ItemCode | null;
      };
    }>("items.json"),
  )("$name", ({ input, expected }) => {
    expect(validateLoadout(input.loadout, gameConfig.items)).toMatchObject(expected);
  });

  it("merges partial loadout updates and treats null as unequip", () => {
    const current: GameLoadout = {
      boostItemCode: "exp_boost",
      modifierItemCode: "gain_more",
    };
    expect(mergeLoadout(current, { modifierItemCode: null })).toEqual({
      boostItemCode: "exp_boost",
      modifierItemCode: null,
    });
    expect(mergeLoadout(current, {})).toEqual(current);
  });

  it("rejects exclusivity rules supplied by the active item catalog", () => {
    const items: readonly GameItemRule[] = [
      { code: "exp_boost", slot: "boost", exclusiveCodes: ["gain_more"] },
      { code: "gain_more", slot: "modifier", exclusiveCodes: [] },
    ];
    expect(
      validateLoadout(
        { boostItemCode: "exp_boost", modifierItemCode: "gain_more" },
        items,
      ),
    ).toMatchObject({ valid: false, reason: "exclusive_items" });
  });

  it("handles a catalog missing a selected item", () => {
    expect(
      validateLoadout({ boostItemCode: "exp_boost", modifierItemCode: null }, []),
    ).toMatchObject({ valid: false, reason: "unknown_item" });
  });
});

describe("anti-cheat vectors", () => {
  const antiCheatVectors = rawVectors<AntiCheatVector>("anti-cheat.json");

  it.each(antiCheatVectors)("$name", ({ policy, samples, expected }) => {
    expect(analyzeAntiCheat(samples, policy)).toEqual(expected);
  });

  it("compares speed thresholds using exact integer ratios", () => {
    const policy = antiCheatVectors[0]?.policy;
    if (!policy) throw new Error("Missing anti-cheat vector policy.");
    const justBelowReject: readonly AntiCheatSample[] = [
      {
        sequence: 1,
        timestampMs: 0,
        latitudeE7: 0,
        longitudeE7: 0,
        distanceFromPreviousMm: 0,
        mocked: false,
      },
      {
        sequence: 2,
        timestampMs: 5000,
        latitudeE7: 1,
        longitudeE7: 0,
        distanceFromPreviousMm: 59998,
        mocked: false,
      },
      {
        sequence: 3,
        timestampMs: 10000,
        latitudeE7: 2,
        longitudeE7: 0,
        distanceFromPreviousMm: 59998,
        mocked: false,
      },
    ];
    expect(analyzeAntiCheat(justBelowReject, policy)).toMatchObject({
      integrity: "clean",
      metrics: { maxContinuousSpeedDurationMs: 0 },
    });
    const justAboveRolling = [
      {
        sequence: 1,
        timestampMs: 0,
        latitudeE7: 0,
        longitudeE7: 0,
        distanceFromPreviousMm: 0,
        mocked: false,
      },
      {
        sequence: 2,
        timestampMs: 60000,
        latitudeE7: 1,
        longitudeE7: 0,
        distanceFromPreviousMm: 450001,
        mocked: false,
      },
    ];
    expect(
      analyzeAntiCheat(justAboveRolling, {
        ...policy,
        maxSampleGapMs: 60000,
      }),
    ).toMatchObject({
      integrity: "flagged",
      reasonCodes: ["rolling_speed"],
      metrics: { maxRollingSpeedMmPerSec: 7500 },
    });
  });

  it("counts out-of-order samples and mocked locations", () => {
    const policy = antiCheatVectors[0]?.policy;
    if (!policy) throw new Error("Missing anti-cheat vector policy.");
    const samples: readonly AntiCheatSample[] = [
      {
        sequence: 1,
        timestampMs: 2000,
        latitudeE7: 0,
        longitudeE7: 0,
        distanceFromPreviousMm: 0,
        mocked: true,
      },
      {
        sequence: 2,
        timestampMs: 1000,
        latitudeE7: 1,
        longitudeE7: 0,
        distanceFromPreviousMm: 0,
        mocked: false,
      },
      {
        sequence: 3,
        timestampMs: 1000,
        latitudeE7: 2,
        longitudeE7: 0,
        distanceFromPreviousMm: 0,
        mocked: false,
      },
    ];
    expect(analyzeAntiCheat(samples, policy)).toMatchObject({
      integrity: "flagged",
      reasonCodes: ["mocked_location", "out_of_order_samples"],
      metrics: { mockedCount: 1, outOfOrderCount: 2 },
    });
  });
});

describe("run states", () => {
  it("follows the documented active, pause, finish and Safe Stop transitions", () => {
    expect(transitionRunState("active", "pause")).toEqual({
      allowed: true,
      status: "paused",
    });
    expect(transitionRunState("paused", "resume")).toEqual({
      allowed: true,
      status: "active",
    });
    expect(transitionRunState("paused", "finish")).toEqual({
      allowed: true,
      status: "completed",
    });
    expect(transitionRunState("paused", "safe_stop")).toEqual({
      allowed: true,
      status: "safe_stopped",
    });
    expect(transitionRunState("active", "reject")).toEqual({
      allowed: true,
      status: "rejected",
    });
    expect(transitionRunState("completed", "resume")).toEqual({
      allowed: false,
      status: "completed",
      reason: "invalid_transition",
    });
  });
});

describe("route safety and candidate score", () => {
  const policy: RouteSafetyPolicy = {
    maxPrimaryRoadSharePermil: 100,
    maxUnpavedSharePermilByLevel: {
      beginner: 200,
      intermediate: 300,
      advanced: 400,
      professional: 500,
      master: 600,
    },
    maxSlopePermilByLevel: {
      beginner: 100,
      intermediate: 200,
      advanced: 300,
      professional: 400,
      master: 500,
    },
  };

  it("evaluates configured route safety attributes without embedding level thresholds", () => {
    expect(
      evaluateRouteSafety({
        levelCode: "beginner",
        policy,
        attributes: {
          routeLengthMeters: 10000,
          primaryRoadLengthMeters: 500,
          unpavedLengthMeters: 1000,
          maxSlopePermil: 100,
          hasConstruction: false,
          hasSteps: false,
          hasFerry: false,
          hasFord: false,
        },
      }),
    ).toMatchObject({ safe: true, reasons: [] });
  });

  it("returns every hard safety violation", () => {
    expect(
      evaluateRouteSafety({
        levelCode: "beginner",
        policy,
        attributes: {
          routeLengthMeters: 10000,
          primaryRoadLengthMeters: 2000,
          unpavedLengthMeters: 3000,
          maxSlopePermil: 101,
          hasConstruction: true,
          hasSteps: true,
          hasFerry: true,
          hasFord: true,
        },
      }),
    ).toMatchObject({
      safe: false,
      reasons: [
        "construction",
        "steps",
        "ferry",
        "ford",
        "primary_road_share",
        "unpaved_share",
        "slope",
      ],
    });
  });

  it("scores weighted integer components with half-up rounding", () => {
    expect(
      scoreRouteCandidate([
        { scorePermil: 800, weight: 2 },
        { scorePermil: 1000, weight: 1 },
      ]),
    ).toBe(867);
    expect(() => scoreRouteCandidate([{ scorePermil: 1001, weight: 1 }])).toThrow(
      RangeError,
    );
  });
});

describe("domain type fixtures", () => {
  it("keeps game configuration and vector contracts parseable", () => {
    const parsed: GameConfig = gameConfig;
    const rules: GameRules = parsed.rules;
    const progress: LevelProgress = levelProgress(0, parsed.levels);
    expect(rules.penaltyFreeRuns).toBe(5);
    expect(progress.level.code).toBe("beginner");
  });
});

import {
  assertNonNegativeInteger,
  assertPositiveInteger,
  multiplySafeIntegers,
  sumSafeIntegers,
  roundDiv,
} from "./math";
import { milestoneMultiplierPermil, penaltyMultiplierPermil } from "./multiplier";
import type { GameRules, ItemCode } from "../types/game";

export interface RunExpInput {
  readonly expPerMilestone: number;
  readonly totalMilestones: number;
  readonly reachedActiveSeconds: readonly number[];
  readonly itemCodes: readonly ItemCode[];
  readonly penaltyFreeRun: boolean;
  readonly completion: "finish" | "safe_stop";
  readonly safeStopWithinQuota: boolean;
  readonly rules: GameRules;
}

export interface RunExpResult {
  readonly earnedBase: number;
  readonly earned: number;
  readonly penalty: number;
  readonly runResult: number;
  readonly levelExpGained: number;
  readonly basis: number;
  readonly failedMilestoneCount: number;
}

export function calculateRunExp(input: RunExpInput): RunExpResult {
  assertPositiveInteger(input.expPerMilestone, "expPerMilestone");
  assertPositiveInteger(input.totalMilestones, "totalMilestones");
  if (input.reachedActiveSeconds.length > input.totalMilestones) {
    throw new RangeError("Reached milestones cannot exceed total milestones.");
  }
  if (input.completion === "finish" && input.safeStopWithinQuota) {
    throw new RangeError("Only a safe stop can use the weekly quota.");
  }
  input.reachedActiveSeconds.forEach((seconds) =>
    assertNonNegativeInteger(seconds, "reachedActiveSeconds"),
  );

  const reachedCount = input.reachedActiveSeconds.length;
  const safeStopProtected = input.completion === "safe_stop" && input.safeStopWithinQuota;
  const failedMilestoneCount = safeStopProtected
    ? 0
    : input.totalMilestones - reachedCount;
  const earnedBase = multiplySafeIntegers(
    reachedCount,
    input.expPerMilestone,
    "earnedBase",
  );
  const earnedByMilestone = input.reachedActiveSeconds.map((activeSecAtReach) => {
    const multiplierPermil = milestoneMultiplierPermil({
      itemCodes: input.itemCodes,
      activeSecAtReach,
      rules: input.rules,
    });
    return roundDiv(
      multiplySafeIntegers(input.expPerMilestone, multiplierPermil, "milestone EXP"),
      1000,
    );
  });
  const earned = sumSafeIntegers(earnedByMilestone, "earned");
  const modifier =
    input.itemCodes.find(
      (code): code is "less_compensation" | "gain_more" => code !== "exp_boost",
    ) ?? null;
  const shouldApplyPenalty = !input.penaltyFreeRun && !safeStopProtected;
  const penalty = shouldApplyPenalty
    ? roundDiv(
        multiplySafeIntegers(
          multiplySafeIntegers(
            failedMilestoneCount,
            input.expPerMilestone,
            "failed milestone EXP",
          ),
          penaltyMultiplierPermil(modifier, input.rules),
          "penalty EXP",
        ),
        1000,
      )
    : 0;
  const runResult = earned - penalty;
  const basisIsProtected = input.penaltyFreeRun || safeStopProtected;
  const basis = basisIsProtected
    ? earnedBase
    : Math.max(
        0,
        earnedBase -
          multiplySafeIntegers(
            failedMilestoneCount,
            input.expPerMilestone,
            "basis deduction",
          ),
      );
  return {
    earnedBase,
    earned,
    penalty,
    runResult,
    levelExpGained: Math.max(0, runResult),
    basis,
    failedMilestoneCount,
  };
}

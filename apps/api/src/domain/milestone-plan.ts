import {
  assertPositiveInteger,
  clampInteger,
  multiplySafeIntegers,
  roundDiv,
} from "./math";
import type { GameLevelRule } from "../types/game";

export interface MilestonePlan {
  readonly milestoneCount: number;
  readonly trackExp: number;
  readonly expPerMilestone: number;
}

export function planMilestones(
  distanceMeters: number,
  level: Pick<
    GameLevelRule,
    "targetSpacingMeters" | "milestoneMin" | "milestoneMax" | "expPerKm"
  >,
): MilestonePlan {
  assertPositiveInteger(distanceMeters, "distanceMeters");
  assertPositiveInteger(level.targetSpacingMeters, "targetSpacingMeters");
  assertPositiveInteger(level.milestoneMin, "milestoneMin");
  assertPositiveInteger(level.milestoneMax, "milestoneMax");
  assertPositiveInteger(level.expPerKm, "expPerKm");
  const estimatedCount = roundDiv(distanceMeters, level.targetSpacingMeters);
  const milestoneCount = clampInteger(
    estimatedCount,
    level.milestoneMin,
    level.milestoneMax,
  );
  const trackExp = roundDiv(
    multiplySafeIntegers(level.expPerKm, distanceMeters, "track EXP"),
    1000,
  );
  const expPerMilestone = roundDiv(trackExp, milestoneCount);
  return { milestoneCount, trackExp, expPerMilestone };
}

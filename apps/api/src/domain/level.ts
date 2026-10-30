import {
  assertNonNegativeInteger,
  assertPositiveInteger,
  multiplySafeIntegers,
  roundDiv,
} from "./math";
import type { GameLevelRule } from "../types/game";

export interface LevelProgress {
  readonly level: GameLevelRule;
  readonly nextLevel: GameLevelRule | null;
  readonly expIntoLevel: number;
  readonly expToNextLevel: number | null;
  readonly progressPermil: number;
}

function orderedLevels(levels: readonly GameLevelRule[]): readonly GameLevelRule[] {
  if (levels.length === 0) throw new RangeError("At least one level is required.");
  const ordered = [...levels].sort((left, right) => left.startExp - right.startExp);
  ordered.forEach((level, index) => {
    assertNonNegativeInteger(level.startExp, "level.startExp");
    if (index > 0 && ordered[index - 1]?.startExp === level.startExp) {
      throw new RangeError("Level start EXP values must be unique.");
    }
    const expectedNext = ordered[index + 1]?.startExp ?? null;
    if (level.nextLevelAtExp !== expectedNext) {
      throw new RangeError("Level thresholds must match the ordered level table.");
    }
  });
  return ordered;
}

export function levelForExp(
  totalExp: number,
  levels: readonly GameLevelRule[],
): GameLevelRule {
  assertNonNegativeInteger(totalExp, "totalExp");
  const ordered = orderedLevels(levels);
  let current = ordered[0];
  if (!current) throw new RangeError("At least one level is required.");
  for (const level of ordered) {
    if (totalExp < level.startExp) break;
    current = level;
  }
  return current;
}

export function levelProgress(
  totalExp: number,
  levels: readonly GameLevelRule[],
): LevelProgress {
  assertNonNegativeInteger(totalExp, "totalExp");
  const ordered = orderedLevels(levels);
  let currentIndex = 0;
  for (let index = 0; index < ordered.length; index += 1) {
    const level = ordered[index];
    if (level && totalExp >= level.startExp) currentIndex = index;
  }
  const level = ordered[currentIndex];
  if (!level) throw new RangeError("At least one level is required.");
  const nextLevel = ordered[currentIndex + 1] ?? null;
  if (!nextLevel) {
    return {
      level,
      nextLevel: null,
      expIntoLevel: totalExp - level.startExp,
      expToNextLevel: null,
      progressPermil: 1000,
    };
  }
  const levelSpan = nextLevel.startExp - level.startExp;
  assertPositiveInteger(levelSpan, "levelSpan");
  const expIntoLevel = Math.min(totalExp - level.startExp, levelSpan);
  const progress = roundDiv(
    multiplySafeIntegers(expIntoLevel, 1000, "level progress"),
    levelSpan,
  );
  return {
    level,
    nextLevel,
    expIntoLevel,
    expToNextLevel: nextLevel.startExp - totalExp,
    progressPermil: Math.min(999, progress),
  };
}

export function levelsCrossed(
  previousTotalExp: number,
  nextTotalExp: number,
  levels: readonly GameLevelRule[],
): readonly GameLevelRule[] {
  assertNonNegativeInteger(previousTotalExp, "previousTotalExp");
  assertNonNegativeInteger(nextTotalExp, "nextTotalExp");
  if (nextTotalExp < previousTotalExp) {
    throw new RangeError("nextTotalExp must not be less than previousTotalExp.");
  }
  return orderedLevels(levels).filter(
    (level) => level.startExp > previousTotalExp && level.startExp <= nextTotalExp,
  );
}

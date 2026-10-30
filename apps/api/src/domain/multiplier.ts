import { assertNonNegativeInteger, assertPositiveInteger, sumSafeIntegers } from "./math";
import type { GameRules, ItemCode } from "../types/game";

export function stackMultipliersPermil(
  multipliersPermil: readonly number[],
  capPermil: number,
): number {
  assertPositiveInteger(capPermil, "capPermil");
  if (capPermil < 1000) {
    throw new RangeError("capPermil must be at least 1000.");
  }
  const bonusPermil = multipliersPermil.map((multiplier) => {
    assertPositiveInteger(multiplier, "multiplierPermil");
    if (multiplier < 1000) {
      throw new RangeError("Item multipliers must be at least 1000 permil.");
    }
    return multiplier - 1000;
  });
  return Math.min(capPermil, 1000 + sumSafeIntegers(bonusPermil, "multiplier bonus"));
}

export function milestoneMultiplierPermil(input: {
  readonly itemCodes: readonly ItemCode[];
  readonly activeSecAtReach: number;
  readonly rules: GameRules;
}): number {
  assertNonNegativeInteger(input.activeSecAtReach, "activeSecAtReach");
  if (new Set(input.itemCodes).size !== input.itemCodes.length) {
    throw new RangeError("A loadout cannot contain duplicate item codes.");
  }
  const multipliers: number[] = [];
  for (const itemCode of input.itemCodes) {
    if (
      itemCode === "exp_boost" &&
      input.activeSecAtReach <= input.rules.boostWindowActiveSec
    ) {
      multipliers.push(input.rules.boostMultiplierPermil);
    }
    if (itemCode === "gain_more") {
      multipliers.push(input.rules.gainMoreMultiplierPermil);
    }
  }
  return stackMultipliersPermil(multipliers, input.rules.multiplierCapPermil);
}

export function penaltyMultiplierPermil(
  modifierItemCode: Exclude<ItemCode, "exp_boost"> | null,
  rules: GameRules,
): number {
  if (modifierItemCode === null) return rules.penaltyPermil.default;
  return rules.penaltyPermil[modifierItemCode];
}

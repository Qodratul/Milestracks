import {
  assertNonNegativeInteger,
  assertPositiveInteger,
  addSafeIntegers,
  floorDiv,
  multiplySafeIntegers,
} from "./math";

export interface CoinConversion {
  readonly coinsGained: number;
  readonly carryMilli: number;
}

export function convertExpToCoins(input: {
  readonly basis: number;
  readonly carryMilli: number;
  readonly expPerCoin: number;
}): CoinConversion {
  assertNonNegativeInteger(input.basis, "basis");
  assertNonNegativeInteger(input.carryMilli, "carryMilli");
  assertPositiveInteger(input.expPerCoin, "expPerCoin");
  if (input.carryMilli >= 1000) {
    throw new RangeError("carryMilli must be less than 1000.");
  }
  const earnedCoinMilli = floorDiv(
    multiplySafeIntegers(input.basis, 1000, "coin conversion"),
    input.expPerCoin,
  );
  const totalCoinMilli = addSafeIntegers(input.carryMilli, earnedCoinMilli, "coin carry");
  return {
    coinsGained: floorDiv(totalCoinMilli, 1000),
    carryMilli: totalCoinMilli % 1000,
  };
}

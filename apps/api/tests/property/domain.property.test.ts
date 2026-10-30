import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import fc from "fast-check";
import { describe, expect, it } from "vitest";
import {
  convertExpToCoins,
  levelForExp,
  levelProgress,
  stackMultipliersPermil,
} from "../../src/domain";
import { GameConfigSchema } from "../../src/config/game-config.schema";

const gameConfig = GameConfigSchema.parse(
  JSON.parse(
    readFileSync(resolve(__dirname, "../../prisma/game-config.v1.json"), "utf8"),
  ) as unknown,
);

describe("domain properties", () => {
  it("item multiplier stacking is order independent and capped", () => {
    fc.assert(
      fc.property(
        fc.array(fc.integer({ min: 1000, max: 3000 }), { maxLength: 12 }),
        fc.integer({ min: 1000, max: 3000 }),
        (multipliers, cap) => {
          const forward = stackMultipliersPermil(multipliers, cap);
          const reversed = stackMultipliersPermil([...multipliers].reverse(), cap);
          expect(forward).toBe(reversed);
          expect(forward).toBeLessThanOrEqual(cap);
        },
      ),
    );
  });

  it("the current level never decreases as total EXP increases", () => {
    fc.assert(
      fc.property(
        fc.integer({ min: 0, max: 500000 }),
        fc.integer({ min: 0, max: 500000 }),
        (first, second) => {
          const lower = Math.min(first, second);
          const higher = Math.max(first, second);
          expect(levelForExp(higher, gameConfig.levels).index).toBeGreaterThanOrEqual(
            levelForExp(lower, gameConfig.levels).index,
          );
          expect(
            levelProgress(higher, gameConfig.levels).progressPermil,
          ).toBeGreaterThanOrEqual(0);
        },
      ),
    );
  });

  it("coin conversion never loses the fractional remainder", () => {
    fc.assert(
      fc.property(
        fc.integer({ min: 0, max: 1000000 }),
        fc.integer({ min: 0, max: 999 }),
        fc.integer({ min: 1, max: 100000 }),
        (basis, carryMilli, expPerCoin) => {
          const earnedMilli = Math.floor((basis * 1000) / expPerCoin);
          const result = convertExpToCoins({ basis, carryMilli, expPerCoin });
          expect(result.coinsGained * 1000 + result.carryMilli).toBe(
            carryMilli + earnedMilli,
          );
          expect(result.carryMilli).toBeGreaterThanOrEqual(0);
          expect(result.carryMilli).toBeLessThan(1000);
        },
      ),
    );
  });
});

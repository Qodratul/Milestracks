import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import { calculateRunExp, convertExpToCoins, planMilestones } from "../src/domain";
import { GameConfigSchema } from "../src/config/game-config.schema";

const EXPECTED_RUNS_TO_NEXT = [7, 11, 19, 31, null] as const;
const EXPECTED_COIN_MILLI_PER_RUN = [1500, 2000, 2100, 2050, 2000] as const;
const SIMULATED_RUNS_FOR_COIN_AVERAGE = 100;

function formatMilli(value: number): string {
  const whole = Math.floor(value / 1000);
  const fraction = String(value % 1000).padStart(3, "0");
  return whole + "." + fraction;
}

function loadConfig() {
  const configPath = resolve(__dirname, "../prisma/game-config.v1.json");
  return GameConfigSchema.parse(JSON.parse(readFileSync(configPath, "utf8")) as unknown);
}

function fullRunExp(config: ReturnType<typeof loadConfig>, levelIndex: number) {
  const level = config.levels[levelIndex];
  if (!level) throw new RangeError("Missing level configuration.");
  const averageDistance = Math.floor(
    (level.distanceMinMeters + level.distanceMaxMeters) / 2,
  );
  const milestonePlan = planMilestones(averageDistance, level);
  return {
    level,
    runExp: calculateRunExp({
      expPerMilestone: milestonePlan.expPerMilestone,
      totalMilestones: milestonePlan.milestoneCount,
      reachedActiveSeconds: Array.from(
        { length: milestonePlan.milestoneCount },
        () => 600,
      ),
      itemCodes: [],
      penaltyFreeRun: false,
      completion: "finish",
      safeStopWithinQuota: false,
      rules: config.rules,
    }),
  };
}

function coinsPerRunMilli(basis: number, expPerCoin: number): number {
  let carryMilli = 0;
  let totalCoins = 0;
  for (let index = 0; index < SIMULATED_RUNS_FOR_COIN_AVERAGE; index += 1) {
    const conversion = convertExpToCoins({ basis, carryMilli, expPerCoin });
    totalCoins += conversion.coinsGained;
    carryMilli = conversion.carryMilli;
  }
  return Math.floor((totalCoins * 1000 + carryMilli) / SIMULATED_RUNS_FOR_COIN_AVERAGE);
}

function writeLine(value: string): void {
  process.stdout.write(value + "\n");
}

function main(): void {
  const config = loadConfig();
  writeLine("Level | EXP per full run | Runs to next | Coin per full run (avg)");
  writeLine("--- | ---: | ---: | ---:");
  for (let index = 0; index < config.levels.length; index += 1) {
    const { level, runExp } = fullRunExp(config, index);
    const expectedRuns = EXPECTED_RUNS_TO_NEXT[index] ?? null;
    let runsToNext: number | null = null;
    if (level.nextLevelAtExp !== null) {
      let totalExp = level.startExp;
      runsToNext = 0;
      while (totalExp < level.nextLevelAtExp) {
        totalExp += runExp.levelExpGained;
        runsToNext += 1;
      }
    }
    const coinAverageMilli = coinsPerRunMilli(runExp.basis, level.expPerCoin);
    if (expectedRuns !== null && runsToNext !== null) {
      if (Math.abs(runsToNext - expectedRuns) > 1) {
        throw new Error("Level progression differs from README expectations.");
      }
    }
    if (Math.abs(coinAverageMilli - EXPECTED_COIN_MILLI_PER_RUN[index]!) > 25) {
      throw new Error("Coin economy differs from README expectations.");
    }
    writeLine(
      level.name +
        " | " +
        runExp.levelExpGained +
        " | " +
        (runsToNext === null ? "prestige" : runsToNext) +
        " | " +
        formatMilli(coinAverageMilli),
    );
  }
}

main();

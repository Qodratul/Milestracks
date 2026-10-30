import type { GameConfig } from "../config/game-config.schema";
import { convertExpToCoins } from "../domain/coin";
import { levelProgress, levelsCrossed } from "../domain/level";
import { createId } from "../lib/ids";
import type { Tx } from "../lib/prisma";
import {
  createCoinLedger,
  createExpLedger,
  lockProfile,
  updateProfileForRunClaim,
} from "../repositories/ledger.repository";

export const ledgerService = {
  async creditRunRewards(
    tx: Tx,
    input: {
      readonly userId: string;
      readonly runId: string;
      readonly claimId: string;
      readonly exp: number;
      readonly coinsBasis: number;
      readonly rp: number;
      readonly expPerCoin: number;
      readonly config: GameConfig;
      readonly timestamp: Date;
    },
  ) {
    const profile = await lockProfile(tx, input.userId);
    if (!profile) throw new Error("Profile not found while claiming run rewards.");
    const totalExp = profile.totalExp + input.exp;
    const progress = levelProgress(totalExp, input.config.levels);
    const levelRule = input.config.levels.find(
      (level) => level.code === progress.level.code,
    );
    const coins = convertExpToCoins({
      basis: input.coinsBasis,
      carryMilli: profile.coinCarryMilli,
      expPerCoin: input.expPerCoin,
    });
    const coinBalance = profile.coinBalance + coins.coinsGained;
    await createExpLedger(tx, {
      id: createId("evt"),
      userId: input.userId,
      runId: input.runId,
      delta: input.exp,
      claimId: input.claimId,
      createdAt: input.timestamp,
    });
    await createCoinLedger(tx, {
      id: createId("evt"),
      userId: input.userId,
      runId: input.runId,
      delta: coins.coinsGained,
      carryMilli: coins.carryMilli,
      claimId: input.claimId,
      createdAt: input.timestamp,
    });
    await updateProfileForRunClaim(tx, {
      userId: input.userId,
      totalExp,
      levelCode: progress.level.code,
      coinBalance,
      coinCarryMilli: coins.carryMilli,
      rpTotal: profile.rpTotal + input.rp,
      completedRuns: profile.completedRuns + 1,
      updatedAt: input.timestamp,
    });
    const crossed = levelsCrossed(profile.totalExp, totalExp, input.config.levels);
    return {
      claimId: input.claimId,
      runId: input.runId,
      claimed: true,
      awarded: { exp: input.exp, coins: coins.coinsGained, rp: input.rp },
      capsRemaining: null,
      wallet: { coins: coinBalance, coinProgress: coins.carryMilli / 1000 },
      streak: null,
      level: {
        levelCode: progress.level.code,
        levelName: progress.level.name,
        totalExp,
        levelStartExp: progress.level.startExp,
        nextLevelAtExp: progress.nextLevel?.startExp ?? null,
        progress: progress.progressPermil / 1000,
        mascotForm: levelRule?.mascotForm ?? "kila_small",
      },
      events: crossed.map((level) => ({
        id: createId("evt"),
        type: "level_up",
        levelCode: level.code,
        levelName: level.name,
      })),
    };
  },
};

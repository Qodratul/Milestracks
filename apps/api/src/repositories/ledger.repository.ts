import { Prisma } from "@prisma/client";
import type { Tx } from "../lib/prisma";

export async function lockProfile(tx: Tx, userId: string) {
  const rows = await tx.$queryRaw<Array<{ userId: string }>>(Prisma.sql`
    SELECT user_id AS "userId" FROM profiles WHERE user_id = ${userId} FOR UPDATE
  `);
  if (rows.length === 0) return null;
  return tx.profile.findUnique({ where: { userId } });
}

export function createExpLedger(
  tx: Tx,
  input: {
    readonly id: string;
    readonly userId: string;
    readonly runId: string;
    readonly delta: number;
    readonly claimId: string;
    readonly createdAt: Date;
  },
) {
  return tx.expLedger.create({
    data: {
      id: input.id,
      userId: input.userId,
      runId: input.runId,
      delta: input.delta,
      reason: "run_claim",
      refId: input.claimId,
      idempotencyKey: "run:" + input.runId + ":exp",
      createdAt: input.createdAt,
    },
  });
}

export function createCoinLedger(
  tx: Tx,
  input: {
    readonly id: string;
    readonly userId: string;
    readonly runId: string;
    readonly delta: number;
    readonly carryMilli: number;
    readonly claimId: string;
    readonly createdAt: Date;
  },
) {
  return tx.coinLedger.create({
    data: {
      id: input.id,
      userId: input.userId,
      runId: input.runId,
      delta: input.delta,
      carryMilli: input.carryMilli,
      reason: "run_claim",
      refId: input.claimId,
      idempotencyKey: "run:" + input.runId + ":coin",
      createdAt: input.createdAt,
    },
  });
}

export function updateProfileForRunClaim(
  tx: Tx,
  input: {
    readonly userId: string;
    readonly totalExp: number;
    readonly levelCode:
      "beginner" | "intermediate" | "advanced" | "professional" | "master";
    readonly coinBalance: number;
    readonly coinCarryMilli: number;
    readonly rpTotal: number;
    readonly completedRuns: number;
    readonly updatedAt: Date;
  },
) {
  return tx.profile.update({
    where: { userId: input.userId },
    data: {
      totalExp: input.totalExp,
      levelCode: input.levelCode,
      coinBalance: input.coinBalance,
      coinCarryMilli: input.coinCarryMilli,
      rpTotal: input.rpTotal,
      completedRuns: input.completedRuns,
      updatedAt: input.updatedAt,
    },
  });
}

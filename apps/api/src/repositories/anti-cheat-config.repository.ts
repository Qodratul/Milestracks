import type { Tx } from "../lib/prisma";

export async function findActiveAntiCheatConfig(tx: Tx, at: Date) {
  return tx.antiCheatConfig.findFirst({
    where: { activeAt: { lte: at } },
    orderBy: { version: "desc" },
    select: { version: true, mode: true, thresholds: true },
  });
}

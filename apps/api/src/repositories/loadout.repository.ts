import { Prisma } from "@prisma/client";
import type { ItemCode } from "@prisma/client";
import type { GameLoadout } from "../types/game";
import type { Tx } from "../lib/prisma";
import { prisma } from "../lib/prisma";

export function findLoadoutByUserId(userId: string) {
  return prisma.loadout.findUnique({
    where: { userId },
    select: { boostItemCode: true, modifierItemCode: true },
  });
}

export async function ensureLockedLoadout(transaction: Tx, userId: string) {
  await transaction.loadout.upsert({
    where: { userId },
    create: { userId },
    update: {},
  });

  const rows = await transaction.$queryRaw<Array<{ userId: string }>>(Prisma.sql`
    SELECT user_id AS "userId" FROM loadouts WHERE user_id = ${userId} FOR UPDATE
  `);
  if (rows.length !== 1) throw new Error("Could not lock the user loadout.");

  const loadout = await transaction.loadout.findUnique({
    where: { userId },
    select: { boostItemCode: true, modifierItemCode: true },
  });
  if (!loadout) throw new Error("Locked user loadout was not found.");
  return loadout;
}

export function saveLoadout(transaction: Tx, userId: string, loadout: GameLoadout) {
  return transaction.loadout.update({
    where: { userId },
    data: {
      boostItemCode: loadout.boostItemCode as ItemCode | null,
      modifierItemCode: loadout.modifierItemCode as ItemCode | null,
    },
    select: { boostItemCode: true, modifierItemCode: true },
  });
}

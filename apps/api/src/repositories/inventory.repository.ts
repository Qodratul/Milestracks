import { Prisma } from "@prisma/client";
import type { ItemCode } from "@prisma/client";
import type { Tx } from "../lib/prisma";
import { prisma } from "../lib/prisma";

export function findInventoryByUserId(userId: string, transaction?: Tx) {
  const client = transaction ?? prisma;
  return client.inventory.findMany({
    where: { userId },
    select: { itemCode: true, quantity: true },
  });
}

export function findInventoryItem(transaction: Tx, userId: string, itemCode: ItemCode) {
  return transaction.inventory.findUnique({
    where: { userId_itemCode: { userId, itemCode } },
    select: { itemCode: true, quantity: true },
  });
}

export function decrementAvailableItem(
  transaction: Tx,
  userId: string,
  itemCode: ItemCode,
) {
  return transaction.inventory.updateMany({
    where: { userId, itemCode, quantity: { gt: 0 } },
    data: { quantity: { decrement: 1 } },
  });
}

export async function lockUserForInventoryGrant(
  transaction: Tx,
  userId: string,
): Promise<boolean> {
  const rows = await transaction.$queryRaw<Array<{ id: string }>>(Prisma.sql`
    SELECT id FROM users WHERE id = ${userId} FOR UPDATE
  `);
  return rows.length === 1;
}

export function saveInventoryQuantity(
  transaction: Tx,
  userId: string,
  itemCode: ItemCode,
  quantity: number,
) {
  return transaction.inventory.upsert({
    where: { userId_itemCode: { userId, itemCode } },
    create: { userId, itemCode, quantity },
    update: { quantity },
    select: { itemCode: true, quantity: true },
  });
}

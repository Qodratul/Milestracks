import type { ItemCode } from "@prisma/client";
import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { createId } from "../lib/ids";
import { prisma, withTransaction } from "../lib/prisma";
import { lockUserForInventoryGrant } from "../repositories/inventory.repository";
import { lockProfile } from "../repositories/ledger.repository";
import { gameConfigService } from "./game-config.service";

const productDetails: Record<
  ItemCode,
  {
    readonly priceCoins: number;
    readonly effectCode: string;
    readonly risky: boolean;
    readonly name: { readonly en: string; readonly id: string };
    readonly description: { readonly en: string; readonly id: string };
  }
> = {
  exp_boost: {
    priceCoins: 8,
    effectCode: "exp_multiplier",
    risky: false,
    name: { en: "EXP Boost 1.5x", id: "Peningkat EXP 1,5x" },
    description: {
      en: "1.5x EXP for milestones reached in the first 24 active minutes.",
      id: "EXP 1,5x untuk milestone dalam 24 menit aktif pertama.",
    },
  },
  less_compensation: {
    priceCoins: 6,
    effectCode: "penalty_reduction",
    risky: false,
    name: { en: "Less Compensation", id: "Kompensasi Ringan" },
    description: {
      en: "Failed milestone penalty is reduced to 65%.",
      id: "Penalti milestone yang terlewat berkurang menjadi 65%.",
    },
  },
  gain_more: {
    priceCoins: 10,
    effectCode: "high_risk_multiplier",
    risky: true,
    name: { en: "Gain More, Risk More", id: "Lebih Banyak, Lebih Berisiko" },
    description: {
      en: "2x EXP and 1.75x failed milestone penalty.",
      id: "EXP 2x dan penalti milestone yang terlewat 1,75x.",
    },
  },
};

export const shopService = {
  async catalog(userId: string) {
    const [profile, config, inventory] = await Promise.all([
      prisma.profile.findUnique({ where: { userId }, select: { locale: true } }),
      gameConfigService.active(),
      prisma.inventory.findMany({
        where: { userId },
        select: { itemCode: true, quantity: true },
      }),
    ]);
    if (!profile) throw notFound();
    const stockByCode = new Map(
      inventory.map((entry) => [entry.itemCode, entry.quantity]),
    );
    return config.items.map((item) => {
      const details = productDetails[item.code];
      const available = (stockByCode.get(item.code) ?? 0) < item.maxStock;
      return {
        id: item.code,
        name: details.name[profile.locale],
        description: details.description[profile.locale],
        priceCoins: details.priceCoins,
        effectCode: details.effectCode,
        available,
        maxStock: item.maxStock,
        risky: details.risky,
      };
    });
  },

  async purchase(userId: string, itemCode: ItemCode, idempotencyKey: string) {
    const config = await gameConfigService.active();
    const item = config.items.find((entry) => entry.code === itemCode);
    if (!item) throw notFound();
    const product = productDetails[itemCode];
    return withTransaction(async (tx) => {
      if (!(await lockUserForInventoryGrant(tx, userId))) throw notFound();
      const profile = await lockProfile(tx, userId);
      if (!profile) throw notFound();
      const current = await tx.inventory.findUnique({
        where: { userId_itemCode: { userId, itemCode } },
        select: { quantity: true },
      });
      const ownedCount = current?.quantity ?? 0;
      if (item.maxStock <= ownedCount) {
        throw new AppError(409, "ITEM_STOCK_FULL", "Jumlah item sudah mencapai batas.", {
          itemCode,
          ownedCount,
          maxStock: item.maxStock,
        });
      }
      if (profile.coinBalance < product.priceCoins) {
        throw new AppError(409, ERROR_CODES.INSUFFICIENT_COINS, "Coin tidak mencukupi.", {
          requiredCoins: product.priceCoins,
          availableCoins: profile.coinBalance,
        });
      }

      const remainingCoins = profile.coinBalance - product.priceCoins;
      await tx.profile.update({
        where: { userId },
        data: { coinBalance: remainingCoins },
      });
      await tx.inventory.upsert({
        where: { userId_itemCode: { userId, itemCode } },
        create: { userId, itemCode, quantity: ownedCount + 1 },
        update: { quantity: ownedCount + 1 },
      });
      await tx.coinLedger.create({
        data: {
          id: createId("evt"),
          userId,
          delta: -product.priceCoins,
          carryMilli: profile.coinCarryMilli,
          reason: "shop_purchase",
          refId: itemCode,
          idempotencyKey: `shop:${userId}:${idempotencyKey}`,
        },
      });
      return {
        inventoryItemId: `inventory-${itemCode}`,
        itemId: itemCode,
        remainingCoins,
      };
    });
  },
};

export function shopCoinLedger(
  userId: string,
  cursor: { id: string; timestamp: Date } | null,
  limit: number,
) {
  return prisma.coinLedger.findMany({
    where: {
      userId,
      ...(cursor
        ? {
            OR: [
              { createdAt: { lt: cursor.timestamp } },
              { createdAt: cursor.timestamp, id: { lt: cursor.id } },
            ],
          }
        : {}),
    },
    orderBy: [{ createdAt: "desc" }, { id: "desc" }],
    take: limit + 1,
    select: {
      id: true,
      delta: true,
      reason: true,
      refId: true,
      createdAt: true,
    },
  });
}

function notFound(): AppError {
  return new AppError(404, ERROR_CODES.NOT_FOUND, "Data tidak ditemukan.");
}

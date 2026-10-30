import { validateLoadout } from "../domain/items";
import type { GameLoadout, ItemCode } from "../types/game";
import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { idMessages } from "../i18n";
import type { Tx } from "../lib/prisma";
import { withTransaction } from "../lib/prisma";
import {
  decrementAvailableItem,
  findInventoryByUserId,
  findInventoryItem,
  lockUserForInventoryGrant,
  saveInventoryQuantity,
} from "../repositories/inventory.repository";
import { findUserById } from "../repositories/user.repository";
import {
  ensureLockedLoadout,
  findLoadoutByUserId,
  saveLoadout,
} from "../repositories/loadout.repository";
import { gameConfigService } from "./game-config.service";

const EMPTY_LOADOUT: GameLoadout = {
  boostItemCode: null,
  modifierItemCode: null,
};
const INVENTORY_PAGE_LIMIT = 20;

export const itemService = {
  async getInventory(userId: string) {
    const [config, inventory, loadout] = await Promise.all([
      gameConfigService.active(),
      findInventoryByUserId(userId),
      findLoadoutByUserId(userId),
    ]);
    const stockByCode = new Map(
      inventory.map((entry) => [entry.itemCode, entry.quantity]),
    );
    const equipped = loadout ? toGameLoadout(loadout) : EMPTY_LOADOUT;

    return {
      items: config.items.map((item) => ({
        itemCode: item.code,
        name: item.name,
        slot: item.slot,
        ownedCount: stockByCode.get(item.code) ?? 0,
        maxStock: item.maxStock,
        autoUse: false,
        equipped:
          item.slot === "boost"
            ? equipped.boostItemCode === item.code
            : equipped.modifierItemCode === item.code,
      })),
      limit: INVENTORY_PAGE_LIMIT,
    };
  },

  async consumeForRun(
    userId: string,
    selection: GameLoadout,
    transaction?: Tx,
  ): Promise<GameLoadout> {
    const config = await gameConfigService.active();
    const validation = validateLoadout(selection, config.items);
    if (!validation.valid) throw loadoutConflict(validation);

    const consume = async (tx: Tx): Promise<GameLoadout> => {
      const currentRecord = await ensureLockedLoadout(tx, userId);
      let nextLoadout = toGameLoadout(currentRecord);

      for (const item of selectedItems(selection)) {
        const result = await decrementAvailableItem(tx, userId, item.itemCode);
        if (result.count !== 1) throw itemNotOwned(item.itemCode);

        const remaining = await findInventoryItem(tx, userId, item.itemCode);
        if (remaining?.quantity === 0) {
          if (item.slot === "boost" && nextLoadout.boostItemCode === item.itemCode) {
            nextLoadout = { ...nextLoadout, boostItemCode: null };
          } else if (
            item.slot === "modifier" &&
            nextLoadout.modifierItemCode === item.itemCode
          ) {
            nextLoadout = { ...nextLoadout, modifierItemCode: null };
          }
        }
      }

      if (
        currentRecord.boostItemCode !== nextLoadout.boostItemCode ||
        currentRecord.modifierItemCode !== nextLoadout.modifierItemCode
      ) {
        await saveLoadout(tx, userId, nextLoadout);
      }
      return selection;
    };

    return transaction ? consume(transaction) : withTransaction(consume);
  },

  async grantForDemo(
    userId: string,
    itemCode: string,
    quantity: number,
  ): Promise<{
    readonly itemCode: ItemCode;
    readonly grantedCount: number;
    readonly ownedCount: number;
    readonly maxStock: number;
  }> {
    if (!Number.isSafeInteger(quantity) || quantity < 1) {
      throw new RangeError("quantity must be a positive safe integer");
    }

    const config = await gameConfigService.active();
    const item = config.items.find((candidate) => candidate.code === itemCode);
    if (!item) throw new RangeError("itemCode is not in the active game config");

    return withTransaction(async (transaction) => {
      if (!(await lockUserForInventoryGrant(transaction, userId))) {
        throw notFound();
      }
      const user = await findUserById(userId, transaction);
      if (!user) throw notFound();

      const current = await findInventoryItem(transaction, userId, item.code);
      const ownedBefore = current?.quantity ?? 0;
      const ownedAfter = Math.min(item.maxStock, ownedBefore + quantity);
      await saveInventoryQuantity(transaction, userId, item.code, ownedAfter);

      return {
        itemCode: item.code,
        grantedCount: Math.max(0, ownedAfter - ownedBefore),
        ownedCount: ownedAfter,
        maxStock: item.maxStock,
      };
    });
  },
};

function selectedItems(
  loadout: GameLoadout,
): readonly { readonly slot: "boost" | "modifier"; readonly itemCode: ItemCode }[] {
  const items: { slot: "boost" | "modifier"; itemCode: ItemCode }[] = [];
  if (loadout.boostItemCode !== null) {
    items.push({ slot: "boost", itemCode: loadout.boostItemCode });
  }
  if (loadout.modifierItemCode !== null) {
    items.push({ slot: "modifier", itemCode: loadout.modifierItemCode });
  }
  return items;
}

function toGameLoadout(loadout: {
  readonly boostItemCode: ItemCode | null;
  readonly modifierItemCode: ItemCode | null;
}): GameLoadout {
  return {
    boostItemCode: loadout.boostItemCode,
    modifierItemCode: loadout.modifierItemCode,
  };
}

function loadoutConflict(validation: {
  readonly slot: "boost" | "modifier";
  readonly itemCode: ItemCode;
}): AppError {
  return new AppError(
    409,
    ERROR_CODES.LOADOUT_CONFLICT,
    idMessages.errors.loadoutConflict,
    { slot: validation.slot, itemCode: validation.itemCode },
  );
}

function itemNotOwned(itemCode: ItemCode): AppError {
  return new AppError(422, ERROR_CODES.ITEM_NOT_OWNED, idMessages.errors.itemNotOwned, {
    itemCode,
  });
}

function notFound(): AppError {
  return new AppError(404, ERROR_CODES.NOT_FOUND, idMessages.errors.notFound);
}

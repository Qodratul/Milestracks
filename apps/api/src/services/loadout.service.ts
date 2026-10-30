import { mergeLoadout, validateLoadout } from "../domain/items";
import type { LoadoutPatch } from "../domain/items";
import type { GameLoadout, ItemCode } from "../types/game";
import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { idMessages } from "../i18n";
import { withTransaction } from "../lib/prisma";
import { findInventoryItem } from "../repositories/inventory.repository";
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

export const loadoutService = {
  async get(userId: string): Promise<GameLoadout> {
    const loadout = await findLoadoutByUserId(userId);
    return loadout ? toGameLoadout(loadout) : EMPTY_LOADOUT;
  },

  async update(userId: string, patch: LoadoutPatch): Promise<GameLoadout> {
    const config = await gameConfigService.active();
    return withTransaction(async (transaction) => {
      const currentRecord = await ensureLockedLoadout(transaction, userId);
      const current = toGameLoadout(currentRecord);
      const next = mergeLoadout(current, patch);
      const validation = validateLoadout(next, config.items);
      if (!validation.valid) {
        throw new AppError(
          409,
          ERROR_CODES.LOADOUT_CONFLICT,
          idMessages.errors.loadoutConflict,
          { slot: validation.slot, itemCode: validation.itemCode },
        );
      }

      const itemCodes = [next.boostItemCode, next.modifierItemCode].filter(
        (itemCode): itemCode is ItemCode => itemCode !== null,
      );
      for (const itemCode of itemCodes) {
        const inventoryItem = await findInventoryItem(transaction, userId, itemCode);
        if (!inventoryItem || inventoryItem.quantity < 1) {
          throw itemNotOwned(itemCode);
        }
      }

      return toGameLoadout(await saveLoadout(transaction, userId, next));
    });
  },
};

function toGameLoadout(loadout: {
  readonly boostItemCode: ItemCode | null;
  readonly modifierItemCode: ItemCode | null;
}): GameLoadout {
  return {
    boostItemCode: loadout.boostItemCode,
    modifierItemCode: loadout.modifierItemCode,
  };
}

function itemNotOwned(itemCode: ItemCode): AppError {
  return new AppError(422, ERROR_CODES.ITEM_NOT_OWNED, idMessages.errors.itemNotOwned, {
    itemCode,
  });
}

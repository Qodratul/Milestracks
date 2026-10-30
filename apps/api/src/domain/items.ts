import type { GameItemRule, GameLoadout, ItemCode } from "../types/game";

export type LoadoutPatch = Readonly<{
  boostItemCode?: ItemCode | null;
  modifierItemCode?: ItemCode | null;
}>;

export type LoadoutValidation =
  | { readonly valid: true }
  | {
      readonly valid: false;
      readonly reason: "unknown_item" | "wrong_slot" | "exclusive_items";
      readonly slot: "boost" | "modifier";
      readonly itemCode: ItemCode;
    };

export function mergeLoadout(current: GameLoadout, patch: LoadoutPatch): GameLoadout {
  return {
    boostItemCode:
      patch.boostItemCode === undefined ? current.boostItemCode : patch.boostItemCode,
    modifierItemCode:
      patch.modifierItemCode === undefined
        ? current.modifierItemCode
        : patch.modifierItemCode,
  };
}

export function validateLoadout(
  loadout: GameLoadout,
  items: readonly GameItemRule[],
): LoadoutValidation {
  const selected = [
    { slot: "boost" as const, itemCode: loadout.boostItemCode },
    { slot: "modifier" as const, itemCode: loadout.modifierItemCode },
  ].filter(
    (entry): entry is { slot: "boost" | "modifier"; itemCode: ItemCode } =>
      entry.itemCode !== null,
  );
  for (const entry of selected) {
    const item = items.find((candidate) => candidate.code === entry.itemCode);
    if (!item) {
      return {
        valid: false,
        reason: "unknown_item",
        slot: entry.slot,
        itemCode: entry.itemCode,
      };
    }
    if (item.slot !== entry.slot) {
      return {
        valid: false,
        reason: "wrong_slot",
        slot: entry.slot,
        itemCode: entry.itemCode,
      };
    }
  }
  for (const entry of selected) {
    const item = items.find((candidate) => candidate.code === entry.itemCode);
    if (
      item?.exclusiveCodes.some((code) =>
        selected.some((selectedItem) => selectedItem.itemCode === code),
      )
    ) {
      return {
        valid: false,
        reason: "exclusive_items",
        slot: entry.slot,
        itemCode: entry.itemCode,
      };
    }
  }
  return { valid: true };
}

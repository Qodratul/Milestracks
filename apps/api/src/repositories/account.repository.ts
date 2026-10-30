import type { ItemCode, Locale } from "@prisma/client";
import type { Tx } from "../lib/prisma";

export interface CreateRegisteredAccountInput {
  readonly userId: string;
  readonly email: string;
  readonly passwordHash: string;
  readonly displayName: string;
  readonly locale: Locale;
  readonly timezone: string;
  readonly inventory: readonly {
    readonly itemCode: ItemCode;
    readonly quantity: number;
  }[];
}

export function createRegisteredAccount(
  transaction: Tx,
  input: CreateRegisteredAccountInput,
) {
  return transaction.user.create({
    data: {
      id: input.userId,
      email: input.email,
      passwordHash: input.passwordHash,
      profile: {
        create: {
          displayName: input.displayName,
          locale: input.locale,
          timezone: input.timezone,
          healthDisclaimerAcceptedAt: null,
        },
      },
      inventory: { create: input.inventory.map((item) => ({ ...item })) },
      loadout: { create: {} },
    },
    select: {
      id: true,
      email: true,
      emailVerified: true,
      profile: { select: { displayName: true, locale: true } },
    },
  });
}

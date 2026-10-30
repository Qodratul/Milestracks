import type { Tx } from "../lib/prisma";
import { prisma } from "../lib/prisma";

export interface NewRefreshTokenRecord {
  readonly id: string;
  readonly userId: string;
  readonly tokenHash: string;
  readonly familyId: string;
  readonly expiresAt: Date;
}

export function findRefreshTokenByHash(tokenHash: string, transaction?: Tx) {
  const client = transaction ?? prisma;
  return client.refreshToken.findUnique({
    where: { tokenHash },
    select: {
      id: true,
      userId: true,
      familyId: true,
      expiresAt: true,
      revokedAt: true,
      replacedBy: true,
      user: { select: { status: true } },
    },
  });
}

export function createRefreshToken(transaction: Tx, input: NewRefreshTokenRecord) {
  return transaction.refreshToken.create({ data: input, select: { id: true } });
}

export function rotateRefreshToken(
  transaction: Tx,
  input: { readonly id: string; readonly nextId: string; readonly now: Date },
): Promise<{ count: number }> {
  return transaction.refreshToken.updateMany({
    where: { id: input.id, revokedAt: null, expiresAt: { gt: input.now } },
    data: { revokedAt: input.now, replacedBy: input.nextId },
  });
}

export function findRefreshTokenById(transaction: Tx, id: string) {
  return transaction.refreshToken.findUnique({
    where: { id },
    select: { familyId: true, revokedAt: true, replacedBy: true, expiresAt: true },
  });
}

export function revokeRefreshFamily(transaction: Tx, familyId: string, now: Date) {
  return transaction.refreshToken.updateMany({
    where: { familyId, revokedAt: null },
    data: { revokedAt: now },
  });
}

export function revokeUserRefreshToken(
  transaction: Tx,
  input: { readonly userId: string; readonly tokenHash: string; readonly now: Date },
) {
  return transaction.refreshToken.updateMany({
    where: {
      userId: input.userId,
      tokenHash: input.tokenHash,
      revokedAt: null,
    },
    data: { revokedAt: input.now },
  });
}

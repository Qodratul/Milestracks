import type { Tx } from "../lib/prisma";
import { prisma } from "../lib/prisma";

export function findUserByEmail(email: string, transaction?: Tx) {
  const client = transaction ?? prisma;
  return client.user.findFirst({
    where: { email: { equals: email, mode: "insensitive" } },
    select: {
      id: true,
      email: true,
      passwordHash: true,
      emailVerified: true,
      status: true,
      profile: { select: { displayName: true, locale: true } },
    },
  });
}

export function findUserById(userId: string, transaction?: Tx) {
  const client = transaction ?? prisma;
  return client.user.findUnique({
    where: { id: userId },
    select: {
      id: true,
      email: true,
      emailVerified: true,
      status: true,
    },
  });
}

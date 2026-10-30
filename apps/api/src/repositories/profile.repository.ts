import { prisma } from "../lib/prisma";

export function findProfileByUserId(userId: string) {
  return prisma.profile.findUnique({
    where: { userId },
    select: {
      displayName: true,
      locale: true,
      timezone: true,
      healthDisclaimerAcceptedAt: true,
      units: true,
      totalExp: true,
      levelCode: true,
      coinBalance: true,
      coinCarryMilli: true,
    },
  });
}

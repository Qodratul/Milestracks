import { prisma } from "../lib/prisma";

export async function findActiveGameConfig(): Promise<{
  readonly version: number;
  readonly payload: unknown;
} | null> {
  return prisma.gameConfigVersion.findFirst({
    where: { isActive: true },
    orderBy: { version: "desc" },
    select: { version: true, payload: true },
  });
}

export async function findGameConfigVersion(
  version: number,
): Promise<{ readonly version: number; readonly payload: unknown } | null> {
  return prisma.gameConfigVersion.findUnique({
    where: { version },
    select: { version: true, payload: true },
  });
}

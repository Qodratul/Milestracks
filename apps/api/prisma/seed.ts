import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import { Prisma, PrismaClient } from "@prisma/client";
import { INITIAL_ANTI_CHEAT_CONFIG } from "../src/config/anti-cheat-config";
import { GameConfigSchema } from "../src/config/game-config.schema";

const CONFIG_PATH = resolve(__dirname, "game-config.v1.json");
const CONFIG_V2_PATH = resolve(__dirname, "game-config.v2.json");

export async function seedGameConfigV1(client: PrismaClient): Promise<void> {
  const config = GameConfigSchema.parse(
    JSON.parse(readFileSync(CONFIG_PATH, "utf8")) as unknown,
  );
  const [existing, active] = await Promise.all([
    client.gameConfigVersion.findUnique({
      where: { version: config.configVersion },
      select: { version: true },
    }),
    client.gameConfigVersion.findFirst({
      where: { isActive: true },
      select: { version: true },
    }),
  ]);

  if (existing) {
    await client.gameConfigVersion.update({
      where: { version: config.configVersion },
      data: {
        payload: config,
        ...(active === null ? { isActive: true } : {}),
      },
    });
    return;
  }

  await client.gameConfigVersion.create({
    data: {
      version: config.configVersion,
      payload: config,
      isActive: active === null,
    },
  });
}

export async function seedGameConfigV2(client: PrismaClient): Promise<void> {
  const config = GameConfigSchema.parse(
    JSON.parse(readFileSync(CONFIG_V2_PATH, "utf8")) as unknown,
  );
  await client.$transaction(async (transaction) => {
    await transaction.gameConfigVersion.updateMany({
      where: { isActive: true },
      data: { isActive: false },
    });
    await transaction.gameConfigVersion.upsert({
      where: { version: config.configVersion },
      create: {
        version: config.configVersion,
        payload: config,
        isActive: true,
      },
      update: {
        payload: config,
        isActive: true,
        activeAt: new Date(),
      },
    });
  });
}

export async function seedAntiCheatConfig(client: PrismaClient): Promise<void> {
  const config = INITIAL_ANTI_CHEAT_CONFIG;
  await client.antiCheatConfig.createMany({
    data: [
      {
        version: config.version,
        mode: config.mode,
        thresholds: config.thresholds as Prisma.InputJsonValue,
      },
    ],
    skipDuplicates: true,
  });
}

async function main(): Promise<void> {
  const prisma = new PrismaClient();
  try {
    await seedGameConfigV1(prisma);
    await seedGameConfigV2(prisma);
    await seedAntiCheatConfig(prisma);
  } finally {
    await prisma.$disconnect();
  }
}

if (require.main === module) {
  void main();
}

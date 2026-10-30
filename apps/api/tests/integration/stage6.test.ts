import { execFileSync } from "node:child_process";
import { resolve } from "node:path";
import { PrismaClient } from "@prisma/client";
import type { ItemCode } from "@prisma/client";
import type { Express } from "express";
import request from "supertest";
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import { seedGameConfigV1 } from "../../prisma/seed";
import { createId } from "../../src/lib/ids";
import type { GameLoadout } from "../../src/types/game";
import { startPostgis } from "../helpers/postgis";

const enabled = process.env.RUN_DATABASE_INTEGRATION === "true";
const API_DIRECTORY = resolve(__dirname, "../..");
const TEST_JWT_SECRET = "stage6-integration-secret-with-at-least-32-chars";
const ITEM_CODES = [
  "exp_boost",
  "less_compensation",
  "gain_more",
] as const satisfies readonly ItemCode[];

interface ItemServiceForTest {
  consumeForRun(userId: string, selection: GameLoadout): Promise<GameLoadout>;
}

describe.skipIf(!enabled)("Stage 6 inventory and loadout integration", () => {
  let database: Awaited<ReturnType<typeof startPostgis>>;
  let client: PrismaClient;
  let app: Express;
  let originalDatabaseUrl: string | undefined;
  let originalDirectUrl: string | undefined;
  let originalStubMode: string | undefined;
  let originalJwtSecret: string | undefined;
  let itemService: ItemServiceForTest;

  beforeAll(async () => {
    database = await startPostgis();
    originalDatabaseUrl = process.env.DATABASE_URL;
    originalDirectUrl = process.env.DIRECT_URL;
    originalStubMode = process.env.STUB_MODE;
    originalJwtSecret = process.env.JWT_SECRET;
    process.env.DATABASE_URL = database.connectionString;
    process.env.DIRECT_URL = database.connectionString;
    process.env.STUB_MODE = "false";
    process.env.JWT_SECRET = TEST_JWT_SECRET;
    deployMigrations(database.connectionString);
    client = new PrismaClient({ datasourceUrl: database.connectionString });
    await seedGameConfigV1(client);
    ({ app } = await import("../../src/app.js"));
    ({ itemService } = await import("../../src/services/item.service.js"));
  }, 120_000);

  afterAll(async () => {
    if (client) await client.$disconnect();
    const { closePrisma } = await import("../../src/lib/prisma.js");
    await closePrisma();
    if (database) await database.stop();
    restoreEnvironment("DATABASE_URL", originalDatabaseUrl);
    restoreEnvironment("DIRECT_URL", originalDirectUrl);
    restoreEnvironment("STUB_MODE", originalStubMode);
    restoreEnvironment("JWT_SECRET", originalJwtSecret);
  }, 30_000);

  it("lists configured items with current stock and equipped state", async () => {
    const account = await createAccount();

    const inventory = await request(app)
      .get("/api/v1/me/inventory")
      .set("Authorization", "Bearer " + account.token);

    expect(inventory.status).toBe(200);
    expect(inventory.body.data).toHaveLength(ITEM_CODES.length);
    expect(inventory.body.meta).toMatchObject({
      nextCursor: null,
      limit: 20,
    });
    expect(inventory.body.data[0]).toMatchObject({
      itemCode: "exp_boost",
      ownedCount: 3,
      maxStock: 3,
      autoUse: false,
      equipped: false,
    });

    const loadout = await request(app)
      .get("/api/v1/me/loadout")
      .set("Authorization", "Bearer " + account.token);
    expect(loadout.status).toBe(200);
    expect(loadout.body.data).toEqual({
      boostItemCode: null,
      modifierItemCode: null,
    });
  });

  it("merges partial patches, treats null as unequip, and rejects wrong slots", async () => {
    const account = await createAccount();

    const boost = await request(app)
      .patch("/api/v1/me/loadout")
      .set("Authorization", "Bearer " + account.token)
      .send({ boostItemCode: "exp_boost" });
    expect(boost.status).toBe(200);
    expect(boost.body.data).toEqual({
      boostItemCode: "exp_boost",
      modifierItemCode: null,
    });

    const modifier = await request(app)
      .patch("/api/v1/me/loadout")
      .set("Authorization", "Bearer " + account.token)
      .send({ modifierItemCode: "less_compensation" });
    expect(modifier.status).toBe(200);
    expect(modifier.body.data).toEqual({
      boostItemCode: "exp_boost",
      modifierItemCode: "less_compensation",
    });

    const unequipped = await request(app)
      .patch("/api/v1/me/loadout")
      .set("Authorization", "Bearer " + account.token)
      .send({ modifierItemCode: null });
    expect(unequipped.status).toBe(200);
    expect(unequipped.body.data).toEqual({
      boostItemCode: "exp_boost",
      modifierItemCode: null,
    });

    const wrongSlot = await request(app)
      .patch("/api/v1/me/loadout")
      .set("Authorization", "Bearer " + account.token)
      .send({ modifierItemCode: "exp_boost" });
    expect(wrongSlot.status).toBe(409);
    expect(wrongSlot.body.error).toMatchObject({
      code: "LOADOUT_CONFLICT",
      details: { slot: "modifier", itemCode: "exp_boost" },
    });
  });

  it("rejects equipping an item without available stock", async () => {
    const account = await createAccount({ inventory: { exp_boost: 0 } });

    const response = await request(app)
      .patch("/api/v1/me/loadout")
      .set("Authorization", "Bearer " + account.token)
      .send({ boostItemCode: "exp_boost" });

    expect(response.status).toBe(422);
    expect(response.body.error).toMatchObject({
      code: "ITEM_NOT_OWNED",
      details: { itemCode: "exp_boost" },
    });
  });

  it("rolls back a partial consume and clears an equipped item when its last unit is used", async () => {
    const account = await createAccount({
      inventory: { exp_boost: 1, gain_more: 0 },
      loadout: { boostItemCode: "exp_boost", modifierItemCode: null },
    });

    await expect(
      itemService.consumeForRun(account.userId, {
        boostItemCode: "exp_boost",
        modifierItemCode: "gain_more",
      }),
    ).rejects.toMatchObject({ code: "ITEM_NOT_OWNED", statusCode: 422 });
    await expect(
      client.inventory.findUnique({
        where: {
          userId_itemCode: { userId: account.userId, itemCode: "exp_boost" },
        },
        select: { quantity: true },
      }),
    ).resolves.toEqual({ quantity: 1 });

    await expect(
      itemService.consumeForRun(account.userId, {
        boostItemCode: "exp_boost",
        modifierItemCode: null,
      }),
    ).resolves.toEqual({
      boostItemCode: "exp_boost",
      modifierItemCode: null,
    });

    await expect(
      client.inventory.findUnique({
        where: {
          userId_itemCode: { userId: account.userId, itemCode: "exp_boost" },
        },
        select: { quantity: true },
      }),
    ).resolves.toEqual({ quantity: 0 });
    await expect(
      client.loadout.findUnique({
        where: { userId: account.userId },
        select: { boostItemCode: true, modifierItemCode: true },
      }),
    ).resolves.toEqual({ boostItemCode: null, modifierItemCode: null });
  });

  it("allows only one concurrent consume of the last item", async () => {
    const account = await createAccount({
      inventory: { gain_more: 1 },
      loadout: { boostItemCode: null, modifierItemCode: "gain_more" },
    });
    const selection: GameLoadout = {
      boostItemCode: null,
      modifierItemCode: "gain_more",
    };

    const results = await Promise.allSettled([
      itemService.consumeForRun(account.userId, selection),
      itemService.consumeForRun(account.userId, selection),
    ]);
    const fulfilled = results.filter((result) => result.status === "fulfilled");
    const rejected = results.find((result) => result.status === "rejected");

    expect(fulfilled).toHaveLength(1);
    expect(rejected?.status).toBe("rejected");
    if (!rejected || rejected.status !== "rejected") {
      throw new Error("Expected one inventory consume to be rejected.");
    }
    expect(rejected.reason).toMatchObject({
      code: "ITEM_NOT_OWNED",
      statusCode: 422,
    });
    await expect(
      client.inventory.findUnique({
        where: {
          userId_itemCode: { userId: account.userId, itemCode: "gain_more" },
        },
        select: { quantity: true },
      }),
    ).resolves.toEqual({ quantity: 0 });
  });

  async function createAccount(
    options: {
      inventory?: Partial<Record<ItemCode, number>>;
      loadout?: GameLoadout;
    } = {},
  ): Promise<{ userId: string; token: string }> {
    const userId = createId("usr");
    const email = userId + "@example.test";
    await client.user.create({
      data: {
        id: userId,
        email,
        passwordHash: "test-password-hash",
        inventory: {
          create: ITEM_CODES.map((itemCode) => ({
            itemCode,
            quantity: options.inventory?.[itemCode] ?? 3,
          })),
        },
        loadout: {
          create: options.loadout ?? {
            boostItemCode: null,
            modifierItemCode: null,
          },
        },
      },
    });
    const { signAccessToken } = await import("../../src/lib/auth-token.js");
    return { userId, token: await signAccessToken(userId, new Date()) };
  }
});

function deployMigrations(connectionString: string): void {
  const command = process.platform === "win32" ? "pnpm.cmd" : "pnpm";
  try {
    execFileSync(command, ["exec", "prisma", "migrate", "deploy"], {
      cwd: API_DIRECTORY,
      env: {
        ...process.env,
        DATABASE_URL: connectionString,
        DIRECT_URL: connectionString,
      },
      stdio: "pipe",
      shell: process.platform === "win32",
    });
  } catch {
    throw new Error("Prisma migrations failed against the disposable PostGIS database.");
  }
}

function restoreEnvironment(name: string, value: string | undefined): void {
  if (value === undefined) {
    delete process.env[name];
    return;
  }
  process.env[name] = value;
}

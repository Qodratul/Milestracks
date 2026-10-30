import { execFileSync } from "node:child_process";
import { resolve } from "node:path";
import { PrismaClient } from "@prisma/client";
import type { Express } from "express";
import request from "supertest";
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import { seedGameConfigV1 } from "../../prisma/seed";
import { startPostgis } from "../helpers/postgis";

const enabled = process.env.RUN_DATABASE_INTEGRATION === "true";
const API_DIRECTORY = resolve(__dirname, "../..");
const TEST_JWT_SECRET = "stage5-integration-secret-with-at-least-32-chars";

describe.skipIf(!enabled)("Stage 5 auth integration", () => {
  let database: Awaited<ReturnType<typeof startPostgis>>;
  let client: PrismaClient;
  let app: Express;
  let originalDatabaseUrl: string | undefined;
  let originalDirectUrl: string | undefined;
  let originalStubMode: string | undefined;
  let originalJwtSecret: string | undefined;
  let resetAuthLimit: () => void;

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
    const limiter = await import("../../src/routes/auth.route.js");
    resetAuthLimit = () => {
      limiter.authRateLimiter.resetKey("127.0.0.1");
      limiter.authRateLimiter.resetKey("::ffff:127.0.0.1");
    };
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

  it("registers an account and provisions initial game state atomically", async () => {
    const response = await register("stage5-register@example.test");
    expect(response.status).toBe(201);
    expect(response.body.data.user.email).toBe("stage5-register@example.test");
    expect(response.body.data.emailVerificationRequired).toBe(false);
    expect(response.body.data.accessToken).toEqual(expect.any(String));
    expect(response.body.data.refreshToken).toMatch(/^rt_/);

    const user = await client.user.findUnique({
      where: { id: response.body.data.user.id as string },
      include: { profile: true, inventory: true, loadout: true, refreshTokens: true },
    });
    expect(user?.passwordHash).toMatch(/^\$argon2id\$/);
    expect(user?.profile).toMatchObject({
      displayName: "Rani",
      locale: "en",
      timezone: "Asia/Jakarta",
      levelCode: "beginner",
      totalExp: 0,
      coinBalance: 0,
    });
    expect(user?.inventory).toHaveLength(3);
    expect(user?.inventory.every((item) => item.quantity === 3)).toBe(true);
    expect(user?.loadout).toMatchObject({
      boostItemCode: null,
      modifierItemCode: null,
    });
    expect(user?.refreshTokens).toHaveLength(1);
    expect(user?.refreshTokens[0]?.tokenHash).not.toBe(response.body.data.refreshToken);

    const authorization = "Bearer " + String(response.body.data.accessToken);
    const me = await request(app).get("/api/v1/me").set("Authorization", authorization);
    const home = await request(app)
      .get("/api/v1/me/home-summary")
      .set("Authorization", authorization);
    const wallet = await request(app)
      .get("/api/v1/me/wallet")
      .set("Authorization", authorization);
    expect(me.body.data).toMatchObject({
      email: "stage5-register@example.test",
      levelCode: "beginner",
      totalExp: 0,
      coins: 0,
    });
    expect(home.body.data).toMatchObject({
      mascotForm: "kila_small",
      nextLevelAtExp: 10_000,
      levelProgress: 0,
    });
    expect(wallet.body.data).toEqual({ coins: 0, coinProgress: 0 });
    resetAuthLimit();
  });

  it("rejects duplicate email and authenticates with a generic credential error", async () => {
    const email = "stage5-login@example.test";
    await register(email);
    const duplicate = await register(email.toUpperCase());
    const invalid = await request(app).post("/api/v1/auth/login").send({
      email,
      password: "IncorrectPassword123",
    });
    const login = await request(app).post("/api/v1/auth/login").send({
      email,
      password: "KataSandiKuat123",
      rememberMe: true,
    });

    expect(duplicate.status).toBe(409);
    expect(duplicate.body.error.code).toBe("EMAIL_TAKEN");
    expect(invalid.status).toBe(401);
    expect(invalid.body.error.code).toBe("INVALID_CREDENTIALS");
    expect(login.status).toBe(200);
    expect(login.body.data.user.email).toBe(email);
    resetAuthLimit();
  });

  it("rotates refresh tokens and revokes the whole family on reuse", async () => {
    const registered = await register("stage5-rotation@example.test");
    const oldToken = String(registered.body.data.refreshToken);
    const rotated = await request(app)
      .post("/api/v1/auth/refresh")
      .send({ refreshToken: oldToken });
    const reused = await request(app)
      .post("/api/v1/auth/refresh")
      .send({ refreshToken: oldToken });
    const revokedFamily = await request(app)
      .post("/api/v1/auth/refresh")
      .send({ refreshToken: rotated.body.data.refreshToken as string });

    expect(rotated.status).toBe(200);
    expect(rotated.body.data.refreshToken).not.toBe(oldToken);
    expect(reused.status).toBe(401);
    expect(reused.body.error.code).toBe("REFRESH_TOKEN_REUSED");
    expect(revokedFamily.status).toBe(401);
    expect(revokedFamily.body.error.code).toBe("UNAUTHORIZED");
    resetAuthLimit();
  });

  it("logs out the supplied session and rejects expired access tokens", async () => {
    const registered = await register("stage5-logout@example.test");
    const accessToken = String(registered.body.data.accessToken);
    const refreshToken = String(registered.body.data.refreshToken);
    const logout = await request(app)
      .post("/api/v1/auth/logout")
      .set("Authorization", "Bearer " + accessToken)
      .send({ refreshToken });
    const refresh = await request(app)
      .post("/api/v1/auth/refresh")
      .send({ refreshToken });

    const { signAccessToken } = await import("../../src/lib/auth-token.js");
    const expiredToken = await signAccessToken(
      String(registered.body.data.user.id),
      new Date(Date.now() - 16 * 60 * 1000),
    );
    const expired = await request(app)
      .get("/api/v1/me")
      .set("Authorization", "Bearer " + expiredToken);

    expect(logout.status).toBe(200);
    expect(logout.body.data).toEqual({ loggedOut: true });
    expect(refresh.status).toBe(401);
    expect(refresh.body.error.code).toBe("UNAUTHORIZED");
    expect(expired.status).toBe(401);
    expect(expired.body.error.code).toBe("TOKEN_EXPIRED");
    resetAuthLimit();
  });

  it("scopes account responses to the authenticated user", async () => {
    const ownerEmail = "stage5-owner@example.test";
    const otherEmail = "stage5-other@example.test";
    const owner = await register(ownerEmail);
    await register(otherEmail);

    const me = await request(app)
      .get("/api/v1/me")
      .set("Authorization", "Bearer " + String(owner.body.data.accessToken));

    expect(me.status).toBe(200);
    expect(me.body.data.email).toBe(ownerEmail);
    expect(JSON.stringify(me.body.data)).not.toContain(otherEmail);
    resetAuthLimit();
  });
  it("limits auth requests to ten per minute per IP", async () => {
    resetAuthLimit();
    for (let index = 0; index < 10; index += 1) {
      const allowed = await request(app).post("/api/v1/auth/login").send({});
      expect(allowed.status).toBe(400);
    }
    const limited = await request(app).post("/api/v1/auth/login").send({});
    expect(limited.status).toBe(429);
    expect(limited.body.error.code).toBe("RATE_LIMITED");
    expect(limited.body.error.details.retryAfterSec).toBe(60);
    resetAuthLimit();
  });

  async function register(email: string) {
    return request(app).post("/api/v1/auth/register").send({
      displayName: "Rani",
      email,
      password: "KataSandiKuat123",
      locale: "en",
      timezone: "Asia/Jakarta",
    });
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

import { randomBytes } from "node:crypto";
import { Prisma } from "@prisma/client";
import { gameConfigService } from "./game-config.service";
import { prisma, withTransaction } from "../lib/prisma";
import { now } from "../lib/clock";
import { createId } from "../lib/ids";
import { hashPassword, verifyPassword } from "../lib/password";
import { createRefreshTokenCredential, hashRefreshToken } from "../lib/refresh-token";
import {
  signAccessToken,
  verifyAccessToken,
  ACCESS_TOKEN_TTL_SECONDS,
} from "../lib/auth-token";
import { findUserByEmail, findUserById } from "../repositories/user.repository";
import { createRegisteredAccount } from "../repositories/account.repository";
import { verifyGoogleIdToken } from "../lib/google-id-token";
import {
  createRefreshToken,
  findRefreshTokenByHash,
  findRefreshTokenById,
  revokeRefreshFamily,
  revokeUserRefreshToken,
  rotateRefreshToken,
} from "../repositories/refresh-token.repository";
import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { idMessages } from "../i18n";
import type { GoogleAuthInput, LoginInput, RegisterInput } from "../types/auth";

const REFRESH_TOKEN_TTL_MS = 30 * 24 * 60 * 60 * 1000;

interface SessionResponse {
  readonly user: {
    readonly id: string;
    readonly displayName: string;
    readonly email: string;
    readonly emailVerified: boolean;
    readonly locale: "id" | "en";
  };
  readonly accessToken: string;
  readonly refreshToken: string;
  readonly accessTokenExpiresAt: string;
  readonly emailVerificationRequired: false;
}

interface IssuedTokens {
  readonly accessToken: string;
  readonly refreshToken: string;
  readonly refreshTokenHash: string;
  readonly refreshTokenId: string;
  readonly familyId: string;
  readonly accessTokenExpiresAt: string;
  readonly refreshTokenExpiresAt: Date;
}

type RefreshOutcome =
  | { readonly kind: "rotated"; readonly userId: string }
  | { readonly kind: "reused" }
  | { readonly kind: "invalid" };

export const authService = {
  async register(input: RegisterInput): Promise<SessionResponse> {
    const email = normalizeEmail(input.email);
    if (await findUserByEmail(email)) throw emailTaken();
    const config = await gameConfigService.active();
    const userId = createId("usr");
    const timestamp = now();
    const issuedTokens = await issueTokens(userId, timestamp);
    const passwordHash = await hashPassword(input.password);

    try {
      const user = await withTransaction(async (transaction) => {
        const account = await createRegisteredAccount(transaction, {
          userId,
          email,
          passwordHash,
          displayName: input.displayName,
          locale: input.locale,
          timezone: input.timezone ?? "UTC",
          inventory: config.items.map((item) => ({
            itemCode: item.code,
            quantity: config.rules.startingItemStock,
          })),
        });
        await createRefreshToken(transaction, {
          id: issuedTokens.refreshTokenId,
          userId,
          tokenHash: issuedTokens.refreshTokenHash,
          familyId: issuedTokens.familyId,
          expiresAt: issuedTokens.refreshTokenExpiresAt,
        });
        return account;
      });
      if (!user.profile) throw new Error("Registered account has no profile.");
      return {
        user: {
          id: user.id,
          displayName: user.profile.displayName,
          email: user.email,
          emailVerified: user.emailVerified,
          locale: user.profile.locale,
        },
        accessToken: issuedTokens.accessToken,
        refreshToken: issuedTokens.refreshToken,
        accessTokenExpiresAt: issuedTokens.accessTokenExpiresAt,
        emailVerificationRequired: false,
      };
    } catch (error) {
      if (isEmailUniqueConflict(error)) throw emailTaken();
      throw error;
    }
  },

  async login(input: LoginInput): Promise<SessionResponse> {
    const email = normalizeEmail(input.email);
    const user = await findUserByEmail(email);
    if (!user) {
      await hashPassword(input.password);
      throw invalidCredentials();
    }

    const passwordMatches = await verifyPassword(input.password, user.passwordHash);
    const profile = user.profile;
    if (!passwordMatches || user.status !== "active" || !profile) {
      throw invalidCredentials();
    }

    const timestamp = now();
    const issuedTokens = await issueTokens(user.id, timestamp);
    await withTransaction((transaction) =>
      createRefreshToken(transaction, {
        id: issuedTokens.refreshTokenId,
        userId: user.id,
        tokenHash: issuedTokens.refreshTokenHash,
        familyId: issuedTokens.familyId,
        expiresAt: issuedTokens.refreshTokenExpiresAt,
      }),
    );
    return {
      user: {
        id: user.id,
        displayName: profile.displayName,
        email: user.email,
        emailVerified: user.emailVerified,
        locale: profile.locale,
      },
      accessToken: issuedTokens.accessToken,
      refreshToken: issuedTokens.refreshToken,
      accessTokenExpiresAt: issuedTokens.accessTokenExpiresAt,
      emailVerificationRequired: false,
    };
  },

  async loginWithGoogle(input: GoogleAuthInput): Promise<SessionResponse> {
    const claims = await verifyGoogleIdToken(input.idToken);
    const email = normalizeEmail(claims.email);
    const identity = await prisma.googleIdentity.findUnique({
      where: { googleSubject: claims.subject },
      include: { user: { include: { profile: true } } },
    });

    let sessionUser: SessionResponse["user"];
    if (identity) {
      const user = identity.user;
      if (user.status !== "active" || !user.profile) throw unauthorized();
      sessionUser = {
        id: user.id,
        displayName: user.profile.displayName,
        email: user.email,
        emailVerified: true,
        locale: user.profile.locale,
      };
    } else {
      const existingUser = await findUserByEmail(email);
      if (existingUser) {
        if (existingUser.status !== "active" || !existingUser.profile) {
          throw unauthorized();
        }
        await withTransaction(async (transaction) => {
          await transaction.user.update({
            where: { id: existingUser.id },
            data: { emailVerified: true },
          });
          await transaction.googleIdentity.create({
            data: {
              googleSubject: claims.subject,
              userId: existingUser.id,
              email,
            },
          });
        });
        sessionUser = {
          id: existingUser.id,
          displayName: existingUser.profile.displayName,
          email: existingUser.email,
          emailVerified: true,
          locale: existingUser.profile.locale,
        };
      } else {
        const config = await gameConfigService.active();
        const userId = createId("usr");
        const timestamp = now();
        const issuedTokens = await issueTokens(userId, timestamp);
        const passwordHash = await hashPassword(randomBytes(48).toString("base64url"));
        const displayName = googleDisplayName(claims.name, email);
        const locale = input.locale ?? "en";
        const created = await withTransaction(async (transaction) => {
          const account = await createRegisteredAccount(transaction, {
            userId,
            email,
            passwordHash,
            displayName,
            locale,
            timezone: input.timezone ?? "UTC",
            inventory: config.items.map((item) => ({
              itemCode: item.code,
              quantity: config.rules.startingItemStock,
            })),
          });
          await transaction.user.update({
            where: { id: userId },
            data: { emailVerified: true },
          });
          await transaction.googleIdentity.create({
            data: { googleSubject: claims.subject, userId, email },
          });
          await createRefreshToken(transaction, {
            id: issuedTokens.refreshTokenId,
            userId,
            tokenHash: issuedTokens.refreshTokenHash,
            familyId: issuedTokens.familyId,
            expiresAt: issuedTokens.refreshTokenExpiresAt,
          });
          return account;
        });
        sessionUser = {
          id: created.id,
          displayName: created.profile!.displayName,
          email: created.email,
          emailVerified: true,
          locale: created.profile!.locale,
        };
        return {
          user: sessionUser,
          accessToken: issuedTokens.accessToken,
          refreshToken: issuedTokens.refreshToken,
          accessTokenExpiresAt: issuedTokens.accessTokenExpiresAt,
          emailVerificationRequired: false,
        };
      }
    }

    const timestamp = now();
    const issuedTokens = await issueTokens(sessionUser.id, timestamp);
    await withTransaction((transaction) =>
      createRefreshToken(transaction, {
        id: issuedTokens.refreshTokenId,
        userId: sessionUser.id,
        tokenHash: issuedTokens.refreshTokenHash,
        familyId: issuedTokens.familyId,
        expiresAt: issuedTokens.refreshTokenExpiresAt,
      }),
    );
    return {
      user: sessionUser,
      accessToken: issuedTokens.accessToken,
      refreshToken: issuedTokens.refreshToken,
      accessTokenExpiresAt: issuedTokens.accessTokenExpiresAt,
      emailVerificationRequired: false,
    };
  },

  async refresh(refreshToken: string): Promise<{
    readonly accessToken: string;
    readonly refreshToken: string;
    readonly accessTokenExpiresAt: string;
  }> {
    const timestamp = now();
    const nextCredential = createRefreshTokenCredential();
    const nextTokenId = createId("rt");
    const outcome = await withTransaction(
      async (transaction): Promise<RefreshOutcome> => {
        const current = await findRefreshTokenByHash(
          hashRefreshToken(refreshToken),
          transaction,
        );
        if (!current) return { kind: "invalid" };
        if (current.revokedAt) {
          if (current.replacedBy) {
            await revokeRefreshFamily(transaction, current.familyId, timestamp);
            return { kind: "reused" };
          }
          return { kind: "invalid" };
        }
        if (current.user.status !== "active") {
          await revokeRefreshFamily(transaction, current.familyId, timestamp);
          return { kind: "invalid" };
        }
        if (current.expiresAt <= timestamp) return { kind: "invalid" };

        const rotated = await rotateRefreshToken(transaction, {
          id: current.id,
          nextId: nextTokenId,
          now: timestamp,
        });
        if (rotated.count !== 1) {
          const latest = await findRefreshTokenById(transaction, current.id);
          if (latest?.revokedAt && latest.replacedBy) {
            await revokeRefreshFamily(transaction, latest.familyId, timestamp);
            return { kind: "reused" };
          }
          if (latest?.revokedAt) return { kind: "invalid" };
          return { kind: "invalid" };
        }

        await createRefreshToken(transaction, {
          id: nextTokenId,
          userId: current.userId,
          tokenHash: nextCredential.tokenHash,
          familyId: current.familyId,
          expiresAt: new Date(timestamp.getTime() + REFRESH_TOKEN_TTL_MS),
        });
        return { kind: "rotated", userId: current.userId };
      },
    );

    if (outcome.kind === "reused") {
      throw new AppError(
        401,
        ERROR_CODES.REFRESH_TOKEN_REUSED,
        idMessages.errors.refreshTokenReused,
      );
    }
    if (outcome.kind === "invalid") throw unauthorized();
    const issued = await signAccessToken(outcome.userId, timestamp);
    return {
      accessToken: issued,
      refreshToken: nextCredential.token,
      accessTokenExpiresAt: accessTokenExpiry(timestamp),
    };
  },

  async logout(
    userId: string,
    refreshToken: string,
  ): Promise<{ readonly loggedOut: true }> {
    await withTransaction((transaction) =>
      revokeUserRefreshToken(transaction, {
        userId,
        tokenHash: hashRefreshToken(refreshToken),
        now: now(),
      }),
    );
    return { loggedOut: true };
  },

  async authenticate(accessToken: string): Promise<string> {
    const userId = await verifyAccessToken(accessToken, now());
    const user = await findUserById(userId);
    if (!user || user.status !== "active") throw unauthorized();
    return user.id;
  },
};

async function issueTokens(userId: string, timestamp: Date): Promise<IssuedTokens> {
  const credential = createRefreshTokenCredential();
  return {
    accessToken: await signAccessToken(userId, timestamp),
    refreshToken: credential.token,
    refreshTokenHash: credential.tokenHash,
    refreshTokenId: createId("rt"),
    familyId: createId("fam"),
    accessTokenExpiresAt: accessTokenExpiry(timestamp),
    refreshTokenExpiresAt: new Date(timestamp.getTime() + REFRESH_TOKEN_TTL_MS),
  };
}

function accessTokenExpiry(timestamp: Date): string {
  return new Date(timestamp.getTime() + ACCESS_TOKEN_TTL_SECONDS * 1000).toISOString();
}

function normalizeEmail(email: string): string {
  return email.trim().toLowerCase();
}

function googleDisplayName(name: string | null, email: string): string {
  const candidate = (name?.trim() || email.split("@")[0] || "Runner").slice(0, 30);
  return candidate.length >= 2 ? candidate : "Runner";
}

function isEmailUniqueConflict(error: unknown): boolean {
  if (
    !(error instanceof Prisma.PrismaClientKnownRequestError) ||
    error.code !== "P2002"
  ) {
    return false;
  }
  const target = error.meta?.target;
  return Array.isArray(target)
    ? target.some((field) => String(field).toLowerCase().includes("email"))
    : typeof target === "string" && target.toLowerCase().includes("email");
}

function emailTaken(): AppError {
  return new AppError(409, ERROR_CODES.EMAIL_TAKEN, idMessages.errors.emailTaken);
}

function invalidCredentials(): AppError {
  return new AppError(
    401,
    ERROR_CODES.INVALID_CREDENTIALS,
    idMessages.errors.invalidCredentials,
  );
}

function unauthorized(): AppError {
  return new AppError(401, ERROR_CODES.UNAUTHORIZED, idMessages.errors.unauthorized);
}

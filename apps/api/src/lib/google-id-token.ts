import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { env } from "../config/env";
import type { createRemoteJWKSet } from "jose" with { "resolution-mode": "import" };

export interface GoogleIdentityClaims {
  readonly subject: string;
  readonly email: string;
  readonly name: string | null;
}

let googleJwks: ReturnType<typeof createRemoteJWKSet> | undefined;

export async function verifyGoogleIdToken(token: string): Promise<GoogleIdentityClaims> {
  if (!env.GOOGLE_CLIENT_ID) {
    throw new AppError(
      503,
      ERROR_CODES.GOOGLE_AUTH_UNAVAILABLE,
      "Google sign-in is not configured.",
    );
  }

  try {
    const jose = await import("jose");
    googleJwks ??= jose.createRemoteJWKSet(
      new URL("https://www.googleapis.com/oauth2/v3/certs"),
    );
    const { payload } = await jose.jwtVerify(token, googleJwks, {
      algorithms: ["RS256"],
      audience: env.GOOGLE_CLIENT_ID,
      issuer: ["https://accounts.google.com", "accounts.google.com"],
    });
    if (
      typeof payload.sub !== "string" ||
      typeof payload.email !== "string" ||
      payload.email_verified !== true
    ) {
      throw new Error("Google token lacks a verified account identity.");
    }
    return {
      subject: payload.sub,
      email: payload.email,
      name: typeof payload.name === "string" ? payload.name : null,
    };
  } catch {
    throw new AppError(
      401,
      ERROR_CODES.INVALID_GOOGLE_TOKEN,
      "Google ID token is invalid.",
    );
  }
}

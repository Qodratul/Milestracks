import { createHash, randomBytes } from "node:crypto";

export interface RefreshTokenCredential {
  readonly token: string;
  readonly tokenHash: string;
}

export function createRefreshTokenCredential(): RefreshTokenCredential {
  const token = "rt_" + randomBytes(32).toString("base64url");
  return { token, tokenHash: hashRefreshToken(token) };
}

export function hashRefreshToken(token: string): string {
  return createHash("sha256").update(token).digest("hex");
}

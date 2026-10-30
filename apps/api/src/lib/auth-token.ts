import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { idMessages } from "../i18n";
import { env } from "../config/env";

export const ACCESS_TOKEN_TTL_SECONDS = 15 * 60;
const JWT_ISSUER = "milestride-api";

function signingKey(): Uint8Array {
  if (!env.JWT_SECRET) {
    throw new AppError(
      503,
      ERROR_CODES.SERVICE_UNAVAILABLE,
      idMessages.errors.serviceUnavailable,
      {
        dependency: "jwt_secret",
      },
    );
  }
  return new TextEncoder().encode(env.JWT_SECRET);
}

export async function signAccessToken(userId: string, issuedAt: Date): Promise<string> {
  const { SignJWT } = await import("jose");
  const issuedAtSeconds = Math.floor(issuedAt.getTime() / 1000);
  return new SignJWT({})
    .setProtectedHeader({ alg: "HS256", typ: "JWT" })
    .setIssuer(JWT_ISSUER)
    .setSubject(userId)
    .setIssuedAt(issuedAtSeconds)
    .setExpirationTime(issuedAtSeconds + ACCESS_TOKEN_TTL_SECONDS)
    .sign(signingKey());
}

export async function verifyAccessToken(
  token: string,
  currentDate: Date,
): Promise<string> {
  const { errors, jwtVerify } = await import("jose");
  try {
    const result = await jwtVerify(token, signingKey(), {
      algorithms: ["HS256"],
      issuer: JWT_ISSUER,
      currentDate,
    });
    if (!result.payload.sub) throw unauthorized();
    return result.payload.sub;
  } catch (error) {
    if (error instanceof AppError) throw error;
    if (error instanceof errors.JWTExpired) {
      throw new AppError(401, ERROR_CODES.TOKEN_EXPIRED, idMessages.errors.tokenExpired);
    }
    throw unauthorized();
  }
}

function unauthorized(): AppError {
  return new AppError(401, ERROR_CODES.UNAUTHORIZED, idMessages.errors.unauthorized);
}

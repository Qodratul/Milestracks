import type { Request } from "express";
import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { idMessages } from "../i18n";

export function requireUserId(request: Request): string {
  const userId = request.user?.id;
  if (!userId) {
    throw new AppError(401, ERROR_CODES.UNAUTHORIZED, idMessages.errors.unauthorized);
  }
  return userId;
}

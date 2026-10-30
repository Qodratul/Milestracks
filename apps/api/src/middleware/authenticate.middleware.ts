import type { RequestHandler } from "express";
import { authService } from "../services/auth.service";
import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { idMessages } from "../i18n";
import { asyncHandler } from "./async-handler";

export const authenticate: RequestHandler = asyncHandler(
  async (request, _response, next) => {
    const authorization = request.get("authorization");
    const token = authorization?.match(/^Bearer\s+(\S+)$/i)?.[1];
    if (!token) {
      next(new AppError(401, ERROR_CODES.UNAUTHORIZED, idMessages.errors.unauthorized));
      return;
    }
    request.user = { id: await authService.authenticate(token) };
    next();
  },
);

export const authenticateStub: RequestHandler = (request, _response, next) => {
  const authorization = request.get("authorization");
  if (!authorization || !/^Bearer\s+\S+$/i.test(authorization)) {
    next(new AppError(401, ERROR_CODES.UNAUTHORIZED, idMessages.errors.unauthorized));
    return;
  }
  next();
};

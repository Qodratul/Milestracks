import type { RequestHandler } from "express";
import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { idMessages } from "../i18n";
import { sendOk } from "../middleware/response";
import { asyncHandler } from "../middleware/async-handler";
import { authService } from "../services/auth.service";
import type { LoginInput, RegisterInput } from "../types/auth";

export const authController = {
  register: asyncHandler(async (request, response) => {
    const result = await authService.register(request.body as RegisterInput);
    sendOk(response, result, 201);
  }) as RequestHandler,

  login: asyncHandler(async (request, response) => {
    const result = await authService.login(request.body as LoginInput);
    sendOk(response, result);
  }) as RequestHandler,

  loginWithGoogle: asyncHandler(async (request, response) => {
    const result = await authService.loginWithGoogle(request.body);
    sendOk(response, result);
  }) as RequestHandler,

  refresh: asyncHandler(async (request, response) => {
    const body = request.body as { readonly refreshToken: string };
    sendOk(response, await authService.refresh(body.refreshToken));
  }) as RequestHandler,

  logout: asyncHandler(async (request, response) => {
    const userId = request.user?.id;
    if (!userId) {
      throw new AppError(401, ERROR_CODES.UNAUTHORIZED, idMessages.errors.unauthorized);
    }
    const body = request.body as { readonly refreshToken: string };
    sendOk(response, await authService.logout(userId, body.refreshToken));
  }) as RequestHandler,
};

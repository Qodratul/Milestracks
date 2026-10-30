import type { RequestHandler } from "express";
import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { idMessages } from "../i18n";
import { asyncHandler } from "../middleware/async-handler";
import { sendOk } from "../middleware/response";
import { accountService } from "../services/account.service";
import type { OnboardingInput } from "../types/account";

export const accountController = {
  getMe: asyncHandler(async (request, response) => {
    sendOk(response, await accountService.getMe(requireUserId(request)));
  }) as RequestHandler,

  getHomeSummary: asyncHandler(async (request, response) => {
    sendOk(response, await accountService.getHomeSummary(requireUserId(request)));
  }) as RequestHandler,

  getWallet: asyncHandler(async (request, response) => {
    sendOk(response, await accountService.getWallet(requireUserId(request)));
  }) as RequestHandler,

  updateOnboarding: asyncHandler(async (request, response) => {
    sendOk(
      response,
      await accountService.updateOnboarding(
        requireUserId(request),
        request.body as OnboardingInput,
      ),
    );
  }) as RequestHandler,
};

function requireUserId(request: Parameters<RequestHandler>[0]): string {
  const userId = request.user?.id;
  if (!userId) {
    throw new AppError(401, ERROR_CODES.UNAUTHORIZED, idMessages.errors.unauthorized);
  }
  return userId;
}

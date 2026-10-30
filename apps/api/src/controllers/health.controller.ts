import type { RequestHandler } from "express";
import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { asyncHandler } from "../middleware/async-handler";
import { sendOk } from "../middleware/response";
import { checkReadiness } from "../services/health.service";
import { idMessages } from "../i18n";
import { API_VERSION } from "../types/api";

export const getHealth: RequestHandler = (_request, response) => {
  sendOk(response, {
    status: "ok",
    uptimeSec: Math.floor(process.uptime()),
    version: API_VERSION,
  });
};

export const getReadiness: RequestHandler = asyncHandler(async (_request, response) => {
  if (!(await checkReadiness())) {
    throw new AppError(
      503,
      ERROR_CODES.SERVICE_UNAVAILABLE,
      idMessages.errors.serviceUnavailable,
      { checks: { postgres: "unavailable" } },
    );
  }
  sendOk(response, { status: "ready", checks: { postgres: "ok" } });
});

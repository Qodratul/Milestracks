import type { ErrorRequestHandler } from "express";
import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { logger } from "../lib/logger";
import { idMessages } from "../i18n";

export const errorMiddleware: ErrorRequestHandler = (
  error: unknown,
  request,
  response,
  next,
) => {
  if (response.headersSent) {
    next(error);
    return;
  }
  const header = response.getHeader("X-Request-Id");
  const requestId = typeof header === "string" ? header : "req_unknown";
  if (error instanceof AppError) {
    logger.warn(
      {
        requestId,
        method: request.method,
        path: request.path,
        code: error.code,
        statusCode: error.statusCode,
      },
      "Request rejected",
    );
    response.status(error.statusCode).json({
      error: {
        code: error.code,
        message: error.message,
        ...(error.details === undefined ? {} : { details: error.details }),
        requestId,
      },
    });
    return;
  }
  logger.error(
    {
      requestId,
      method: request.method,
      path: request.path,
      ...safeErrorMetadata(error),
    },
    "Unhandled request error",
  );
  response.status(500).json({
    error: {
      code: ERROR_CODES.INTERNAL_ERROR,
      message: idMessages.errors.internal,
      requestId,
    },
  });
};

function safeErrorMetadata(error: unknown): Record<string, string> {
  if (!(error instanceof Error)) return { errorType: typeof error };

  const metadata: Record<string, string> = { errorType: error.name };
  const candidate = error as Error & { code?: unknown; meta?: unknown };
  const frames = candidate.stack
    ?.split("\n")
    .slice(1, 21)
    .map((frame) => frame.trim());
  if (frames?.length) metadata.errorFrames = frames.join(" | ");
  if (typeof candidate.code === "string" && /^[A-Z0-9_]{3,32}$/.test(candidate.code)) {
    metadata.errorCode = candidate.code;
  }
  if (typeof candidate.meta === "object" && candidate.meta !== null) {
    const databaseCode = (candidate.meta as { code?: unknown }).code;
    if (typeof databaseCode === "string" && /^[0-9A-Z]{5}$/.test(databaseCode)) {
      metadata.databaseCode = databaseCode;
    }
  }
  return metadata;
}

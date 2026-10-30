import { createHash } from "node:crypto";
import type { RequestHandler, Response } from "express";
import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { idMessages } from "../i18n";
import { logger } from "../lib/logger";
import { idempotencyService } from "../services/idempotency.service";
import { IdempotencyHeaderSchema } from "../validators/api.validator";

export function requireIdempotencyKey(required = true): RequestHandler {
  return (request, _response, next) => {
    const key = request.get("Idempotency-Key");
    if (!key) {
      if (required) {
        next(
          new AppError(
            400,
            ERROR_CODES.IDEMPOTENCY_KEY_REQUIRED,
            idMessages.errors.idempotencyKeyRequired,
            {
              fields: [
                {
                  path: "header.Idempotency-Key",
                  message: idMessages.errors.idempotencyKeyRequired,
                },
              ],
            },
          ),
        );
        return;
      }
      next();
      return;
    }
    if (!IdempotencyHeaderSchema.safeParse(key).success) {
      next(
        new AppError(400, ERROR_CODES.VALIDATION_ERROR, idMessages.errors.validation, {
          fields: [
            {
              path: "header.Idempotency-Key",
              message: idMessages.errors.idempotencyKeyInvalid,
            },
          ],
        }),
      );
      return;
    }
    next();
  };
}

export const idempotency: RequestHandler = (request, response, next) => {
  const key = request.get("Idempotency-Key");
  if (!key) {
    next();
    return;
  }
  const parsedKey = IdempotencyHeaderSchema.safeParse(key);
  if (!parsedKey.success) {
    next(new AppError(400, ERROR_CODES.VALIDATION_ERROR, idMessages.errors.validation));
    return;
  }
  const userId = request.user?.id;
  if (!userId) {
    next(new AppError(401, ERROR_CODES.UNAUTHORIZED, idMessages.errors.unauthorized));
    return;
  }

  const route = `${request.method}:${request.baseUrl}${request.path}`;
  const requestHash = hashRequest({
    method: request.method,
    path: request.path,
    query: request.query,
    body: request.body,
  });
  void reserveAndHandle({
    userId,
    key: parsedKey.data,
    route,
    requestHash,
    response,
    next,
  });
};

async function reserveAndHandle(input: {
  readonly userId: string;
  readonly key: string;
  readonly route: string;
  readonly requestHash: string;
  readonly response: Response;
  readonly next: (error?: unknown) => void;
}): Promise<void> {
  let stage = "reserve_key";
  try {
    const reservation = await idempotencyService.reserve({
      userId: input.userId,
      key: input.key,
      route: input.route,
      requestHash: input.requestHash,
    });
    if (reservation.kind === "replay") {
      input.response.status(reservation.statusCode).json(reservation.response);
      return;
    }
    interceptJsonResponse(input.response, reservation.id, input.next);
    stage = "next_handler";
    input.next();
  } catch (error) {
    logger.error(
      { stage, errorType: error instanceof Error ? error.name : typeof error },
      "Idempotency request handling failed",
    );
    input.next(error);
  }
}

function interceptJsonResponse(
  response: Response,
  recordId: string,
  next: (error?: unknown) => void,
): void {
  const originalJson = response.json.bind(response);
  let intercepted = false;
  response.json = ((body: unknown) => {
    if (intercepted) return originalJson(body as never);
    intercepted = true;
    if (response.statusCode >= 500) {
      releaseAndSend({ recordId, originalJson, body });
      return response;
    }
    persistAndSend({
      response,
      recordId,
      originalJson,
      body,
      next,
      statusCode: response.statusCode,
    });
    return response;
  }) as Response["json"];
}

function releaseAndSend(input: {
  readonly recordId: string;
  readonly originalJson: Response["json"];
  readonly body: unknown;
}): void {
  void idempotencyService
    .release(input.recordId)
    .catch((error: unknown) => {
      logger.error({ code: errorCode(error) }, "Could not release idempotency key");
    })
    .finally(() => input.originalJson(input.body as never));
}

function persistAndSend(input: {
  readonly response: Response;
  readonly recordId: string;
  readonly originalJson: Response["json"];
  readonly body: unknown;
  readonly next: (error?: unknown) => void;
  readonly statusCode: number;
}): void {
  void idempotencyService
    .complete({
      id: input.recordId,
      response: input.body,
      statusCode: input.statusCode,
    })
    .then(() => input.originalJson(input.body as never))
    .catch((error: unknown) => {
      logger.error({ code: errorCode(error) }, "Could not persist idempotency response");
      input.response.json = input.originalJson;
      void idempotencyService
        .release(input.recordId)
        .catch((releaseError: unknown) => {
          logger.error(
            { code: errorCode(releaseError) },
            "Could not release idempotency key",
          );
        })
        .finally(() => input.next(error));
    });
}

function hashRequest(value: unknown): string {
  return createHash("sha256").update(canonicalJson(value)).digest("hex");
}

function canonicalJson(value: unknown): string {
  if (Array.isArray(value)) {
    return `[${value.map((entry) => canonicalJson(entry)).join(",")}]`;
  }
  if (value !== null && typeof value === "object") {
    const entries = Object.entries(value as Record<string, unknown>).sort(
      ([left], [right]) => (left < right ? -1 : left > right ? 1 : 0),
    );
    return `{${entries
      .map(([key, entry]) => `${JSON.stringify(key)}:${canonicalJson(entry)}`)
      .join(",")}}`;
  }
  return JSON.stringify(value) ?? "null";
}

function errorCode(error: unknown): string {
  return error instanceof Error ? error.name : "unknown";
}

export const requireIdempotencyKeyStub = requireIdempotencyKey;

import { Prisma } from "@prisma/client";
import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { idMessages } from "../i18n";
import { now } from "../lib/clock";
import {
  completeIdempotencyRecord,
  createIdempotencyRecord,
  deleteExpiredIdempotencyRecords,
  deleteIdempotencyRecord,
  findIdempotencyRecord,
} from "../repositories/idempotency.repository";
import { logger } from "../lib/logger";

const IDEMPOTENCY_TTL_MS = 24 * 60 * 60 * 1_000;
const EXPIRED_RECORD_CLEANUP_INTERVAL_MS = 60 * 60 * 1_000;
let lastCleanupAtMs = 0;

export type IdempotencyReservation =
  | { readonly kind: "reserved"; readonly id: string }
  | {
      readonly kind: "replay";
      readonly response: Prisma.JsonValue;
      readonly statusCode: number;
    };

export const idempotencyService = {
  async reserve(input: {
    readonly userId: string;
    readonly key: string;
    readonly route: string;
    readonly requestHash: string;
  }): Promise<IdempotencyReservation> {
    const timestamp = now();
    let stage = "cleanup_expired";
    try {
      await cleanExpiredRecords(timestamp);
      stage = "find_existing_key";
      const existing = await findIdempotencyRecord(input);
      if (existing) {
        if (existing.expiresAt <= timestamp) {
          stage = "delete_expired_key";
          await deleteIdempotencyRecord(existing.id);
        } else {
          return existingReservation(existing, input.requestHash);
        }
      }

      stage = "create_key";
      try {
        const record = await createIdempotencyRecord({
          ...input,
          expiresAt: new Date(timestamp.getTime() + IDEMPOTENCY_TTL_MS),
        });
        return { kind: "reserved", id: record.id };
      } catch (error) {
        if (!isUniqueConflict(error)) throw error;
        stage = "find_raced_key";
        const racedRecord = await findIdempotencyRecord(input);
        if (!racedRecord) throw error;
        return existingReservation(racedRecord, input.requestHash);
      }
    } catch (error) {
      logger.error(
        {
          stage,
          errorType: error instanceof Error ? error.name : typeof error,
          ...(error instanceof Prisma.PrismaClientKnownRequestError
            ? { prismaCode: error.code }
            : {}),
        },
        "Idempotency key reservation failed",
      );
      throw error;
    }
  },

  async complete(input: {
    readonly id: string;
    readonly response: unknown;
    readonly statusCode: number;
  }): Promise<void> {
    const serialized = JSON.stringify(input.response);
    if (serialized === undefined) throw new Error("Response is not JSON serializable.");
    await completeIdempotencyRecord({
      id: input.id,
      response: JSON.parse(serialized) as Prisma.InputJsonValue,
      statusCode: input.statusCode,
    });
  },

  release(id: string): Promise<void> {
    return deleteIdempotencyRecord(id);
  },
};

async function cleanExpiredRecords(timestamp: Date): Promise<void> {
  const currentTimeMs = timestamp.getTime();
  if (currentTimeMs - lastCleanupAtMs < EXPIRED_RECORD_CLEANUP_INTERVAL_MS) return;
  lastCleanupAtMs = currentTimeMs;
  try {
    await deleteExpiredIdempotencyRecords(timestamp);
  } catch (error) {
    logger.warn(
      { errorType: error instanceof Error ? error.name : typeof error },
      "Could not clean expired idempotency keys; continuing request",
    );
  }
}

function existingReservation(
  record: NonNullable<Awaited<ReturnType<typeof findIdempotencyRecord>>>,
  requestHash: string,
): IdempotencyReservation {
  if (record.requestHash !== requestHash) {
    throw new AppError(
      422,
      ERROR_CODES.IDEMPOTENCY_KEY_REUSED,
      idMessages.errors.idempotencyKeyReused,
    );
  }
  if (
    record.state !== "completed" ||
    record.response === null ||
    record.statusCode === null
  ) {
    throw new AppError(
      409,
      ERROR_CODES.IDEMPOTENCY_IN_PROGRESS,
      idMessages.errors.idempotencyInProgress,
      { retryAfterMs: 500 },
    );
  }
  return {
    kind: "replay",
    response: record.response,
    statusCode: record.statusCode,
  };
}

function isUniqueConflict(error: unknown): boolean {
  return error instanceof Prisma.PrismaClientKnownRequestError && error.code === "P2002";
}

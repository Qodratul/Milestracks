import type { Prisma } from "@prisma/client";
import { prisma } from "../lib/prisma";

export interface IdempotencyRecord {
  readonly id: string;
  readonly requestHash: string;
  readonly state: "processing" | "completed";
  readonly response: Prisma.JsonValue | null;
  readonly statusCode: number | null;
  readonly expiresAt: Date;
}

export async function createIdempotencyRecord(input: {
  readonly userId: string;
  readonly key: string;
  readonly route: string;
  readonly requestHash: string;
  readonly expiresAt: Date;
}): Promise<{ readonly id: string }> {
  return prisma.idempotencyKey.create({
    data: input,
    select: { id: true },
  });
}

export async function findIdempotencyRecord(input: {
  readonly userId: string;
  readonly key: string;
  readonly route: string;
}): Promise<IdempotencyRecord | null> {
  return prisma.idempotencyKey.findUnique({
    where: {
      userId_key_route: {
        userId: input.userId,
        key: input.key,
        route: input.route,
      },
    },
    select: {
      id: true,
      requestHash: true,
      state: true,
      response: true,
      statusCode: true,
      expiresAt: true,
    },
  });
}

export async function deleteIdempotencyRecord(id: string): Promise<void> {
  await prisma.idempotencyKey.deleteMany({ where: { id } });
}

export async function deleteExpiredIdempotencyRecords(before: Date): Promise<void> {
  await prisma.idempotencyKey.deleteMany({ where: { expiresAt: { lte: before } } });
}

export async function completeIdempotencyRecord(input: {
  readonly id: string;
  readonly response: Prisma.InputJsonValue;
  readonly statusCode: number;
}): Promise<void> {
  await prisma.idempotencyKey.update({
    where: { id: input.id },
    data: {
      response: input.response,
      statusCode: input.statusCode,
      state: "completed",
    },
  });
}

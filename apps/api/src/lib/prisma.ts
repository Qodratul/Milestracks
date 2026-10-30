import { PrismaClient } from "@prisma/client";
import type { Prisma } from "@prisma/client";
import { env } from "../config/env";

const CONNECTION_POOL_SIZE = 5;
const TRANSACTION_MAX_WAIT_MS = 5_000;
const TRANSACTION_TIMEOUT_MS = 15_000;
const pooledUrl = withConnectionLimit(env.DATABASE_URL);
const directUrl = withConnectionLimit(env.DIRECT_URL ?? env.DATABASE_URL);

interface PrismaGlobal {
  pooledClient?: PrismaClient;
  directClient?: PrismaClient;
}

const prismaGlobal = globalThis as typeof globalThis & PrismaGlobal;

export const prisma =
  prismaGlobal.pooledClient ?? new PrismaClient({ datasourceUrl: pooledUrl });
if (env.NODE_ENV !== "production") prismaGlobal.pooledClient = prisma;

export const txDirect =
  directUrl === pooledUrl
    ? prisma
    : (prismaGlobal.directClient ?? new PrismaClient({ datasourceUrl: directUrl }));
if (env.NODE_ENV !== "production") prismaGlobal.directClient = txDirect;

export type Tx = Prisma.TransactionClient;

export async function withTransaction<T>(
  operation: (transaction: Tx) => Promise<T>,
): Promise<T> {
  return txDirect.$transaction(operation, {
    maxWait: TRANSACTION_MAX_WAIT_MS,
    timeout: TRANSACTION_TIMEOUT_MS,
  });
}

export async function closePrisma(): Promise<void> {
  const clients = new Set([prisma, txDirect]);
  await Promise.all([...clients].map((client) => client.$disconnect()));
}

function withConnectionLimit(connectionString: string): string {
  const connectionUrl = new URL(connectionString);
  if (!connectionUrl.searchParams.has("connection_limit")) {
    connectionUrl.searchParams.set("connection_limit", String(CONNECTION_POOL_SIZE));
  }
  return connectionUrl.toString();
}

import "./instrument";
import { app } from "./app";
import { env } from "./config/env";
import { logger } from "./lib/logger";
import { closePrisma } from "./lib/prisma";
import { Sentry } from "./instrument";
import { refreshFastModelCapabilities } from "./providers/llm/model-catalog";
import { recoverRouteGenerationJobs } from "./workers/route-generation.worker";

export async function startServer(): Promise<void> {
  if (!env.STUB_MODE) {
    const recoveredJobs = await recoverRouteGenerationJobs();
    logger.info({ recoveredJobs }, "Route generation jobs recovered");
  }
  void refreshFastModelCapabilities().then((capabilities) => {
    if (capabilities.available) {
      logger.info(
        {
          modelId: capabilities.modelId,
          supportedFeatures: capabilities.supportedFeatures,
          jsonSchema: capabilities.supportsJsonSchema,
        },
        "Nebius Fast Tier model verified",
      );
      return;
    }
    logger.warn(
      { failureCode: capabilities.failureCode },
      "Nebius Fast Tier model unavailable; narrative fallback remains active",
    );
  });
  const server = app.listen(env.PORT, env.HOST, () => {
    logger.info({ port: env.PORT, host: env.HOST }, "API listening");
  });
  let shuttingDown = false;
  const shutdown = async (signal: NodeJS.Signals): Promise<void> => {
    if (shuttingDown) return;
    shuttingDown = true;
    logger.info({ signal }, "Graceful shutdown started");
    const serverClosed = new Promise<void>((resolve, reject) => {
      server.close((error) => (error ? reject(error) : resolve()));
    });
    try {
      await Promise.all([serverClosed, closePrisma(), Sentry.close(2_000)]);
      logger.info({ signal }, "Graceful shutdown complete");
    } catch {
      logger.error({ signal }, "Graceful shutdown failed");
      process.exitCode = 1;
    }
  };
  process.on("SIGINT", () => void shutdown("SIGINT"));
  process.on("SIGTERM", () => void shutdown("SIGTERM"));
}
if (require.main === module) {
  void startServer().catch((error: unknown) => {
    logger.fatal({ err: error }, "API startup failed");
    process.exitCode = 1;
  });
}

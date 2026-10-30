import cors from "cors";
import express from "express";
import type { Express } from "express";
import helmet from "helmet";
import pinoHttp from "pino-http";
import swaggerUi from "swagger-ui-express";
import { env } from "./config/env";
import { logger } from "./lib/logger";
import { openApiDocument } from "./openapi/document";
import { errorMiddleware } from "./middleware/error.middleware";
import { notFoundMiddleware } from "./middleware/not-found.middleware";
import { requestIdMiddleware } from "./middleware/request-id.middleware";
import { healthRouter } from "./routes/health.route";
import { apiRouter } from "./routes/api.route";
import { configRouter } from "./routes/config.route";
import { authRouter } from "./routes/auth.route";
import { accountRouter } from "./routes/account.route";
import { inventoryRouter } from "./routes/inventory.route";
import { loadoutRouter } from "./routes/loadout.route";
import { routeRouter } from "./routes/route.route";
import { runRouter } from "./routes/run.route";
import { achievementRouter } from "./routes/achievement.route";
import { shopRouter } from "./routes/shop.route";

export const app: Express = express();
app.disable("x-powered-by");
const isRailwayDeployment = Boolean(process.env.RAILWAY_ENVIRONMENT_NAME);
const trustProxy = env.NODE_ENV === "production" || isRailwayDeployment ? 1 : false;
app.set("trust proxy", trustProxy);
logger.info({ nodeEnv: env.NODE_ENV, trustProxy }, "HTTP proxy configuration loaded");
logger.info(
  {
    routingProvider: env.DEMO_MODE ? "mock" : env.ROUTING_PROVIDER,
    osmTagsProvider: env.OSM_TAGS_PROVIDER,
  },
  "Route providers configured",
);
app.use(requestIdMiddleware);
app.use(
  pinoHttp({
    logger,
    genReqId: (_request, response) => {
      const requestId = response.getHeader("X-Request-Id");
      return typeof requestId === "string" ? requestId : "req_unknown";
    },
    serializers: {
      req: (request) => ({ id: request.id, method: request.method }),
      res: (response) => ({ statusCode: response.statusCode }),
    },
  }),
);
app.use(helmet());
app.use(cors({ origin: env.CORS_ORIGIN || true }));
app.use(express.json({ limit: "1mb" }));
app.use(healthRouter);
app.get("/openapi.json", (_request, response) => response.json(openApiDocument));
app.use("/docs", swaggerUi.serve, swaggerUi.setup(openApiDocument));
if (env.STUB_MODE) {
  app.use("/api/v1", apiRouter);
} else {
  app.use("/api/v1", authRouter);
  app.use("/api/v1", accountRouter);
  app.use("/api/v1", achievementRouter);
  app.use("/api/v1", inventoryRouter);
  app.use("/api/v1", shopRouter);
  app.use("/api/v1", loadoutRouter);
  app.use("/api/v1", configRouter);
  app.use("/api/v1", routeRouter);
  app.use("/api/v1", runRouter);
}
app.use(notFoundMiddleware);
app.use(errorMiddleware);

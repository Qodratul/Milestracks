import { Router } from "express";
import rateLimit from "express-rate-limit";
import { API_ENDPOINTS } from "../contracts/endpoint.contracts";
import { routeController } from "../controllers/route.controller";
import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { idMessages } from "../i18n";
import { authenticate } from "../middleware/authenticate.middleware";
import { idempotency, requireIdempotencyKey } from "../middleware/idempotency.middleware";
import { validateRequest } from "../middleware/validate.middleware";

export const routeRouter: ReturnType<typeof Router> = Router();

const mysteryRouteRateLimitWindowMs = 60_000;
const mysteryRouteRateLimiter = rateLimit({
  windowMs: mysteryRouteRateLimitWindowMs,
  limit: 6,
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (request) => request.user?.id ?? "missing-user",
  handler: (_request, response) => {
    const header = response.getHeader("X-Request-Id");
    const requestId = typeof header === "string" ? header : "req_unknown";
    response.status(429).json({
      error: {
        code: ERROR_CODES.RATE_LIMITED,
        message: idMessages.errors.rateLimited,
        details: { retryAfterSec: 60 },
        requestId,
      },
    });
  },
});

const routeReportRateLimitWindowMs = 60 * 60 * 1000;
const routeReportRateLimiter = rateLimit({
  windowMs: routeReportRateLimitWindowMs,
  limit: 10,
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (request) => request.user?.id ?? "missing-user",
  handler: (_request, response) => {
    const header = response.getHeader("X-Request-Id");
    const requestId = typeof header === "string" ? header : "req_unknown";
    response.status(429).json({
      error: {
        code: ERROR_CODES.RATE_LIMITED,
        message: idMessages.errors.rateLimited,
        details: { retryAfterSec: 3600 },
        requestId,
      },
    });
  },
});

routeRouter.get("/routes/mystery/today", authenticate, routeController.today);
routeRouter.post(
  "/routes/mystery/generate",
  authenticate,
  mysteryRouteRateLimiter,
  validate("generateMysteryRoute"),
  requireIdempotencyKey(),
  idempotency,
  routeController.generate,
);
routeRouter.post(
  "/routes/mystery/regenerate",
  authenticate,
  mysteryRouteRateLimiter,
  validate("regenerateMysteryRoute"),
  requireIdempotencyKey(),
  idempotency,
  routeController.regenerate,
);
routeRouter.get(
  "/routes/:routeId/preview",
  authenticate,
  validate("getRoutePreview"),
  routeController.preview,
);
routeRouter.get(
  "/routes/:routeId/geometry",
  authenticate,
  validate("getRouteGeometry"),
  routeController.geometry,
);
routeRouter.post(
  "/routes/:routeId/reports",
  authenticate,
  validate("reportRoute"),
  routeReportRateLimiter,
  routeController.report,
);

function validate(operationId: string) {
  const contract = API_ENDPOINTS.find((endpoint) => endpoint.operationId === operationId);
  if (!contract) {
    throw new AppError(
      500,
      ERROR_CODES.INTERNAL_ERROR,
      "Missing API endpoint contract: " + operationId,
    );
  }
  return validateRequest(contract);
}

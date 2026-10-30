import { Router } from "express";
import type { RequestHandler } from "express";
import rateLimit from "express-rate-limit";
import { API_ENDPOINTS } from "../contracts/endpoint.contracts";
import { runController } from "../controllers/run.controller";
import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { idMessages } from "../i18n";
import { authenticate } from "../middleware/authenticate.middleware";
import { idempotency, requireIdempotencyKey } from "../middleware/idempotency.middleware";
import { validateRequest } from "../middleware/validate.middleware";

export const runRouter: ReturnType<typeof Router> = Router();

const locationRateLimit = rateLimit({
  windowMs: 60_000,
  limit: 60,
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (request) => request.user?.id + ":" + request.params.runId,
  handler: (_request, response) => {
    const value = response.getHeader("X-Request-Id");
    response.status(429).json({
      error: {
        code: ERROR_CODES.RATE_LIMITED,
        message: idMessages.errors.rateLimited,
        details: { retryAfterSec: 60 },
        requestId: typeof value === "string" ? value : "req_unknown",
      },
    });
  },
});

runRouter.post(
  "/runs",
  authenticate,
  validate("startRun"),
  requireIdempotencyKey(),
  idempotency,
  runController.start,
);
runRouter.get(
  "/runs/active",
  authenticate,
  validate("getActiveRun"),
  runController.active,
);
runRouter.get("/runs", authenticate, validate("listRuns"), runController.list);
runRouter.get("/runs/:runId", authenticate, validate("getRun"), runController.get);
runRouter.get(
  "/runs/:runId/trace",
  authenticate,
  validate("getRunTrace"),
  runController.trace,
);
runRouter.post(
  "/runs/:runId/pause",
  authenticate,
  validate("pauseRun"),
  runController.pause,
);
runRouter.post(
  "/runs/:runId/resume",
  authenticate,
  validate("resumeRun"),
  runController.resume,
);
runRouter.post(
  "/runs/:runId/locations",
  authenticate,
  locationRateLimit,
  locationPayloadLimit,
  validate("uploadRunLocations"),
  runController.locations,
);
runRouter.post(
  "/runs/:runId/milestones/:milestoneId/reach",
  authenticate,
  validate("reachMilestone"),
  requireIdempotencyKey(false),
  idempotency,
  runController.reach,
);
runRouter.post(
  "/runs/:runId/safe-stop",
  authenticate,
  validate("safeStopRun"),
  requireIdempotencyKey(false),
  idempotency,
  runController.safeStop,
);
runRouter.post(
  "/runs/:runId/finish",
  authenticate,
  validate("finishRun"),
  requireIdempotencyKey(false),
  idempotency,
  runController.finish,
);
runRouter.get(
  "/runs/:runId/summary",
  authenticate,
  validate("getRunSummary"),
  runController.summary,
);
runRouter.post(
  "/runs/:runId/claim",
  authenticate,
  validate("claimRunRewards"),
  requireIdempotencyKey(),
  idempotency,
  runController.claim,
);
runRouter.get(
  "/runs/:runId/guidance",
  authenticate,
  validate("getRunGuidance"),
  runController.guidance,
);

function locationPayloadLimit(
  request: Parameters<RequestHandler>[0],
  _response: Parameters<RequestHandler>[1],
  next: Parameters<RequestHandler>[2],
): void {
  const body = request.body as { samples?: unknown } | undefined;
  if (Array.isArray(body?.samples) && body.samples.length > 100) {
    next(
      new AppError(
        413,
        ERROR_CODES.PAYLOAD_TOO_LARGE,
        "Maksimal 100 sampel per permintaan.",
      ),
    );
    return;
  }
  next();
}

function validate(operationId: string) {
  const contract = API_ENDPOINTS.find((endpoint) => endpoint.operationId === operationId);
  if (!contract) {
    throw new AppError(
      500,
      ERROR_CODES.INTERNAL_ERROR,
      "Missing endpoint contract: " + operationId,
    );
  }
  return validateRequest(contract);
}

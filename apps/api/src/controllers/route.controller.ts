import type { RequestHandler } from "express";
import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { idMessages } from "../i18n";
import { asyncHandler } from "../middleware/async-handler";
import { sendOk, sendPage } from "../middleware/response";
import { routeGenerationService } from "../services/route-generation.service";
import { routeReadService } from "../services/route-read.service";
import { routeReportService } from "../services/route-report.service";
import type {
  GenerateRouteBody,
  GeometryQuerySchema,
  RegenerateRouteBodySchema,
  RouteReportBodySchema,
} from "../validators/api.validator";
import type { z } from "zod";
import { requireUserId } from "./require-user-id";

type RegenerateRouteBody = z.infer<typeof RegenerateRouteBodySchema>;
type RouteReportBody = z.infer<typeof RouteReportBodySchema>;
type GeometryQuery = z.infer<typeof GeometryQuerySchema>;

export const routeController = {
  today: asyncHandler(async (request, response) => {
    sendOk(response, await routeReadService.today(requireUserId(request)));
  }) as RequestHandler,

  generate: asyncHandler(async (request, response) => {
    const action = await routeGenerationService.request(
      requireUserId(request),
      request.body as GenerateRouteBody,
    );
    if (action.status === "generating") {
      sendOk(
        response,
        {
          routeId: action.routeId,
          status: "generating",
          pollAfterMs: 1500,
        },
        202,
      );
      return;
    }
    sendOk(
      response,
      await routeReadService.readySummary(action.routeId, requireUserId(request)),
    );
  }) as RequestHandler,

  regenerate: asyncHandler(async (request, response) => {
    const userId = requireUserId(request);
    const action = await routeGenerationService.regenerate(
      userId,
      (request.body ?? {}) as RegenerateRouteBody,
    );
    if (action.status === "generating") {
      sendOk(
        response,
        {
          route: {
            routeId: action.routeId,
            status: "generating",
            pollAfterMs: 1500,
          },
          regenerationsRemaining: action.regenerationsRemaining ?? 0,
        },
        202,
      );
      return;
    }
    const summary = await routeReadService.readySummary(action.routeId, userId);
    sendOk(response, {
      route: {
        routeId: summary.routeId,
        status: "ready",
        title: summary.title,
        distanceMeters: summary.distanceMeters,
        estimatedDurationSec: summary.estimatedDurationSec,
        safetyScore: summary.safetyScore,
      },
      regenerationsRemaining: action.regenerationsRemaining ?? 0,
    });
  }) as RequestHandler,

  preview: asyncHandler(async (request, response) => {
    sendOk(
      response,
      await routeReadService.preview(routeId(request), requireUserId(request)),
    );
  }) as RequestHandler,

  geometry: asyncHandler(async (request, response) => {
    const query = request.query as unknown as GeometryQuery;
    const result = await routeReadService.geometry(
      routeId(request),
      requireUserId(request),
      query,
    );
    if (result.kind === "page") {
      sendPage(response, result.data, {
        nextCursor: result.nextCursor,
        limit: result.limit,
      });
      return;
    }
    sendOk(response, result.data);
  }) as RequestHandler,

  report: asyncHandler(async (request, response) => {
    const result = await routeReportService.report(
      routeId(request),
      requireUserId(request),
      request.body as RouteReportBody,
    );
    sendOk(response, result, 201);
  }) as RequestHandler,
};

function routeId(request: Parameters<RequestHandler>[0]): string {
  const value = request.params.routeId;
  if (!value || Array.isArray(value)) {
    throw new AppError(400, ERROR_CODES.VALIDATION_ERROR, idMessages.errors.validation);
  }
  return value;
}

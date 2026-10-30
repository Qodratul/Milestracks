import type { RequestHandler } from "express";
import type { z } from "zod";
import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { asyncHandler } from "../middleware/async-handler";
import { sendList, sendOk } from "../middleware/response";
import { runService } from "../services/run.service";
import { runHistoryService } from "../services/run-history.service";
import type {
  ClaimBodySchema,
  FinishBodySchema,
  LocationsBodySchema,
  ReachMilestoneBodySchema,
  SafeStopBodySchema,
  StartRunBodySchema,
} from "../validators/api.validator";
import { requireUserId } from "./require-user-id";

type StartBody = z.infer<typeof StartRunBodySchema>;
type LocationsBody = z.infer<typeof LocationsBodySchema>;
type ReachBody = z.infer<typeof ReachMilestoneBodySchema>;
type FinishBody = z.infer<typeof FinishBodySchema>;
type SafeStopBody = z.infer<typeof SafeStopBodySchema>;
type ClaimBody = z.infer<typeof ClaimBodySchema>;

export const runController = {
  active: asyncHandler(async (request, response) => {
    sendOk(response, await runService.getActive(requireUserId(request)));
  }) as RequestHandler,
  start: asyncHandler(async (request, response) => {
    sendOk(
      response,
      await runService.start(requireUserId(request), request.body as StartBody),
      201,
    );
  }) as RequestHandler,
  list: asyncHandler(async (request, response) => {
    const cursor =
      typeof request.query.cursor === "string" ? request.query.cursor : undefined;
    const limit = Number(request.query.limit ?? 20);
    const page = await runHistoryService.list(requireUserId(request), cursor, limit);
    sendList(response, page.runs, {
      nextCursor: page.nextCursor,
      limit: page.limit,
    });
  }) as RequestHandler,
  get: asyncHandler(async (request, response) => {
    sendOk(
      response,
      await runService.get(requireUserId(request), param(request, "runId")),
    );
  }) as RequestHandler,
  trace: asyncHandler(async (request, response) => {
    const trace = await runService.getTrace(
      requireUserId(request),
      param(request, "runId"),
    );
    sendList(response, trace, { nextCursor: null, limit: trace.length });
  }) as RequestHandler,
  pause: asyncHandler(async (request, response) => {
    sendOk(
      response,
      await runService.pause(requireUserId(request), param(request, "runId")),
    );
  }) as RequestHandler,
  resume: asyncHandler(async (request, response) => {
    sendOk(
      response,
      await runService.resume(requireUserId(request), param(request, "runId")),
    );
  }) as RequestHandler,
  locations: asyncHandler(async (request, response) => {
    sendOk(
      response,
      await runService.uploadLocations(
        requireUserId(request),
        param(request, "runId"),
        request.body as LocationsBody,
      ),
    );
  }) as RequestHandler,
  reach: asyncHandler(async (request, response) => {
    sendOk(
      response,
      await runService.reachMilestone(
        requireUserId(request),
        param(request, "runId"),
        param(request, "milestoneId"),
        request.body as ReachBody,
      ),
    );
  }) as RequestHandler,
  finish: asyncHandler(async (request, response) => {
    sendOk(
      response,
      await runService.finish(
        requireUserId(request),
        param(request, "runId"),
        request.body as FinishBody,
      ),
    );
  }) as RequestHandler,
  safeStop: asyncHandler(async (request, response) => {
    sendOk(
      response,
      await runService.safeStop(
        requireUserId(request),
        param(request, "runId"),
        request.body as SafeStopBody,
      ),
    );
  }) as RequestHandler,
  summary: asyncHandler(async (request, response) => {
    sendOk(
      response,
      await runService.summary(requireUserId(request), param(request, "runId")),
    );
  }) as RequestHandler,
  claim: asyncHandler(async (request, response) => {
    sendOk(
      response,
      await runService.claim(
        requireUserId(request),
        param(request, "runId"),
        request.body as ClaimBody,
      ),
    );
  }) as RequestHandler,
  guidance: asyncHandler(async (request, response) => {
    sendOk(
      response,
      await runService.guidance(requireUserId(request), param(request, "runId")),
    );
  }) as RequestHandler,
};

function param(request: Parameters<RequestHandler>[0], key: string): string {
  const value = request.params[key];
  if (!value || Array.isArray(value)) {
    throw new AppError(400, ERROR_CODES.VALIDATION_ERROR, "Parameter URL tidak valid.");
  }
  return value;
}

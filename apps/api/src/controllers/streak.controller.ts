import type { RequestHandler } from "express";
import { asyncHandler } from "../middleware/async-handler";
import { sendOk } from "../middleware/response";
import { streakService } from "../services/streak.service";
import { requireUserId } from "./require-user-id";

export const streakController = {
  get: asyncHandler(async (request, response) => {
    sendOk(response, await streakService.get(requireUserId(request)));
  }) as RequestHandler,
};

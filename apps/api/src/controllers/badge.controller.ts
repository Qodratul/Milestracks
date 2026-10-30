import type { RequestHandler } from "express";
import { asyncHandler } from "../middleware/async-handler";
import { sendList } from "../middleware/response";
import { badgeService } from "../services/badge.service";
import { requireUserId } from "./require-user-id";

export const badgeController = {
  list: asyncHandler(async (request, response) => {
    const badges = await badgeService.list(requireUserId(request));
    sendList(response, badges, { nextCursor: null, limit: badges.length });
  }) as RequestHandler,
};

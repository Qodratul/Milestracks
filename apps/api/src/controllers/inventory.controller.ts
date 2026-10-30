import type { RequestHandler } from "express";
import { asyncHandler } from "../middleware/async-handler";
import { sendList } from "../middleware/response";
import { itemService } from "../services/item.service";
import { requireUserId } from "./require-user-id";

export const inventoryController = {
  get: asyncHandler(async (request, response) => {
    const result = await itemService.getInventory(requireUserId(request));
    sendList(response, result.items, {
      nextCursor: null,
      limit: result.limit,
    });
  }) as RequestHandler,
};

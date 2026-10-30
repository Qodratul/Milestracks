import type { RequestHandler } from "express";
import type { LoadoutPatch } from "../domain/items";
import { asyncHandler } from "../middleware/async-handler";
import { sendOk } from "../middleware/response";
import { loadoutService } from "../services/loadout.service";
import { requireUserId } from "./require-user-id";

export const loadoutController = {
  get: asyncHandler(async (request, response) => {
    sendOk(response, await loadoutService.get(requireUserId(request)));
  }) as RequestHandler,

  update: asyncHandler(async (request, response) => {
    const patch = request.body as LoadoutPatch;
    sendOk(response, await loadoutService.update(requireUserId(request), patch));
  }) as RequestHandler,
};

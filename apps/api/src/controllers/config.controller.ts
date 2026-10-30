import type { RequestHandler } from "express";
import { asyncHandler } from "../middleware/async-handler";
import { sendOk } from "../middleware/response";
import { gameConfigService } from "../services/game-config.service";

export const getGameConfigController: RequestHandler = asyncHandler(
  async (_request, response) => {
    const config = await gameConfigService.active();
    sendOk(response, config);
  },
);

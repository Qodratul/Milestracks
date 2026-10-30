import { Router } from "express";
import { getGameConfigController } from "../controllers/config.controller";
import { authenticate } from "../middleware/authenticate.middleware";

export const configRouter: ReturnType<typeof Router> = Router();
configRouter.get("/config/game", authenticate, getGameConfigController);

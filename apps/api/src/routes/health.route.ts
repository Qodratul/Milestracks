import { Router } from "express";
import { getHealth, getReadiness } from "../controllers/health.controller";

export const healthRouter: ReturnType<typeof Router> = Router();
healthRouter.get("/healthz", getHealth);
healthRouter.get("/readyz", getReadiness);

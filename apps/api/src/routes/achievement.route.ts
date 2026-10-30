import { Router } from "express";
import { API_ENDPOINTS } from "../contracts/endpoint.contracts";
import { badgeController } from "../controllers/badge.controller";
import { streakController } from "../controllers/streak.controller";
import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { authenticate } from "../middleware/authenticate.middleware";
import { validateRequest } from "../middleware/validate.middleware";

export const achievementRouter: ReturnType<typeof Router> = Router();
achievementRouter.get(
  "/badges",
  authenticate,
  validate("getBadges"),
  badgeController.list,
);
achievementRouter.get(
  "/streak",
  authenticate,
  validate("getStreak"),
  streakController.get,
);

function validate(operationId: string) {
  const contract = API_ENDPOINTS.find((endpoint) => endpoint.operationId === operationId);
  if (!contract) {
    throw new AppError(
      500,
      ERROR_CODES.INTERNAL_ERROR,
      "Missing API endpoint contract: " + operationId,
    );
  }
  return validateRequest(contract);
}

import { Router } from "express";
import { API_ENDPOINTS } from "../contracts/endpoint.contracts";
import { loadoutController } from "../controllers/loadout.controller";
import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { authenticate } from "../middleware/authenticate.middleware";
import { validateRequest } from "../middleware/validate.middleware";

export const loadoutRouter: ReturnType<typeof Router> = Router();

const updateContract = API_ENDPOINTS.find(
  (endpoint) => endpoint.operationId === "updateLoadout",
);
if (!updateContract) {
  throw new AppError(
    500,
    ERROR_CODES.INTERNAL_ERROR,
    "Missing API endpoint contract: updateLoadout",
  );
}

loadoutRouter.get("/me/loadout", authenticate, loadoutController.get);
loadoutRouter.patch(
  "/me/loadout",
  authenticate,
  validateRequest(updateContract),
  loadoutController.update,
);

import { Router } from "express";
import { accountController } from "../controllers/account.controller";
import { API_ENDPOINTS } from "../contracts/endpoint.contracts";
import { authenticate } from "../middleware/authenticate.middleware";
import { validateRequest } from "../middleware/validate.middleware";
import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";

export const accountRouter: ReturnType<typeof Router> = Router();

accountRouter.get("/me", authenticate, accountController.getMe);
accountRouter.get("/me/home-summary", authenticate, accountController.getHomeSummary);
accountRouter.get("/me/wallet", authenticate, accountController.getWallet);

const onboardingContract = API_ENDPOINTS.find(
  (endpoint) => endpoint.operationId === "updateOnboarding",
);
if (!onboardingContract) {
  throw new AppError(
    500,
    ERROR_CODES.INTERNAL_ERROR,
    "Missing API endpoint contract: updateOnboarding",
  );
}
accountRouter.patch(
  "/me/onboarding",
  authenticate,
  validateRequest(onboardingContract),
  accountController.updateOnboarding,
);

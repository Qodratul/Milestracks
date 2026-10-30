import { Router } from "express";
import { API_ENDPOINTS } from "../contracts/endpoint.contracts";
import { shopController } from "../controllers/shop.controller";
import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { authenticate } from "../middleware/authenticate.middleware";
import { idempotency, requireIdempotencyKey } from "../middleware/idempotency.middleware";
import { validateRequest } from "../middleware/validate.middleware";

export const shopRouter: ReturnType<typeof Router> = Router();

shopRouter.get(
  "/shop/items",
  authenticate,
  validate("getShopCatalog"),
  shopController.catalog,
);
shopRouter.post(
  "/shop/purchase",
  authenticate,
  validate("purchaseShopItem"),
  requireIdempotencyKey(),
  idempotency,
  shopController.purchase,
);
shopRouter.get(
  "/coins/ledger",
  authenticate,
  validate("getCoinLedger"),
  shopController.ledger,
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

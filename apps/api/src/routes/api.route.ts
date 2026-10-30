import { Router } from "express";
import { API_ENDPOINTS } from "../contracts/endpoint.contracts";
import { createStubController } from "../controllers/stub.controller";
import { authenticateStub } from "../middleware/authenticate.middleware";
import { requireIdempotencyKeyStub } from "../middleware/idempotency.middleware";
import { validateRequest } from "../middleware/validate.middleware";

export const apiRouter: ReturnType<typeof Router> = Router();

for (const contract of API_ENDPOINTS) {
  const handlers = [];
  if (contract.protected) handlers.push(authenticateStub);
  if (contract.paramsSchema || contract.querySchema || contract.bodySchema) {
    handlers.push(validateRequest(contract));
  }
  if (contract.idempotencyAccepted) {
    handlers.push(requireIdempotencyKeyStub(contract.idempotencyRequired));
  }
  handlers.push(createStubController(contract));

  if (contract.method === "get") apiRouter.get(contract.expressPath, ...handlers);
  if (contract.method === "post") apiRouter.post(contract.expressPath, ...handlers);
  if (contract.method === "patch") apiRouter.patch(contract.expressPath, ...handlers);
}

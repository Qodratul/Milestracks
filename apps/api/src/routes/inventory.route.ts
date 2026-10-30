import { Router } from "express";
import { inventoryController } from "../controllers/inventory.controller";
import { authenticate } from "../middleware/authenticate.middleware";

export const inventoryRouter: ReturnType<typeof Router> = Router();

inventoryRouter.get("/me/inventory", authenticate, inventoryController.get);

import { Router } from "express";
import rateLimit from "express-rate-limit";
import { API_ENDPOINTS } from "../contracts/endpoint.contracts";
import { authController } from "../controllers/auth.controller";
import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { idMessages } from "../i18n";
import { authenticate } from "../middleware/authenticate.middleware";
import { validateRequest } from "../middleware/validate.middleware";

const AUTH_RATE_LIMIT_WINDOW_MS = 60_000;
const AUTH_RATE_LIMIT_REQUESTS = 10;

export const authRouter: ReturnType<typeof Router> = Router();

export const authRateLimiter = rateLimit({
  windowMs: AUTH_RATE_LIMIT_WINDOW_MS,
  limit: AUTH_RATE_LIMIT_REQUESTS,
  standardHeaders: true,
  legacyHeaders: false,
  handler: (_request, response) => {
    const header = response.getHeader("X-Request-Id");
    const requestId = typeof header === "string" ? header : "req_unknown";
    response.status(429).json({
      error: {
        code: ERROR_CODES.RATE_LIMITED,
        message: idMessages.errors.rateLimited,
        details: { retryAfterSec: Math.ceil(AUTH_RATE_LIMIT_WINDOW_MS / 1000) },
        requestId,
      },
    });
  },
});

authRouter.use("/auth", authRateLimiter);

authRouter.post(
  "/auth/register",
  validateRequest(requireContract("post", "/auth/register")),
  authController.register,
);
authRouter.post(
  "/auth/login",
  validateRequest(requireContract("post", "/auth/login")),
  authController.login,
);
authRouter.post(
  "/auth/google",
  validateRequest(requireContract("post", "/auth/google")),
  authController.loginWithGoogle,
);
authRouter.post(
  "/auth/refresh",
  validateRequest(requireContract("post", "/auth/refresh")),
  authController.refresh,
);
authRouter.post(
  "/auth/logout",
  authenticate,
  validateRequest(requireContract("post", "/auth/logout")),
  authController.logout,
);

function requireContract(method: "post", path: string) {
  const contract = API_ENDPOINTS.find(
    (candidate) => candidate.method === method && candidate.expressPath === path,
  );
  if (!contract) {
    throw new AppError(
      500,
      ERROR_CODES.INTERNAL_ERROR,
      "Missing API endpoint contract: " + path,
    );
  }
  return contract;
}

import type { RequestHandler } from "express";
import type { EndpointContract } from "../contracts/endpoint.contracts";
import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";

export function validateRequest(contract: EndpointContract): RequestHandler {
  return (request, _response, next) => {
    const checks = [
      ["params", contract.paramsSchema, request.params],
      ["query", contract.querySchema, request.query],
      ["body", contract.bodySchema, request.body],
    ] as const;

    for (const [location, schema, value] of checks) {
      if (!schema) continue;
      const result = schema.safeParse(value);
      if (result.success) continue;
      next(
        new AppError(
          400,
          ERROR_CODES.VALIDATION_ERROR,
          "Data yang dikirim tidak valid.",
          {
            fields: result.error.issues.map((issue) => ({
              path: [location, ...issue.path].join("."),
              message: issue.message,
            })),
          },
        ),
      );
      return;
    }
    next();
  };
}

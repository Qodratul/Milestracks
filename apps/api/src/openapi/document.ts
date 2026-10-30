import {
  extendZodWithOpenApi,
  OpenAPIRegistry,
  OpenApiGeneratorV31,
} from "@asteasolutions/zod-to-openapi";
import type { RouteConfig } from "@asteasolutions/zod-to-openapi";
import { z } from "zod";
import { API_ENDPOINTS } from "../contracts/endpoint.contracts";
import {
  ErrorEnvelopeSchema,
  IdempotencyHeaderSchema,
} from "../validators/api.validator";

extendZodWithOpenApi(z);

const registry = new OpenAPIRegistry();
registry.registerComponent("securitySchemes", "bearerAuth", {
  type: "http",
  scheme: "bearer",
  bearerFormat: "JWT",
});

const ApiMetaSchema = registry.register(
  "ApiMeta",
  z.object({ requestId: z.string(), timestamp: z.string().datetime() }).strict(),
);
const HealthDataSchema = registry.register(
  "HealthData",
  z
    .object({
      status: z.literal("ok"),
      uptimeSec: z.number().int(),
      version: z.string(),
    })
    .strict(),
);
const ReadinessDataSchema = registry.register(
  "ReadinessData",
  z
    .object({
      status: z.literal("ready"),
      checks: z.object({ postgres: z.literal("ok") }).strict(),
    })
    .strict(),
);
const ErrorResponseSchema = registry.register("ErrorResponse", ErrorEnvelopeSchema);

function jsonResponse(schema: z.ZodType, description: string, example?: unknown) {
  return {
    description,
    content: {
      "application/json": {
        schema,
        ...(example === undefined ? {} : { example }),
      },
    },
  };
}

registry.registerPath({
  method: "get",
  path: "/healthz",
  operationId: "health",
  summary: "Check API liveness",
  responses: {
    200: jsonResponse(
      z.object({ data: HealthDataSchema, meta: ApiMetaSchema }).strict(),
      "API process is responding.",
    ),
  },
});
registry.registerPath({
  method: "get",
  path: "/readyz",
  operationId: "readiness",
  summary: "Check API readiness",
  responses: {
    200: jsonResponse(
      z.object({ data: ReadinessDataSchema, meta: ApiMetaSchema }).strict(),
      "PostgreSQL is ready.",
    ),
    503: jsonResponse(ErrorResponseSchema, "A required dependency is unavailable."),
  },
});

for (const contract of API_ENDPOINTS) {
  const requestConfig: NonNullable<RouteConfig["request"]> = {};
  if (contract.paramsSchema) requestConfig.params = contract.paramsSchema;
  if (contract.querySchema) requestConfig.query = contract.querySchema;
  if (contract.idempotencyAccepted) {
    requestConfig.headers = z
      .object({
        "Idempotency-Key": contract.idempotencyRequired
          ? IdempotencyHeaderSchema
          : IdempotencyHeaderSchema.optional(),
      })
      .strict();
  }
  if (contract.bodySchema) {
    requestConfig.body = {
      required: contract.bodyRequired,
      content: {
        "application/json": {
          schema: contract.bodySchema,
          ...(contract.bodyExample === undefined
            ? {}
            : { example: contract.bodyExample }),
        },
      },
    };
  }

  const responses: NonNullable<RouteConfig["responses"]> = {
    [contract.statusCode]: jsonResponse(
      contract.responseSchema,
      "Successful response wrapped in the API envelope.",
    ),
    400: jsonResponse(ErrorResponseSchema, "The request is invalid."),
    401: jsonResponse(ErrorResponseSchema, "Authentication is required."),
    404: jsonResponse(ErrorResponseSchema, "The resource was not found."),
    409: jsonResponse(
      ErrorResponseSchema,
      "The resource state conflicts with the request.",
    ),
    422: jsonResponse(ErrorResponseSchema, "The request cannot be processed."),
  };
  for (const statusCode of contract.additionalStatusCodes) {
    responses[statusCode] = jsonResponse(
      contract.responseSchema,
      "Successful response wrapped in the API envelope.",
    );
  }
  for (const statusCode of [403, 413, 429, 500, 503]) {
    responses[statusCode] = jsonResponse(
      ErrorResponseSchema,
      "The request failed or a dependency is unavailable.",
    );
  }

  registry.registerPath({
    method: contract.method,
    path: contract.openApiPath,
    operationId: contract.operationId,
    summary: contract.summary,
    description: contract.description,
    ...(contract.protected ? { security: [{ bearerAuth: [] }] } : {}),
    ...(Object.keys(requestConfig).length > 0 ? { request: requestConfig } : {}),
    responses,
  });
}

const generator = new OpenApiGeneratorV31(registry.definitions);
export const openApiDocument: ReturnType<OpenApiGeneratorV31["generateDocument"]> =
  generator.generateDocument({
    openapi: "3.1.0",
    info: {
      title: "Milestracks API",
      version: "2.0.0",
      description:
        "Milestracks MVP API contract. Stub responses are enabled with STUB_MODE=true.",
    },
    servers: [{ url: "/" }],
  });

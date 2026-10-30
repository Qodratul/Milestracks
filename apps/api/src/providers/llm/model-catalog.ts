import { z } from "zod";
import { env } from "../../config/env";

const modelListSchema = z
  .object({
    data: z.array(
      z
        .object({
          id: z.string(),
          supported_features: z.array(z.string()).optional(),
        })
        .passthrough(),
    ),
  })
  .passthrough();

export interface FastModelCapabilities {
  readonly configured: boolean;
  readonly available: boolean;
  readonly modelId: string | null;
  readonly supportedFeatures: readonly string[];
  readonly supportsJsonSchema: boolean;
  readonly supportsTools: boolean;
  readonly failureCode:
    "NOT_CONFIGURED" | "HTTP_ERROR" | "INVALID_RESPONSE" | "TIMEOUT" | null;
}

let cachedFastModelRequest: Promise<FastModelCapabilities> | undefined;

export function getFastModelCapabilities(): Promise<FastModelCapabilities> {
  cachedFastModelRequest ??= requestFastModelCapabilities();
  return cachedFastModelRequest;
}

export function refreshFastModelCapabilities(): Promise<FastModelCapabilities> {
  cachedFastModelRequest = requestFastModelCapabilities();
  return cachedFastModelRequest;
}

async function requestFastModelCapabilities(): Promise<FastModelCapabilities> {
  const modelId = env.LLM_MODEL_FAST;
  const baseUrl = env.LLM_FAST_BASE_URL;
  if (!env.LLM_API_KEY || !modelId || !baseUrl) {
    return unavailableModel("NOT_CONFIGURED", modelId ?? null);
  }

  const normalizedBase = baseUrl.endsWith("/") ? baseUrl : baseUrl + "/";
  let response: Response;
  try {
    response = await fetch(new URL("models?verbose=true", normalizedBase), {
      headers: { Authorization: "Bearer " + env.LLM_API_KEY },
      signal: AbortSignal.timeout(env.LLM_TIMEOUT_MS),
    });
  } catch (error) {
    const failureCode =
      error instanceof Error && error.name === "TimeoutError" ? "TIMEOUT" : "HTTP_ERROR";
    return unavailableModel(failureCode, modelId);
  }
  if (!response.ok) return unavailableModel("HTTP_ERROR", modelId);

  const payload: unknown = await response.json().catch(() => undefined);
  const parsed = modelListSchema.safeParse(payload);
  if (!parsed.success) return unavailableModel("INVALID_RESPONSE", modelId);

  const model = parsed.data.data.find((entry) => entry.id === modelId);
  const supportedFeatures = model?.supported_features ?? [];
  const supportsTools = supportedFeatures.some(
    (feature) => feature.toLowerCase() === "tools",
  );
  const supportsJsonSchema = supportedFeatures.some((feature) =>
    ["json_schema", "response_format_json_schema", "structured_outputs"].includes(
      feature.toLowerCase(),
    ),
  );
  return {
    configured: true,
    available: model !== undefined,
    modelId,
    supportedFeatures,
    supportsJsonSchema,
    supportsTools,
    failureCode: model === undefined ? "INVALID_RESPONSE" : null,
  };
}

function unavailableModel(
  failureCode: NonNullable<FastModelCapabilities["failureCode"]>,
  modelId: string | null,
): FastModelCapabilities {
  return {
    configured: Boolean(env.LLM_API_KEY && env.LLM_FAST_BASE_URL && modelId),
    available: false,
    modelId,
    supportedFeatures: [],
    supportsJsonSchema: false,
    supportsTools: false,
    failureCode,
  };
}

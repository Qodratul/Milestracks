import "dotenv/config";
import { z } from "zod";

const optionalString = z.preprocess(
  (value) => (value === "" ? undefined : value),
  z.string().min(1).optional(),
);
const optionalUrl = z.preprocess(
  (value) => (value === "" ? undefined : value),
  z.url().optional(),
);
const optionalSecret = z.preprocess(
  (value) => (value === "" ? undefined : value),
  z.string().min(32, "JWT_SECRET must contain at least 32 characters").optional(),
);
const optionalRedisUrl = z.preprocess(
  (value) => (value === "" ? undefined : value),
  z
    .url()
    .refine((value) => value.startsWith("redis://"), "Must use a TLS Redis URL.")
    .optional(),
);
const EnvironmentSchema = z
  .object({
    NODE_ENV: z.enum(["development", "test", "production"]).default("development"),
    HOST: z.string().min(1).default("0.0.0.0"),
    PORT: z.coerce.number().int().min(1).max(65_535).default(3_000),
    LOG_LEVEL: z
      .enum(["fatal", "error", "warn", "info", "debug", "trace", "silent"])
      .default("info"),
    CORS_ORIGIN: z.string().optional(),
    JWT_SECRET: optionalSecret,
    GOOGLE_CLIENT_ID: optionalString,
    DATABASE_URL: optionalUrl,
    DIRECT_URL: optionalUrl,
    ROUTING_PROVIDER: z.enum(["graphhopper", "mock"]).default("mock"),
    GRAPHOPPER_BASE_URL: z.url().default("https://graphhopper.com/api/1"),
    GRAPHOPPER_API_KEY: optionalString,
    GRAPHOPPER_PROFILE: z.string().min(1).default("foot"),
    GRAPHOPPER_TIMEOUT_MS: z.coerce.number().int().positive().default(10_000),
    GRAPHOPPER_CREDITS_PER_MINUTE: z.coerce
      .number()
      .int()
      .positive()
      .max(10_000)
      .default(20),
    OPEN_METEO_ELEVATION_URL: z.url().default("https://api.open-meteo.com/v1/elevation"),
    OPEN_METEO_API_KEY: optionalString,
    OPEN_METEO_TIMEOUT_MS: z.coerce.number().int().positive().default(8_000),
    OSM_TAGS_PROVIDER: z.enum(["overpass", "none"]).default("overpass"),
    OVERPASS_API_URL: z.url().default("https://overpass-api.de/api/interpreter"),
    OVERPASS_FALLBACK_API_URL: z
      .url()
      .default("https://overpass.private.coffee/api/interpreter"),
    OVERPASS_TIMEOUT_MS: z.coerce.number().int().positive().default(12_000),
    OVERPASS_REQUEST_INTERVAL_MS: z.coerce.number().int().min(0).default(2_000),
    UPSTASH_REDIS_URL: optionalRedisUrl,
    DEMO_MODE: z
      .enum(["true", "false"])
      .default("false")
      .transform((value) => value === "true"),
    ROUTE_GENERATION_CONCURRENCY: z.coerce.number().int().positive().max(10).default(2),
    ROUTE_GENERATION_STALE_AFTER_MS: z.coerce.number().int().positive().default(120_000),
    STUB_MODE: z
      .enum(["true", "false"])
      .default("false")
      .transform((value) => value === "true"),
    LLM_API_KEY: optionalString,
    LLM_TIMEOUT_MS: z.coerce.number().int().positive().default(8_000),
    LLM_FAST_BASE_URL: optionalUrl,
    LLM_MODEL_FAST: optionalString,
    LLM_REASONING_BASE_URL: optionalUrl,
    LLM_MODEL_REASONING: optionalString,
    SENTRY_DSN: optionalUrl,
  })
  .superRefine((environment, context) => {
    if (!environment.STUB_MODE && !environment.JWT_SECRET) {
      context.addIssue({
        code: "custom",
        path: ["JWT_SECRET"],
        message: "Required when real API routes are enabled.",
      });
    }
    if (environment.NODE_ENV === "production" && environment.STUB_MODE) {
      context.addIssue({
        code: "custom",
        path: ["STUB_MODE"],
        message: "Stub mode cannot run in production.",
      });
    }
    if (
      environment.ROUTING_PROVIDER === "graphhopper" &&
      !environment.GRAPHOPPER_API_KEY
    ) {
      context.addIssue({
        code: "custom",
        path: ["GRAPHOPPER_API_KEY"],
        message: "Required when ROUTING_PROVIDER is graphhopper.",
      });
    }
    if (environment.NODE_ENV === "production" && !environment.DATABASE_URL) {
      context.addIssue({
        code: "custom",
        path: ["DATABASE_URL"],
        message: "Required in production.",
      });
    }
  });
const parsedEnvironment = EnvironmentSchema.safeParse(process.env);
if (!parsedEnvironment.success) {
  const issues = parsedEnvironment.error.issues
    .map((issue) => issue.path.join(".") + ": " + issue.message)
    .join("; ");
  throw new Error("Invalid environment configuration: " + issues);
}
export const env = {
  ...parsedEnvironment.data,
  DATABASE_URL:
    parsedEnvironment.data.DATABASE_URL ??
    "postgresql://milestride:milestride@127.0.0.1:5432/milestride",
};
export type Environment = typeof env;

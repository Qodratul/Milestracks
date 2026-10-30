import { extendZodWithOpenApi } from "@asteasolutions/zod-to-openapi";
import { z } from "zod";

extendZodWithOpenApi(z);

const latitude = z.number().min(-90).max(90);
const longitude = z.number().min(-180).max(180);
const positiveMeters = z.number().positive();

function isTimeZone(value: string): boolean {
  try {
    new Intl.DateTimeFormat("en", { timeZone: value });
    return true;
  } catch {
    return false;
  }
}

export const RouteIdParamsSchema = z.object({ routeId: z.string().min(1) }).strict();
export const RunIdParamsSchema = z.object({ runId: z.string().min(1) }).strict();
export const RunMilestoneParamsSchema = z
  .object({ runId: z.string().min(1), milestoneId: z.string().min(1) })
  .strict();

export const RegisterBodySchema = z
  .object({
    displayName: z.string().min(2).max(30),
    email: z.email().max(320),
    password: z.string().min(8).max(72),
    locale: z.enum(["id", "en"]),
    timezone: z
      .string()
      .min(1)
      .max(64)
      .refine(isTimeZone, "Must be a valid IANA time zone")
      .optional(),
  })
  .strict();

export const LoginBodySchema = z
  .object({
    email: z.email().max(320),
    password: z.string().min(8).max(72),
    rememberMe: z.boolean().optional(),
  })
  .strict();

export const GoogleAuthBodySchema = z
  .object({
    idToken: z.string().min(1).max(8192),
    locale: z.enum(["id", "en"]).optional(),
    timezone: z
      .string()
      .min(1)
      .max(64)
      .refine(isTimeZone, "Must be a valid IANA time zone")
      .optional(),
  })
  .strict();

export const OnboardingBodySchema = z
  .object({
    healthDisclaimerAccepted: z.boolean().optional(),
    locale: z.enum(["id", "en"]).optional(),
    timezone: z
      .string()
      .min(1)
      .max(64)
      .refine(isTimeZone, "Must be a valid IANA time zone")
      .optional(),
  })
  .strict()
  .refine((value) => Object.keys(value).length > 0);

export const RefreshBodySchema = z.object({ refreshToken: z.string().min(1) }).strict();
export const LogoutBodySchema = z.object({ refreshToken: z.string().min(1) }).strict();

export const LocationSchema = z
  .object({
    lat: latitude,
    lng: longitude,
    accuracyMeters: positiveMeters,
  })
  .strict();

export const WeatherHintSchema = z
  .object({
    temperatureC: z.number().min(-80).max(70),
    observedAt: z.string().datetime().optional(),
  })
  .strict();

export const GenerateRouteBodySchema = z
  .object({
    location: LocationSchema,
    weather: WeatherHintSchema.optional(),
    preferredDistanceMeters: positiveMeters.optional(),
  })
  .strict();

export const RouteGenerationJobInputSchema = z
  .object({
    location: LocationSchema,
    targetDistanceMeters: positiveMeters,
    levelCode: z.enum(["beginner", "intermediate", "advanced", "professional", "master"]),
    locale: z.enum(["id", "en"]),
    excludedTemplateId: z.string().min(1).optional(),
    weather: WeatherHintSchema.optional(),
  })
  .strict();

export const RegenerateRouteBodySchema = z
  .object({
    location: LocationSchema.optional(),
    weather: WeatherHintSchema.optional(),
  })
  .strict()
  .optional();

export const RouteReportBodySchema = z
  .object({
    reason: z.enum(["safety_concern", "incorrect_map", "inaccessible", "other"]),
    details: z.string().max(240).optional(),
  })
  .strict();

export const ItemCodeSchema = z.enum(["exp_boost", "less_compensation", "gain_more"]);
export const LoadoutBodySchema = z
  .object({
    boostItemCode: ItemCodeSchema.nullable().optional(),
    modifierItemCode: ItemCodeSchema.nullable().optional(),
  })
  .strict()
  .refine(
    (value) => Object.keys(value).length > 0,
    "At least one loadout field is required.",
  );

export const GeometryQuerySchema = z
  .object({
    detail: z.enum(["preview"]).optional(),
    cursor: z.string().optional(),
    limit: z.coerce.number().int().min(1).max(500).optional(),
  })
  .strict();

export const CursorPageQuerySchema = z
  .object({
    cursor: z.string().min(1).max(512).optional(),
    limit: z.coerce.number().int().min(1).max(100).optional(),
  })
  .strict();

export const ShopPurchaseBodySchema = z.object({ itemId: ItemCodeSchema }).strict();

export const StartRunBodySchema = z
  .object({
    routeId: z.string().min(1),
    boostItemCode: ItemCodeSchema.nullable(),
    modifierItemCode: ItemCodeSchema.nullable(),
    units: z.enum(["metric", "imperial"]),
    startLocation: LocationSchema,
    clientCapabilities: z
      .object({
        platform: z.enum(["android", "ios"]),
        appVersion: z.string().min(1),
        backgroundLocation: z.boolean(),
        mockLocationEnabled: z.boolean(),
      })
      .strict(),
  })
  .strict();

export const LocationSampleSchema = z
  .object({
    sequence: z.number().int().positive(),
    t: z.number().int().positive(),
    lat: latitude,
    lng: longitude,
    accuracyMeters: positiveMeters,
    speedMps: z.number().min(0).optional(),
    altitudeMeters: z.number().optional(),
    mocked: z.boolean().optional(),
  })
  .strict();

export const LocationsBodySchema = z
  .object({
    samples: z.array(LocationSampleSchema).min(1).max(100),
  })
  .strict();

export const ReachMilestoneBodySchema = z
  .object({
    reachedAt: z.string().datetime(),
    location: LocationSchema,
    lastSampleSequence: z.number().int().nonnegative(),
  })
  .strict();

export const SafeStopBodySchema = z
  .object({
    reason: z.enum(["tired", "unsafe", "injury", "other"]),
    lastSampleSequence: z.number().int().nonnegative(),
  })
  .strict();

export const FinishBodySchema = z
  .object({
    endedAt: z.string().datetime(),
    lastSampleSequence: z.number().int().nonnegative(),
    clientSummary: z
      .object({
        distanceMeters: z.number().nonnegative(),
        durationSec: z.number().nonnegative(),
      })
      .strict()
      .optional(),
  })
  .strict();

export const ClaimBodySchema = z.object({ claimId: z.string().min(1) }).strict();
export const IdempotencyHeaderSchema = z.string().uuid();

export const ErrorEnvelopeSchema = z
  .object({
    error: z
      .object({
        code: z.string(),
        message: z.string(),
        details: z.unknown().optional(),
        requestId: z.string(),
      })
      .strict(),
  })
  .strict();

export type RegisterBody = z.infer<typeof RegisterBodySchema>;
export type LoginBody = z.infer<typeof LoginBodySchema>;
export type GenerateRouteBody = z.infer<typeof GenerateRouteBodySchema>;
export type StartRunBody = z.infer<typeof StartRunBodySchema>;
export type ShopPurchaseBody = z.infer<typeof ShopPurchaseBodySchema>;

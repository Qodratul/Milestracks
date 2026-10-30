import { z } from "zod";
import {
  ClaimBodySchema,
  CursorPageQuerySchema,
  FinishBodySchema,
  GenerateRouteBodySchema,
  GoogleAuthBodySchema,
  GeometryQuerySchema,
  LoadoutBodySchema,
  LocationsBodySchema,
  LoginBodySchema,
  OnboardingBodySchema,
  LogoutBodySchema,
  ReachMilestoneBodySchema,
  RefreshBodySchema,
  RegenerateRouteBodySchema,
  RegisterBodySchema,
  RouteIdParamsSchema,
  RouteReportBodySchema,
  RunIdParamsSchema,
  RunMilestoneParamsSchema,
  SafeStopBodySchema,
  StartRunBodySchema,
  ShopPurchaseBodySchema,
} from "../validators/api.validator";
import { STUB_RESPONSE_FIXTURES, type StubResponseFixture } from "./stub-fixtures";

export type ApiMethod = "get" | "post" | "patch";
export type ResponseMode = "success" | "list";

export interface EndpointContract {
  readonly operationId: string;
  readonly method: ApiMethod;
  readonly expressPath: string;
  readonly openApiPath: string;
  readonly testPath: string;
  readonly summary: string;
  readonly description: string;
  readonly protected: boolean;
  readonly idempotencyRequired: boolean;
  readonly idempotencyAccepted: boolean;
  readonly statusCode: number;
  readonly additionalStatusCodes: readonly number[];
  readonly responseMode: ResponseMode;
  readonly responseData: unknown;
  readonly responseSchema: z.ZodType;
  readonly bodySchema?: z.ZodType;
  readonly bodyRequired: boolean;
  readonly querySchema?: z.ZodObject;
  readonly paramsSchema?: z.ZodObject;
  readonly bodyExample?: Record<string, unknown>;
}

function schemaFromExamples(examples: readonly unknown[]): z.ZodType {
  if (examples.length === 0) return z.unknown();

  const nonNullExamples = examples.filter(
    (example) => example !== null && example !== undefined,
  );
  if (nonNullExamples.length !== examples.length) {
    if (nonNullExamples.length === 0) return z.null();
    return z.union([schemaFromExamples(nonNullExamples), z.null()]);
  }

  if (examples.every(Array.isArray)) {
    const items = examples.flatMap((example) => example as unknown[]);
    return z.array(items.length ? schemaFromExamples(items) : z.unknown());
  }

  if (examples.every((example) => typeof example === "object")) {
    const keys = new Set(
      examples.flatMap((example) => Object.keys(example as Record<string, unknown>)),
    );
    const shape: Record<string, z.ZodType> = {};
    for (const key of keys) {
      const values = examples.flatMap((example) =>
        Object.hasOwn(example as object, key)
          ? [(example as Record<string, unknown>)[key]]
          : [],
      );
      const fieldSchema = schemaFromExamples(values);
      shape[key] =
        values.length === examples.length ? fieldSchema : fieldSchema.optional();
    }
    return z.object(shape).strict();
  }

  if (examples.every((example) => typeof example === "string")) return z.string();
  if (examples.every((example) => typeof example === "boolean")) return z.boolean();
  if (examples.every((example) => typeof example === "number")) {
    return examples.every((example) => Number.isInteger(example))
      ? z.number().int()
      : z.number();
  }

  const schemas = new Map<string, z.ZodType>();
  for (const example of examples) {
    const type = typeof example;
    if (type === "string") schemas.set(type, z.string());
    else if (type === "boolean") schemas.set(type, z.boolean());
    else if (type === "number") schemas.set(type, z.number());
    else schemas.set(type, z.unknown());
  }
  const uniqueSchemas = [...schemas.values()];
  if (uniqueSchemas.length === 1) return uniqueSchemas[0] ?? z.unknown();
  return z.union(uniqueSchemas as unknown as [z.ZodType, z.ZodType, ...z.ZodType[]]);
}

function schemaFromExample(example: unknown): z.ZodType {
  return schemaFromExamples([example]);
}

const routeGeneratingSchema = z
  .object({
    routeId: z.string(),
    status: z.literal("generating"),
    pollAfterMs: z.number().int(),
  })
  .strict();

const routeReadySchema = z
  .object({
    routeId: z.string(),
    status: z.literal("ready"),
    level: z.enum(["beginner", "intermediate", "advanced", "professional", "master"]),
    title: z.string(),
    mysteryBrief: z.string(),
    distanceMeters: z.number(),
    estimatedDurationSec: z.number().int(),
    estimatedCalories: z.number().int(),
    milestoneCount: z.number().int(),
    expPerMilestone: z.number().int(),
    startPoint: z
      .object({
        label: z.string(),
        distanceMeters: z.number(),
        location: z.object({ lat: z.number(), lng: z.number() }).strict(),
      })
      .strict(),
    safetyScore: z.number(),
    dataConfidence: z.number(),
    warning: z.string().nullable().optional(),
    revealMode: z.enum(["full", "next_milestone", "blind"]),
    selectionReason: z.string(),
    expiresAt: z.string().datetime(),
  })
  .strict();

const routeFailedSchema = z
  .object({
    routeId: z.string(),
    status: z.literal("failed"),
    failure: z.object({ code: z.string(), retryable: z.boolean() }).strict(),
  })
  .strict();

const routeSummarySchema = z.union([
  routeGeneratingSchema,
  routeReadySchema,
  routeFailedSchema,
]);
const routeTodayDataSchema = z.union([routeSummarySchema, z.null()]);
const routeGeometryDataSchema = z.union([
  z
    .object({
      routeId: z.string(),
      revealed: z.literal(true),
      encoding: z.literal("polyline"),
      precision: z.number().int(),
      coordinates: z.string(),
      bounds: z
        .object({
          north: z.number(),
          south: z.number(),
          east: z.number(),
          west: z.number(),
        })
        .strict(),
    })
    .strict(),
  z
    .object({
      routeId: z.string(),
      revealed: z.literal(false),
      encoding: z.literal("polyline"),
      precision: z.number().int(),
      coordinates: z.null(),
      bounds: z
        .object({
          north: z.number(),
          south: z.number(),
          east: z.number(),
          west: z.number(),
        })
        .strict(),
    })
    .strict(),
]);
const routeGeometryPageDataSchema = z
  .object({
    routeId: z.string(),
    revealed: z.literal(true),
    encoding: z.literal("polyline"),
    precision: z.number().int(),
    segments: z.array(
      z.object({ ordinal: z.number().int(), coordinates: z.string() }).strict(),
    ),
  })
  .strict();
const routeRegenerateDataSchema = z
  .object({
    route: z.union([
      routeGeneratingSchema,
      z
        .object({
          routeId: z.string(),
          status: z.literal("ready"),
          title: z.string(),
          distanceMeters: z.number(),
          estimatedDurationSec: z.number().int(),
          safetyScore: z.number(),
        })
        .strict(),
    ]),
    regenerationsRemaining: z.number().int().nonnegative(),
  })
  .strict();
const rejectedFinishDataExample = {
  ...(STUB_RESPONSE_FIXTURES["run.finish"].data as Record<string, unknown>),
  status: "rejected",
  integrity: "rejected",
  reasonCodes: ["SPEED_ANOMALY"],
  claimId: null,
  rewardPreview: { coins: 0, rp: 0, exp: 0 },
};

function responseDataSchema(
  key: keyof typeof STUB_RESPONSE_FIXTURES,
  example: unknown,
): z.ZodType {
  if (key === "run.list")
    return z.array(
      z
        .object({
          runId: z.string(),
          routeId: z.string(),
          trackTitle: z.string().nullable(),
          status: z.enum(["completed", "safe_stopped", "rejected"]),
          startedAt: z.string().datetime(),
          endedAt: z.string().datetime().nullable(),
          distanceMeters: z.number().nullable(),
          durationSec: z.number().nullable(),
          avgPaceSecPerKm: z.number().nullable(),
          levelExpGained: z.number().nullable(),
          coinsGained: z.number().nullable(),
          expEarnedBase: z.number().nullable(),
          expMultiplier: z.number().nullable(),
          expPenalty: z.number().nullable(),
          rpGained: z.number().nullable(),
          estimatedCalories: z.number().nullable(),
          streakDays: z.number().int().nullable(),
          reachedMilestones: z.number().int().nullable(),
          loadoutLabel: z.string(),
          rejectionCode: z.string().nullable(),
          claimId: z.string().nullable(),
          claimed: z.boolean(),
        })
        .strict(),
    );
  if (key === "run.trace")
    return z.array(
      z
        .object({
          sequence: z.number().int(),
          t: z.number().int(),
          lat: z.number(),
          lng: z.number(),
          accuracyMeters: z.number(),
          speedMps: z.number().optional(),
          mocked: z.boolean().optional(),
        })
        .strict(),
    );
  if (key === "badge.get")
    return z.array(
      z
        .object({
          id: z.string(),
          name: z.string(),
          description: z.string(),
          unlocked: z.boolean(),
          progress: z.number().nullable(),
          unlockedAt: z.string().datetime().nullable(),
        })
        .strict(),
    );
  if (key === "streak.get")
    return z
      .object({
        currentDays: z.number().int(),
        bestDays: z.number().int(),
        freezesRemaining: z.number().int(),
        restShieldActive: z.boolean(),
        lastQualifiedAt: z.string().datetime().nullable(),
      })
      .strict();
  if (key === "coin.ledger")
    return z.array(
      z
        .object({
          id: z.string(),
          currency: z.literal("coin"),
          amount: z.number().int(),
          reason: z.string(),
          refId: z.string().nullable(),
          createdAt: z.string().datetime(),
        })
        .strict(),
    );
  if (key === "route.today") return routeTodayDataSchema;
  if (key === "route.generate") return z.union([routeGeneratingSchema, routeReadySchema]);
  if (key === "route.regenerate") return routeRegenerateDataSchema;
  if (key === "route.geometry") return routeGeometryDataSchema;
  if (key === "run.finish")
    return schemaFromExamples([example, rejectedFinishDataExample]);
  if (key === "run.summary") {
    const summary = example as Record<string, unknown>;
    const streakAfter = summary.streakAfter as Record<string, unknown>;
    return schemaFromExamples([
      example,
      {
        ...summary,
        safeStop: { reason: "tired", usedThisWeek: 1, quota: 2, withinQuota: true },
      },
      {
        ...summary,
        status: "rejected",
        claim: null,
        streakAfter: { ...streakAfter, currentDays: 0, lastQualifiedAt: null },
      },
    ]);
  }
  if (key === "run.get") {
    return schemaFromExamples([
      example,
      {
        ...(example as Record<string, unknown>),
        status: "completed",
        claim: { claimId: "claim_123", claimed: false },
      },
    ]);
  }
  if (key === "run.active") {
    const activeRun = z
      .object({
        runId: z.string(),
        routeId: z.string(),
        status: z.enum(["active", "paused"]),
        startedAt: z.string().datetime(),
        elapsedSec: z.number().int(),
        activeSec: z.number().int(),
        distanceMeters: z.number(),
        lastSampleSequence: z.number().int(),
        reachedMilestoneIds: z.array(z.string()),
      })
      .strict();
    return z.object({ run: activeRun.nullable() }).strict();
  }
  if (key === "run.claim") {
    const claim = example as Record<string, unknown>;
    const level = claim.level as Record<string, unknown>;
    return schemaFromExamples([
      example,
      {
        ...claim,
        level: {
          ...level,
          levelCode: "master",
          levelName: "Master",
          totalExp: 500_000,
          levelStartExp: 300_000,
          nextLevelAtExp: null,
          progress: 1,
          mascotForm: "kila_legend",
        },
      },
    ]);
  }
  if (key === "me.home-summary") {
    return schemaFromExamples([
      example,
      { ...(example as Record<string, unknown>), nextLevelAtExp: null, levelProgress: 1 },
    ]);
  }
  return schemaFromExample(example);
}

interface EndpointInput {
  readonly key: keyof typeof STUB_RESPONSE_FIXTURES;
  readonly operationId: string;
  readonly method: ApiMethod;
  readonly path: string;
  readonly testPath: string;
  readonly summary: string;
  readonly description: string;
  readonly protected?: boolean;
  readonly idempotencyRequired?: boolean;
  readonly idempotencyAccepted?: boolean;
  readonly additionalStatusCodes?: readonly number[];
  readonly bodySchema?: z.ZodType;
  readonly bodyRequired?: boolean;
  readonly querySchema?: z.ZodObject;
  readonly paramsSchema?: z.ZodObject;
  readonly bodyExample?: Record<string, unknown>;
}

function defineEndpoint(input: EndpointInput): EndpointContract {
  const fixture: StubResponseFixture = STUB_RESPONSE_FIXTURES[input.key];
  const responseMode = fixture.responseMode ?? "success";
  const metaSchema =
    responseMode === "list"
      ? z
          .object({
            requestId: z.string(),
            timestamp: z.string().datetime(),
            nextCursor: z.string().nullable(),
            limit: z.number().int(),
          })
          .strict()
      : z.object({ requestId: z.string(), timestamp: z.string().datetime() }).strict();
  const dataSchema = responseDataSchema(input.key, fixture.data);
  const responseSchema =
    input.key === "route.geometry"
      ? z.union([
          z.object({ data: dataSchema, meta: metaSchema }).strict(),
          z
            .object({
              data: routeGeometryPageDataSchema,
              meta: z
                .object({
                  requestId: z.string(),
                  timestamp: z.string().datetime(),
                  nextCursor: z.string().nullable(),
                  limit: z.number().int(),
                })
                .strict(),
            })
            .strict(),
        ])
      : z.object({ data: dataSchema, meta: metaSchema }).strict();
  return {
    operationId: input.operationId,
    method: input.method,
    expressPath: input.path,
    openApiPath: "/api/v1" + input.path.replace(/:([A-Za-z0-9_]+)/g, "{$1}"),
    testPath: "/api/v1" + input.testPath,
    summary: input.summary,
    description: input.description,
    protected: input.protected ?? true,
    idempotencyRequired: input.idempotencyRequired ?? false,
    idempotencyAccepted: input.idempotencyAccepted ?? input.idempotencyRequired ?? false,
    bodyRequired: input.bodyRequired ?? true,
    statusCode: fixture.statusCode ?? 200,
    additionalStatusCodes: input.additionalStatusCodes ?? [],
    responseMode,
    responseData: fixture.data,
    responseSchema,
    ...(input.bodySchema ? { bodySchema: input.bodySchema } : {}),
    ...(input.querySchema ? { querySchema: input.querySchema } : {}),
    ...(input.paramsSchema ? { paramsSchema: input.paramsSchema } : {}),
    ...(input.bodyExample === undefined ? {} : { bodyExample: input.bodyExample }),
  };
}

export const API_ENDPOINTS: readonly EndpointContract[] = [
  defineEndpoint({
    key: "config.game",
    operationId: "getGameConfig",
    method: "get",
    path: "/config/game",
    testPath: "/config/game",
    summary: "Get game configuration",
    description: "Returns the active game balance and item configuration.",
  }),
  defineEndpoint({
    key: "auth.register",
    operationId: "register",
    method: "post",
    path: "/auth/register",
    testPath: "/auth/register",
    summary: "Register an account",
    description: "Creates a user with initial profile and inventory.",
    protected: false,
    bodySchema: RegisterBodySchema,
    bodyExample: {
      displayName: "Rani",
      email: "rani@example.com",
      password: "KataSandiKuat123",
      locale: "en",
      timezone: "Asia/Jakarta",
    },
  }),
  defineEndpoint({
    key: "auth.login",
    operationId: "login",
    method: "post",
    path: "/auth/login",
    testPath: "/auth/login",
    summary: "Sign in",
    description: "Starts a session and returns access and refresh tokens.",
    protected: false,
    bodySchema: LoginBodySchema,
    bodyExample: {
      email: "rani@example.com",
      password: "KataSandiKuat123",
      rememberMe: true,
    },
  }),
  defineEndpoint({
    key: "auth.google",
    operationId: "loginWithGoogle",
    method: "post",
    path: "/auth/google",
    testPath: "/auth/google",
    summary: "Sign in with Google",
    description: "Verifies a Google OpenID Connect ID token and starts an API session.",
    protected: false,
    bodySchema: GoogleAuthBodySchema,
    bodyExample: {
      idToken: "google-id-token",
      locale: "en",
      timezone: "Asia/Jakarta",
    },
  }),
  defineEndpoint({
    key: "auth.refresh",
    operationId: "refreshToken",
    method: "post",
    path: "/auth/refresh",
    testPath: "/auth/refresh",
    summary: "Refresh session tokens",
    description: "Rotates the refresh token.",
    protected: false,
    bodySchema: RefreshBodySchema,
    bodyExample: { refreshToken: "rt_2f6c9a1b7d" },
  }),
  defineEndpoint({
    key: "auth.logout",
    operationId: "logout",
    method: "post",
    path: "/auth/logout",
    testPath: "/auth/logout",
    summary: "Log out",
    description: "Revokes the supplied refresh token.",
    bodySchema: LogoutBodySchema,
    bodyExample: { refreshToken: "rt_8e41c0d9aa" },
  }),
  defineEndpoint({
    key: "me.get",
    operationId: "getMe",
    method: "get",
    path: "/me",
    testPath: "/me",
    summary: "Get current user",
    description: "Returns the signed-in user's basic profile.",
  }),
  defineEndpoint({
    key: "me.onboarding",
    operationId: "updateOnboarding",
    method: "patch",
    path: "/me/onboarding",
    testPath: "/me/onboarding",
    summary: "Update onboarding and profile preferences",
    description: "Stores health disclaimer acceptance, language, and IANA timezone.",
    bodySchema: OnboardingBodySchema,
    bodyExample: {
      healthDisclaimerAccepted: true,
      locale: "en",
      timezone: "Asia/Jakarta",
    },
  }),
  defineEndpoint({
    key: "me.home-summary",
    operationId: "getHomeSummary",
    method: "get",
    path: "/me/home-summary",
    testPath: "/me/home-summary",
    summary: "Get home summary",
    description: "Returns the level progress card for Home.",
  }),
  defineEndpoint({
    key: "me.wallet",
    operationId: "getWallet",
    method: "get",
    path: "/me/wallet",
    testPath: "/me/wallet",
    summary: "Get wallet",
    description: "Returns the user's coin balance and progress.",
  }),
  defineEndpoint({
    key: "route.today",
    operationId: "getTodaysMysteryRoute",
    method: "get",
    path: "/routes/mystery/today",
    testPath: "/routes/mystery/today",
    summary: "Get today's mystery route",
    description: "Returns the active mystery route or null when none exists.",
  }),
  defineEndpoint({
    key: "route.generate",
    operationId: "generateMysteryRoute",
    method: "post",
    path: "/routes/mystery/generate",
    testPath: "/routes/mystery/generate",
    summary: "Generate a mystery route",
    description: "Starts route generation or returns a reusable route.",
    idempotencyRequired: true,
    additionalStatusCodes: [200],
    bodySchema: GenerateRouteBodySchema,
    bodyExample: {
      location: { lat: -6.2185, lng: 106.8021, accuracyMeters: 12 },
      weather: { temperatureC: 31.5, observedAt: "2026-10-25T09:25:00Z" },
      preferredDistanceMeters: 1500,
    },
  }),
  defineEndpoint({
    key: "route.regenerate",
    operationId: "regenerateMysteryRoute",
    method: "post",
    path: "/routes/mystery/regenerate",
    testPath: "/routes/mystery/regenerate",
    summary: "Regenerate a mystery route",
    description: "Requests a replacement for the active mystery route.",
    idempotencyRequired: true,
    bodyRequired: false,
    bodySchema: RegenerateRouteBodySchema,
    bodyExample: {
      location: { lat: -6.2185, lng: 106.8021, accuracyMeters: 12 },
      weather: { temperatureC: 31.5 },
    },
  }),
  defineEndpoint({
    key: "route.preview",
    operationId: "getRoutePreview",
    method: "get",
    path: "/routes/:routeId/preview",
    testPath: "/routes/route_456/preview",
    summary: "Get route preview",
    description: "Returns route details before a run starts.",
    paramsSchema: RouteIdParamsSchema,
  }),
  defineEndpoint({
    key: "route.geometry",
    operationId: "getRouteGeometry",
    method: "get",
    path: "/routes/:routeId/geometry",
    testPath: "/routes/route_456/geometry?detail=preview",
    summary: "Get route geometry",
    description: "Returns route geometry for preview or paging.",
    paramsSchema: RouteIdParamsSchema,
    querySchema: GeometryQuerySchema,
  }),
  defineEndpoint({
    key: "route.report",
    operationId: "reportRoute",
    method: "post",
    path: "/routes/:routeId/reports",
    testPath: "/routes/route_456/reports",
    summary: "Report a route",
    description: "Reports an unsafe or incorrect route.",
    paramsSchema: RouteIdParamsSchema,
    bodySchema: RouteReportBodySchema,
    bodyExample: {
      reason: "safety_concern",
      details: "No sidewalk and fast motorbikes.",
    },
  }),
  defineEndpoint({
    key: "inventory.get",
    operationId: "getInventory",
    method: "get",
    path: "/me/inventory",
    testPath: "/me/inventory",
    summary: "Get inventory",
    description: "Returns the user's item inventory.",
  }),
  defineEndpoint({
    key: "loadout.get",
    operationId: "getLoadout",
    method: "get",
    path: "/me/loadout",
    testPath: "/me/loadout",
    summary: "Get loadout",
    description: "Returns the equipped item slots.",
  }),
  defineEndpoint({
    key: "loadout.patch",
    operationId: "updateLoadout",
    method: "patch",
    path: "/me/loadout",
    testPath: "/me/loadout",
    summary: "Update loadout",
    description: "Updates selected item slots.",
    bodySchema: LoadoutBodySchema,
    bodyExample: { boostItemCode: "exp_boost", modifierItemCode: "less_compensation" },
  }),
  defineEndpoint({
    key: "run.start",
    operationId: "startRun",
    method: "post",
    path: "/runs",
    testPath: "/runs",
    summary: "Start a run",
    description: "Starts a run and returns its milestone package.",
    idempotencyRequired: true,
    bodySchema: StartRunBodySchema,
    bodyExample: {
      routeId: "route_456",
      boostItemCode: null,
      modifierItemCode: "less_compensation",
      units: "metric",
      startLocation: { lat: -6.2185, lng: 106.8021, accuracyMeters: 8 },
      clientCapabilities: {
        platform: "android",
        appVersion: "1.0.0",
        backgroundLocation: true,
        mockLocationEnabled: false,
      },
    },
  }),
  defineEndpoint({
    key: "run.get",
    operationId: "getRun",
    method: "get",
    path: "/runs/:runId",
    testPath: "/runs/run_123",
    summary: "Get a run",
    description: "Returns run status for recovery.",
    paramsSchema: RunIdParamsSchema,
  }),
  defineEndpoint({
    key: "run.active",
    operationId: "getActiveRun",
    method: "get",
    path: "/runs/active",
    testPath: "/runs/active",
    summary: "Get active run",
    description: "Returns the current active or paused run for recovery.",
  }),
  defineEndpoint({
    key: "run.trace",
    operationId: "getRunTrace",
    method: "get",
    path: "/runs/:runId/trace",
    testPath: "/runs/run_123/trace",
    summary: "Get run GPS trace",
    description: "Returns GPS samples recorded for the user's run history map.",
    paramsSchema: RunIdParamsSchema,
  }),
  defineEndpoint({
    key: "run.pause",
    operationId: "pauseRun",
    method: "post",
    path: "/runs/:runId/pause",
    testPath: "/runs/run_123/pause",
    summary: "Pause a run",
    description: "Pauses the active run.",
    paramsSchema: RunIdParamsSchema,
  }),
  defineEndpoint({
    key: "run.resume",
    operationId: "resumeRun",
    method: "post",
    path: "/runs/:runId/resume",
    testPath: "/runs/run_123/resume",
    summary: "Resume a run",
    description: "Resumes a paused run.",
    paramsSchema: RunIdParamsSchema,
  }),
  defineEndpoint({
    key: "run.locations",
    operationId: "uploadRunLocations",
    method: "post",
    path: "/runs/:runId/locations",
    testPath: "/runs/run_123/locations",
    summary: "Upload run locations",
    description: "Uploads up to 100 ordered location samples.",
    paramsSchema: RunIdParamsSchema,
    bodySchema: LocationsBodySchema,
    bodyExample: {
      samples: [
        {
          sequence: 1,
          t: 1792920605000,
          lat: -6.21851,
          lng: 106.80212,
          accuracyMeters: 6.5,
          speedMps: 2.7,
          altitudeMeters: 12,
          mocked: false,
        },
      ],
    },
  }),
  defineEndpoint({
    key: "run.reach",
    operationId: "reachMilestone",
    method: "post",
    path: "/runs/:runId/milestones/:milestoneId/reach",
    testPath: "/runs/run_123/milestones/ms_1/reach",
    summary: "Reach a milestone",
    description: "Submits a provisional geofence result.",
    idempotencyAccepted: true,
    paramsSchema: RunMilestoneParamsSchema,
    bodySchema: ReachMilestoneBodySchema,
    bodyExample: {
      reachedAt: "2026-10-25T09:34:05Z",
      location: { lat: -6.2171, lng: 106.8034, accuracyMeters: 7 },
      lastSampleSequence: 245,
    },
  }),
  defineEndpoint({
    key: "run.safe-stop",
    operationId: "safeStopRun",
    method: "post",
    path: "/runs/:runId/safe-stop",
    testPath: "/runs/run_123/safe-stop",
    summary: "Safe stop a run",
    description: "Ends a run under the weekly safe-stop rule.",
    idempotencyAccepted: true,
    paramsSchema: RunIdParamsSchema,
    bodySchema: SafeStopBodySchema,
    bodyExample: { reason: "tired", lastSampleSequence: 330 },
  }),
  defineEndpoint({
    key: "run.finish",
    operationId: "finishRun",
    method: "post",
    path: "/runs/:runId/finish",
    testPath: "/runs/run_123/finish",
    summary: "Finish a run",
    description: "Calculates the run result without crediting rewards.",
    idempotencyAccepted: true,
    paramsSchema: RunIdParamsSchema,
    bodySchema: FinishBodySchema,
    bodyExample: {
      endedAt: "2026-10-25T09:39:30Z",
      lastSampleSequence: 642,
      clientSummary: { distanceMeters: 1162, durationSec: 570 },
    },
  }),
  defineEndpoint({
    key: "run.summary",
    operationId: "getRunSummary",
    method: "get",
    path: "/runs/:runId/summary",
    testPath: "/runs/run_123/summary",
    summary: "Get run summary",
    description: "Returns the finished run summary.",
    paramsSchema: RunIdParamsSchema,
  }),
  defineEndpoint({
    key: "run.claim",
    operationId: "claimRunRewards",
    method: "post",
    path: "/runs/:runId/claim",
    testPath: "/runs/run_123/claim",
    summary: "Claim run rewards",
    description: "Credits run rewards once.",
    idempotencyRequired: true,
    paramsSchema: RunIdParamsSchema,
    bodySchema: ClaimBodySchema,
    bodyExample: { claimId: "claim_123" },
  }),
  defineEndpoint({
    key: "badge.get",
    operationId: "getBadges",
    method: "get",
    path: "/badges",
    testPath: "/badges",
    summary: "Get achievements",
    description: "Returns localized badges and progress derived from completed runs.",
  }),
  defineEndpoint({
    key: "streak.get",
    operationId: "getStreak",
    method: "get",
    path: "/streak",
    testPath: "/streak",
    summary: "Get running streak",
    description: "Returns the current and best local-day streak for the user.",
  }),
  defineEndpoint({
    key: "shop.catalog",
    operationId: "getShopCatalog",
    method: "get",
    path: "/shop/items",
    testPath: "/shop/items",
    summary: "Get shop catalog",
    description: "Returns coin-priced game items and current availability.",
  }),
  defineEndpoint({
    key: "shop.purchase",
    operationId: "purchaseShopItem",
    method: "post",
    path: "/shop/purchase",
    testPath: "/shop/purchase",
    summary: "Purchase a game item",
    description: "Buys one item with in-game coins. No external payment is involved.",
    idempotencyRequired: true,
    additionalStatusCodes: [201],
    bodySchema: ShopPurchaseBodySchema,
    bodyExample: { itemId: "exp_boost" },
  }),
  defineEndpoint({
    key: "coin.ledger",
    operationId: "getCoinLedger",
    method: "get",
    path: "/coins/ledger",
    testPath: "/coins/ledger?limit=20",
    summary: "Get coin ledger",
    description: "Returns a cursor-paginated history of coin credits and debits.",
    querySchema: CursorPageQuerySchema,
  }),
  defineEndpoint({
    key: "run.list",
    operationId: "listRuns",
    method: "get",
    path: "/runs",
    testPath: "/runs?limit=20",
    summary: "List run history",
    description:
      "Returns the signed-in user's completed, safe-stopped, and rejected runs.",
    querySchema: CursorPageQuerySchema,
  }),
  defineEndpoint({
    key: "run.guidance",
    operationId: "getRunGuidance",
    method: "get",
    path: "/runs/:runId/guidance",
    testPath: "/runs/run_123/guidance",
    summary: "Get run guidance",
    description: "Returns turn-by-turn steps and dialogue for offline use.",
    paramsSchema: RunIdParamsSchema,
  }),
];

export function responseSchemaFromExample(example: unknown): z.ZodType {
  return schemaFromExample(example);
}

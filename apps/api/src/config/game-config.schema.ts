import { z } from "zod";

export const LEVEL_CODES = [
  "beginner",
  "intermediate",
  "advanced",
  "professional",
  "master",
] as const;
export const ITEM_CODES = ["exp_boost", "less_compensation", "gain_more"] as const;

const DEFAULT_ROUTE_SAFETY = {
  minimumDataConfidencePermil: 500,
  maxPrimaryRoadSharePermil: 100,
  nightSafetyFactorPermil: 500,
  maxUnpavedSharePermilByLevel: {
    beginner: 100,
    intermediate: 250,
    advanced: 400,
    professional: 600,
    master: 800,
  },
  maxSlopePermilByLevel: {
    beginner: 100,
    intermediate: 150,
    advanced: 200,
    professional: 250,
    master: 300,
  },
} as const;

const LevelConfigSchema = z
  .object({
    code: z.enum(LEVEL_CODES),
    index: z.number().int().positive(),
    name: z.string().min(1),
    distanceMinMeters: z.number().int().positive(),
    distanceMaxMeters: z.number().int().positive(),
    milestoneMin: z.number().int().positive(),
    milestoneMax: z.number().int().positive(),
    targetSpacingMeters: z.number().int().positive(),
    expPerKm: z.number().int().positive(),
    startExp: z.number().int().nonnegative(),
    nextLevelAtExp: z.number().int().positive().nullable(),
    expPerCoin: z.number().int().positive(),
    safeStopPerWeek: z.number().int().nonnegative(),
    defaultRevealMode: z.enum(["full", "next_milestone", "blind"]),
    mascotForm: z.string().min(1),
  })
  .strict();

const ItemConfigSchema = z
  .object({
    code: z.enum(ITEM_CODES),
    name: z.string().min(1),
    slot: z.enum(["boost", "modifier"]),
    maxStock: z.number().int().nonnegative(),
    exclusiveCodes: z.array(z.enum(ITEM_CODES)),
  })
  .strict();

const RouteSafetySchema = z
  .object({
    minimumDataConfidencePermil: z.number().int().min(0).max(1000),
    maxPrimaryRoadSharePermil: z.number().int().min(0).max(1000),
    nightSafetyFactorPermil: z.number().int().min(0).max(1000),
    maxUnpavedSharePermilByLevel: z.record(
      z.enum(LEVEL_CODES),
      z.number().int().min(0).max(1000),
    ),
    maxSlopePermilByLevel: z.record(
      z.enum(LEVEL_CODES),
      z.number().int().min(0).max(1000),
    ),
  })
  .strict();

const GameRulesSchema = z
  .object({
    penaltyFreeRuns: z.number().int().nonnegative(),
    boostWindowActiveSec: z.number().int().positive(),
    boostMultiplierPermil: z.number().int().positive(),
    gainMoreMultiplierPermil: z.number().int().positive(),
    multiplierCapPermil: z.number().int().positive(),
    penaltyPermil: z
      .object({
        default: z.number().int().nonnegative(),
        less_compensation: z.number().int().nonnegative(),
        gain_more: z.number().int().nonnegative(),
      })
      .strict(),
    milestoneRadiusMeters: z.number().int().positive(),
    trackStartRadiusMeters: z.number().int().positive(),
    startMaxDistanceMeters: z.number().int().positive(),
    minimumDistanceMeters: z.number().int().positive(),
    regenerationsPerDay: z.number().int().nonnegative(),
    kcalPerKm: z.number().int().positive(),
    startingItemStock: z.number().int().nonnegative(),
    weekStart: z.literal("monday_utc"),
  })
  .strict();

export const GameConfigSchema = z
  .object({
    configVersion: z.number().int().positive(),
    levels: z.array(LevelConfigSchema).length(5),
    items: z.array(ItemConfigSchema).length(3),
    rules: GameRulesSchema,
    routeSafety: RouteSafetySchema.default(DEFAULT_ROUTE_SAFETY),
    routeExpiryHourUtc: z.number().int().min(0).max(23).default(0),
  })
  .strict();

export type GameConfig = z.infer<typeof GameConfigSchema>;
export type GameLevel = GameConfig["levels"][number];
export type GameItem = GameConfig["items"][number];
export type ItemCode = (typeof ITEM_CODES)[number];
export type LevelCode = (typeof LEVEL_CODES)[number];

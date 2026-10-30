export type ItemCode = "exp_boost" | "less_compensation" | "gain_more";
export type LevelCode =
  "beginner" | "intermediate" | "advanced" | "professional" | "master";
export type RunStatus = "active" | "paused" | "completed" | "safe_stopped" | "rejected";
export type Integrity = "clean" | "flagged" | "rejected";

export interface GameLevelRule {
  readonly code: LevelCode;
  readonly index: number;
  readonly name: string;
  readonly startExp: number;
  readonly nextLevelAtExp: number | null;
  readonly distanceMinMeters: number;
  readonly distanceMaxMeters: number;
  readonly milestoneMin: number;
  readonly milestoneMax: number;
  readonly targetSpacingMeters: number;
  readonly expPerKm: number;
  readonly expPerCoin: number;
  readonly safeStopPerWeek: number;
}

export interface GameItemRule {
  readonly code: ItemCode;
  readonly slot: "boost" | "modifier";
  readonly exclusiveCodes: readonly ItemCode[];
}

export interface GameRules {
  readonly penaltyFreeRuns: number;
  readonly boostWindowActiveSec: number;
  readonly boostMultiplierPermil: number;
  readonly gainMoreMultiplierPermil: number;
  readonly multiplierCapPermil: number;
  readonly penaltyPermil: {
    readonly default: number;
    readonly less_compensation: number;
    readonly gain_more: number;
  };
}

export interface GameLoadout {
  readonly boostItemCode: ItemCode | null;
  readonly modifierItemCode: ItemCode | null;
}

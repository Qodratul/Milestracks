import type { LevelCode } from "./game";

export interface RoutePoint {
  readonly lat: number;
  readonly lng: number;
}

export interface RouteGuidanceInstruction {
  readonly text: string;
  readonly distanceMeters: number;
  readonly sign?: number;
}

export interface RouteGenerationInput {
  readonly location: RoutePoint & { readonly accuracyMeters: number };
  readonly targetDistanceMeters: number;
  readonly levelCode: LevelCode;
  readonly locale: "id" | "en";
  readonly excludedTemplateId?: string | undefined;
  readonly weather?:
    | {
        readonly temperatureC: number;
        readonly observedAt?: string | undefined;
      }
    | undefined;
}

export interface RouteGeneratingResponse {
  readonly routeId: string;
  readonly status: "generating";
  readonly pollAfterMs: number;
}

export interface RouteReadySummary {
  readonly routeId: string;
  readonly status: "ready";
  readonly level: LevelCode;
  readonly title: string;
  readonly mysteryBrief: string;
  readonly distanceMeters: number;
  readonly estimatedDurationSec: number;
  readonly estimatedCalories: number;
  readonly milestoneCount: number;
  readonly expPerMilestone: number;
  readonly startPoint: {
    readonly label: string;
    readonly distanceMeters: number;
    readonly location: RoutePoint;
  };
  readonly safetyScore: number;
  readonly dataConfidence: number;
  readonly warning?: string | null;
  readonly revealMode: "full" | "next_milestone" | "blind";
  readonly selectionReason: string;
  readonly expiresAt: string;
}

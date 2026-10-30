export type RunnerLevel =
  "Beginner" | "Intermediate" | "Advanced" | "Professional" | "Master";
export type SupportedLanguage = "id" | "en";

export interface RouteCandidate {
  readonly id: string;
  readonly distanceKm: number;
  readonly elevationGain?: string;
  readonly maxGradePercent?: number;
  readonly turnsPerKm?: number;
  readonly safetyScore?: number;
  readonly dataConfidence?: number;
  readonly surfaceDesc?: string;
  readonly areaHints?: readonly string[];
}

export interface RoutePromptInput {
  readonly userLevel: RunnerLevel;
  readonly totalDistanceKm: number;
  readonly milestoneCount: number;
  readonly surfaceType?: string;
  readonly weatherCondition?: string;
  readonly timeOfDay?: string;
  readonly language?: SupportedLanguage;
  readonly consecutiveRunningDays?: number;
  readonly candidates?: readonly RouteCandidate[];
}

export interface MilestoneDialogueOutput {
  readonly milestoneOrder: number;
  readonly cheerLine: string;
  readonly continuePrompt: string;
  readonly restPrompt: string;
  readonly warnLine: string;
}

export interface TrackNarrativeOutput {
  readonly selectedRouteId: string;
  readonly selectionReason: string;
  readonly trackTitle: string;
  readonly mysteryBrief: string;
  readonly preRunTip: string;
  readonly milestoneDialogues: readonly MilestoneDialogueOutput[];
}

export interface TrackNarrativeAttempt {
  readonly output: TrackNarrativeOutput;
  readonly usedFallback: boolean;
  readonly attempts: number;
  readonly validFirstAttempt: boolean;
  readonly jsonSchemaRequested: boolean;
  readonly toolCallRequested: boolean;
}

export interface SafetyDiagnosticInput {
  userLevel: RunnerLevel;
  currentPaceSecPerKm: number;
  baselinePaceSecPerKm: number;
  weatherTempCelsius: number;
  consecutiveRunningDays: number;
  failedMilestonesToday: number;
  language?: SupportedLanguage;
}

export interface SafetyCheckOutput {
  recommendSafeStop: boolean;
  applyRestShield: boolean;
  kilaAdvice: string;
  riskLevel: "low" | "moderate" | "high";
}

export interface LLMProvider {
  generateTrackNarrative(input: RoutePromptInput): Promise<TrackNarrativeOutput>;
  generateTrackNarrativeDetailed?(
    input: RoutePromptInput,
  ): Promise<TrackNarrativeAttempt>;
  evaluateRunnerSafety(input: SafetyDiagnosticInput): Promise<SafetyCheckOutput>;
}

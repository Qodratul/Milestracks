import {
  buildDeterministicTrackFallback,
  type LLMProvider,
  type RouteCandidate,
  type RoutePromptInput,
  type RunnerLevel,
  type TrackNarrativeOutput,
} from "../providers/llm";

export interface SelectableRoute {
  readonly id: string;
  readonly distanceMeters: number;
  readonly scorePermil: number;
  readonly safetyScore: number;
  readonly dataConfidence: number;
  readonly elevationGainMeters: number;
  readonly maxGradePercent: number;
  readonly surfaces: readonly string[];
  readonly areaHints: readonly string[];
}

export interface RouteSelectionInput {
  readonly userLevel: RunnerLevel;
  readonly totalDistanceMeters: number;
  readonly milestoneCount: number;
  readonly language: "id" | "en";
  readonly candidates: readonly SelectableRoute[];
}

export interface RouteSelectionResult {
  readonly selected: SelectableRoute;
  readonly narrative: TrackNarrativeOutput;
  readonly usedFallback: boolean;
}

export class RouteSelectionService {
  public constructor(private readonly llm: LLMProvider) {}

  public async select(input: RouteSelectionInput): Promise<RouteSelectionResult> {
    if (input.candidates.length === 0) {
      throw new RangeError("At least one safe route candidate is required.");
    }
    const ranked = [...input.candidates].sort(
      (left, right) =>
        right.scorePermil - left.scorePermil || left.id.localeCompare(right.id),
    );
    const prompt: RoutePromptInput = {
      userLevel: input.userLevel,
      totalDistanceKm: input.totalDistanceMeters / 1000,
      milestoneCount: input.milestoneCount,
      language: input.language,
      candidates: ranked.map(toPromptCandidate),
    };
    const fallback = buildDeterministicTrackFallback(prompt);
    const detailedGenerator = this.llm.generateTrackNarrativeDetailed;
    if (detailedGenerator) {
      try {
        const result = await detailedGenerator.call(this.llm, prompt);
        const selected = ranked.find(
          (candidate) => candidate.id === result.output.selectedRouteId,
        );
        if (result.usedFallback) {
          return {
            selected: selected ?? ranked[0]!,
            narrative: result.output,
            usedFallback: true,
          };
        }
        if (selected && hasCorrectDialogues(result.output, input.milestoneCount)) {
          return { selected, narrative: result.output, usedFallback: false };
        }
      } catch {
        // The deterministic route ranker below remains available on provider errors.
      }
      return { selected: ranked[0]!, narrative: fallback, usedFallback: true };
    }

    for (let attempt = 0; attempt < 2; attempt += 1) {
      let narrative: TrackNarrativeOutput;
      try {
        narrative = await this.llm.generateTrackNarrative(prompt);
      } catch {
        continue;
      }
      const selected = ranked.find(
        (candidate) => candidate.id === narrative.selectedRouteId,
      );
      if (selected && hasCorrectDialogues(narrative, input.milestoneCount)) {
        return { selected, narrative, usedFallback: false };
      }
    }
    return { selected: ranked[0]!, narrative: fallback, usedFallback: true };
  }
}

function toPromptCandidate(route: SelectableRoute): RouteCandidate {
  return {
    id: route.id,
    distanceKm: route.distanceMeters / 1000,
    elevationGain: String(route.elevationGainMeters) + " m",
    maxGradePercent: route.maxGradePercent,
    safetyScore: route.safetyScore,
    dataConfidence: route.dataConfidence,
    surfaceDesc: route.surfaces.join(", ") || "unknown",
    areaHints: route.areaHints,
  };
}

function hasCorrectDialogues(
  narrative: TrackNarrativeOutput,
  expectedCount: number,
): boolean {
  return (
    narrative.milestoneDialogues.length === expectedCount &&
    narrative.milestoneDialogues.every(
      (dialogue, index) => dialogue.milestoneOrder === index + 1,
    )
  );
}

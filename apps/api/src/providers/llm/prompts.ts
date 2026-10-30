import type { RoutePromptInput, SafetyDiagnosticInput } from "./types";

export const KILA_NEMOTRON_SYSTEM_PROMPT = [
  "You are Kila, a warm and supportive mouse-deer mascot for Milestracks.",
  "Choose only among the supplied safe route candidates and explain the choice.",
  "Treat candidate metrics as context; never alter safety scores.",
  "Return exactly one valid JSON object with exactly the requested fields.",
  "Do not wrap the JSON in Markdown fences or add text before or after it.",
  "Use double quotes for every JSON key and string; do not use trailing commas.",
  "Each milestone dialogue line must contain 12 words or fewer.",
  "Do not include coordinates, user identifiers, tokens, or hidden reasoning.",
].join("\n");

export function buildRouteUserPrompt(input: RoutePromptInput): string {
  const language = input.language === "en" ? "English" : "Bahasa Indonesia";
  const languageStyle =
    input.language === "id"
      ? "Use natural contemporary Bahasa Indonesia. Prefer simple words like pemanasan, minum air, jaga langkah, and perhatikan jalan. Avoid literal translations, invented words, and awkward phrasing."
      : "Use clear, natural everyday English with short, supportive sentences.";
  const candidates =
    input.candidates && input.candidates.length > 0
      ? input.candidates.map(formatCandidate).join("\n")
      : "- Option A: " +
        input.totalDistanceKm +
        " km, flat terrain, pedestrian-friendly area";
  const example = {
    selectedRouteId: input.candidates?.[0]?.id ?? "A",
    selectionReason:
      input.language === "id"
        ? "Rute ini aman dan sesuai dengan kondisi saat ini."
        : "This route is safe and suits the current conditions.",
    trackTitle: input.language === "id" ? "Jalur Pagi" : "Morning Trail",
    mysteryBrief:
      input.language === "id"
        ? "Ikuti jalur yang tenang dan temukan pemandangan baru."
        : "Follow quiet paths and discover a new view.",
    preRunTip:
      input.language === "id"
        ? "Lakukan pemanasan dan perhatikan jalan sekitar."
        : "Warm up and stay aware of your surroundings.",
    milestoneDialogues: Array.from({ length: input.milestoneCount }, (_, index) => ({
      milestoneOrder: index + 1,
      cheerLine:
        input.language === "id"
          ? "Hebat, kamu mencapai titik ini!"
          : "Great work reaching this checkpoint!",
      continuePrompt:
        input.language === "id"
          ? "Atur napas dan lanjutkan dengan santai."
          : "Keep your breathing steady as you continue.",
      restPrompt:
        input.language === "id"
          ? "Istirahat jika tubuh terasa lelah."
          : "Pause if your legs feel tense.",
      warnLine:
        input.language === "id"
          ? "Perhatikan kondisi jalan sekitar."
          : "Watch the path and nearby traffic.",
    })),
  };

  return [
    "Generate a route narrative and select the safest supplied candidate.",
    "Output language: " + language,
    languageStyle,
    "Runner level: " + input.userLevel,
    "Consecutive running days: " + (input.consecutiveRunningDays ?? 0),
    "Weather: " + (input.weatherCondition ?? "Clear"),
    "Time of day: " + (input.timeOfDay ?? "Morning"),
    "Target distance km: " + input.totalDistanceKm,
    "Exact milestone count: " + input.milestoneCount,
    "Candidate summaries without coordinates or user identifiers:",
    candidates,
    "Return JSON matching this example; each dialogue line is at most 12 words:",
    JSON.stringify(example),
  ].join("\n");
}

export const KILA_REASONING_SYSTEM_PROMPT = [
  "You are Kila, a caring mouse-deer mascot focused on runner safety.",
  "Analyze only the supplied telemetry and deterministic guardrails.",
  "Return one raw JSON object with actual boolean values.",
].join("\n");

export function buildSafetyUserPrompt(
  input: SafetyDiagnosticInput,
  rules: {
    readonly recommendSafeStop: boolean;
    readonly applyRestShield: boolean;
    readonly riskLevel: "low" | "moderate" | "high";
    readonly paceDropRatio: number;
  },
): string {
  const example = {
    recommendSafeStop: rules.recommendSafeStop,
    applyRestShield: rules.applyRestShield,
    riskLevel: rules.riskLevel,
    kilaAdvice:
      input.language === "en"
        ? "Your pace changed. Rest briefly and hydrate before continuing."
        : "Pace kamu berubah. Istirahat sejenak dan minum sebelum lanjut.",
  };
  return [
    "Review runner safety telemetry in " +
      (input.language === "en" ? "English" : "Bahasa Indonesia") +
      ".",
    "Level: " + input.userLevel,
    "Current pace sec/km: " + input.currentPaceSecPerKm,
    "Baseline pace sec/km: " + input.baselinePaceSecPerKm,
    "Temperature C: " + input.weatherTempCelsius,
    "Consecutive running days: " + input.consecutiveRunningDays,
    "Failed milestones: " + input.failedMilestonesToday,
    "Deterministic risk: " + rules.riskLevel,
    "Pace drop ratio: " + rules.paceDropRatio,
    "Return JSON matching this shape: " + JSON.stringify(example),
  ].join("\n");
}

function formatCandidate(
  candidate: NonNullable<RoutePromptInput["candidates"]>[number],
): string {
  const fields = [
    "Option " + candidate.id,
    candidate.distanceKm + " km",
    "elevation " + (candidate.elevationGain ?? "unknown"),
    "max grade " + (candidate.maxGradePercent ?? "unknown") + "%",
    "turns per km " + (candidate.turnsPerKm ?? "unknown"),
    "safety score " + (candidate.safetyScore ?? "unknown"),
    "data confidence " + (candidate.dataConfidence ?? "unknown"),
    "surface " + (candidate.surfaceDesc ?? "pedestrian"),
    "area " + (candidate.areaHints?.join(", ") ?? "unknown"),
  ];
  return "- " + fields.join("; ");
}

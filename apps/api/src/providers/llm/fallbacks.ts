import type {
  RoutePromptInput,
  TrackNarrativeOutput,
  SafetyDiagnosticInput,
  SafetyCheckOutput,
  MilestoneDialogueOutput,
} from "./types";
import { routeNarrativeMessages } from "../../i18n/routes";

export function buildDeterministicTrackFallback(
  input: RoutePromptInput,
): TrackNarrativeOutput {
  const messages = routeNarrativeMessages[input.language === "en" ? "en" : "id"];
  const defaultRouteId = input.candidates?.[0]?.id || "A";
  const milestoneDialogues: MilestoneDialogueOutput[] = Array.from(
    { length: Math.max(1, input.milestoneCount) },
    (_unused, index) => {
      const order = index + 1;
      const templateIndex = index % messages.cheers.length;
      const cheerLine = messages.cheers[templateIndex] ?? "Milestone {n}";
      const continuePrompt = messages.continues[templateIndex] ?? "";
      const restPrompt = messages.rests[templateIndex] ?? "";
      return {
        milestoneOrder: order,
        cheerLine: cheerLine.replace("{n}", String(order)),
        continuePrompt,
        restPrompt,
        warnLine: messages.warning,
      };
    },
  );
  return {
    selectedRouteId: defaultRouteId,
    selectionReason: messages.selectionReason,
    trackTitle: messages.title(input.userLevel),
    mysteryBrief: messages.brief(input.totalDistanceKm, input.milestoneCount),
    preRunTip: messages.preRunTip,
    milestoneDialogues,
  };
}

export function evaluateDeterministicSafetyRules(input: SafetyDiagnosticInput): {
  recommendSafeStop: boolean;
  applyRestShield: boolean;
  riskLevel: "low" | "moderate" | "high";
  paceDropRatio: number;
} {
  const baseline = Math.max(180, input.baselinePaceSecPerKm);
  const paceDropRatio = (input.currentPaceSecPerKm - baseline) / baseline;
  const isExtremeHeat = input.weatherTempCelsius >= 34;
  const isSeverePaceDrop = paceDropRatio >= 0.25;
  const isHighFatigueStreak = input.consecutiveRunningDays >= 6;
  const hasMultipleFailures = input.failedMilestonesToday >= 2;

  if (isExtremeHeat || (isSeverePaceDrop && hasMultipleFailures)) {
    return {
      recommendSafeStop: true,
      applyRestShield: true,
      riskLevel: "high",
      paceDropRatio,
    };
  }

  if (isSeverePaceDrop || isHighFatigueStreak || input.weatherTempCelsius >= 31) {
    return {
      recommendSafeStop: false,
      applyRestShield: isHighFatigueStreak,
      riskLevel: "moderate",
      paceDropRatio,
    };
  }

  return {
    recommendSafeStop: false,
    applyRestShield: false,
    riskLevel: "low",
    paceDropRatio,
  };
}

export function buildDeterministicSafetyFallback(
  input: SafetyDiagnosticInput,
): SafetyCheckOutput {
  const isEn = input.language === "en";
  const rules = evaluateDeterministicSafetyRules(input);

  if (rules.riskLevel === "high") {
    return {
      recommendSafeStop: rules.recommendSafeStop,
      applyRestShield: rules.applyRestShield,
      riskLevel: "high",
      kilaAdvice: isEn
        ? "Your pace dropped significantly under tough conditions. Please use Safe Stop now Rest Shield will protect your daily streak!"
        : "Pace kamu turun cukup jauh dan kondisi cukup berat. Gunakan Safe Stop sekarang ya, Rest Shield akan menjaga daily streak kamu tetap aman!",
    };
  }

  if (rules.riskLevel === "moderate") {
    return {
      recommendSafeStop: rules.recommendSafeStop,
      applyRestShield: rules.applyRestShield,
      riskLevel: "moderate",
      kilaAdvice: isEn
        ? "You have been working hard! Take a 90-second rest at this milestone and hydrate well before continuing."
        : "Tubuhmu sudah bekerja keras! Ambil jeda istirahat 90 detik di milestone ini dan atur napas sebelum lanjut ya.",
    };
  }

  return {
    recommendSafeStop: false,
    applyRestShield: false,
    riskLevel: "low",
    kilaAdvice: isEn
      ? "Your pace and rhythm look solid! Keep enjoying the run and stay aware of your surroundings."
      : "Ritme dan pace larimu terlihat stabil! Terus nikmati jalurnya dan tetap perhatikan kondisi jalan di sekitar.",
  };
}

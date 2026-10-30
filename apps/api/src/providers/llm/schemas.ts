import { z } from "zod";

export const MilestoneDialogueSchema = z
  .object({
    milestoneOrder: z.number().int().positive(),
    cheerLine: z.string().min(2).max(110),
    continuePrompt: z.string().min(2).max(110),
    restPrompt: z.string().min(2).max(110),
    warnLine: z.string().min(2).max(110),
  })
  .strict();

export const TrackNarrativeSchema = z
  .object({
    selectedRouteId: z.string().min(1),
    selectionReason: z.string().min(2).max(240),
    trackTitle: z.string().min(3).max(60),
    mysteryBrief: z.string().min(10).max(240),
    preRunTip: z.string().min(5).max(150),
    milestoneDialogues: z.array(MilestoneDialogueSchema).min(1).max(16),
  })
  .strict();

export const SafetyCheckSchema = z.object({
  recommendSafeStop: z.boolean(),
  applyRestShield: z.boolean(),
  kilaAdvice: z.string().min(5).max(240),
  riskLevel: z.enum(["low", "moderate", "high"]),
});

export function extractAndParseJson(rawText: string): unknown {
  let cleaned = rawText.replace(/<think>[\s\S]*?<\/think>/gi, "").trim();
  cleaned = cleaned
    .replace(/^\x60\x60\x60(?:json)?\s*/i, "")
    .replace(/\s*\x60\x60\x60$/i, "")
    .trim();

  const candidates = extractJsonObjects(cleaned);
  let lastError: unknown;
  for (const candidate of candidates) {
    try {
      return JSON.parse(candidate);
    } catch {
      // A trailing comma may still be repaired below.
    }
    try {
      return JSON.parse(removeTrailingCommas(candidate));
    } catch (error) {
      lastError = error;
    }
  }
  if (candidates.length === 0) return JSON.parse(cleaned);
  throw lastError instanceof Error
    ? lastError
    : new SyntaxError("The model response contains no valid JSON object.");
}

function extractJsonObjects(text: string): string[] {
  const objects: string[] = [];
  let start = -1;
  let depth = 0;
  let inString = false;
  let escaped = false;

  for (let index = 0; index < text.length; index += 1) {
    const character = text[index];
    if (inString) {
      if (escaped) escaped = false;
      else if (character === "\\") escaped = true;
      else if (character === '"') inString = false;
      continue;
    }
    if (character === '"') {
      inString = true;
    } else if (character === "{") {
      if (depth === 0) start = index;
      depth += 1;
    } else if (character === "}" && depth > 0) {
      depth -= 1;
      if (depth === 0 && start >= 0) {
        objects.push(text.slice(start, index + 1));
        start = -1;
      }
    }
  }
  return objects;
}

function removeTrailingCommas(value: string): string {
  let result = "";
  let inString = false;
  let escaped = false;
  for (let index = 0; index < value.length; index += 1) {
    const character = value[index]!;
    if (inString) {
      result += character;
      if (escaped) escaped = false;
      else if (character === "\\") escaped = true;
      else if (character === '"') inString = false;
      continue;
    }
    if (character === '"') {
      inString = true;
      result += character;
      continue;
    }
    if (character === ",") {
      let next = index + 1;
      while (next < value.length && /\s/.test(value[next]!)) next += 1;
      if (value[next] === "}" || value[next] === "]") continue;
    }
    result += character;
  }
  return result;
}

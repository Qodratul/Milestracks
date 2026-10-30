import { env } from "../../config/env";
import { logger } from "../../lib/logger";
import {
  buildDeterministicSafetyFallback,
  buildDeterministicTrackFallback,
  evaluateDeterministicSafetyRules,
} from "./fallbacks";
import { nebiusFastClient, nebiusReasoningClient } from "./client";
import { getFastModelCapabilities } from "./model-catalog";
import {
  buildRouteUserPrompt,
  buildSafetyUserPrompt,
  KILA_NEMOTRON_SYSTEM_PROMPT,
  KILA_REASONING_SYSTEM_PROMPT,
} from "./prompts";
import { extractAndParseJson, SafetyCheckSchema, TrackNarrativeSchema } from "./schemas";
import type {
  LLMProvider,
  RoutePromptInput,
  SafetyCheckOutput,
  SafetyDiagnosticInput,
  TrackNarrativeAttempt,
  TrackNarrativeOutput,
} from "./types";

const MAX_NARRATIVE_ATTEMPTS = 2;
const NARRATIVE_MAX_OUTPUT_TOKENS = 2_000;

export class NebiusLLMProvider implements LLMProvider {
  public async generateTrackNarrative(
    input: RoutePromptInput,
  ): Promise<TrackNarrativeOutput> {
    const result = await this.generateTrackNarrativeDetailed(input);
    return result.output;
  }

  public async generateTrackNarrativeDetailed(
    input: RoutePromptInput,
  ): Promise<TrackNarrativeAttempt> {
    const fallback = buildDeterministicTrackFallback(input);
    if (!env.LLM_API_KEY || !env.LLM_MODEL_FAST || !env.LLM_FAST_BASE_URL) {
      logger.warn(
        { fallback: true, reason: "not_configured" },
        "Nebius narrative is not configured; using deterministic fallback",
      );
      return fallbackResult(fallback, 0, false, false);
    }

    const capabilities = await getFastModelCapabilities();
    const jsonSchemaRequested = capabilities.supportsJsonSchema;
    const toolCallRequested = !jsonSchemaRequested && capabilities.supportsTools;
    let lastError: unknown;
    let failureStage = "request";
    let failedContentSource: string | undefined;
    let failedJsonOffset: number | undefined;
    let failedResponseMetadata: Record<string, unknown> | undefined;

    for (let attempt = 1; attempt <= MAX_NARRATIVE_ATTEMPTS; attempt += 1) {
      // A broken tool-call payload should not be retried with the same response
      // mode. Give the model one constrained plain-text JSON attempt instead.
      const useToolCalling = toolCallRequested && attempt === 1;
      failureStage = "request";
      try {
        const completion = await requestNarrative(
          input,
          jsonSchemaRequested,
          useToolCalling,
        );
        const choice = completion.choices[0];
        failedResponseMetadata = describeNarrativeResponse(choice, completion.usage);
        failureStage = "extract_response";
        const candidates = extractContentCandidates(choice?.message);
        failureStage = "parse_and_validate";
        let candidateError: unknown;
        for (const candidate of candidates) {
          try {
            const narrative = validateNarrative(candidate.content, input);
            return {
              output: narrative,
              usedFallback: false,
              attempts: attempt,
              validFirstAttempt: attempt === 1,
              jsonSchemaRequested,
              toolCallRequested,
            };
          } catch (error) {
            candidateError = error;
            failedContentSource = candidate.source;
            failedJsonOffset = jsonErrorOffset(error);
          }
        }
        throw candidateError ?? new TypeError("Nebius returned no narrative content.");
      } catch (error) {
        lastError = error;
      }
    }

    logger.warn(
      {
        fallback: true,
        attempts: MAX_NARRATIVE_ATTEMPTS,
        failureStage,
        errorType: lastError instanceof Error ? lastError.name : "unknown",
        jsonSchemaRequested,
        toolCallRequested,
        failedContentSource,
        failedJsonOffset,
        ...failedResponseMetadata,
        modelAvailable: capabilities.available,
        modelCapabilityFailure: capabilities.failureCode,
      },
      "Nebius narrative invalid or unavailable; using deterministic fallback",
    );
    return fallbackResult(
      fallback,
      MAX_NARRATIVE_ATTEMPTS,
      jsonSchemaRequested,
      toolCallRequested,
    );
  }

  public async evaluateRunnerSafety(
    input: SafetyDiagnosticInput,
  ): Promise<SafetyCheckOutput> {
    const rules = evaluateDeterministicSafetyRules(input);
    if (!env.LLM_API_KEY || !env.LLM_MODEL_REASONING || !env.LLM_REASONING_BASE_URL) {
      return buildDeterministicSafetyFallback(input);
    }

    try {
      const completion = await nebiusReasoningClient.chat.completions.create({
        model: env.LLM_MODEL_REASONING,
        temperature: 0.2,
        max_tokens: 1_000,
        messages: [
          { role: "system", content: KILA_REASONING_SYSTEM_PROMPT },
          { role: "user", content: buildSafetyUserPrompt(input, rules) },
        ],
      });
      const rawContent = extractContent(completion.choices[0]?.message);
      const parsed = SafetyCheckSchema.parse(extractAndParseJson(rawContent));
      if (rules.riskLevel === "high") {
        return {
          recommendSafeStop: true,
          applyRestShield: true,
          riskLevel: "high",
          kilaAdvice: parsed.kilaAdvice.trim(),
        };
      }
      return { ...parsed, kilaAdvice: parsed.kilaAdvice.trim() };
    } catch {
      logger.warn(
        { fallback: true },
        "Nebius safety response unavailable; using fallback",
      );
      return buildDeterministicSafetyFallback(input);
    }
  }
}

async function requestNarrative(
  input: RoutePromptInput,
  useJsonSchema: boolean,
  useToolCalling: boolean,
) {
  const baseRequest = {
    model: env.LLM_MODEL_FAST ?? "unconfigured",
    temperature: 0.2,
    // Reasoning tokens count against the completion budget on this model. Leave
    // room for its final structured answer after it has finished reasoning.
    max_tokens: NARRATIVE_MAX_OUTPUT_TOKENS,
    messages: [
      { role: "system" as const, content: KILA_NEMOTRON_SYSTEM_PROMPT },
      { role: "user" as const, content: buildRouteUserPrompt(input) },
    ],
  };
  if (!useJsonSchema && !useToolCalling) {
    return nebiusFastClient.chat.completions.create(baseRequest);
  }
  if (useToolCalling) {
    return nebiusFastClient.chat.completions.create({
      ...baseRequest,
      tools: [
        {
          type: "function",
          function: {
            name: "return_track_narrative",
            description:
              "Return the chosen route and narrative using the required fields.",
            strict: true,
            parameters: buildNarrativeJsonSchema(input),
          },
        },
      ],
      tool_choice: { type: "function", function: { name: "return_track_narrative" } },
    });
  }
  return nebiusFastClient.chat.completions.create({
    ...baseRequest,
    response_format: {
      type: "json_schema",
      json_schema: {
        name: "milestride_track_narrative",
        strict: true,
        schema: buildNarrativeJsonSchema(input),
      },
    },
  });
}

function buildNarrativeJsonSchema(input: RoutePromptInput): Record<string, unknown> {
  const candidateIds = input.candidates?.map((candidate) => candidate.id);
  return {
    type: "object",
    additionalProperties: false,
    required: [
      "selectedRouteId",
      "selectionReason",
      "trackTitle",
      "mysteryBrief",
      "preRunTip",
      "milestoneDialogues",
    ],
    properties: {
      selectedRouteId: {
        type: "string",
        enum: candidateIds?.length ? candidateIds : ["A"],
      },
      selectionReason: { type: "string" },
      trackTitle: { type: "string" },
      mysteryBrief: { type: "string" },
      preRunTip: { type: "string" },
      milestoneDialogues: {
        type: "array",
        minItems: input.milestoneCount,
        maxItems: input.milestoneCount,
        items: {
          type: "object",
          additionalProperties: false,
          required: [
            "milestoneOrder",
            "cheerLine",
            "continuePrompt",
            "restPrompt",
            "warnLine",
          ],
          properties: {
            milestoneOrder: { type: "integer" },
            cheerLine: { type: "string" },
            continuePrompt: { type: "string" },
            restPrompt: { type: "string" },
            warnLine: { type: "string" },
          },
        },
      },
    },
  };
}

function extractContent(message: unknown): string {
  if (typeof message !== "object" || message === null) {
    throw new TypeError("Nebius returned no message.");
  }
  const toolCalls = Reflect.get(message, "tool_calls");
  if (Array.isArray(toolCalls)) {
    for (const call of toolCalls) {
      const functionCall = Reflect.get(call, "function");
      const name = Reflect.get(functionCall, "name");
      const argumentsText = Reflect.get(functionCall, "arguments");
      if (name === "return_track_narrative" && typeof argumentsText === "string") {
        return argumentsText;
      }
    }
  }
  const content = Reflect.get(message, "content");
  if (typeof content === "string" && content.trim()) return content;
  if (Array.isArray(content)) {
    const text = content
      .map((part) =>
        typeof part === "object" && part !== null ? Reflect.get(part, "text") : null,
      )
      .filter(
        (part): part is string => typeof part === "string" && part.trim().length > 0,
      )
      .join("\n");
    if (text) return text;
  }
  throw new TypeError("Nebius returned no narrative content.");
}

function extractContentCandidates(
  message: unknown,
): readonly { readonly source: string; readonly content: string }[] {
  if (typeof message !== "object" || message === null) {
    throw new TypeError("Nebius returned no message.");
  }

  const candidates: { source: string; content: string }[] = [];
  const toolCalls = Reflect.get(message, "tool_calls");
  if (Array.isArray(toolCalls)) {
    for (const call of toolCalls) {
      const functionCall = Reflect.get(call, "function");
      const argumentsText = Reflect.get(functionCall, "arguments");
      if (
        Reflect.get(functionCall, "name") === "return_track_narrative" &&
        typeof argumentsText === "string" &&
        argumentsText.trim()
      ) {
        candidates.push({ source: "tool_arguments", content: argumentsText });
      }
    }
  }

  const content = Reflect.get(message, "content");
  if (typeof content === "string" && content.trim()) {
    candidates.push({ source: "content", content });
  } else if (Array.isArray(content)) {
    const text = content
      .map((part) =>
        typeof part === "object" && part !== null ? Reflect.get(part, "text") : null,
      )
      .filter(
        (part): part is string => typeof part === "string" && part.trim().length > 0,
      )
      .join("\n");
    if (text) candidates.push({ source: "content_parts", content: text });
  }

  if (candidates.length === 0) {
    throw new TypeError("Nebius returned no narrative content.");
  }
  return candidates;
}

function describeNarrativeResponse(
  choice: unknown,
  usage: unknown,
): Record<string, unknown> {
  const message =
    typeof choice === "object" && choice !== null
      ? Reflect.get(choice, "message")
      : undefined;
  const content =
    typeof message === "object" && message !== null
      ? Reflect.get(message, "content")
      : undefined;
  const toolCalls =
    typeof message === "object" && message !== null
      ? Reflect.get(message, "tool_calls")
      : undefined;
  const reasoning =
    typeof message === "object" && message !== null
      ? Reflect.get(message, "reasoning")
      : undefined;
  const completionDetails =
    typeof usage === "object" && usage !== null
      ? Reflect.get(usage, "completion_tokens_details")
      : undefined;

  return {
    responseFinishReason:
      typeof choice === "object" && choice !== null
        ? Reflect.get(choice, "finish_reason")
        : undefined,
    responseContentKind: Array.isArray(content)
      ? "parts"
      : typeof content === "string"
        ? "text"
        : "empty",
    responseContentLength: typeof content === "string" ? content.length : undefined,
    responseToolCallCount: Array.isArray(toolCalls) ? toolCalls.length : 0,
    responseHasReasoning: typeof reasoning === "string" && reasoning.length > 0,
    responseCompletionTokens:
      typeof usage === "object" && usage !== null
        ? Reflect.get(usage, "completion_tokens")
        : undefined,
    responseReasoningTokens:
      typeof completionDetails === "object" && completionDetails !== null
        ? Reflect.get(completionDetails, "reasoning_tokens")
        : undefined,
  };
}

function jsonErrorOffset(error: unknown): number | undefined {
  if (!(error instanceof SyntaxError)) return undefined;
  const match = /position\s+(\d+)/i.exec(error.message);
  return match ? Number(match[1]) : undefined;
}

function validateNarrative(raw: string, input: RoutePromptInput): TrackNarrativeOutput {
  const narrative = TrackNarrativeSchema.parse(extractAndParseJson(raw));
  const candidateIds = input.candidates?.map((candidate) => candidate.id);
  if (candidateIds?.length && !candidateIds.includes(narrative.selectedRouteId)) {
    throw new TypeError("Nebius selected a route outside the candidate list.");
  }
  if (narrative.milestoneDialogues.length !== input.milestoneCount) {
    throw new TypeError("Nebius returned an incorrect milestone count.");
  }
  narrative.milestoneDialogues.forEach((dialogue, index) => {
    if (dialogue.milestoneOrder !== index + 1) {
      throw new TypeError("Nebius returned milestones out of order.");
    }
    for (const line of [
      dialogue.cheerLine,
      dialogue.continuePrompt,
      dialogue.restPrompt,
      dialogue.warnLine,
    ]) {
      if (countWords(line) > 12)
        throw new TypeError("Nebius dialogue exceeds the word limit.");
    }
  });
  return {
    ...narrative,
    selectionReason: narrative.selectionReason.trim(),
    trackTitle: narrative.trackTitle.trim(),
    mysteryBrief: narrative.mysteryBrief.trim(),
    preRunTip: narrative.preRunTip.trim(),
    milestoneDialogues: narrative.milestoneDialogues.map((dialogue) => ({
      ...dialogue,
      cheerLine: dialogue.cheerLine.trim(),
      continuePrompt: dialogue.continuePrompt.trim(),
      restPrompt: dialogue.restPrompt.trim(),
      warnLine: dialogue.warnLine.trim(),
    })),
  };
}

function countWords(value: string): number {
  return value.trim().split(/\s+/).filter(Boolean).length;
}

function fallbackResult(
  output: TrackNarrativeOutput,
  attempts: number,
  jsonSchemaRequested: boolean,
  toolCallRequested: boolean,
): TrackNarrativeAttempt {
  return {
    output,
    usedFallback: true,
    attempts,
    validFirstAttempt: false,
    jsonSchemaRequested,
    toolCallRequested,
  };
}

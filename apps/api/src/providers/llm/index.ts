import { NebiusLLMProvider } from "./nebius.provider";
import type { LLMProvider } from "./types";

export const llmProvider: LLMProvider = new NebiusLLMProvider();

export * from "./types";
export * from "./schemas";
export * from "./prompts";
export * from "./fallbacks";
export { NebiusLLMProvider };
export { getFastModelCapabilities, refreshFastModelCapabilities } from "./model-catalog";
export type { FastModelCapabilities } from "./model-catalog";

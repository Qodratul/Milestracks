import OpenAI from "openai";
import { env } from "../../config/env";

const apiKey = env.LLM_API_KEY ?? "unconfigured";
const timeout = env.LLM_TIMEOUT_MS;
export const nebiusFastClient = new OpenAI({
  baseURL: env.LLM_FAST_BASE_URL,
  apiKey,
  timeout,
  maxRetries: 0,
});
export const nebiusReasoningClient = new OpenAI({
  baseURL: env.LLM_REASONING_BASE_URL,
  apiKey,
  timeout,
  maxRetries: 0,
});

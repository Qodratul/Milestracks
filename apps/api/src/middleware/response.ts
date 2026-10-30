import type { Response } from "express";
import { now } from "../lib/clock";
import type { ApiMeta } from "../types/api";

function responseRequestId(response: Response): string {
  const header = response.getHeader("X-Request-Id");
  return typeof header === "string" ? header : "req_unknown";
}
export function sendOk<T>(response: Response, data: T, statusCode = 200): void {
  const meta: ApiMeta = {
    requestId: responseRequestId(response),
    timestamp: now().toISOString(),
  };
  response.status(statusCode).json({ data, meta });
}
export function sendList<T>(
  response: Response,
  data: readonly T[],
  options: { nextCursor: string | null; limit: number },
): void {
  sendPage(response, data, options);
}
export function sendPage<T>(
  response: Response,
  data: T,
  options: { nextCursor: string | null; limit: number },
): void {
  response.status(200).json({
    data,
    meta: {
      requestId: responseRequestId(response),
      timestamp: now().toISOString(),
      ...options,
    },
  });
}

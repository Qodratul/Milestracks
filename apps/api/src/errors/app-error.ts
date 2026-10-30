import type { ErrorCode } from "./codes";

export class AppError extends Error {
  public constructor(
    public readonly statusCode: number,
    public readonly code: ErrorCode | string,
    message: string,
    public readonly details?: unknown,
    cause?: unknown,
  ) {
    super(message, cause === undefined ? undefined : { cause });
    this.name = "AppError";
  }
}

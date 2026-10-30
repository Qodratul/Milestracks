import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";

export interface PageCursor {
  readonly id: string;
  readonly timestamp: Date;
}

export function encodePageCursor(timestamp: Date, id: string): string {
  return Buffer.from(JSON.stringify({ id, timestamp: timestamp.toISOString() })).toString(
    "base64url",
  );
}

export function decodePageCursor(value: string | undefined): PageCursor | null {
  if (value === undefined) return null;
  try {
    const decoded: unknown = JSON.parse(Buffer.from(value, "base64url").toString("utf8"));
    if (typeof decoded !== "object" || decoded === null) throw new Error("invalid");
    const id = Reflect.get(decoded, "id");
    const timestampValue = Reflect.get(decoded, "timestamp");
    if (typeof id !== "string" || typeof timestampValue !== "string")
      throw new Error("invalid");
    const timestamp = new Date(timestampValue);
    if (!Number.isFinite(timestamp.getTime())) throw new Error("invalid");
    return { id, timestamp };
  } catch {
    throw new AppError(400, ERROR_CODES.VALIDATION_ERROR, "Cursor halaman tidak valid.", {
      fields: [{ path: "query.cursor", message: "Cursor tidak valid." }],
    });
  }
}

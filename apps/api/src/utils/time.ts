const DAY_MILLISECONDS = 24 * 60 * 60 * 1000;
const WEEK_MILLISECONDS = 7 * DAY_MILLISECONDS;

export interface UtcDayWindow {
  readonly startEpochMs: number;
  readonly endEpochMs: number;
}

export function utcDayWindow(timestampMs: number): UtcDayWindow {
  if (!Number.isSafeInteger(timestampMs))
    throw new RangeError("timestampMs must be a safe integer.");
  const date = new Date(timestampMs);
  const startEpochMs = Date.UTC(
    date.getUTCFullYear(),
    date.getUTCMonth(),
    date.getUTCDate(),
  );
  return { startEpochMs, endEpochMs: startEpochMs + 24 * 60 * 60 * 1000 };
}

export interface UtcWeekWindow {
  readonly startEpochMs: number;
  readonly endEpochMs: number;
}

export function utcWeekWindow(timestampMs: number): UtcWeekWindow {
  if (!Number.isSafeInteger(timestampMs)) {
    throw new RangeError("timestampMs must be a safe integer.");
  }
  const date = new Date(timestampMs);
  const daysSinceMonday = (date.getUTCDay() + 6) % 7;
  const startEpochMs = Date.UTC(
    date.getUTCFullYear(),
    date.getUTCMonth(),
    date.getUTCDate() - daysSinceMonday,
  );
  return {
    startEpochMs,
    endEpochMs: startEpochMs + WEEK_MILLISECONDS,
  };
}

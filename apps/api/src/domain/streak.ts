export interface QualifiedRunDay {
  readonly status: "completed" | "safe_stopped";
  readonly endedAt: Date;
}

export interface StreakSummary {
  readonly currentDays: number;
  readonly bestDays: number;
  readonly freezesRemaining: number;
  readonly restShieldActive: boolean;
  readonly lastQualifiedAt: string | null;
}

export function summarizeStreak(
  runs: readonly QualifiedRunDay[],
  timezone: string,
  timestamp: Date,
): StreakSummary {
  const days = new Map<string, { latest: Date; hasSafeStop: boolean }>();
  for (const run of runs) {
    const key = localDate(run.endedAt, timezone);
    const previous = days.get(key);
    days.set(key, {
      latest: !previous || run.endedAt > previous.latest ? run.endedAt : previous.latest,
      hasSafeStop: previous?.hasSafeStop === true || run.status === "safe_stopped",
    });
  }

  const sortedDays = [...days.keys()].sort();
  let bestDays = 0;
  let streak = 0;
  let previousDate: Date | null = null;
  for (const key of sortedDays) {
    const date = utcDate(key);
    streak = previousDate && dayDifference(previousDate, date) === 1 ? streak + 1 : 1;
    bestDays = Math.max(bestDays, streak);
    previousDate = date;
  }

  const today = utcDate(localDate(timestamp, timezone));
  const lastKey = sortedDays.at(-1);
  const lastDate = lastKey ? utcDate(lastKey) : null;
  const daysSinceQualified = lastDate ? dayDifference(lastDate, today) : null;
  const withinCurrentWindow =
    daysSinceQualified !== null && daysSinceQualified >= 0 && daysSinceQualified <= 1;
  let currentDays = 0;
  if (withinCurrentWindow && lastDate) {
    currentDays = 1;
    for (let index = sortedDays.length - 1; index > 0; index -= 1) {
      const current = utcDate(sortedDays[index] ?? "");
      const previous = utcDate(sortedDays[index - 1] ?? "");
      if (dayDifference(previous, current) !== 1) break;
      currentDays += 1;
    }
  }

  const latestQualified = [...runs].sort(
    (left, right) => right.endedAt.getTime() - left.endedAt.getTime(),
  )[0];
  return {
    currentDays,
    bestDays,
    freezesRemaining: 0,
    restShieldActive:
      lastKey === localDate(timestamp, timezone) &&
      (days.get(lastKey)?.hasSafeStop ?? false),
    lastQualifiedAt: latestQualified?.endedAt.toISOString() ?? null,
  };
}

export function localDate(timestamp: Date, timezone: string): string {
  const parts = new Intl.DateTimeFormat("en-CA", {
    timeZone: timezone,
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).formatToParts(timestamp);
  const value = (type: string) => parts.find((part) => part.type === type)?.value ?? "";
  return `${value("year")}-${value("month")}-${value("day")}`;
}

export function utcDate(value: string): Date {
  return new Date(`${value}T00:00:00.000Z`);
}

export function dayDifference(first: Date, second: Date): number {
  return Math.round((second.getTime() - first.getTime()) / 86_400_000);
}

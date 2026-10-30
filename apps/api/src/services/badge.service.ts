import { prisma } from "../lib/prisma";
import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { localDate } from "../domain/streak";

interface AchievementRun {
  readonly status: "completed" | "safe_stopped";
  readonly endedAt: Date;
  readonly distanceMeters: number;
  readonly milestonesReached: number;
}

interface BadgeDefinition {
  readonly id: string;
  readonly name: { readonly en: string; readonly id: string };
  readonly description: { readonly en: string; readonly id: string };
  readonly threshold: number;
  readonly value: (runs: readonly AchievementRun[], timezone: string) => number;
  readonly unlockedAt: (runs: readonly AchievementRun[], timezone: string) => Date | null;
}

const badgeDefinitions: readonly BadgeDefinition[] = [
  {
    id: "first_run",
    name: { en: "First Stride", id: "Langkah Pertama" },
    description: { en: "Complete your first run.", id: "Selesaikan lari pertamamu." },
    threshold: 1,
    value: (runs) => runs.filter((run) => run.status === "completed").length,
    unlockedAt: (runs) => runs.find((run) => run.status === "completed")?.endedAt ?? null,
  },
  {
    id: "five_runs",
    name: { en: "Finding Your Rhythm", id: "Menemukan Ritme" },
    description: { en: "Complete five runs.", id: "Selesaikan lima sesi lari." },
    threshold: 5,
    value: (runs) => runs.filter((run) => run.status === "completed").length,
    unlockedAt: (runs) => nthCompletedRun(runs, 5),
  },
  ...[
    { id: "first_5k", km: 5, name: { en: "First 5K", id: "5K Pertama" } },
    { id: "first_10k", km: 10, name: { en: "10K Explorer", id: "Penjelajah 10K" } },
  ].map((badge) => ({
    id: badge.id,
    name: badge.name,
    description: {
      en: `Cover ${badge.km} kilometers in total.`,
      id: `Tempuh total ${badge.km} kilometer.`,
    },
    threshold: badge.km * 1000,
    value: (runs: readonly AchievementRun[]) =>
      runs.reduce(
        (sum, run) => sum + (run.status === "completed" ? run.distanceMeters : 0),
        0,
      ),
    unlockedAt: (runs: readonly AchievementRun[]) => {
      let distance = 0;
      for (const run of runs) {
        if (run.status !== "completed") continue;
        distance += run.distanceMeters;
        if (distance >= badge.km * 1000) return run.endedAt;
      }
      return null;
    },
  })),
  ...[
    { id: "streak_5", days: 5, name: { en: "Five Day Flow", id: "Alur Lima Hari" } },
    { id: "streak_7", days: 7, name: { en: "Week of Movement", id: "Pekan Bergerak" } },
  ].map((badge) => ({
    id: badge.id,
    name: badge.name,
    description: {
      en: `Keep a ${badge.days}-day running streak.`,
      id: `Jaga streak lari selama ${badge.days} hari.`,
    },
    threshold: badge.days,
    value: (runs: readonly AchievementRun[], timezone: string) =>
      longestStreak(runs, timezone).best,
    unlockedAt: (runs: readonly AchievementRun[], timezone: string) =>
      longestStreak(runs, timezone).unlockedAt.get(badge.days) ?? null,
  })),
  {
    id: "first_checkpoints",
    name: { en: "Checkpoint Starter", id: "Checkpoint Pertama" },
    description: { en: "Reach three run milestones.", id: "Capai tiga milestone lari." },
    threshold: 3,
    value: (runs) => runs.reduce((sum, run) => sum + run.milestonesReached, 0),
    unlockedAt: (runs) => milestoneThresholdAt(runs, 3),
  },
  {
    id: "checkpoint_10",
    name: { en: "Milestone Collector", id: "Pengumpul Milestone" },
    description: { en: "Reach ten run milestones.", id: "Capai sepuluh milestone lari." },
    threshold: 10,
    value: (runs) => runs.reduce((sum, run) => sum + run.milestonesReached, 0),
    unlockedAt: (runs) => milestoneThresholdAt(runs, 10),
  },
  {
    id: "safe_stop_1",
    name: { en: "A Good Call", id: "Pilihan Tepat" },
    description: {
      en: "Use Safe Stop to end a run safely.",
      id: "Gunakan Safe Stop untuk mengakhiri lari dengan aman.",
    },
    threshold: 1,
    value: (runs) => runs.filter((run) => run.status === "safe_stopped").length,
    unlockedAt: (runs) =>
      runs.find((run) => run.status === "safe_stopped")?.endedAt ?? null,
  },
  {
    id: "longest_2k",
    name: { en: "Two Kilometer Stretch", id: "Dua Kilometer" },
    description: {
      en: "Complete a run of at least 2 km.",
      id: "Selesaikan satu lari sejauh minimal 2 km.",
    },
    threshold: 2000,
    value: (runs) =>
      Math.max(
        0,
        ...runs
          .filter((run) => run.status === "completed")
          .map((run) => run.distanceMeters),
      ),
    unlockedAt: (runs) =>
      runs.find((run) => run.status === "completed" && run.distanceMeters >= 2000)
        ?.endedAt ?? null,
  },
];

export const badgeService = {
  async list(userId: string) {
    const [profile, rows] = await Promise.all([
      prisma.profile.findUnique({
        where: { userId },
        select: { locale: true, timezone: true },
      }),
      prisma.run.findMany({
        where: {
          userId,
          status: { in: ["completed", "safe_stopped"] },
          endedAt: { not: null },
        },
        orderBy: [{ endedAt: "asc" }, { id: "asc" }],
        select: { status: true, endedAt: true, result: true },
      }),
    ]);
    if (!profile) throw new AppError(404, ERROR_CODES.NOT_FOUND, "Data tidak ditemukan.");
    const runs = rows.flatMap((run) => {
      if (!run.endedAt || (run.status !== "completed" && run.status !== "safe_stopped"))
        return [];
      const result = objectValue(run.result);
      const summary = objectValue(result.summary);
      const milestones = objectValue(summary.milestones);
      return [
        {
          status: run.status,
          endedAt: run.endedAt,
          distanceMeters: finiteNumber(summary.distanceMeters),
          milestonesReached: finiteNumber(milestones.reached),
        } satisfies AchievementRun,
      ];
    });
    const locale = profile.locale;
    return badgeDefinitions.map((badge) => {
      const value = badge.value(runs, profile.timezone);
      const unlockedAt = badge.unlockedAt(runs, profile.timezone);
      return {
        id: badge.id,
        name: badge.name[locale],
        description: badge.description[locale],
        unlocked: unlockedAt !== null,
        progress: Math.max(0, Math.min(1, value / badge.threshold)),
        unlockedAt: unlockedAt?.toISOString() ?? null,
      };
    });
  },
};

function nthCompletedRun(runs: readonly AchievementRun[], count: number): Date | null {
  return runs.filter((run) => run.status === "completed")[count - 1]?.endedAt ?? null;
}

function milestoneThresholdAt(
  runs: readonly AchievementRun[],
  target: number,
): Date | null {
  let count = 0;
  for (const run of runs) {
    count += run.milestonesReached;
    if (count >= target) return run.endedAt;
  }
  return null;
}

function longestStreak(runs: readonly AchievementRun[], timezone: string) {
  const days = new Map<string, Date>();
  for (const run of runs) {
    const key = localDate(run.endedAt, timezone);
    const previous = days.get(key);
    if (!previous || run.endedAt > previous) days.set(key, run.endedAt);
  }
  let current = 0;
  let best = 0;
  let previousDay = -2;
  const unlockedAt = new Map<number, Date>();
  for (const [key, timestamp] of days) {
    const day = Date.parse(`${key}T00:00:00.000Z`) / 86_400_000;
    current = day - previousDay === 1 ? current + 1 : 1;
    best = Math.max(best, current);
    if (current >= 5 && !unlockedAt.has(5)) unlockedAt.set(5, timestamp);
    if (current >= 7 && !unlockedAt.has(7)) unlockedAt.set(7, timestamp);
    previousDay = day;
  }
  return { best, unlockedAt };
}

function objectValue(value: unknown): Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value)
    ? (value as Record<string, unknown>)
    : {};
}

function finiteNumber(value: unknown): number {
  return typeof value === "number" && Number.isFinite(value) ? value : 0;
}

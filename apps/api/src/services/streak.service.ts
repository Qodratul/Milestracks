import { prisma } from "../lib/prisma";
import { now } from "../lib/clock";
import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { summarizeStreak } from "../domain/streak";

export const streakService = {
  async get(userId: string, timestamp: Date = now()) {
    const [profile, runs] = await Promise.all([
      prisma.profile.findUnique({
        where: { userId },
        select: { timezone: true },
      }),
      prisma.run.findMany({
        where: {
          userId,
          status: { in: ["completed", "safe_stopped"] },
          endedAt: { not: null },
        },
        orderBy: { endedAt: "asc" },
        select: { status: true, endedAt: true },
      }),
    ]);
    if (!profile) return notFound();
    const qualifiedRuns = runs.flatMap((run) =>
      run.endedAt && (run.status === "completed" || run.status === "safe_stopped")
        ? [{ status: run.status, endedAt: run.endedAt }]
        : [],
    );
    const summary = summarizeStreak(qualifiedRuns, profile.timezone, timestamp);
    return summary;
  },
};

function notFound(): never {
  throw new AppError(404, ERROR_CODES.NOT_FOUND, "Data tidak ditemukan.");
}

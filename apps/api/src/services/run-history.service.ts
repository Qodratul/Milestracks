import { prisma } from "../lib/prisma";
import { decodePageCursor, encodePageCursor } from "../lib/page-cursor";

const DEFAULT_PAGE_SIZE = 20;

export const runHistoryService = {
  async list(userId: string, cursorValue?: string, requestedLimit?: number) {
    const limit = requestedLimit ?? DEFAULT_PAGE_SIZE;
    const cursor = decodePageCursor(cursorValue);
    const profile = await prisma.profile.findUnique({
      where: { userId },
      select: { locale: true },
    });
    const locale = profile?.locale ?? "en";
    const rows = await prisma.run.findMany({
      where: {
        userId,
        status: { in: ["completed", "safe_stopped", "rejected"] },
        endedAt: { not: null },
        ...(cursor
          ? {
              OR: [
                { startedAt: { lt: cursor.timestamp } },
                { startedAt: cursor.timestamp, id: { lt: cursor.id } },
              ],
            }
          : {}),
      },
      orderBy: [{ startedAt: "desc" }, { id: "desc" }],
      take: limit + 1,
      select: {
        id: true,
        routeId: true,
        status: true,
        integrity: true,
        reasonCodes: true,
        claimId: true,
        claimedAt: true,
        startedAt: true,
        endedAt: true,
        result: true,
        route: {
          select: {
            template: {
              select: {
                narrations: { select: { locale: true, title: true } },
              },
            },
          },
        },
      },
    });
    const hasMore = rows.length > limit;
    const page = rows.slice(0, limit);
    const last = page.at(-1);
    return {
      runs: page.map((run) => toRunSummary(run, locale)),
      nextCursor: hasMore && last ? encodePageCursor(last.startedAt, last.id) : null,
      limit,
    };
  },
};

function toRunSummary(
  run: {
    readonly id: string;
    readonly routeId: string;
    readonly status: string;
    readonly integrity: string;
    readonly reasonCodes: unknown;
    readonly claimId: string | null;
    readonly claimedAt: Date | null;
    readonly startedAt: Date;
    readonly endedAt: Date | null;
    readonly result: unknown;
    readonly route: {
      readonly template: {
        readonly narrations: readonly {
          readonly locale: string;
          readonly title: string;
        }[];
      } | null;
    };
  },
  locale: string,
) {
  const root = objectValue(run.result);
  const summary = objectValue(root.summary);
  const milestones = objectValue(summary.milestones);
  const streak = objectValue(summary.streakAfter);
  const reasons = Array.isArray(run.reasonCodes) ? run.reasonCodes : [];
  const items = Array.isArray(summary.itemsUsed) ? summary.itemsUsed : [];
  return {
    runId: run.id,
    routeId: run.routeId,
    trackTitle:
      run.route.template?.narrations.find((narration) => narration.locale === locale)
        ?.title ??
      run.route.template?.narrations[0]?.title ??
      null,
    status: run.status,
    startedAt: run.startedAt.toISOString(),
    endedAt: run.endedAt?.toISOString() ?? null,
    distanceMeters: numberOrNull(summary.distanceMeters),
    durationSec: numberOrNull(summary.durationSec),
    avgPaceSecPerKm: numberOrNull(summary.avgPaceSecPerKm),
    levelExpGained: numberOrNull(summary.levelExpGained),
    coinsGained: numberOrNull(summary.coinsGained),
    expEarnedBase: numberOrNull(summary.expEarnedBase),
    expMultiplier: numberOrNull(summary.expMultiplier),
    expPenalty: numberOrNull(summary.expPenalty),
    rpGained: numberOrNull(summary.rpGained),
    estimatedCalories: numberOrNull(summary.estimatedCalories),
    streakDays: numberOrNull(streak.currentDays),
    reachedMilestones: numberOrNull(milestones.reached),
    loadoutLabel: items.join(", "),
    rejectionCode:
      run.integrity === "rejected" && typeof reasons[0] === "string" ? reasons[0] : null,
    claimId: run.claimId,
    claimed: run.claimedAt !== null,
  };
}

function objectValue(value: unknown): Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value)
    ? (value as Record<string, unknown>)
    : {};
}

function numberOrNull(value: unknown): number | null {
  return typeof value === "number" && Number.isFinite(value) ? value : null;
}

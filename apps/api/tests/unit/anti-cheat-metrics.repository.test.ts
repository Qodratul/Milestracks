import { describe, expect, it, vi } from "vitest";
import type { Tx } from "../../src/lib/prisma";
import { writeIntegrityMetrics } from "../../src/repositories/run.repository";

describe("run integrity metric persistence", () => {
  it("stores only aggregate metrics and the configured mode per run", async () => {
    const metrics = {
      maxRollingSpeedMmPerSec: 5_200,
      maxContinuousSpeedDurationMs: 0,
      maxJumpDistanceMm: 0,
      jumpCount: 0,
      gapCount: 0,
      duplicateCount: 0,
      mockedCount: 0,
      outOfOrderCount: 0,
      configVersion: 1,
    };
    const input = {
      runId: "run_metrics_test",
      metrics,
      reasonCodes: [],
      mode: "shadow" as const,
      calculatedAt: new Date("2026-10-27T12:00:00.000Z"),
    };
    const upsert = vi.fn().mockResolvedValue(undefined);
    const tx = { runIntegrityMetric: { upsert } } as unknown as Tx;

    await writeIntegrityMetrics(tx, input);

    expect(upsert).toHaveBeenCalledWith({
      where: { runId: input.runId },
      create: input,
      update: {
        metrics: input.metrics,
        reasonCodes: input.reasonCodes,
        mode: input.mode,
        calculatedAt: input.calculatedAt,
      },
    });
    expect(JSON.stringify(metrics)).not.toMatch(/"(?:lat|lng|latitude|longitude)"/);
  });
});

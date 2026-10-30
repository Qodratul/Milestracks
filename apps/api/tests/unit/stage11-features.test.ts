import { describe, expect, it } from "vitest";
import { summarizeStreak } from "../../src/domain/streak";
import { decodePageCursor, encodePageCursor } from "../../src/lib/page-cursor";

describe("MVP account feature calculations", () => {
  it("counts completed and safe-stopped local days toward the streak", () => {
    const summary = summarizeStreak(
      [
        { status: "completed", endedAt: new Date("2026-10-24T17:30:00Z") },
        { status: "safe_stopped", endedAt: new Date("2026-10-25T18:00:00Z") },
      ],
      "Asia/Jakarta",
      new Date("2026-10-25T19:00:00Z"),
    );

    expect(summary).toMatchObject({
      currentDays: 2,
      bestDays: 2,
      freezesRemaining: 0,
      restShieldActive: true,
      lastQualifiedAt: "2026-10-25T18:00:00.000Z",
    });
  });

  it("expires the current streak after two unqualified local days", () => {
    const summary = summarizeStreak(
      [{ status: "completed", endedAt: new Date("2026-10-24T17:30:00Z") }],
      "Asia/Jakarta",
      new Date("2026-10-26T18:00:00Z"),
    );

    expect(summary.currentDays).toBe(0);
    expect(summary.bestDays).toBe(1);
  });

  it("round trips opaque page cursors and rejects malformed values", () => {
    const timestamp = new Date("2026-10-25T09:30:00Z");
    const cursor = encodePageCursor(timestamp, "run_123");

    expect(decodePageCursor(cursor)).toEqual({ id: "run_123", timestamp });
    expect(() => decodePageCursor("not-a-page-cursor")).toThrow();
  });
});

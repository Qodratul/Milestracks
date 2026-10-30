import { describe, expect, it, vi } from "vitest";
import {
  AntiCheatConfigSchema,
  INITIAL_ANTI_CHEAT_CONFIG,
} from "../../src/config/anti-cheat-config";
import type { Tx } from "../../src/lib/prisma";
import { antiCheatConfigService } from "../../src/services/anti-cheat-config.service";

describe("anti-cheat configuration", () => {
  it("uses the versioned shadow baseline when no database version is active", async () => {
    const findFirst = vi.fn().mockResolvedValue(null);
    const tx = { antiCheatConfig: { findFirst } } as unknown as Tx;
    const at = new Date("2026-10-27T12:00:00.000Z");

    await expect(antiCheatConfigService.active(tx, at)).resolves.toEqual(
      INITIAL_ANTI_CHEAT_CONFIG,
    );
    expect(findFirst).toHaveBeenCalledWith({
      where: { activeAt: { lte: at } },
      orderBy: { version: "desc" },
      select: { version: true, mode: true, thresholds: true },
    });
  });

  it("loads the active version and mode from anti_cheat_config", async () => {
    const config = {
      ...INITIAL_ANTI_CHEAT_CONFIG,
      version: 7,
      mode: "enforce" as const,
    };
    const findFirst = vi.fn().mockResolvedValue(config);
    const tx = { antiCheatConfig: { findFirst } } as unknown as Tx;

    await expect(
      antiCheatConfigService.active(tx, new Date("2026-10-27T12:00:00.000Z")),
    ).resolves.toEqual(config);
  });

  it("rejects incomplete or invalid persisted thresholds", () => {
    expect(() =>
      AntiCheatConfigSchema.parse({
        ...INITIAL_ANTI_CHEAT_CONFIG,
        thresholds: { rejectSpeedThresholdMmPerSec: -1 },
      }),
    ).toThrow();
  });
});

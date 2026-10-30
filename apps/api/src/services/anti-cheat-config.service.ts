import {
  AntiCheatConfigSchema,
  INITIAL_ANTI_CHEAT_CONFIG,
} from "../config/anti-cheat-config";
import type { AntiCheatConfig } from "../config/anti-cheat-config";
import type { Tx } from "../lib/prisma";
import { findActiveAntiCheatConfig } from "../repositories/anti-cheat-config.repository";

export const antiCheatConfigService = {
  async active(tx: Tx, at: Date): Promise<AntiCheatConfig> {
    const config = await findActiveAntiCheatConfig(tx, at);
    if (!config) return INITIAL_ANTI_CHEAT_CONFIG;
    return AntiCheatConfigSchema.parse(config);
  },
};

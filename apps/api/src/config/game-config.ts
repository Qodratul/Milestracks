import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { idMessages } from "../i18n";
import { epochMilliseconds } from "../lib/clock";
import {
  findActiveGameConfig,
  findGameConfigVersion,
} from "../repositories/game-config.repository";
import type { GameConfig, GameItem, ItemCode, LevelCode } from "./game-config.schema";
import { GameConfigSchema } from "./game-config.schema";

const CACHE_TTL_MS = 30_000;

interface CachedGameConfig {
  readonly value: GameConfig;
  readonly cachedAt: number;
}

let cachedConfig: CachedGameConfig | undefined;

export const gameConfig = {
  async active(): Promise<GameConfig> {
    const nowMs = epochMilliseconds();
    if (cachedConfig && nowMs - cachedConfig.cachedAt < CACHE_TTL_MS) {
      return cachedConfig.value;
    }

    const record = await findActiveGameConfig();
    if (!record) {
      throw new AppError(
        503,
        ERROR_CODES.SERVICE_UNAVAILABLE,
        idMessages.errors.serviceUnavailable,
        { dependency: "game_config" },
      );
    }

    const config = GameConfigSchema.parse(record.payload);
    if (config.configVersion !== record.version) {
      throw new Error("Active game config payload version does not match its row.");
    }
    cachedConfig = { value: config, cachedAt: nowMs };
    return config;
  },

  async version(version: number): Promise<GameConfig> {
    const record = await findGameConfigVersion(version);
    if (!record) {
      throw new AppError(
        503,
        ERROR_CODES.SERVICE_UNAVAILABLE,
        idMessages.errors.serviceUnavailable,
        {
          dependency: "game_config",
        },
      );
    }
    const config = GameConfigSchema.parse(record.payload);
    if (config.configVersion !== record.version) {
      throw new Error("Game config payload version does not match its row.");
    }
    return config;
  },

  invalidate(): void {
    cachedConfig = undefined;
  },
};

export function requireItem(config: GameConfig, itemCode: ItemCode): GameItem {
  const item = config.items.find((candidate) => candidate.code === itemCode);
  if (!item) throw new Error("Active game config is missing a registered item.");
  return item;
}

export function levelFor(
  config: GameConfig,
  totalExp: number,
): GameConfig["levels"][number] {
  const level = [...config.levels]
    .sort((left, right) => right.startExp - left.startExp)
    .find((candidate) => totalExp >= candidate.startExp);
  if (!level) throw new Error("Active game config has no starting level.");
  return level;
}

export function levelByCode(
  config: GameConfig,
  code: LevelCode,
): GameConfig["levels"][number] {
  const level = config.levels.find((candidate) => candidate.code === code);
  if (!level) throw new Error("Active game config is missing a registered level.");
  return level;
}

import { gameConfig } from "../config/game-config";
import type { GameConfig } from "../config/game-config.schema";

export const gameConfigService = {
  version(version: number): Promise<GameConfig> {
    return gameConfig.version(version);
  },

  active(): Promise<GameConfig> {
    return gameConfig.active();
  },
};

import { gameConfigService } from "./game-config.service";
import { levelFor } from "../config/game-config";
import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { idMessages } from "../i18n";
import { findProfileByUserId } from "../repositories/profile.repository";
import { findUserById } from "../repositories/user.repository";
import { prisma } from "../lib/prisma";
import { now } from "../lib/clock";
import type { OnboardingInput } from "../types/account";

const COIN_PROGRESS_SCALE = 1000;

export const accountService = {
  async getMe(userId: string) {
    const [user, profile, config] = await Promise.all([
      findUserById(userId),
      findProfileByUserId(userId),
      gameConfigService.active(),
    ]);
    if (!user || !profile) throw notFound();
    const level = levelFor(config, profile.totalExp);
    return {
      id: user.id,
      displayName: profile.displayName,
      email: user.email,
      emailVerified: user.emailVerified,
      locale: profile.locale,
      timezone: profile.timezone,
      units: profile.units,
      levelCode: level.code,
      levelName: level.name,
      mascotForm: level.mascotForm,
      totalExp: profile.totalExp,
      coins: profile.coinBalance,
      onboardingComplete: profile.healthDisclaimerAcceptedAt !== null,
    };
  },

  async updateOnboarding(userId: string, input: OnboardingInput) {
    const profile = await prisma.profile.update({
      where: { userId },
      data: {
        ...(input.locale === undefined ? {} : { locale: input.locale }),
        ...(input.timezone === undefined ? {} : { timezone: input.timezone }),
        ...(input.healthDisclaimerAccepted === undefined
          ? {}
          : {
              healthDisclaimerAcceptedAt: input.healthDisclaimerAccepted ? now() : null,
            }),
      },
      select: {
        locale: true,
        timezone: true,
        healthDisclaimerAcceptedAt: true,
      },
    });
    return {
      onboardingComplete: profile.healthDisclaimerAcceptedAt !== null,
      locale: profile.locale,
      timezone: profile.timezone,
    };
  },

  async getHomeSummary(userId: string) {
    const [profile, config] = await Promise.all([
      findProfileByUserId(userId),
      gameConfigService.active(),
    ]);
    if (!profile) throw notFound();
    const level = levelFor(config, profile.totalExp);
    const nextLevelAtExp = level.nextLevelAtExp;
    const levelProgress =
      nextLevelAtExp === null
        ? 1
        : Math.min(
            1,
            Math.max(
              0,
              (profile.totalExp - level.startExp) / (nextLevelAtExp - level.startExp),
            ),
          );
    return {
      displayName: profile.displayName,
      levelCode: level.code,
      levelName: level.name,
      mascotForm: level.mascotForm,
      totalExp: profile.totalExp,
      nextLevelAtExp,
      levelProgress,
      timezone: profile.timezone,
    };
  },

  async getWallet(userId: string) {
    const profile = await findProfileByUserId(userId);
    if (!profile) throw notFound();
    return {
      coins: profile.coinBalance,
      coinProgress: profile.coinCarryMilli / COIN_PROGRESS_SCALE,
    };
  },
};

function notFound(): AppError {
  return new AppError(404, ERROR_CODES.NOT_FOUND, idMessages.errors.notFound);
}

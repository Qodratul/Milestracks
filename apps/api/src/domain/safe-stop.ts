import { assertNonNegativeInteger } from "./math";

export interface SafeStopQuota {
  readonly usedThisWeek: number;
  readonly quota: number;
  readonly remaining: number;
  readonly withinQuota: boolean;
}

export function resolveSafeStopQuota(input: {
  readonly usedThisWeek: number;
  readonly quota: number;
}): SafeStopQuota {
  assertNonNegativeInteger(input.usedThisWeek, "usedThisWeek");
  assertNonNegativeInteger(input.quota, "quota");
  return {
    usedThisWeek: input.usedThisWeek,
    quota: input.quota,
    remaining: Math.max(0, input.quota - input.usedThisWeek),
    withinQuota: input.usedThisWeek < input.quota,
  };
}

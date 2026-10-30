import {
  assertNonNegativeInteger,
  assertPositiveInteger,
  multiplySafeIntegers,
  roundDiv,
} from "./math";
import type { LevelCode } from "../types/game";

export interface RouteSafetyAttributes {
  readonly routeLengthMeters: number;
  readonly primaryRoadLengthMeters: number;
  readonly unpavedLengthMeters: number;
  readonly maxSlopePermil: number;
  readonly hasConstruction: boolean;
  readonly hasSteps: boolean;
  readonly hasFerry: boolean;
  readonly hasFord: boolean;
}

export interface RouteSafetyPolicy {
  readonly maxPrimaryRoadSharePermil: number;
  readonly maxUnpavedSharePermilByLevel: Readonly<Record<LevelCode, number>>;
  readonly maxSlopePermilByLevel: Readonly<Record<LevelCode, number>>;
}

export type RouteSafetyReason =
  | "construction"
  | "steps"
  | "ferry"
  | "ford"
  | "primary_road_share"
  | "unpaved_share"
  | "slope";

export interface RouteSafetyResult {
  readonly safe: boolean;
  readonly reasons: readonly RouteSafetyReason[];
  readonly primaryRoadSharePermil: number;
  readonly unpavedSharePermil: number;
}

export function evaluateRouteSafety(input: {
  readonly levelCode: LevelCode;
  readonly attributes: RouteSafetyAttributes;
  readonly policy: RouteSafetyPolicy;
}): RouteSafetyResult {
  const attributes = input.attributes;
  assertPositiveInteger(attributes.routeLengthMeters, "routeLengthMeters");
  assertNonNegativeInteger(attributes.primaryRoadLengthMeters, "primaryRoadLengthMeters");
  assertNonNegativeInteger(attributes.unpavedLengthMeters, "unpavedLengthMeters");
  assertNonNegativeInteger(attributes.maxSlopePermil, "maxSlopePermil");
  const primaryRoadSharePermil = roundDiv(
    multiplySafeIntegers(attributes.primaryRoadLengthMeters, 1000, "primary road share"),
    attributes.routeLengthMeters,
  );
  const unpavedSharePermil = roundDiv(
    multiplySafeIntegers(attributes.unpavedLengthMeters, 1000, "unpaved share"),
    attributes.routeLengthMeters,
  );
  const reasons: RouteSafetyReason[] = [];
  if (attributes.hasConstruction) reasons.push("construction");
  if (attributes.hasSteps) reasons.push("steps");
  if (attributes.hasFerry) reasons.push("ferry");
  if (attributes.hasFord) reasons.push("ford");
  if (
    multiplySafeIntegers(attributes.primaryRoadLengthMeters, 1000, "primary road share") >
    multiplySafeIntegers(
      attributes.routeLengthMeters,
      input.policy.maxPrimaryRoadSharePermil,
      "primary road policy",
    )
  ) {
    reasons.push("primary_road_share");
  }
  const maxUnpavedShare = input.policy.maxUnpavedSharePermilByLevel[input.levelCode];
  const maxSlope = input.policy.maxSlopePermilByLevel[input.levelCode];
  assertNonNegativeInteger(maxUnpavedShare, "maxUnpavedSharePermil");
  assertNonNegativeInteger(maxSlope, "maxSlopePermil policy");
  if (
    multiplySafeIntegers(attributes.unpavedLengthMeters, 1000, "unpaved share") >
    multiplySafeIntegers(attributes.routeLengthMeters, maxUnpavedShare, "unpaved policy")
  ) {
    reasons.push("unpaved_share");
  }
  if (attributes.maxSlopePermil > maxSlope) reasons.push("slope");
  return {
    safe: reasons.length === 0,
    reasons,
    primaryRoadSharePermil,
    unpavedSharePermil,
  };
}

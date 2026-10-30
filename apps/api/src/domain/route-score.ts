import {
  assertNonNegativeInteger,
  assertPositiveInteger,
  multiplySafeIntegers,
  roundDiv,
  sumSafeIntegers,
} from "./math";

export interface RouteScoreComponent {
  readonly scorePermil: number;
  readonly weight: number;
}

export function scoreRouteCandidate(components: readonly RouteScoreComponent[]): number {
  if (components.length === 0) {
    throw new RangeError("At least one route score component is required.");
  }
  const weightedScores = components.map((component) => {
    assertNonNegativeInteger(component.scorePermil, "scorePermil");
    if (component.scorePermil > 1000) {
      throw new RangeError("scorePermil must not exceed 1000.");
    }
    assertPositiveInteger(component.weight, "weight");
    return multiplySafeIntegers(
      component.scorePermil,
      component.weight,
      "weighted route score",
    );
  });
  const totalWeight = sumSafeIntegers(
    components.map((component) => component.weight),
    "route score weight",
  );
  return roundDiv(sumSafeIntegers(weightedScores, "route score"), totalWeight);
}

import { describe, expect, it } from "vitest";
import { buildGuidanceSteps } from "../../src/domain/route-guidance";

describe("route guidance", () => {
  it("maps stored routing instructions and places them along the route", () => {
    const steps = buildGuidanceSteps(
      [
        { lat: 0, lng: 0 },
        { lat: 0, lng: 0.01 },
        { lat: 0.01, lng: 0.01 },
      ],
      [
        { text: "Continue onto Main Street", distanceMeters: 800, sign: 0 },
        { text: "Turn left onto River Road", distanceMeters: 900, sign: -2 },
      ],
    );
    expect(steps.map((step) => step.maneuver)).toEqual(["depart", "turn_left"]);
    expect(steps[1]?.streetName).toBe("River Road");
    expect(steps[1]?.location.lng).toBeGreaterThan(0);
  });

  it("derives turn steps from geometry for older templates without instructions", () => {
    const steps = buildGuidanceSteps(
      [
        { lat: 0, lng: 0 },
        { lat: 0, lng: 0.01 },
        { lat: 0.01, lng: 0.01 },
      ],
      [],
    );
    expect(steps.map((step) => step.maneuver)).toEqual(["depart", "turn_left", "arrive"]);
  });
});

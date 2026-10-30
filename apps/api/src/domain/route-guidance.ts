import { distanceBetweenMeters } from "./run";
import type { RoutePoint } from "../types/routes";

export interface RouteGuidanceInstruction {
  readonly text: string;
  readonly distanceMeters: number;
  readonly sign?: number;
}

export interface RouteGuidanceStep {
  readonly index: number;
  readonly atDistanceMeters: number;
  readonly maneuver: string;
  readonly streetName: string;
  readonly location: RoutePoint;
}

export function buildGuidanceSteps(
  points: readonly RoutePoint[],
  instructions: readonly RouteGuidanceInstruction[],
): readonly RouteGuidanceStep[] {
  if (instructions.length > 0) {
    let distance = 0;
    return instructions.map((instruction, index) => {
      const step = {
        index,
        atDistanceMeters: Math.round(distance),
        maneuver: index === 0 ? "depart" : maneuverFor(instruction),
        streetName: streetNameFor(instruction.text),
        location: pointAtDistance(points, distance),
      };
      distance += Math.max(0, instruction.distanceMeters);
      return step;
    });
  }
  return deriveGeometrySteps(points);
}

function maneuverFor(instruction: RouteGuidanceInstruction): string {
  const text = instruction.text.toLowerCase();
  switch (instruction.sign) {
    case -3:
      return "turn_sharp_left";
    case -2:
      return "turn_left";
    case -1:
      return "turn_slight_left";
    case 1:
      return "turn_slight_right";
    case 2:
      return "turn_right";
    case 3:
      return "turn_sharp_right";
    case 4:
      return "arrive";
    case 6:
      return "roundabout";
    default:
      if (text.includes("left")) return "turn_left";
      if (text.includes("right")) return "turn_right";
      if (text.includes("arrive") || text.includes("destination")) return "arrive";
      return "continue";
  }
}

function streetNameFor(text: string): string {
  const match = text.match(/(?:onto|on|via)\s+(.+)$/i);
  return (match?.[1] ?? text).trim();
}

function deriveGeometrySteps(
  points: readonly RoutePoint[],
): readonly RouteGuidanceStep[] {
  if (points.length === 0) return [];
  const steps: RouteGuidanceStep[] = [
    {
      index: 0,
      atDistanceMeters: 0,
      maneuver: "depart",
      streetName: "",
      location: points[0]!,
    },
  ];
  let distance = 0;
  for (let index = 1; index < points.length; index += 1) {
    const previous = points[index - 1];
    const current = points[index];
    const next = points[index + 1];
    if (!previous || !current) continue;
    distance += distanceBetweenMeters(previous, current);
    if (!next) {
      steps.push({
        index: steps.length,
        atDistanceMeters: Math.round(distance),
        maneuver: "arrive",
        streetName: "",
        location: current,
      });
      continue;
    }
    const incoming = bearing(previous, current);
    const outgoing = bearing(current, next);
    const turn = normalizeAngle(outgoing - incoming);
    if (Math.abs(turn) < 35) continue;
    steps.push({
      index: steps.length,
      atDistanceMeters: Math.round(distance),
      maneuver: turn < 0 ? "turn_left" : "turn_right",
      streetName: "",
      location: current,
    });
  }
  return steps;
}

function pointAtDistance(
  points: readonly RoutePoint[],
  targetMeters: number,
): RoutePoint {
  const first = points[0];
  if (!first) return { lat: 0, lng: 0 };
  let travelled = 0;
  for (let index = 1; index < points.length; index += 1) {
    const start = points[index - 1];
    const end = points[index];
    if (!start || !end) continue;
    const length = distanceBetweenMeters(start, end);
    if (travelled + length >= targetMeters) {
      const fraction = length === 0 ? 0 : (targetMeters - travelled) / length;
      return {
        lat: start.lat + (end.lat - start.lat) * fraction,
        lng: start.lng + (end.lng - start.lng) * fraction,
      };
    }
    travelled += length;
  }
  return points[points.length - 1] ?? first;
}

function bearing(from: RoutePoint, to: RoutePoint): number {
  const radians = Math.PI / 180;
  const fromLat = from.lat * radians;
  const toLat = to.lat * radians;
  const longitudeDelta = (to.lng - from.lng) * radians;
  const y = Math.sin(longitudeDelta) * Math.cos(toLat);
  const x =
    Math.cos(fromLat) * Math.sin(toLat) -
    Math.sin(fromLat) * Math.cos(toLat) * Math.cos(longitudeDelta);
  return (Math.atan2(y, x) * 180) / Math.PI;
}

function normalizeAngle(angle: number): number {
  let normalized = angle;
  while (normalized <= -180) normalized += 360;
  while (normalized > 180) normalized -= 360;
  return normalized;
}

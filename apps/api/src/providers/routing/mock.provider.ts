import type { LoopRouteRequest, RoutePoint, RouteResult, RoutingProvider } from "./types";

const EARTH_RADIUS_METERS = 6_371_008.8;
const MOCK_METERS_PER_SECOND = 1.4;
const MOCK_ROUND_TRIP_DISTANCE_FACTOR = 1.5;

export class MockRoutingProvider implements RoutingProvider {
  public async routeLoop(input: LoopRouteRequest): Promise<RouteResult> {
    const estimatedRouteDistance =
      input.targetDistanceMeters * MOCK_ROUND_TRIP_DISTANCE_FACTOR;
    const radius = estimatedRouteDistance / (2 * Math.PI);
    const rotation = (input.seed % 360) * (Math.PI / 180);
    const phaseRadius = 1 + 0.18 * Math.sin(4 * rotation);
    const originX = radius * phaseRadius * Math.cos(rotation);
    const originY = radius * phaseRadius * Math.sin(rotation);
    const points = Array.from({ length: 49 }, (_, index) => {
      const angle = rotation + (index * 2 * Math.PI) / 48;
      const variation = 1 + 0.18 * Math.sin(4 * angle);
      const x = radius * variation * Math.cos(angle) - originX;
      const y = radius * variation * Math.sin(angle) - originY;
      return {
        lat: input.start.lat + y / 111_320,
        lng: input.start.lng + x / (111_320 * Math.cos(toRadians(input.start.lat))),
      };
    });
    return this.route(points);
  }

  public async route(waypoints: readonly RoutePoint[]): Promise<RouteResult> {
    const geometry = waypoints.map((point) => ({ ...point }));
    const distanceMeters = pathDistance(geometry);
    return {
      distanceMeters,
      timeMs: (distanceMeters / MOCK_METERS_PER_SECOND) * 1_000,
      geometry,
      snappedWaypoints: geometry,
      instructions: geometry.slice(1).map((_, index) => ({
        text: "Continue along the mapped route",
        distanceMeters: distanceBetween(geometry[index]!, geometry[index + 1]!),
        sign: 0,
      })),
      providerLatencyMs: 0,
    };
  }
}

function pathDistance(points: readonly RoutePoint[]): number {
  let distance = 0;
  for (let index = 1; index < points.length; index += 1) {
    distance += distanceBetween(points[index - 1]!, points[index]!);
  }
  return distance;
}

function distanceBetween(first: RoutePoint, second: RoutePoint): number {
  const latitudeDelta = toRadians(second.lat - first.lat);
  const longitudeDelta = toRadians(second.lng - first.lng);
  const firstLatitude = toRadians(first.lat);
  const secondLatitude = toRadians(second.lat);
  const haversine =
    Math.sin(latitudeDelta / 2) ** 2 +
    Math.cos(firstLatitude) *
      Math.cos(secondLatitude) *
      Math.sin(longitudeDelta / 2) ** 2;
  return EARTH_RADIUS_METERS * 2 * Math.asin(Math.sqrt(haversine));
}

function toRadians(degrees: number): number {
  return (degrees * Math.PI) / 180;
}

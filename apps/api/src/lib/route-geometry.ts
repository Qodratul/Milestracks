import type { RoutePoint } from "../types/routes";

export interface RouteBounds {
  readonly north: number;
  readonly south: number;
  readonly east: number;
  readonly west: number;
}

export function encodePolyline(points: readonly RoutePoint[], precision = 5): string {
  if (!Number.isInteger(precision) || precision < 0 || precision > 7) {
    throw new RangeError("Polyline precision must be between 0 and 7.");
  }
  const scale = 10 ** precision;
  let previousLatitude = 0;
  let previousLongitude = 0;
  let encoded = "";
  for (const point of points) {
    const latitude = Math.round(point.lat * scale);
    const longitude = Math.round(point.lng * scale);
    encoded += encodeDelta(latitude - previousLatitude);
    encoded += encodeDelta(longitude - previousLongitude);
    previousLatitude = latitude;
    previousLongitude = longitude;
  }
  return encoded;
}

export function simplifyPolyline(
  points: readonly RoutePoint[],
  maxPoints = 250,
): readonly RoutePoint[] {
  if (!Number.isSafeInteger(maxPoints) || maxPoints < 2) {
    throw new RangeError("Polyline page must allow at least two points.");
  }
  if (points.length <= maxPoints) return points.map((point) => ({ ...point }));
  let toleranceMeters = 2;
  let simplified = douglasPeucker(points, toleranceMeters);
  while (simplified.length > maxPoints && toleranceMeters < 100_000) {
    toleranceMeters *= 2;
    simplified = douglasPeucker(points, toleranceMeters);
  }
  return simplified.length <= maxPoints ? simplified : sampleEvenly(points, maxPoints);
}

export function routeBounds(points: readonly RoutePoint[]): RouteBounds {
  const first = points[0];
  if (!first) throw new RangeError("Route geometry must contain a point.");
  return points.reduce(
    (bounds, point) => ({
      north: Math.max(bounds.north, point.lat),
      south: Math.min(bounds.south, point.lat),
      east: Math.max(bounds.east, point.lng),
      west: Math.min(bounds.west, point.lng),
    }),
    { north: first.lat, south: first.lat, east: first.lng, west: first.lng },
  );
}

export function distanceBetween(first: RoutePoint, second: RoutePoint): number {
  const latitudeDelta = toRadians(second.lat - first.lat);
  const longitudeDelta = toRadians(second.lng - first.lng);
  const firstLatitude = toRadians(first.lat);
  const secondLatitude = toRadians(second.lat);
  const haversine =
    Math.sin(latitudeDelta / 2) ** 2 +
    Math.cos(firstLatitude) *
      Math.cos(secondLatitude) *
      Math.sin(longitudeDelta / 2) ** 2;
  return 6_371_008.8 * 2 * Math.asin(Math.sqrt(haversine));
}

export function encodeGeometryCursor(routeId: string, offset: number): string {
  if (!routeId || !Number.isSafeInteger(offset) || offset < 0) {
    throw new RangeError("Invalid geometry page cursor.");
  }
  return Buffer.from(JSON.stringify({ routeId, offset })).toString("base64url");
}

export function decodeGeometryCursor(
  cursor: string,
  routeId: string,
): number | undefined {
  try {
    const value: unknown = JSON.parse(Buffer.from(cursor, "base64url").toString("utf8"));
    if (
      typeof value === "object" &&
      value !== null &&
      Reflect.get(value, "routeId") === routeId &&
      Number.isSafeInteger(Reflect.get(value, "offset")) &&
      Reflect.get(value, "offset") >= 0
    ) {
      return Reflect.get(value, "offset") as number;
    }
  } catch {
    return undefined;
  }
  return undefined;
}

function encodeDelta(delta: number): string {
  let value = delta < 0 ? ~(delta << 1) : delta << 1;
  let encoded = "";
  while (value >= 0x20) {
    encoded += String.fromCharCode((0x20 | (value & 0x1f)) + 63);
    value >>= 5;
  }
  return encoded + String.fromCharCode(value + 63);
}

function douglasPeucker(
  points: readonly RoutePoint[],
  toleranceMeters: number,
): readonly RoutePoint[] {
  const first = points[0];
  const last = points.at(-1);
  if (!first || !last) return [];
  const keep = new Uint8Array(points.length);
  keep[0] = 1;
  keep[points.length - 1] = 1;
  const pending: Array<readonly [number, number]> = [[0, points.length - 1]];
  const referenceLatitude = toRadians(first.lat);
  while (pending.length > 0) {
    const range = pending.pop();
    if (!range) continue;
    const [start, end] = range;
    const startPoint = points[start];
    const endPoint = points[end];
    if (!startPoint || !endPoint) continue;
    let farthestDistance = toleranceMeters;
    let farthestIndex = -1;
    for (let index = start + 1; index < end; index += 1) {
      const point = points[index];
      if (!point) continue;
      const distance = distanceToSegmentMeters(
        point,
        startPoint,
        endPoint,
        referenceLatitude,
      );
      if (distance > farthestDistance) {
        farthestDistance = distance;
        farthestIndex = index;
      }
    }
    if (farthestIndex >= 0) {
      keep[farthestIndex] = 1;
      pending.push([start, farthestIndex], [farthestIndex, end]);
    }
  }
  return points
    .filter((_point, index) => keep[index] === 1)
    .map((point) => ({ ...point }));
}

function distanceToSegmentMeters(
  point: RoutePoint,
  start: RoutePoint,
  end: RoutePoint,
  referenceLatitude: number,
): number {
  const longitudeScale = 111_320 * Math.cos(referenceLatitude);
  const startX = start.lng * longitudeScale;
  const startY = start.lat * 111_320;
  const endX = end.lng * longitudeScale;
  const endY = end.lat * 111_320;
  const pointX = point.lng * longitudeScale;
  const pointY = point.lat * 111_320;
  const deltaX = endX - startX;
  const deltaY = endY - startY;
  const segmentLengthSquared = deltaX * deltaX + deltaY * deltaY;
  const projection =
    segmentLengthSquared === 0
      ? 0
      : Math.max(
          0,
          Math.min(
            1,
            ((pointX - startX) * deltaX + (pointY - startY) * deltaY) /
              segmentLengthSquared,
          ),
        );
  const nearestX = startX + projection * deltaX;
  const nearestY = startY + projection * deltaY;
  return Math.hypot(pointX - nearestX, pointY - nearestY);
}

function sampleEvenly(
  points: readonly RoutePoint[],
  maxPoints: number,
): readonly RoutePoint[] {
  return Array.from({ length: maxPoints }, (_unused, index) => {
    const point = points[Math.round((index * (points.length - 1)) / (maxPoints - 1))];
    if (!point) throw new RangeError("Invalid geometry sample.");
    return { ...point };
  });
}

function toRadians(value: number): number {
  return (value * Math.PI) / 180;
}

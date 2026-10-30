import { XMLParser, XMLValidator } from "fast-xml-parser";
import type { RoutePoint } from "../types/routes";

export interface GpxPoint extends RoutePoint {
  readonly timestampMs: number | null;
  readonly elevationMeters: number | null;
  readonly accuracyMeters: number | null;
  readonly speedMps: number | null;
  readonly mocked: boolean | null;
  readonly segmentIndex: number;
}

export interface GpxTrack {
  readonly name: string;
  readonly description: string;
  readonly points: readonly GpxPoint[];
}

const MAX_GPX_BYTES = 16 * 1024 * 1024;
const parser = new XMLParser({
  allowBooleanAttributes: false,
  attributeNamePrefix: "@_",
  ignoreAttributes: false,
  parseAttributeValue: true,
  parseTagValue: true,
  processEntities: true,
  removeNSPrefix: true,
  trimValues: true,
});

export function parseGpx(xml: string): GpxTrack {
  if (Buffer.byteLength(xml, "utf8") > MAX_GPX_BYTES) {
    throw new RangeError("GPX file exceeds the 16 MiB limit.");
  }
  if (/<!DOCTYPE|<!ENTITY/i.test(xml)) {
    throw new TypeError("GPX files cannot declare document types or entities.");
  }
  const validation = XMLValidator.validate(xml);
  if (validation !== true) {
    throw new TypeError("Invalid GPX XML: " + validation.err.msg);
  }

  const parsed = asRecord(parser.parse(xml));
  if (!parsed) throw new TypeError("Invalid GPX document.");
  const gpx = asRecord(parsed.gpx);
  if (!gpx) throw new TypeError("The XML root must be gpx.");

  const points: GpxPoint[] = [];
  let segmentIndex = 0;
  const tracks = asArray(gpx.trk);
  for (const trackValue of tracks) {
    const track = asRecord(trackValue);
    if (!track) continue;
    const segments = asArray(track.trkseg);
    if (segments.length === 0) {
      for (const pointValue of asArray(track.trkpt)) {
        const point = parsePoint(pointValue, segmentIndex);
        if (point) points.push(point);
      }
      segmentIndex += 1;
      continue;
    }
    for (const segmentValue of segments) {
      const segment = asRecord(segmentValue);
      if (segment) {
        for (const pointValue of asArray(segment.trkpt)) {
          const point = parsePoint(pointValue, segmentIndex);
          if (point) points.push(point);
        }
      }
      segmentIndex += 1;
    }
  }

  if (points.length === 0) {
    for (const routeValue of asArray(gpx.rte)) {
      const route = asRecord(routeValue);
      if (!route) continue;
      for (const pointValue of asArray(route.rtept)) {
        const point = parsePoint(pointValue, segmentIndex);
        if (point) points.push(point);
      }
      segmentIndex += 1;
    }
  }
  if (points.length === 0)
    throw new TypeError("GPX must contain at least one trkpt or rtept.");

  const metadata = asRecord(gpx.metadata);
  const firstTrack = asRecord(tracks[0]);
  const name = textValue(metadata?.name) ?? textValue(firstTrack?.name) ?? "Untitled GPX";
  const description = textValue(metadata?.desc) ?? "";
  return { name, description, points };
}

export function serializeGpx(track: GpxTrack, description = track.description): string {
  if (track.points.length === 0)
    throw new RangeError("A GPX track needs at least one point.");
  const lines = [
    '<?xml version="1.0" encoding="UTF-8"?>',
    '<gpx version="1.1" creator="Milestride GPX tooling" xmlns="http://www.topografix.com/GPX/1/1" xmlns:ms="https://milestride.app/gpx/extensions/1">',
    "  <metadata>",
    "    <name>" + escapeXml(track.name) + "</name>",
    "    <desc>" + escapeXml(description) + "</desc>",
    "  </metadata>",
    "  <trk>",
    "    <name>" + escapeXml(track.name) + "</name>",
  ];

  let activeSegment: number | null = null;
  for (const point of track.points) {
    if (activeSegment !== point.segmentIndex) {
      if (activeSegment !== null) lines.push("    </trkseg>");
      lines.push("    <trkseg>");
      activeSegment = point.segmentIndex;
    }
    lines.push(
      '      <trkpt lat="' +
        point.lat.toFixed(7) +
        '" lon="' +
        point.lng.toFixed(7) +
        '">',
    );
    if (point.elevationMeters !== null) {
      lines.push("        <ele>" + point.elevationMeters.toFixed(1) + "</ele>");
    }
    if (point.timestampMs !== null) {
      lines.push(
        "        <time>" + new Date(point.timestampMs).toISOString() + "</time>",
      );
    }
    const extensions = [
      point.accuracyMeters === null
        ? ""
        : "          <ms:accuracyMeters>" +
          point.accuracyMeters.toFixed(1) +
          "</ms:accuracyMeters>",
      point.speedMps === null
        ? ""
        : "          <ms:speedMps>" + point.speedMps.toFixed(3) + "</ms:speedMps>",
      point.mocked === null
        ? ""
        : "          <ms:mocked>" + String(point.mocked) + "</ms:mocked>",
    ].filter(Boolean);
    if (extensions.length > 0) {
      lines.push("        <extensions>", ...extensions, "        </extensions>");
    }
    lines.push("      </trkpt>");
  }
  lines.push("    </trkseg>", "  </trk>", "</gpx>");
  return lines.join("\n") + "\n";
}

function parsePoint(value: unknown, segmentIndex: number): GpxPoint | null {
  const point = asRecord(value);
  if (!point) return null;
  const lat = numberValue(point["@_lat"] ?? point.lat);
  const lng = numberValue(point["@_lon"] ?? point.lon ?? point.lng);
  if (lat === null || lng === null || lat < -90 || lat > 90 || lng < -180 || lng > 180) {
    throw new TypeError(
      "GPX trackpoint coordinates must be valid latitude and longitude.",
    );
  }
  const timestampValue = textValue(point.time);
  const parsedTimestamp = timestampValue === null ? null : Date.parse(timestampValue);
  if (timestampValue !== null && !Number.isFinite(parsedTimestamp)) {
    throw new TypeError("GPX trackpoint time must be an ISO-8601 timestamp.");
  }
  const extensions = asRecord(point.extensions);
  const hdop = numberValue(point.hdop);
  const accuracyMeters =
    firstNumber(extensions, ["accuracymeters", "accuracy", "horizontalaccuracy"]) ??
    (hdop === null ? null : hdop * 5);
  return {
    lat,
    lng,
    timestampMs: parsedTimestamp,
    elevationMeters: numberValue(point.ele),
    accuracyMeters,
    speedMps: firstNumber(extensions, ["speedmps", "speed"]) ?? numberValue(point.speed),
    mocked: firstBoolean(extensions, ["mocked", "mocklocation"]),
    segmentIndex,
  };
}

function firstNumber(value: unknown, keys: readonly string[]): number | null {
  const target = new Set(keys);
  const visit = (current: unknown): number | null => {
    if (Array.isArray(current)) {
      for (const item of current) {
        const found = visit(item);
        if (found !== null) return found;
      }
      return null;
    }
    const record = asRecord(current);
    if (!record) return null;
    for (const [key, child] of Object.entries(record)) {
      if (target.has(localName(key))) {
        const found = numberValue(child);
        if (found !== null) return found;
      }
      const nested = visit(child);
      if (nested !== null) return nested;
    }
    return null;
  };
  return visit(value);
}

function firstBoolean(value: unknown, keys: readonly string[]): boolean | null {
  const target = new Set(keys);
  const visit = (current: unknown): boolean | null => {
    if (Array.isArray(current)) {
      for (const item of current) {
        const found = visit(item);
        if (found !== null) return found;
      }
      return null;
    }
    const record = asRecord(current);
    if (!record) return null;
    for (const [key, child] of Object.entries(record)) {
      if (target.has(localName(key))) {
        const parsed = booleanValue(child);
        if (parsed !== null) return parsed;
      }
      const nested = visit(child);
      if (nested !== null) return nested;
    }
    return null;
  };
  return visit(value);
}

function booleanValue(value: unknown): boolean | null {
  if (typeof value === "boolean") return value;
  const normalized = textValue(value)?.toLowerCase();
  if (normalized === "true" || normalized === "1") return true;
  if (normalized === "false" || normalized === "0") return false;
  return null;
}

function numberValue(value: unknown): number | null {
  const scalar = typeof value === "object" && value !== null ? textValue(value) : value;
  if (typeof scalar === "number") return Number.isFinite(scalar) ? scalar : null;
  if (typeof scalar !== "string" || scalar.trim() === "") return null;
  const parsed = Number(scalar);
  return Number.isFinite(parsed) ? parsed : null;
}

function textValue(value: unknown): string | null {
  if (typeof value === "string" || typeof value === "number") return String(value);
  const record = asRecord(value);
  if (!record) return null;
  const text = record["#text"];
  return typeof text === "string" || typeof text === "number" ? String(text) : null;
}

function asArray(value: unknown): readonly unknown[] {
  if (value === undefined || value === null) return [];
  return Array.isArray(value) ? value : [value];
}

function asRecord(value: unknown): Record<string, unknown> | null {
  if (typeof value !== "object" || value === null || Array.isArray(value)) return null;
  return value as Record<string, unknown>;
}

function localName(name: string): string {
  return name.split(":").at(-1)?.replace(/^@_/, "").toLowerCase() ?? name.toLowerCase();
}

function escapeXml(value: string): string {
  return value
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&apos;");
}

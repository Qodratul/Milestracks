import { Prisma, type Locale, type TemplateStatus } from "@prisma/client";
import type { Tx } from "../lib/prisma";
import type { RouteGuidanceInstruction, RoutePoint } from "../types/routes";
import type { LevelCode } from "../types/game";

export interface ReusableTemplateQuery {
  readonly userId: string;
  readonly levelCode: LevelCode;
  readonly targetDistanceMeters: number;
  readonly tolerancePermil: number;
  readonly start: RoutePoint;
  readonly radiusMeters: number;
  readonly usedAfter: Date;
  readonly algorithmVersion: string;
  readonly excludedTemplateId?: string;
}

export interface ReusableTemplate {
  readonly id: string;
  readonly distanceMeters: number;
  readonly safetyScore: number;
  readonly dataConfidence: number;
  readonly startLat: number;
  readonly startLng: number;
}

export interface RouteMilestoneInput {
  readonly id: string;
  readonly ordinal: number;
  readonly distanceMeters: number;
  readonly radiusMeters: number;
  readonly exp: number;
}

export interface RouteNarrationInput {
  readonly locale: Locale;
  readonly title: string;
  readonly mysteryBrief: string;
  readonly preRunTip: string;
  readonly warning: string | null;
  readonly selectionReason: string;
  readonly dialogues: unknown;
}

export interface CreateRouteTemplateInput {
  readonly id: string;
  readonly levelCode: LevelCode;
  readonly distanceMeters: number;
  readonly estimatedDurationSec: number;
  readonly estimatedCalories: number;
  readonly geometry: readonly RoutePoint[];
  readonly instructions?: readonly RouteGuidanceInstruction[];
  readonly safetyScore: number;
  readonly dataConfidence: number;
  readonly algorithmVersion: string;
  readonly createdAt: Date;
  readonly milestones: readonly RouteMilestoneInput[];
}

export async function findReusableTemplate(
  tx: Tx,
  query: ReusableTemplateQuery,
): Promise<ReusableTemplate | null> {
  const lower = Math.floor(
    (query.targetDistanceMeters * (1000 - query.tolerancePermil)) / 1000,
  );
  const upper = Math.ceil(
    (query.targetDistanceMeters * (1000 + query.tolerancePermil)) / 1000,
  );
  const rows = await tx.$queryRaw<ReusableTemplate[]>(Prisma.sql`
    SELECT t.id, t.distance_meters AS "distanceMeters",
           t.safety_score AS "safetyScore", t.data_confidence AS "dataConfidence",
           ST_Y(t.start_point) AS "startLat", ST_X(t.start_point) AS "startLng"
    FROM route_templates t
    WHERE t.level_code = ${query.levelCode}::level_code
      AND t.distance_meters BETWEEN ${lower} AND ${upper}
      AND t.algorithm_version = ${query.algorithmVersion}
      AND t.status IN ('active'::template_status, 'flagged'::template_status)
      AND ST_DWithin(t.start_point::geography,
        ST_SetSRID(ST_MakePoint(${query.start.lng}, ${query.start.lat}), 4326)::geography,
        ${query.radiusMeters})
      AND (${query.excludedTemplateId ?? null}::varchar IS NULL
        OR t.id <> ${query.excludedTemplateId ?? null})
      AND NOT EXISTS (
        SELECT 1 FROM routes r JOIN runs run ON run.route_id = r.id
        WHERE r.template_id = t.id AND r.user_id = ${query.userId}
          AND run.started_at >= ${query.usedAfter})
      AND NOT EXISTS (
        SELECT 1 FROM route_reports report JOIN routes r ON r.id = report.route_id
        WHERE r.template_id = t.id AND report.user_id = ${query.userId})
    ORDER BY ABS(t.distance_meters - ${query.targetDistanceMeters}),
      ST_Distance(t.start_point::geography,
        ST_SetSRID(ST_MakePoint(${query.start.lng}, ${query.start.lat}), 4326)::geography),
      t.safety_score DESC, t.data_confidence DESC
    LIMIT 1
  `);
  return rows[0] ?? null;
}

export async function hasDuplicateGeometry(
  tx: Tx,
  input: {
    readonly levelCode: LevelCode;
    readonly points: readonly RoutePoint[];
    readonly bufferMeters: number;
    readonly overlapPermil: number;
  },
): Promise<boolean> {
  const geoJson = lineStringJson(input.points);
  const rows = await tx.$queryRaw<Array<{ duplicate: boolean }>>(Prisma.sql`
    WITH candidate AS (
      SELECT ST_SetSRID(ST_GeomFromGeoJSON(${geoJson}), 4326)::geography AS line
    )
    SELECT EXISTS (
      SELECT 1 FROM route_templates t, candidate c
      WHERE t.level_code = ${input.levelCode}::level_code
        AND t.status IN ('active'::template_status, 'flagged'::template_status)
        AND ST_DWithin(t.geometry::geography, c.line, ${input.bufferMeters})
        AND ST_Area(ST_Intersection(
          ST_Buffer(t.geometry::geography, ${input.bufferMeters}),
          ST_Buffer(c.line, ${input.bufferMeters})))
          / NULLIF(LEAST(
            ST_Area(ST_Buffer(t.geometry::geography, ${input.bufferMeters})),
            ST_Area(ST_Buffer(c.line, ${input.bufferMeters}))), 0)
          >= ${input.overlapPermil}::double precision / 1000
    ) AS duplicate
  `);
  return rows[0]?.duplicate ?? false;
}

export async function findActiveDuplicateGeometryId(
  tx: Tx,
  input: {
    readonly levelCode: LevelCode;
    readonly points: readonly RoutePoint[];
    readonly bufferMeters: number;
    readonly overlapPermil: number;
  },
): Promise<string | null> {
  const geoJson = lineStringJson(input.points);
  const rows = await tx.$queryRaw<Array<{ id: string }>>(Prisma.sql`
    WITH candidate AS (
      SELECT ST_SetSRID(ST_GeomFromGeoJSON(${geoJson}), 4326)::geography AS line
    )
    SELECT t.id FROM route_templates t, candidate c
    WHERE t.level_code = ${input.levelCode}::level_code
      AND t.status = 'active'::template_status
      AND ST_DWithin(t.geometry::geography, c.line, ${input.bufferMeters})
      AND ST_Area(ST_Intersection(
        ST_Buffer(t.geometry::geography, ${input.bufferMeters}),
        ST_Buffer(c.line, ${input.bufferMeters})))
        / NULLIF(LEAST(
          ST_Area(ST_Buffer(t.geometry::geography, ${input.bufferMeters})),
          ST_Area(ST_Buffer(c.line, ${input.bufferMeters}))), 0)
        >= ${input.overlapPermil}::double precision / 1000
    ORDER BY t.safety_score DESC, t.data_confidence DESC, t.created_at DESC
    LIMIT 1
  `);
  return rows[0]?.id ?? null;
}

export async function createRouteTemplate(
  tx: Tx,
  input: CreateRouteTemplateInput,
): Promise<void> {
  const first = input.geometry[0];
  if (!first) throw new RangeError("Route geometry cannot be empty.");
  const geoJson = lineStringJson(input.geometry);
  await tx.$executeRaw(Prisma.sql`
    INSERT INTO route_templates (
      id, level_code, distance_meters, estimated_duration_sec, estimated_calories,
      geometry, start_point, safety_score, data_confidence, status,
      algorithm_version, instructions, created_at, updated_at
    ) VALUES (
      ${input.id}, ${input.levelCode}::level_code, ${input.distanceMeters},
      ${input.estimatedDurationSec}, ${input.estimatedCalories},
      ST_SetSRID(ST_GeomFromGeoJSON(${geoJson}), 4326),
      ST_SetSRID(ST_MakePoint(${first.lng}, ${first.lat}), 4326),
      ${input.safetyScore}, ${input.dataConfidence}, 'active'::template_status,
      ${input.algorithmVersion}, ${JSON.stringify(input.instructions ?? [])}::jsonb, ${input.createdAt}, ${input.createdAt}
    )
  `);
  for (const milestone of input.milestones) await insertMilestone(tx, input, milestone);
}

export async function insertNarration(
  tx: Tx,
  templateId: string,
  narrationId: string,
  value: RouteNarrationInput,
  timestamp: Date,
): Promise<void> {
  await tx.$executeRaw(Prisma.sql`
    INSERT INTO route_template_narrations (
      id, template_id, locale, title, mystery_brief, pre_run_tip,
      warning, selection_reason, dialogues, created_at
    ) VALUES (
      ${narrationId}, ${templateId}, ${value.locale}::locale, ${value.title},
      ${value.mysteryBrief}, ${value.preRunTip}, ${value.warning},
      ${value.selectionReason}, ${JSON.stringify(value.dialogues)}::jsonb, ${timestamp}
    )
    ON CONFLICT (template_id, locale) DO NOTHING
  `);
}

export async function findNarration(
  tx: Tx,
  templateId: string,
  locale: Locale,
): Promise<RouteNarrationInput | null> {
  const rows = await tx.$queryRaw<RouteNarrationInput[]>(Prisma.sql`
    SELECT locale, title, mystery_brief AS "mysteryBrief",
      pre_run_tip AS "preRunTip", warning, selection_reason AS "selectionReason", dialogues
    FROM route_template_narrations
    WHERE template_id = ${templateId} AND locale = ${locale}::locale
    LIMIT 1
  `);
  return rows[0] ?? null;
}

export async function setTemplateStatus(
  tx: Tx,
  templateId: string,
  status: TemplateStatus,
): Promise<void> {
  await tx.routeTemplate.update({ where: { id: templateId }, data: { status } });
}

export async function readTemplateStart(
  tx: Tx,
  templateId: string,
): Promise<{ readonly lat: number; readonly lng: number } | null> {
  const rows = await tx.$queryRaw<Array<{ lat: number; lng: number }>>(Prisma.sql`
    SELECT ST_Y(start_point) AS lat, ST_X(start_point) AS lng
    FROM route_templates WHERE id = ${templateId}
  `);
  return rows[0] ?? null;
}

export async function readTemplateGeometry(
  tx: Tx,
  templateId: string,
): Promise<{
  readonly geometryJson: string;
  readonly startLat: number;
  readonly startLng: number;
} | null> {
  const rows = await tx.$queryRaw<
    Array<{
      geometryJson: string;
      startLat: number;
      startLng: number;
    }>
  >(Prisma.sql`
    SELECT ST_AsGeoJSON(geometry) AS "geometryJson",
      ST_Y(start_point) AS "startLat", ST_X(start_point) AS "startLng"
    FROM route_templates WHERE id = ${templateId}
  `);
  return rows[0] ?? null;
}

async function insertMilestone(
  tx: Tx,
  template: CreateRouteTemplateInput,
  milestone: RouteMilestoneInput,
): Promise<void> {
  const fraction = Math.min(1, milestone.distanceMeters / template.distanceMeters);
  await tx.$executeRaw(Prisma.sql`
    INSERT INTO route_template_milestones (
      template_id, ordinal, milestone_id, location, distance_meters, radius_meters, exp
    )
    SELECT ${template.id}, ${milestone.ordinal}, ${milestone.id},
      ST_LineInterpolatePoint(geometry, ${fraction}),
      ${milestone.distanceMeters}, ${milestone.radiusMeters}, ${milestone.exp}
    FROM route_templates WHERE id = ${template.id}
  `);
}

function lineStringJson(points: readonly RoutePoint[]): string {
  return JSON.stringify({
    type: "LineString",
    coordinates: points.map((point) => [point.lng, point.lat]),
  });
}

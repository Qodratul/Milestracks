import { Prisma, type Locale } from "@prisma/client";
import { levelByCode } from "../config/game-config";
import type { GameConfig, LevelCode } from "../config/game-config.schema";
import { planMilestones, scoreRouteCandidate } from "../domain";
import { evaluateRouteSafety, type RouteSafetyPolicy } from "../domain/route-safety";
import { roundDiv } from "../domain/math";
import { env } from "../config/env";
import { ROUTE_ALGORITHM_VERSION } from "../config/route-algorithm";
import { now } from "../lib/clock";
import { createId } from "../lib/ids";
import { logger } from "../lib/logger";
import { withTransaction, type Tx } from "../lib/prisma";
import {
  OpenMeteoElevationProvider,
  type ElevationProfile,
} from "../providers/elevation";
import { llmProvider, type LLMProvider, type RunnerLevel } from "../providers/llm";
import { OverpassOsmTagsProvider, type OsmRouteTags } from "../providers/osm-tags";
import {
  GraphHopperRoutingProvider,
  generateLoopCandidates,
  MockRoutingProvider,
  type LoopCandidate,
  type RoutePoint,
  type RouteRoadDetails,
  type RoutingProvider,
} from "../providers/routing";
import {
  createRouteTemplate,
  findActiveDuplicateGeometryId,
  hasDuplicateGeometry,
  insertNarration,
  type CreateRouteTemplateInput,
  type RouteNarrationInput,
  type RouteMilestoneInput,
} from "../repositories/route-template.repository";
import { RouteSelectionService, type SelectableRoute } from "./route-selection.service";

const DISTANCE_TOLERANCE_PERMIL = 150;
const DUPLICATE_BUFFER_METERS = 20;
const DUPLICATE_OVERLAP_PERMIL = 850;
const U_TURN_LIMIT = 1;

export interface RouteCandidateBuildInput {
  readonly routeId?: string;
  readonly userId: string;
  readonly levelCode: LevelCode;
  readonly targetDistanceMeters: number;
  readonly location: RoutePoint;
  readonly locale: Locale;
  readonly timezone: string;
  readonly weatherTemperatureC?: number | undefined;
  readonly seed?: number | undefined;
  readonly config: GameConfig;
}

export interface GeneratedRouteTemplate {
  readonly template: CreateRouteTemplateInput;
  readonly narration: RouteNarrationInput;
  readonly selectionReason: string;
  readonly allowDuplicateReuse: boolean;
}

interface EnrichedCandidate {
  readonly route: LoopCandidate;
  readonly elevation: ElevationProfile;
  readonly tags: OsmRouteTags;
  readonly dataConfidencePermil: number;
  readonly safetyScorePermil: number;
  readonly scorePermil: number;
  readonly rejectionReasons: readonly string[];
}

export class RouteCandidateService {
  private readonly routing: RoutingProvider;
  private readonly elevation: OpenMeteoElevationProvider;
  private readonly osm: OverpassOsmTagsProvider;
  private readonly selection: RouteSelectionService;
  private readonly demoMode: boolean;

  public constructor(
    options: {
      readonly routing?: RoutingProvider;
      readonly elevation?: OpenMeteoElevationProvider;
      readonly osm?: OverpassOsmTagsProvider;
      readonly llm?: LLMProvider;
      readonly demoMode?: boolean;
    } = {},
  ) {
    this.demoMode = options.demoMode ?? env.DEMO_MODE;
    this.routing =
      options.routing ??
      (this.demoMode || env.ROUTING_PROVIDER === "mock"
        ? new MockRoutingProvider()
        : new GraphHopperRoutingProvider());
    this.elevation = options.elevation ?? new OpenMeteoElevationProvider();
    this.osm = options.osm ?? new OverpassOsmTagsProvider();
    this.selection = new RouteSelectionService(options.llm ?? llmProvider);
  }

  public async persist(tx: Tx, built: GeneratedRouteTemplate): Promise<string | null> {
    await tx.$queryRaw<Array<{ acquired: boolean }>>(
      Prisma.sql`SELECT pg_advisory_xact_lock(hashtext(${built.template.levelCode})) IS NOT NULL AS acquired`,
    );
    const duplicate = await hasDuplicateGeometry(tx, {
      levelCode: built.template.levelCode,
      points: built.template.geometry,
      bufferMeters: DUPLICATE_BUFFER_METERS,
      overlapPermil: DUPLICATE_OVERLAP_PERMIL,
    });
    if (duplicate) {
      if (!built.allowDuplicateReuse) return null;
      return findActiveDuplicateGeometryId(tx, {
        levelCode: built.template.levelCode,
        points: built.template.geometry,
        bufferMeters: DUPLICATE_BUFFER_METERS,
        overlapPermil: DUPLICATE_OVERLAP_PERMIL,
      });
    }
    await createRouteTemplate(tx, built.template);
    await insertNarration(
      tx,
      built.template.id,
      createId("rt"),
      built.narration,
      built.template.createdAt,
    );
    return built.template.id;
  }

  public async build(
    input: RouteCandidateBuildInput,
  ): Promise<GeneratedRouteTemplate | null> {
    const level = levelByCode(input.config, input.levelCode);
    const isNight = localNighttime(now(), input.timezone);
    const candidates = await generateLoopCandidates(this.routing, {
      start: input.location,
      targetDistanceMeters: input.targetDistanceMeters,
      candidateCount: 3,
      seedOffset: input.seed ?? 0,
      maxAdjustments: 2,
      maxSnapDistanceMeters: input.config.rules.trackStartRadiusMeters,
      distanceToleranceRatio: DISTANCE_TOLERANCE_PERMIL / 1000,
    });
    const enriched = await Promise.all(
      candidates.map((candidate) => this.enrichCandidate(candidate, input, isNight)),
    );
    const { candidates: safe, reusedDuplicatePool } = await this.removeUnsafeOrDuplicate(
      enriched,
      input.levelCode,
    );
    if (safe.length === 0) {
      logger.warn(
        {
          routeId: input.routeId,
          candidates: enriched.map((candidate) => ({
            candidateId: candidate.route.id,
            routeValid: candidate.route.valid,
            routeFailure: candidate.route.failureReason,
            routingErrorCode: candidate.route.routingErrorCode,
            routingStatusCode: candidate.route.routingStatusCode,
            routingRateLimitInfo: candidate.route.routingRateLimitInfo,
            uTurnCount: candidate.route.uTurnCount,
            dataConfidencePermil: candidate.dataConfidencePermil,
            rejectionReasons: candidate.rejectionReasons,
          })),
        },
        "All generated route candidates were rejected",
      );
      return null;
    }

    const milestonePlan = planMilestones(Math.round(input.targetDistanceMeters), level);
    const selected = await this.selection.select({
      userLevel: levelName(input.levelCode),
      totalDistanceMeters: input.targetDistanceMeters,
      milestoneCount: milestonePlan.milestoneCount,
      language: input.locale,
      candidates: safe.map(toSelectableRoute),
    });
    logger.info(
      {
        routeId: input.routeId,
        candidateCount: safe.length,
        selectedCandidateId: selected.selected.id,
        selectionSource: selected.usedFallback ? "deterministic_fallback" : "llm",
        reusedDuplicatePool,
      },
      "Route candidate selection completed",
    );
    const chosen = safe.find((item) => item.route.id === selected.selected.id);
    if (!chosen?.route.route) return null;
    const distanceMeters = Math.round(chosen.route.route.distanceMeters);
    const routeMilestones = createMilestones(distanceMeters, milestonePlan, input.config);
    const warning = buildWarning(
      input.locale,
      chosen.dataConfidencePermil,
      input.weatherTemperatureC,
      isNight,
      chosen.tags.lightingCoverage,
    );
    const narration: RouteNarrationInput = {
      locale: input.locale,
      title: selected.narrative.trackTitle,
      mysteryBrief: selected.narrative.mysteryBrief,
      preRunTip: selected.narrative.preRunTip,
      warning,
      selectionReason: selected.narrative.selectionReason,
      dialogues: selected.narrative.milestoneDialogues,
    };
    const template: CreateRouteTemplateInput = {
      id: createId("route"),
      levelCode: input.levelCode,
      distanceMeters,
      estimatedDurationSec: Math.max(1, Math.round(chosen.route.route.timeMs / 1000)),
      estimatedCalories: roundDiv(input.config.rules.kcalPerKm * distanceMeters, 1000),
      geometry: chosen.route.route.geometry,
      instructions: chosen.route.route.instructions,
      safetyScore: chosen.safetyScorePermil / 1000,
      dataConfidence: chosen.dataConfidencePermil / 1000,
      algorithmVersion: ROUTE_ALGORITHM_VERSION,
      createdAt: now(),
      milestones: routeMilestones,
    };
    return {
      template,
      narration,
      selectionReason: selected.narrative.selectionReason,
      allowDuplicateReuse: reusedDuplicatePool,
    };
  }

  private async enrichCandidate(
    route: LoopCandidate,
    input: RouteCandidateBuildInput,
    isNight: boolean,
  ): Promise<EnrichedCandidate> {
    if (!route.valid || !route.route) {
      return emptyCandidate(route);
    }
    const [elevation, tags] = this.demoMode
      ? [demoElevation(), demoOsmTags()]
      : await Promise.all([
          this.elevation.getProfile(route.route.geometry),
          this.loadRouteTags(
            route.route.geometry,
            route.route.roadDetails,
            input.config.routeSafety.minimumDataConfidencePermil,
          ),
        ]);
    const dataConfidencePermil = roundDiv(
      Math.round(tags.dataConfidence * 1000) + (elevation.available ? 1000 : 0),
      2,
    );
    const policy = buildPolicy(input.config, dataConfidencePermil, isNight);
    const safety = evaluateRouteSafety({
      levelCode: input.levelCode,
      policy,
      attributes: {
        routeLengthMeters: Math.max(1, Math.round(route.route.distanceMeters)),
        primaryRoadLengthMeters: tags.hasPrimaryRoad
          ? Math.round(route.route.distanceMeters)
          : 0,
        unpavedLengthMeters: tags.hasUnpavedSurface
          ? Math.round(route.route.distanceMeters)
          : 0,
        maxSlopePermil: Math.round(elevation.maxGradePercent * 10),
        hasConstruction: tags.hasConstruction,
        hasSteps: tags.hasSteps,
        hasFerry: tags.hasFerry,
        hasFord: tags.hasFord,
      },
    });
    const lightingUnsafe = isNight && tags.lightingCoverage === "no";
    const rejectionReasons = [
      ...safety.reasons,
      ...(dataConfidencePermil < input.config.routeSafety.minimumDataConfidencePermil
        ? ["insufficient_data_confidence"]
        : []),
      ...(lightingUnsafe ? ["unlit_at_night"] : []),
      ...((route.uTurnCount ?? U_TURN_LIMIT + 1) > U_TURN_LIMIT
        ? ["too_many_uturns"]
        : []),
    ];
    const safe = rejectionReasons.length === 0;
    const safetyScorePermil = safe ? dataConfidencePermil : 0;
    const distanceFitPermil = Math.max(
      0,
      1000 -
        Math.round(
          (Math.abs(route.route.distanceMeters - input.targetDistanceMeters) /
            input.targetDistanceMeters) *
            1000,
        ),
    );
    const turnScore = (route.uTurnCount ?? U_TURN_LIMIT + 1) <= U_TURN_LIMIT ? 1000 : 0;
    return {
      route: safe ? route : { ...route, valid: false },
      elevation,
      tags,
      dataConfidencePermil,
      safetyScorePermil,
      scorePermil: scoreRouteCandidate([
        { scorePermil: safetyScorePermil, weight: 1 },
        { scorePermil: dataConfidencePermil, weight: 1 },
        { scorePermil: distanceFitPermil, weight: 1 },
        { scorePermil: turnScore, weight: 1 },
      ]),
      rejectionReasons,
    };
  }

  private async removeUnsafeOrDuplicate(
    candidates: readonly EnrichedCandidate[],
    levelCode: LevelCode,
  ): Promise<{
    readonly candidates: readonly EnrichedCandidate[];
    readonly reusedDuplicatePool: boolean;
  }> {
    const safeCandidates = candidates.filter(
      (candidate) => candidate.route.valid && candidate.route.route !== null,
    );
    return withTransaction(async (tx) => {
      const duplicateFlags = await Promise.all(
        safeCandidates.map((candidate) =>
          hasDuplicateGeometry(tx, {
            levelCode,
            points: candidate.route.route!.geometry,
            bufferMeters: DUPLICATE_BUFFER_METERS,
            overlapPermil: DUPLICATE_OVERLAP_PERMIL,
          }),
        ),
      );
      const uniqueCandidates = safeCandidates.filter(
        (_candidate, index) => !duplicateFlags[index],
      );
      if (duplicateFlags.some(Boolean)) {
        logger.warn(
          {
            levelCode,
            rejectedCandidateIds: safeCandidates
              .filter((_candidate, index) => duplicateFlags[index])
              .map((candidate) => candidate.route.id),
          },
          "Safe route candidates overlapped existing route templates",
        );
      }
      // If every safe candidate duplicates an existing template, keep them eligible
      // for AI selection. Persistence will reuse the matching active template.
      return uniqueCandidates.length > 0
        ? { candidates: uniqueCandidates, reusedDuplicatePool: false }
        : { candidates: safeCandidates, reusedDuplicatePool: safeCandidates.length > 0 };
    });
  }

  private async loadRouteTags(
    geometry: readonly RoutePoint[],
    roadDetails?: RouteRoadDetails,
    minimumConfidencePermil = 0,
  ): Promise<OsmRouteTags> {
    const routingTags = roadDetails ? tagsFromRouteDetails(roadDetails) : undefined;
    if (
      routingTags?.available &&
      routingTags.dataConfidence * 1000 >= minimumConfidencePermil
    ) {
      return routingTags;
    }
    const osmTags = await this.osm.getRouteTags(geometry);
    if (!routingTags) return osmTags;
    return mergeRouteTags(routingTags, osmTags);
  }
}

function buildPolicy(
  config: GameConfig,
  dataConfidencePermil: number,
  isNight: boolean,
): RouteSafetyPolicy {
  const nightFactor = isNight ? config.routeSafety.nightSafetyFactorPermil : 1000;
  const factor = roundDiv(dataConfidencePermil * nightFactor, 1000);
  return {
    maxPrimaryRoadSharePermil: scalePermil(
      config.routeSafety.maxPrimaryRoadSharePermil,
      factor,
    ),
    maxUnpavedSharePermilByLevel: mapLevelPolicy(
      config.routeSafety.maxUnpavedSharePermilByLevel,
      factor,
    ),
    maxSlopePermilByLevel: mapLevelPolicy(
      config.routeSafety.maxSlopePermilByLevel,
      factor,
    ),
  };
}

function mapLevelPolicy(
  source: Readonly<Record<LevelCode, number>>,
  factorPermil: number,
): Readonly<Record<LevelCode, number>> {
  return {
    beginner: scalePermil(source.beginner, factorPermil),
    intermediate: scalePermil(source.intermediate, factorPermil),
    advanced: scalePermil(source.advanced, factorPermil),
    professional: scalePermil(source.professional, factorPermil),
    master: scalePermil(source.master, factorPermil),
  };
}

function scalePermil(value: number, factorPermil: number): number {
  return roundDiv(value * factorPermil, 1000);
}

function createMilestones(
  distanceMeters: number,
  plan: ReturnType<typeof planMilestones>,
  config: GameConfig,
): readonly RouteMilestoneInput[] {
  return Array.from({ length: plan.milestoneCount }, (_unused, index) => {
    const ordinal = index + 1;
    return {
      id: createId("ms"),
      ordinal,
      distanceMeters: Math.round((distanceMeters * ordinal) / plan.milestoneCount),
      radiusMeters: config.rules.milestoneRadiusMeters,
      exp: plan.expPerMilestone,
    };
  });
}

function toSelectableRoute(candidate: EnrichedCandidate): SelectableRoute {
  const route = candidate.route.route;
  if (!route) throw new RangeError("A selectable route must have geometry.");
  return {
    id: candidate.route.id,
    distanceMeters: Math.round(route.distanceMeters),
    scorePermil: candidate.scorePermil,
    safetyScore: candidate.safetyScorePermil / 1000,
    dataConfidence: candidate.dataConfidencePermil / 1000,
    elevationGainMeters: candidate.elevation.gainMeters,
    maxGradePercent: candidate.elevation.maxGradePercent,
    surfaces: candidate.tags.surfaces,
    areaHints: candidate.tags.areaHints,
  };
}

function levelName(code: LevelCode): RunnerLevel {
  const names: Readonly<Record<LevelCode, RunnerLevel>> = {
    beginner: "Beginner",
    intermediate: "Intermediate",
    advanced: "Advanced",
    professional: "Professional",
    master: "Master",
  };
  return names[code];
}

function localNighttime(timestamp: Date, timezone: string): boolean {
  try {
    const hour = Number(
      new Intl.DateTimeFormat("en", {
        timeZone: timezone,
        hour: "2-digit",
        hourCycle: "h23",
      }).format(timestamp),
    );
    return hour >= 20 || hour < 6;
  } catch {
    return false;
  }
}

function buildWarning(
  locale: Locale,
  dataConfidencePermil: number,
  temperatureC?: number,
  isNight = false,
  lighting: "yes" | "no" | "unknown" = "unknown",
): string | null {
  const warnings: string[] = [];
  if (temperatureC !== undefined && temperatureC >= 34) {
    warnings.push(
      locale === "en"
        ? "The temperature hint is high; consider postponing your run."
        : "Petunjuk suhu tinggi; pertimbangkan untuk menunda lari.",
    );
  }
  if (dataConfidencePermil < 1000) {
    warnings.push(
      locale === "en"
        ? "Street or elevation data is incomplete; choose a familiar path."
        : "Data jalan atau elevasi terbatas; pilih jalur yang sudah dikenal.",
    );
  }
  if (isNight && lighting !== "yes") {
    warnings.push(
      locale === "en"
        ? "Street lighting could not be confirmed for this route."
        : "Penerangan jalan belum dapat dipastikan untuk rute ini.",
    );
  }
  return warnings.length ? warnings.join(" ") : null;
}

function emptyCandidate(route: LoopCandidate): EnrichedCandidate {
  return {
    route,
    elevation: demoElevation(false),
    tags: demoOsmTags(false),
    dataConfidencePermil: 0,
    safetyScorePermil: 0,
    scorePermil: 0,
    rejectionReasons: route.failureReason ? [route.failureReason] : ["invalid_route"],
  };
}

function demoElevation(available = true): ElevationProfile {
  return {
    available,
    samples: [],
    gainMeters: 0,
    lossMeters: 0,
    maxGradePercent: 0,
  };
}

function demoOsmTags(available = true): OsmRouteTags {
  return {
    available,
    dataConfidence: available ? 1 : 0,
    wayCount: available ? 5 : 0,
    roadTypes: available ? ["residential"] : [],
    surfaces: available ? ["paved"] : [],
    sidewalkCoverage: available ? "yes" : "unknown",
    lightingCoverage: available ? "yes" : "unknown",
    areaHints: [],
    hasConstruction: false,
    hasSteps: false,
    hasFerry: false,
    hasFord: false,
    hasPrimaryRoad: false,
    hasUnpavedSurface: false,
  };
}

function tagsFromRouteDetails(details: RouteRoadDetails): OsmRouteTags {
  const roadTypes = details.roadClasses.map((value) => value.toLowerCase());
  const environments = details.roadEnvironments.map((value) => value.toLowerCase());
  const surfaces = details.surfaces.map((value) => value.toLowerCase());
  return {
    available: roadTypes.length > 0 || environments.length > 0,
    dataConfidence: details.coveragePermil / 1000,
    wayCount: roadTypes.length,
    roadTypes,
    surfaces,
    sidewalkCoverage: "unknown",
    lightingCoverage: "unknown",
    areaHints: [],
    hasConstruction: roadTypes.includes("construction"),
    hasSteps: roadTypes.includes("steps"),
    hasFerry: environments.includes("ferry"),
    hasFord: false,
    hasPrimaryRoad: roadTypes.some((road) =>
      ["primary", "secondary", "tertiary", "trunk", "motorway"].includes(road),
    ),
    hasUnpavedSurface:
      roadTypes.includes("track") ||
      surfaces.some((surface) =>
        ["unpaved", "gravel", "dirt", "ground", "sand", "mud", "grass"].includes(surface),
      ),
  };
}

function mergeRouteTags(routing: OsmRouteTags, osm: OsmRouteTags): OsmRouteTags {
  const coverage = (
    primary: OsmRouteTags["sidewalkCoverage"],
    fallback: OsmRouteTags["sidewalkCoverage"],
  ) => (primary === "unknown" ? fallback : primary);
  return {
    available: routing.available || osm.available,
    dataConfidence: Math.max(routing.dataConfidence, osm.dataConfidence),
    wayCount: Math.max(routing.wayCount, osm.wayCount),
    roadTypes: [...new Set([...routing.roadTypes, ...osm.roadTypes])],
    surfaces: [...new Set([...routing.surfaces, ...osm.surfaces])],
    sidewalkCoverage: coverage(osm.sidewalkCoverage, routing.sidewalkCoverage),
    lightingCoverage: coverage(osm.lightingCoverage, routing.lightingCoverage),
    areaHints: [...new Set([...routing.areaHints, ...osm.areaHints])],
    hasConstruction: routing.hasConstruction || osm.hasConstruction,
    hasSteps: routing.hasSteps || osm.hasSteps,
    hasFerry: routing.hasFerry || osm.hasFerry,
    hasFord: routing.hasFord || osm.hasFord,
    hasPrimaryRoad: routing.hasPrimaryRoad || osm.hasPrimaryRoad,
    hasUnpavedSurface: routing.hasUnpavedSurface || osm.hasUnpavedSurface,
  };
}

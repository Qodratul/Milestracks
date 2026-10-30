import type { RoutePoint } from "../../types/routes";

export type { RoutePoint };

export interface RouteInstruction {
  readonly text: string;
  readonly distanceMeters: number;
  readonly sign?: number;
}

export interface RouteRoadDetails {
  readonly roadClasses: readonly string[];
  readonly roadEnvironments: readonly string[];
  readonly surfaces: readonly string[];
  readonly coveragePermil: number;
}

export interface RouteResult {
  readonly distanceMeters: number;
  readonly timeMs: number;
  readonly geometry: readonly RoutePoint[];
  readonly snappedWaypoints: readonly RoutePoint[];
  readonly instructions: readonly RouteInstruction[];
  readonly roadDetails?: RouteRoadDetails;
  readonly providerLatencyMs: number;
}

export interface LoopRouteRequest {
  readonly start: RoutePoint;
  readonly targetDistanceMeters: number;
  readonly seed: number;
}

export interface RoutingProvider {
  route(waypoints: readonly RoutePoint[]): Promise<RouteResult>;
  routeLoop(request: LoopRouteRequest): Promise<RouteResult>;
}

export type RoutingErrorCode =
  "NOT_CONFIGURED" | "REQUEST_FAILED" | "INVALID_RESPONSE" | "TIMEOUT";

export class RoutingProviderError extends Error {
  public constructor(
    public readonly code: RoutingErrorCode,
    public readonly statusCode?: number,
    public readonly providerLatencyMs?: number,
    public readonly rateLimitInfo?: Readonly<Record<string, string>>,
  ) {
    super("Routing provider request failed: " + code);
    this.name = "RoutingProviderError";
  }
}

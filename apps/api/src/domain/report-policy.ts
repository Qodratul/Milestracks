import type { TemplateStatus } from "@prisma/client";

export interface RouteReportPolicyInput {
  readonly currentStatus: TemplateStatus;
  readonly uniqueSafetyConcernReporters: number;
}

export function statusAfterRouteReport(input: RouteReportPolicyInput): TemplateStatus {
  if (input.currentStatus === "suspended") return "suspended";
  if (input.uniqueSafetyConcernReporters >= 3) return "suspended";
  return "flagged";
}

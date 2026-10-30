import { Prisma } from "@prisma/client";
import { statusAfterRouteReport } from "../domain/report-policy";
import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { idMessages } from "../i18n";
import { now } from "../lib/clock";
import { createId } from "../lib/ids";
import { withTransaction } from "../lib/prisma";
import {
  countSafetyReporters,
  createRouteReport,
  findRouteReportTarget,
} from "../repositories/route.repository";
import { setTemplateStatus } from "../repositories/route-template.repository";

export const routeReportService = {
  async report(
    routeId: string,
    userId: string,
    input: {
      readonly reason: "safety_concern" | "incorrect_map" | "inaccessible" | "other";
      readonly details?: string | undefined;
    },
  ) {
    const timestamp = now();
    try {
      return await withTransaction(async (tx) => {
        const alreadyReported =
          (await tx.routeReport.count({ where: { routeId, userId } })) > 0;
        if (alreadyReported) throw alreadyReportedError();
        const target = await findRouteReportTarget(tx, routeId, userId, timestamp);
        if (!target || target.templateStatus === "suspended") throw notFound();
        const reportId = createId("rpt");
        await createRouteReport(tx, {
          id: reportId,
          routeId,
          templateId: target.templateId,
          userId,
          reason: input.reason,
          ...(input.details === undefined ? {} : { details: input.details }),
          timestamp,
        });
        const safetyReporters = await countSafetyReporters(tx, target.templateId);
        const templateStatus = statusAfterRouteReport({
          currentStatus: target.templateStatus,
          uniqueSafetyConcernReporters: safetyReporters,
        });
        await setTemplateStatus(tx, target.templateId, templateStatus);
        if (target.status === "ready") {
          await tx.route.updateMany({
            where: { id: routeId, userId, status: "ready" },
            data: { status: "expired", updatedAt: timestamp },
          });
        }
        return {
          reportId,
          status: "received" as const,
          createdAt: timestamp.toISOString(),
        };
      });
    } catch (error) {
      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        error.code === "P2002"
      ) {
        throw alreadyReportedError();
      }
      throw error;
    }
  },
};

function alreadyReportedError(): AppError {
  return new AppError(
    409,
    ERROR_CODES.ALREADY_REPORTED,
    idMessages.errors.alreadyReported,
  );
}

function notFound(): AppError {
  return new AppError(404, ERROR_CODES.NOT_FOUND, idMessages.errors.notFound);
}

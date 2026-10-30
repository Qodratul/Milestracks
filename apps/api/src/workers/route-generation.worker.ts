import { routeGenerationService } from "../services/route-generation.service";

export async function generateRoute(routeId: string): Promise<void> {
  try {
    await routeGenerationService.generate(routeId);
  } catch {
    await routeGenerationService.fail(routeId);
  }
}

export function recoverRouteGenerationJobs(): Promise<number> {
  return routeGenerationService.recoverPendingJobs();
}

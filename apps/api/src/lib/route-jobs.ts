import { env } from "../config/env";
import { InProcessJobQueue } from "./jobs";

export const routeJobs = new InProcessJobQueue(env.ROUTE_GENERATION_CONCURRENCY);

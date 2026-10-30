import { env } from "./env";

const routingProvider =
  env.DEMO_MODE || env.ROUTING_PROVIDER === "mock" ? "mock" : "graphhopper";

/** Keep cached route templates isolated when the geometry provider changes. */
export const ROUTE_ALGORITHM_VERSION = `mystery-v2-${routingProvider}`;

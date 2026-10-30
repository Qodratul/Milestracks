import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import type {
  LLMProvider,
  RoutePromptInput,
  SafetyDiagnosticInput,
} from "../src/providers/llm";

const CITY_STARTS = [
  { name: "jakarta", lat: -6.2, lng: 106.8167 },
  { name: "bandung", lat: -6.9175, lng: 107.6191 },
  { name: "denpasar", lat: -8.65, lng: 115.2167 },
] as const;

async function main(): Promise<void> {
  if (process.env.NODE_ENV === "production") {
    throw new Error("Route demo seeding is disabled in production.");
  }
  process.env.DEMO_MODE = "true";
  const [
    { GameConfigSchema },
    { RouteCandidateService },
    { withTransaction, closePrisma },
    llm,
  ] = await Promise.all([
    import("../src/config/game-config.schema.js"),
    import("../src/services/route-candidate.service.js"),
    import("../src/lib/prisma.js"),
    import("../src/providers/llm/index.js"),
  ]);
  const config = GameConfigSchema.parse(
    JSON.parse(
      readFileSync(resolve(__dirname, "../prisma/game-config.v2.json"), "utf8"),
    ) as unknown,
  );
  const deterministicLlm: LLMProvider = {
    async generateTrackNarrative(input: RoutePromptInput) {
      return llm.buildDeterministicTrackFallback(input);
    },
    async evaluateRunnerSafety(input: SafetyDiagnosticInput) {
      return llm.buildDeterministicSafetyFallback(input);
    },
  };
  const candidates = new RouteCandidateService({
    demoMode: true,
    llm: deterministicLlm,
  });
  let created = 0;
  let skipped = 0;
  try {
    for (const city of CITY_STARTS) {
      for (const level of config.levels) {
        const targetDistanceMeters = Math.round(
          (level.distanceMinMeters + level.distanceMaxMeters) / 2,
        );
        const built = await candidates.build({
          userId: "route-library-seed",
          levelCode: level.code,
          targetDistanceMeters,
          location: { lat: city.lat, lng: city.lng },
          locale: "id",
          timezone: "Asia/Jakarta",
          config,
        });
        if (!built) {
          skipped += 1;
          continue;
        }
        const persisted = await withTransaction((tx) => candidates.persist(tx, built));
        if (persisted) created += 1;
        else skipped += 1;
      }
    }
  } finally {
    await closePrisma();
  }
  process.stdout.write(
    "Demo route library complete: " + created + " created, " + skipped + " skipped.\n",
  );
}

if (require.main === module) {
  void main().catch((error: unknown) => {
    process.stderr.write(
      "Demo route library seed failed: " +
        (error instanceof Error ? error.message : "unknown error") +
        "\n",
    );
    process.exitCode = 1;
  });
}

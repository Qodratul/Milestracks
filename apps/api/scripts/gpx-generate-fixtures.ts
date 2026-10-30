import { mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";
import { generateSyntheticTrack, type GpxScenario } from "../src/lib/gpx-generator";
import { parseGpx, serializeGpx } from "../src/lib/gpx";

const START_TIME_MS = Date.parse("2026-10-27T00:00:00.000Z");
const FIXTURE_DIRECTORY = resolve("tests/fixtures/gpx/runs");
const FIXTURES: readonly {
  readonly file: string;
  readonly scenario: GpxScenario;
  readonly seed: number;
}[] = [
  { file: "valid-steady.gpx", scenario: "steady", seed: 101 },
  { file: "valid-variable-pace.gpx", scenario: "variable-pace", seed: 102 },
  { file: "valid-pause.gpx", scenario: "pause", seed: 103 },
  { file: "valid-signal-loss.gpx", scenario: "signal-loss", seed: 104 },
  { file: "cheat-vehicle.gpx", scenario: "vehicle", seed: 201 },
  { file: "cheat-teleport.gpx", scenario: "teleport", seed: 202 },
  { file: "cheat-shortcut.gpx", scenario: "shortcut", seed: 203 },
  { file: "cheat-too-smooth.gpx", scenario: "too-smooth", seed: 204 },
  { file: "cheat-duplicate.gpx", scenario: "duplicate", seed: 205 },
  { file: "cheat-replay.gpx", scenario: "replay", seed: 206 },
  { file: "cheat-mocked.gpx", scenario: "mocked", seed: 207 },
  { file: "cheat-clock-skew.gpx", scenario: "clock-skew", seed: 208 },
];

function main(): void {
  const route = parseGpx(
    readFileSync(resolve("tests/fixtures/gpx/routes/senayan-loop.gpx"), "utf8"),
  );
  mkdirSync(FIXTURE_DIRECTORY, { recursive: true });
  const output = FIXTURES.map((fixture) => {
    const track = generateSyntheticTrack(route, {
      scenario: fixture.scenario,
      seed: fixture.seed,
      startedAtMs: START_TIME_MS,
    });
    writeFileSync(resolve(FIXTURE_DIRECTORY, fixture.file), serializeGpx(track), "utf8");
    return {
      file: fixture.file,
      scenario: fixture.scenario,
      samples: track.points.length,
    };
  });
  process.stdout.write(JSON.stringify(output, null, 2) + "\n");
}

if (require.main === module) {
  try {
    main();
  } catch (error) {
    process.stderr.write(
      "GPX fixture generation failed: " +
        (error instanceof Error ? error.message : "unknown error") +
        "\n",
    );
    process.exitCode = 1;
  }
}

import { mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import {
  generateSyntheticTrack,
  GPX_SCENARIOS,
  type GpxScenario,
} from "../src/lib/gpx-generator";
import { parseGpx, serializeGpx } from "../src/lib/gpx";

interface Arguments {
  readonly route: string;
  readonly out: string;
  readonly scenario: GpxScenario;
  readonly seed: number;
  readonly startedAtMs: number;
  readonly paceSecPerKm?: number;
  readonly paceVariationPermil?: number;
  readonly noiseMinMeters?: number;
  readonly noiseMaxMeters?: number;
  readonly accuracyMinMeters?: number;
  readonly accuracyMaxMeters?: number;
  readonly signalLossPermil?: number;
  readonly pauseDurationSec?: number;
}

function main(): void {
  const raw = parseArguments(process.argv.slice(2));
  if (raw.help) {
    process.stdout.write(helpText());
    return;
  }
  const options = toArguments(raw.values);
  const route = parseGpx(readFileSync(resolve(options.route), "utf8"));
  const track = generateSyntheticTrack(route, {
    scenario: options.scenario,
    seed: options.seed,
    startedAtMs: options.startedAtMs,
    ...(options.paceSecPerKm === undefined ? {} : { paceSecPerKm: options.paceSecPerKm }),
    ...(options.paceVariationPermil === undefined
      ? {}
      : { paceVariationPermil: options.paceVariationPermil }),
    ...(options.noiseMinMeters === undefined
      ? {}
      : { noiseMinMeters: options.noiseMinMeters }),
    ...(options.noiseMaxMeters === undefined
      ? {}
      : { noiseMaxMeters: options.noiseMaxMeters }),
    ...(options.accuracyMinMeters === undefined
      ? {}
      : { accuracyMinMeters: options.accuracyMinMeters }),
    ...(options.accuracyMaxMeters === undefined
      ? {}
      : { accuracyMaxMeters: options.accuracyMaxMeters }),
    ...(options.signalLossPermil === undefined
      ? {}
      : { signalLossPermil: options.signalLossPermil }),
    ...(options.pauseDurationSec === undefined
      ? {}
      : { pauseDurationSec: options.pauseDurationSec }),
  });
  const outputPath = resolve(options.out);
  mkdirSync(dirname(outputPath), { recursive: true });
  writeFileSync(outputPath, serializeGpx(track), "utf8");
  process.stdout.write(
    JSON.stringify({
      output: outputPath,
      name: track.name,
      scenario: options.scenario,
      seed: options.seed,
      samples: track.points.length,
      firstTime: iso(track.points[0]?.timestampMs ?? null),
      lastTime: iso(track.points.at(-1)?.timestampMs ?? null),
    }) + "\n",
  );
}

function parseArguments(argv: readonly string[]): {
  readonly help: boolean;
  readonly values: ReadonlyMap<string, string>;
} {
  const values = new Map<string, string>();
  let help = false;
  for (let index = 0; index < argv.length; index += 1) {
    const key = argv[index]!;
    if (key === "--help" || key === "-h") {
      help = true;
      continue;
    }
    if (!key.startsWith("--")) throw new TypeError("Unexpected argument: " + key);
    const value = argv[index + 1];
    if (!value || value.startsWith("--")) throw new TypeError("Missing value for " + key);
    if (values.has(key)) throw new TypeError("Option provided more than once: " + key);
    values.set(key, value);
    index += 1;
  }
  return { help, values };
}

function toArguments(values: ReadonlyMap<string, string>): Arguments {
  const allowed = new Set([
    "--route",
    "--out",
    "--scenario",
    "--seed",
    "--start-time",
    "--pace-sec-per-km",
    "--pace-variation-permil",
    "--noise-min-m",
    "--noise-max-m",
    "--accuracy-min-m",
    "--accuracy-max-m",
    "--signal-loss-permil",
    "--pause-seconds",
  ]);
  for (const key of values.keys()) {
    if (!allowed.has(key)) throw new TypeError("Unknown option: " + key);
  }
  const route = values.get("--route");
  if (!route) throw new TypeError("--route is required.");
  const scenarioValue = values.get("--scenario") ?? "steady";
  if (!GPX_SCENARIOS.includes(scenarioValue as GpxScenario)) {
    throw new TypeError("Unsupported scenario: " + scenarioValue);
  }
  const seed = numberOption(values, "--seed", 1);
  if (!Number.isInteger(seed)) throw new TypeError("--seed must be an integer.");
  const start = values.get("--start-time");
  const startedAtMs = start === undefined ? Date.now() : Date.parse(start);
  if (!Number.isFinite(startedAtMs))
    throw new TypeError("--start-time must be ISO-8601.");
  const scenario = scenarioValue as GpxScenario;
  const defaultOut = "run-" + scenario + "-" + seed + ".gpx";
  return {
    route,
    out: values.get("--out") ?? defaultOut,
    scenario,
    seed,
    startedAtMs,
    ...optionalNumber(values, "--pace-sec-per-km", "paceSecPerKm"),
    ...optionalNumber(values, "--pace-variation-permil", "paceVariationPermil"),
    ...optionalNumber(values, "--noise-min-m", "noiseMinMeters"),
    ...optionalNumber(values, "--noise-max-m", "noiseMaxMeters"),
    ...optionalNumber(values, "--accuracy-min-m", "accuracyMinMeters"),
    ...optionalNumber(values, "--accuracy-max-m", "accuracyMaxMeters"),
    ...optionalNumber(values, "--signal-loss-permil", "signalLossPermil"),
    ...optionalNumber(values, "--pause-seconds", "pauseDurationSec"),
  };
}

function numberOption(
  values: ReadonlyMap<string, string>,
  key: string,
  fallback: number,
): number {
  const value = values.get(key);
  if (value === undefined) return fallback;
  const parsed = Number(value);
  if (!Number.isFinite(parsed)) throw new TypeError(key + " must be numeric.");
  return parsed;
}

function optionalNumber(
  values: ReadonlyMap<string, string>,
  key: string,
  property:
    | "paceSecPerKm"
    | "paceVariationPermil"
    | "noiseMinMeters"
    | "noiseMaxMeters"
    | "accuracyMinMeters"
    | "accuracyMaxMeters"
    | "signalLossPermil"
    | "pauseDurationSec",
): Partial<Arguments> {
  const value = values.get(key);
  if (value === undefined) return {};
  const parsed = Number(value);
  if (!Number.isFinite(parsed)) throw new TypeError(key + " must be numeric.");
  return { [property]: parsed };
}

function iso(timestamp: number | null): string | null {
  return timestamp === null ? null : new Date(timestamp).toISOString();
}

function helpText(): string {
  return [
    "Generate a deterministic synthetic GPX track from a route GPX file.",
    "",
    "Usage: pnpm gpx:generate -- --route <route.gpx> [options]",
    "Options: --out <file> --scenario <" + GPX_SCENARIOS.join("|") + ">",
    "         --seed <integer> --start-time <ISO-8601> --pace-sec-per-km <number>",
    "         --pace-variation-permil <0..1000> --noise-min-m <number> --noise-max-m <number>",
    "         --accuracy-min-m <number> --accuracy-max-m <number>",
    "         --signal-loss-permil <0..1000> --pause-seconds <integer>",
    "",
  ].join("\n");
}

if (require.main === module) {
  try {
    main();
  } catch (error) {
    process.stderr.write(
      "GPX generation failed: " +
        (error instanceof Error ? error.message : "unknown error") +
        "\n",
    );
    process.exitCode = 1;
  }
}

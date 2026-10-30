import "dotenv/config";
import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import { parseGpx } from "../src/lib/gpx";
import { replayGpx } from "../src/lib/gpx-replay";

async function main(): Promise<void> {
  const args = parseArguments(process.argv.slice(2));
  if (args.help) {
    process.stdout.write(helpText());
    return;
  }
  const token = args.token ?? process.env.MILESTRIDE_ACCESS_TOKEN;
  if (!token) {
    throw new TypeError("Pass --token or set MILESTRIDE_ACCESS_TOKEN.");
  }
  const track = parseGpx(readFileSync(resolve(args.file), "utf8"));
  const startedAtMs =
    args.startTime === undefined ? undefined : Date.parse(args.startTime);
  if (startedAtMs !== undefined && !Number.isFinite(startedAtMs)) {
    throw new TypeError("--start-time must be ISO-8601.");
  }
  const summary = await replayGpx(track, {
    baseUrl:
      args.baseUrl ?? process.env.MILESTRIDE_API_URL ?? "http://127.0.0.1:3000/api/v1",
    accessToken: token,
    routeId: args.routeId ?? "route_456",
    speedMultiplier: args.speed ?? 0,
    ...(args.pauseAtSequence === undefined
      ? {}
      : { pauseAtSequence: args.pauseAtSequence }),
    ...(startedAtMs === undefined ? {} : { startTimeMs: startedAtMs }),
    ...(args.sampleIntervalMs === undefined
      ? {}
      : { sampleIntervalMs: args.sampleIntervalMs }),
  });
  process.stdout.write(JSON.stringify(summary, null, 2) + "\n");
}

interface CliArguments {
  readonly file: string;
  readonly baseUrl?: string;
  readonly token?: string;
  readonly routeId?: string;
  readonly speed?: number;
  readonly pauseAtSequence?: number;
  readonly startTime?: string;
  readonly sampleIntervalMs?: number;
  readonly help: boolean;
}

function parseArguments(argv: readonly string[]): CliArguments {
  const allowed = new Set([
    "--file",
    "--base-url",
    "--token",
    "--route-id",
    "--speed",
    "--pause-at-sequence",
    "--start-time",
    "--sample-interval-ms",
  ]);
  const values = new Map<string, string>();
  let help = false;
  for (let index = 0; index < argv.length; index += 1) {
    const key = argv[index]!;
    if (key === "--help" || key === "-h") {
      help = true;
      continue;
    }
    if (!allowed.has(key)) throw new TypeError("Unknown option: " + key);
    const value = argv[index + 1];
    if (!value || value.startsWith("--")) throw new TypeError("Missing value for " + key);
    if (values.has(key)) throw new TypeError("Option provided more than once: " + key);
    values.set(key, value);
    index += 1;
  }
  const file = values.get("--file");
  if (!file && !help) throw new TypeError("--file is required.");
  return {
    file: file ?? "",
    ...(values.has("--base-url") ? { baseUrl: values.get("--base-url")! } : {}),
    ...(values.has("--token") ? { token: values.get("--token")! } : {}),
    ...(values.has("--route-id") ? { routeId: values.get("--route-id")! } : {}),
    ...(values.has("--speed")
      ? { speed: numeric(values.get("--speed")!, "--speed", true) }
      : {}),
    ...(values.has("--pause-at-sequence")
      ? {
          pauseAtSequence: integer(
            values.get("--pause-at-sequence")!,
            "--pause-at-sequence",
          ),
        }
      : {}),
    ...(values.has("--start-time") ? { startTime: values.get("--start-time")! } : {}),
    ...(values.has("--sample-interval-ms")
      ? {
          sampleIntervalMs: integer(
            values.get("--sample-interval-ms")!,
            "--sample-interval-ms",
          ),
        }
      : {}),
    help,
  };
}

function numeric(value: string, option: string, allowZero = false): number {
  const parsed = Number(value);
  if (!Number.isFinite(parsed) || parsed < 0 || (!allowZero && parsed === 0)) {
    throw new TypeError(
      option + " must be a " + (allowZero ? "nonnegative" : "positive") + " number.",
    );
  }
  return parsed;
}

function integer(value: string, option: string): number {
  const parsed = Number(value);
  if (!Number.isInteger(parsed) || parsed <= 0) {
    throw new TypeError(option + " must be a positive integer.");
  }
  return parsed;
}

function helpText(): string {
  return [
    "Replay a GPX file through the run API. The target should use STUB_MODE=true.",
    "",
    "Usage: pnpm gpx:replay -- --file <run.gpx> --token <bearer-token> [options]",
    "Options: --base-url <origin-or-/api/v1> --route-id <route-id>",
    "         --speed <multiplier> (0 sends immediately; 1 follows recorded time)",
    "         --pause-at-sequence <n> --start-time <ISO-8601>",
    "         --sample-interval-ms <n> (fills GPX points without timestamps)",
    "",
    "MILESTRIDE_API_URL and MILESTRIDE_ACCESS_TOKEN can be set in .env.",
    "Recorded timestamps are sent unchanged; speed only controls upload pacing.",
    "",
  ].join("\n");
}

if (require.main === module) {
  void main().catch((error: unknown) => {
    process.stderr.write(
      "GPX replay failed: " +
        (error instanceof Error ? error.message : "unknown error") +
        "\n",
    );
    process.exitCode = 1;
  });
}

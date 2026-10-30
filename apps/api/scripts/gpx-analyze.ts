import { mkdirSync, readFileSync, readdirSync, writeFileSync } from "node:fs";
import { basename, dirname, extname, relative, resolve } from "node:path";
import { analyzeGpx, renderGpxMarkdown } from "../src/lib/gpx-analysis";
import { parseGpx } from "../src/lib/gpx";

function main(): void {
  const args = parseArguments(process.argv.slice(2));
  if (args.help) {
    process.stdout.write(helpText());
    return;
  }
  if (!args.inputDirectory) throw new TypeError("--input-dir is required.");
  const inputDirectory = resolve(args.inputDirectory);
  const files = collectGpxFiles(inputDirectory);
  if (files.length === 0) throw new Error("No .gpx files found in " + inputDirectory);
  const results = files.map((file) => ({
    file: relative(inputDirectory, file).replace(/\\/g, "/"),
    analysis: analyzeGpx(parseGpx(readFileSync(file, "utf8")), {
      ...(args.jumpSpeedMps === undefined
        ? {}
        : { jumpSpeedThresholdMps: args.jumpSpeedMps }),
      ...(args.timeGapSec === undefined ? {} : { timeGapThresholdSec: args.timeGapSec }),
    }),
  }));
  const outPrefix = resolve(args.outPrefix ?? resolve(inputDirectory, "gpx-analysis"));
  mkdirSync(dirname(outPrefix), { recursive: true });
  const jsonPath = outPrefix + ".json";
  const markdownPath = outPrefix + ".md";
  writeFileSync(
    jsonPath,
    JSON.stringify({ sourceFolder: basename(inputDirectory), files: results }, null, 2) +
      "\n",
    "utf8",
  );
  writeFileSync(markdownPath, renderGpxMarkdown(results), "utf8");
  process.stdout.write(
    JSON.stringify({ files: results.length, json: jsonPath, markdown: markdownPath }) +
      "\n",
  );
}

function parseArguments(argv: readonly string[]): {
  readonly help: boolean;
  readonly inputDirectory?: string;
  readonly outPrefix?: string;
  readonly jumpSpeedMps?: number;
  readonly timeGapSec?: number;
} {
  const values = new Map<string, string>();
  let help = false;
  for (let index = 0; index < argv.length; index += 1) {
    const key = argv[index]!;
    if (key === "--help" || key === "-h") {
      help = true;
      continue;
    }
    if (
      !["--input-dir", "--out-prefix", "--jump-speed-mps", "--time-gap-sec"].includes(key)
    ) {
      throw new TypeError("Unknown option: " + key);
    }
    const value = argv[index + 1];
    if (!value || value.startsWith("--")) throw new TypeError("Missing value for " + key);
    if (values.has(key)) throw new TypeError("Option provided more than once: " + key);
    values.set(key, value);
    index += 1;
  }
  return {
    help,
    ...(values.has("--input-dir") ? { inputDirectory: values.get("--input-dir")! } : {}),
    ...(values.has("--out-prefix") ? { outPrefix: values.get("--out-prefix")! } : {}),
    ...(values.has("--jump-speed-mps")
      ? { jumpSpeedMps: numeric(values.get("--jump-speed-mps")!, "--jump-speed-mps") }
      : {}),
    ...(values.has("--time-gap-sec")
      ? { timeGapSec: numeric(values.get("--time-gap-sec")!, "--time-gap-sec") }
      : {}),
  };
}

function numeric(value: string, option: string): number {
  const parsed = Number(value);
  if (!Number.isFinite(parsed) || parsed <= 0) {
    throw new TypeError(option + " must be a positive number.");
  }
  return parsed;
}

function collectGpxFiles(directory: string): string[] {
  return readdirSync(directory, { withFileTypes: true })
    .flatMap((entry) => {
      const path = resolve(directory, entry.name);
      if (entry.isDirectory()) return collectGpxFiles(path);
      if (entry.isFile() && extname(entry.name).toLowerCase() === ".gpx") return [path];
      return [];
    })
    .sort((left, right) => left.localeCompare(right));
}

function helpText(): string {
  return [
    "Analyze all GPX files in a folder recursively.",
    "",
    "Usage: pnpm gpx:analyze -- --input-dir <folder> [options]",
    "Options: --out-prefix <path-without-extension>",
    "         --jump-speed-mps <number> (default 12)",
    "         --time-gap-sec <number> (default 10)",
    "",
  ].join("\n");
}

if (require.main === module) {
  try {
    main();
  } catch (error) {
    process.stderr.write(
      "GPX analysis failed: " +
        (error instanceof Error ? error.message : "unknown error") +
        "\n",
    );
    process.exitCode = 1;
  }
}

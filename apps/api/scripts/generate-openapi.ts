import { writeFileSync } from "node:fs";
import { resolve } from "node:path";
import { format, resolveConfig } from "prettier";
import { openApiDocument } from "../src/openapi/document";

const outputPath = resolve(__dirname, "../openapi.json");

async function generateOpenApi(): Promise<void> {
  const prettierOptions = await resolveConfig(outputPath);
  const formattedDocument = await format(JSON.stringify(openApiDocument), {
    ...(prettierOptions ?? {}),
    parser: "json",
  });
  writeFileSync(outputPath, formattedDocument, "utf8");
  process.stdout.write("Generated " + outputPath + "\n");
}

void generateOpenApi();

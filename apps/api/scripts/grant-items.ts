import { closePrisma } from "../src/lib/prisma";
import { itemService } from "../src/services/item.service";

const USAGE =
  "Usage: pnpm grant:items -- --user-id <user-id> --item-code <item-code> --quantity <count>";

interface GrantArguments {
  readonly userId: string;
  readonly itemCode: string;
  readonly quantity: number;
}

async function main(): Promise<void> {
  try {
    const args = parseArguments(process.argv.slice(2));
    if (!args) {
      process.stdout.write(USAGE + "\n");
      return;
    }

    const result = await itemService.grantForDemo(
      args.userId,
      args.itemCode,
      args.quantity,
    );
    process.stdout.write(
      "Granted " +
        result.grantedCount +
        " " +
        result.itemCode +
        " to " +
        args.userId +
        "; stock=" +
        result.ownedCount +
        "/" +
        result.maxStock +
        "\n",
    );
  } catch (error) {
    const message =
      error instanceof RangeError
        ? error.message
        : "Grant failed. Check the user ID, item code, and database connection.";
    process.stderr.write(message + "\n");
    process.exitCode = 1;
  } finally {
    await closePrisma();
  }
}

function parseArguments(args: readonly string[]): GrantArguments | null {
  if (args.includes("--help") || args.includes("-h")) return null;

  const values = new Map<string, string>();
  for (let index = 0; index < args.length; index += 1) {
    const key = args[index];
    const value = args[index + 1];
    if (!key?.startsWith("--") || !value || value.startsWith("--")) {
      throw new RangeError(USAGE);
    }
    values.set(key, value);
    index += 1;
  }

  const userId = values.get("--user-id");
  const itemCode = values.get("--item-code");
  const quantity = Number(values.get("--quantity"));
  if (
    !userId ||
    userId.length > 64 ||
    !itemCode ||
    !Number.isSafeInteger(quantity) ||
    quantity < 1
  ) {
    throw new RangeError(USAGE);
  }
  return { userId, itemCode, quantity };
}

void main();

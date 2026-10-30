import { ulid } from "ulid";

export type IdPrefix =
  "usr" | "route" | "run" | "claim" | "rpt" | "evt" | "req" | "ms" | "rt" | "fam";
export function createId(prefix: IdPrefix): string {
  return prefix + "_" + ulid().toLowerCase();
}

import { assertNonNegativeInteger } from "./math";

export function calculateRunRp(basis: number): number {
  assertNonNegativeInteger(basis, "basis");
  return basis;
}

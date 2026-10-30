export function assertSafeInteger(value: number, name: string): void {
  if (!Number.isSafeInteger(value)) {
    throw new RangeError(name + " must be a safe integer.");
  }
}

export function assertNonNegativeInteger(value: number, name: string): void {
  assertSafeInteger(value, name);
  if (value < 0) throw new RangeError(name + " must be non-negative.");
}

export function assertPositiveInteger(value: number, name: string): void {
  assertSafeInteger(value, name);
  if (value <= 0) throw new RangeError(name + " must be positive.");
}

export function addSafeIntegers(left: number, right: number, name: string): number {
  assertSafeInteger(left, name);
  assertSafeInteger(right, name);
  const result = left + right;
  assertSafeInteger(result, name);
  return result;
}

export function multiplySafeIntegers(left: number, right: number, name: string): number {
  assertNonNegativeInteger(left, name);
  assertNonNegativeInteger(right, name);
  const result = left * right;
  assertSafeInteger(result, name);
  return result;
}

export function sumSafeIntegers(values: readonly number[], name: string): number {
  return values.reduce((total, value) => addSafeIntegers(total, value, name), 0);
}

export function floorDiv(numerator: number, denominator: number): number {
  assertNonNegativeInteger(numerator, "numerator");
  assertPositiveInteger(denominator, "denominator");
  return Math.floor(numerator / denominator);
}

export function roundDiv(numerator: number, denominator: number): number {
  assertNonNegativeInteger(numerator, "numerator");
  assertPositiveInteger(denominator, "denominator");
  const quotient = Math.floor(numerator / denominator);
  const remainder = numerator % denominator;
  return quotient + (remainder >= Math.ceil(denominator / 2) ? 1 : 0);
}

export function clampInteger(value: number, minimum: number, maximum: number): number {
  assertSafeInteger(value, "value");
  assertSafeInteger(minimum, "minimum");
  assertSafeInteger(maximum, "maximum");
  if (minimum > maximum) throw new RangeError("minimum must not exceed maximum.");
  return Math.min(maximum, Math.max(minimum, value));
}

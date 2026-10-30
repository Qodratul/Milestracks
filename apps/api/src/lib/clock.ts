export function now(): Date {
  return new Date();
}
export function epochMilliseconds(): number {
  return now().getTime();
}

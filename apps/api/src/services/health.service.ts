import { isDatabaseReady } from "../repositories/health.repository";

export async function checkReadiness(): Promise<boolean> {
  return isDatabaseReady();
}

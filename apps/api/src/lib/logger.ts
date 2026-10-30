import pino from "pino";
import { env } from "../config/env";

export const logger = pino({
  level: env.LOG_LEVEL,
  redact: {
    paths: [
      "req.headers.authorization",
      "req.headers.cookie",
      "req.body.email",
      "req.body.password",
      "req.body.token",
      "req.body.accessToken",
      "req.body.refreshToken",
      "req.body.startLocation",
      "req.body.locations",
      "req.body.samples",
      "*.lat",
      "*.lng",
      "*.latitude",
      "*.longitude",
      "*.email",
      "*.token",
      "*.accessToken",
      "*.refreshToken",
    ],
    censor: "[Redacted]",
  },
});

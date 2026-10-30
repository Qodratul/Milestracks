import express from "express";
import { describe, expect, it } from "vitest";
import request from "supertest";
import { app } from "../../src/app";
import { AppError } from "../../src/errors/app-error";
import { errorMiddleware } from "../../src/middleware/error.middleware";
import { requestIdMiddleware } from "../../src/middleware/request-id.middleware";

describe("health endpoints", () => {
  it("returns a success envelope from /healthz", async () => {
    const response = await request(app).get("/healthz");
    expect(response.status).toBe(200);
    expect(response.body).toMatchObject({
      data: { status: "ok" },
      meta: { requestId: expect.any(String), timestamp: expect.any(String) },
    });
  });

  it("returns a request-id error envelope for unknown routes", async () => {
    const response = await request(app).get("/missing");
    expect(response.status).toBe(404);
    expect(response.body.error).toMatchObject({
      code: "NOT_FOUND",
      requestId: expect.any(String),
    });
  });

  it("returns a request-id error envelope for validation failures", async () => {
    const validationApp = express();
    validationApp.use(requestIdMiddleware);
    validationApp.post("/validate", (_request, _response, next) => {
      next(
        new AppError(400, "VALIDATION_ERROR", "Data yang dikirim tidak valid.", {
          fields: [],
        }),
      );
    });
    validationApp.use(errorMiddleware);

    const response = await request(validationApp).post("/validate");
    expect(response.status).toBe(400);
    expect(response.body.error).toMatchObject({
      code: "VALIDATION_ERROR",
      requestId: expect.any(String),
      details: { fields: [] },
    });
  });
});

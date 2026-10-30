import type { RequestHandler } from "express";
import { createId } from "../lib/ids";

const requestIdPattern = /^[A-Za-z0-9_-]{1,64}$/;
export const requestIdMiddleware: RequestHandler = (request, response, next) => {
  const receivedId = request.get("X-Request-Id");
  const requestId =
    receivedId && requestIdPattern.test(receivedId) ? receivedId : createId("req");
  response.locals.requestId = requestId;
  response.setHeader("X-Request-Id", requestId);
  next();
};

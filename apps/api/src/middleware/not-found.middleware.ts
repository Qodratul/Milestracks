import type { RequestHandler } from "express";
import { AppError } from "../errors/app-error";
import { idMessages } from "../i18n";

export const notFoundMiddleware: RequestHandler = (_request, _response, next) => {
  next(new AppError(404, "NOT_FOUND", idMessages.errors.notFound));
};

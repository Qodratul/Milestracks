import type { RequestHandler } from "express";
import type { z } from "zod";
import { AppError } from "../errors/app-error";
import { ERROR_CODES } from "../errors/codes";
import { decodePageCursor, encodePageCursor } from "../lib/page-cursor";
import { asyncHandler } from "../middleware/async-handler";
import { sendList, sendOk } from "../middleware/response";
import { shopService, shopCoinLedger } from "../services/shop.service";
import type {
  CursorPageQuerySchema,
  ShopPurchaseBodySchema,
} from "../validators/api.validator";
import { requireUserId } from "./require-user-id";

type PurchaseBody = z.infer<typeof ShopPurchaseBodySchema>;
type PageQuery = z.infer<typeof CursorPageQuerySchema>;

export const shopController = {
  catalog: asyncHandler(async (request, response) => {
    const items = await shopService.catalog(requireUserId(request));
    sendList(response, items, { nextCursor: null, limit: items.length });
  }) as RequestHandler,

  purchase: asyncHandler(async (request, response) => {
    const key = request.get("Idempotency-Key");
    if (!key)
      throw new AppError(
        400,
        ERROR_CODES.IDEMPOTENCY_KEY_REQUIRED,
        "Header Idempotency-Key wajib diisi.",
      );
    const body = request.body as PurchaseBody;
    sendOk(
      response,
      await shopService.purchase(requireUserId(request), body.itemId, key),
    );
  }) as RequestHandler,

  ledger: asyncHandler(async (request, response) => {
    const query = request.query as unknown as PageQuery;
    const limit = Number(query.limit ?? 20);
    const cursor = decodePageCursor(query.cursor);
    const rows = await shopCoinLedger(requireUserId(request), cursor, limit);
    const hasMore = rows.length > limit;
    const pageRows = rows.slice(0, limit);
    const nextCursor =
      hasMore && pageRows.length > 0
        ? encodePageCursor(
            pageRows[pageRows.length - 1]!.createdAt,
            pageRows[pageRows.length - 1]!.id,
          )
        : null;
    sendList(
      response,
      pageRows.map((entry) => ({
        id: entry.id,
        currency: "coin",
        amount: entry.delta,
        reason: entry.reason,
        refId: entry.refId,
        createdAt: entry.createdAt.toISOString(),
      })),
      { nextCursor, limit },
    );
  }) as RequestHandler,
};

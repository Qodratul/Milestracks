import type { RequestHandler } from "express";
import type { EndpointContract } from "../contracts/endpoint.contracts";
import { asyncHandler } from "../middleware/async-handler";
import { sendList, sendOk, sendPage } from "../middleware/response";

export function createStubController(contract: EndpointContract): RequestHandler {
  return asyncHandler(async (request, response) => {
    if (
      contract.operationId === "getRouteGeometry" &&
      request.query.detail !== "preview"
    ) {
      const fixture = contract.responseData as {
        routeId: string;
        encoding: "polyline";
        precision: number;
      };
      const requestedLimit = Number(request.query.limit);
      sendPage(
        response,
        {
          routeId: fixture.routeId,
          revealed: true,
          encoding: fixture.encoding,
          precision: fixture.precision,
          segments: [{ ordinal: 0, coordinates: "_p~iF~ps|U_ulLnnqC" }],
        },
        {
          nextCursor: null,
          limit: Number.isInteger(requestedLimit) ? requestedLimit : 500,
        },
      );
      return;
    }
    if (contract.responseMode === "list") {
      if (!Array.isArray(contract.responseData)) {
        throw new Error("List stub must contain an array.");
      }
      sendList(response, contract.responseData, { nextCursor: null, limit: 20 });
      return;
    }
    sendOk(response, contract.responseData, contract.statusCode);
  });
}

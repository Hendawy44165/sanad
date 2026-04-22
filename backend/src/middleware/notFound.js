import { sendError } from "../utils/apiResponse.js";

export function notFoundHandler(req, res) {
  return sendError(
    res,
    {
      code: "NOT_FOUND",
      message: `Route not found: ${req.method} ${req.originalUrl}`,
      request_id: req.requestId,
    },
    404,
  );
}

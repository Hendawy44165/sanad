import multer from "multer";

import { AppError } from "../utils/appError.js";
import { sendError } from "../utils/apiResponse.js";

export function errorHandler(error, req, res, _next) {
  if (error instanceof multer.MulterError) {
    return sendError(
      res,
      {
        code: "VALIDATION_ERROR",
        message: error.message,
        request_id: req.requestId,
      },
      400,
    );
  }

  if (
    error?.message === "Only JPG, PNG, and WEBP files are allowed" ||
    error?.message === "Only PDF, DOC, and DOCX files are allowed"
  ) {
    return sendError(
      res,
      {
        code: "VALIDATION_ERROR",
        message: error.message,
        request_id: req.requestId,
      },
      400,
    );
  }

  if (error instanceof AppError) {
    return sendError(
      res,
      {
        code: error.code,
        message: error.message,
        details: error.details,
        request_id: req.requestId,
      },
      error.statusCode,
    );
  }

  return sendError(
    res,
    {
      code: "INTERNAL_ERROR",
      message: "An unexpected error occurred",
      request_id: req.requestId,
    },
    500,
  );
}

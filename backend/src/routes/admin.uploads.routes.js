import { Router } from "express";

import { requireAuth, requireRole } from "../middleware/auth.js";
import { uploadImage, buildUploadedFilePayload } from "../middleware/upload.js";
import { asyncHandler } from "../utils/asyncHandler.js";
import { AppError } from "../utils/appError.js";
import { sendSuccess } from "../utils/apiResponse.js";

const adminUploadsRouter = Router();

adminUploadsRouter.use(requireAuth, requireRole("admin"));

adminUploadsRouter.post(
  "/image",
  uploadImage.single("image"),
  asyncHandler(async (req, res) => {
    if (!req.file) {
      throw new AppError("image file is required", 400, "VALIDATION_ERROR", [
        { field: "image", reason: "required" },
      ]);
    }

    const payload = buildUploadedFilePayload(req, req.file);

    return sendSuccess(
      res,
      {
        ...payload,
        image_url: payload.file_url,
        image_url_absolute: payload.file_url_absolute,
      },
      null,
      201,
    );
  }),
);

export { adminUploadsRouter };

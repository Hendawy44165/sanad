import { Router } from "express";

import { requireAuth, requireRole } from "../middleware/auth.js";
import {
  uploadCv,
  uploadImage,
  buildUploadedFilePayload,
} from "../middleware/upload.js";
import { UserCv } from "../models/UserCv.js";
import { UserProfile } from "../models/UserProfile.js";
import { asyncHandler } from "../utils/asyncHandler.js";
import { AppError } from "../utils/appError.js";
import { sendSuccess } from "../utils/apiResponse.js";

const userUploadsRouter = Router();

userUploadsRouter.use(requireAuth, requireRole("user"));

userUploadsRouter.post(
  "/image",
  (req, _res, next) => {
    req.uploadFolder = "users";
    next();
  },
  uploadImage.single("image"),
  asyncHandler(async (req, res) => {
    if (!req.file) {
      throw new AppError("image file is required", 400, "VALIDATION_ERROR", [
        { field: "image", reason: "required" },
      ]);
    }

    const payload = buildUploadedFilePayload(req, req.file);
    const profile = await UserProfile.findOneAndUpdate(
      { supabase_user_id: req.user.id },
      {
        $set: {
          email: req.user.email || "",
          avatar_url: payload.file_url,
          is_active: true,
          last_login_at: new Date(),
        },
        $setOnInsert: {
          full_name: req.user.claims?.user_metadata?.full_name || null,
          role: "user",
          profile_completion: 10,
        },
      },
      { upsert: true, new: true },
    );

    return sendSuccess(
      res,
      {
        ...payload,
        image_url: payload.file_url,
        image_url_absolute: payload.file_url_absolute,
        profile_id: String(profile._id),
        profile_updated: true,
      },
      null,
      201,
    );
  }),
);

userUploadsRouter.post(
  "/cv",
  (req, _res, next) => {
    req.uploadFolder = "users-cv";
    next();
  },
  uploadCv.single("cv"),
  asyncHandler(async (req, res) => {
    if (!req.file) {
      throw new AppError("cv file is required", 400, "VALIDATION_ERROR", [
        { field: "cv", reason: "required" },
      ]);
    }

    const payload = buildUploadedFilePayload(req, req.file);

    const profile = await UserProfile.findOne({
      supabase_user_id: req.user.id,
    });
    const fallbackName =
      profile?.full_name ||
      req.user.claims?.user_metadata?.full_name ||
      req.user.email ||
      "User";

    const cv = await UserCv.findOneAndUpdate(
      { user_id: req.user.id },
      {
        $set: {
          email: req.user.email || profile?.email || null,
          phone: profile?.phone || null,
          cv_file_url: payload.file_url,
        },
        $setOnInsert: {
          user_id: req.user.id,
          full_name: fallbackName,
          skills: [],
          education: [],
          experience: [],
        },
      },
      { upsert: true, new: true },
    );

    return sendSuccess(
      res,
      {
        ...payload,
        cv_file_url: payload.file_url,
        cv_file_url_absolute: payload.file_url_absolute,
        cv_id: String(cv._id),
        cv_updated: true,
      },
      null,
      201,
    );
  }),
);

export { userUploadsRouter };

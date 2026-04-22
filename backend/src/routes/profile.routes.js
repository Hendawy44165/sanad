import { Router } from "express";

import { requireAuth } from "../middleware/auth.js";
import { UserProfile } from "../models/UserProfile.js";
import { asyncHandler } from "../utils/asyncHandler.js";
import { AppError } from "../utils/appError.js";
import { sendSuccess } from "../utils/apiResponse.js";

const profileRouter = Router();

function computeProfileCompletion(profile) {
  const checkpoints = [
    Boolean(profile.full_name),
    Boolean(profile.phone),
    Boolean(profile.disability_type),
    Boolean(profile.language),
  ];
  const completed = checkpoints.filter(Boolean).length;
  return Math.round((completed / checkpoints.length) * 100);
}

profileRouter.post(
  "/sync-profile",
  requireAuth,
  asyncHandler(async (req, res) => {
    const now = new Date();
    const role = req.user.role === "admin" ? "admin" : "user";
    const profile = await UserProfile.findOneAndUpdate(
      { supabase_user_id: req.user.id },
      {
        $set: {
          email: req.user.email || "",
          role,
          last_login_at: now,
        },
        $setOnInsert: {
          full_name: req.user.claims.user_metadata?.full_name || null,
          avatar_url: req.user.claims.user_metadata?.avatar_url || null,
          profile_completion: 10,
        },
      },
      { upsert: true, new: true },
    );

    profile.profile_completion = computeProfileCompletion(profile);
    await profile.save();

    return sendSuccess(res, profile);
  }),
);

profileRouter.get(
  "/me",
  requireAuth,
  asyncHandler(async (req, res) => {
    const profile = await UserProfile.findOne({
      supabase_user_id: req.user.id,
    });
    if (!profile) {
      throw new AppError(
        "Profile not found. Call sync-profile first.",
        404,
        "PROFILE_NOT_FOUND",
      );
    }

    return sendSuccess(res, profile);
  }),
);

profileRouter.patch(
  "/me",
  requireAuth,
  asyncHandler(async (req, res) => {
    const allowedUpdates = [
      "full_name",
      "phone",
      "avatar_url",
      "disability_type",
      "language",
      "notifications_enabled",
    ];
    const updates = {};
    for (const key of allowedUpdates) {
      if (key in req.body) {
        updates[key] = req.body[key];
      }
    }

    const profile = await UserProfile.findOne({
      supabase_user_id: req.user.id,
    });
    if (!profile) {
      throw new AppError(
        "Profile not found. Call sync-profile first.",
        404,
        "PROFILE_NOT_FOUND",
      );
    }

    Object.assign(profile, updates);
    profile.profile_completion = computeProfileCompletion(profile);
    await profile.save();

    return sendSuccess(res, profile);
  }),
);

export { profileRouter };

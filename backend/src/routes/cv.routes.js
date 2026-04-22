import { Router } from "express";

import { requireAuth, requireRole } from "../middleware/auth.js";
import { UserCv } from "../models/UserCv.js";
import { asyncHandler } from "../utils/asyncHandler.js";
import { AppError } from "../utils/appError.js";
import { sendSuccess } from "../utils/apiResponse.js";

const cvRouter = Router();

cvRouter.use(requireAuth, requireRole("user"));

cvRouter.put(
  "/me",
  asyncHandler(async (req, res) => {
    const required = ["full_name"];
    for (const field of required) {
      if (!req.body[field]) {
        throw new AppError(`${field} is required`, 400, "VALIDATION_ERROR", [
          { field, reason: "required" },
        ]);
      }
    }

    const cv = await UserCv.findOneAndUpdate(
      { user_id: req.user.id },
      {
        $set: {
          full_name: req.body.full_name,
          email: req.body.email ?? req.user.email ?? null,
          phone: req.body.phone ?? null,
          city: req.body.city ?? null,
          summary: req.body.summary ?? null,
          skills: Array.isArray(req.body.skills) ? req.body.skills : [],
          education: Array.isArray(req.body.education)
            ? req.body.education
            : [],
          experience: Array.isArray(req.body.experience)
            ? req.body.experience
            : [],
          cv_file_url: req.body.cv_file_url ?? null,
        },
        $setOnInsert: {
          user_id: req.user.id,
        },
      },
      { upsert: true, new: true },
    );

    return sendSuccess(res, cv);
  }),
);

cvRouter.patch(
  "/me",
  asyncHandler(async (req, res) => {
    const cv = await UserCv.findOne({ user_id: req.user.id });
    if (!cv) {
      throw new AppError(
        "CV not found. Use PUT /cv/me first.",
        404,
        "NOT_FOUND",
      );
    }

    const allowed = [
      "full_name",
      "email",
      "phone",
      "city",
      "summary",
      "skills",
      "education",
      "experience",
      "cv_file_url",
    ];
    for (const key of allowed) {
      if (key in req.body) {
        cv[key] = req.body[key];
      }
    }

    await cv.save();
    return sendSuccess(res, cv);
  }),
);

cvRouter.get(
  "/me",
  asyncHandler(async (req, res) => {
    const cv = await UserCv.findOne({ user_id: req.user.id });
    if (!cv) {
      throw new AppError("CV not found", 404, "NOT_FOUND");
    }
    return sendSuccess(res, cv);
  }),
);

export { cvRouter };

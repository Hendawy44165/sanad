import { Router } from "express";
import mongoose from "mongoose";

import { requireAuth } from "../middleware/auth.js";
import { Job } from "../models/Job.js";
import { asyncHandler } from "../utils/asyncHandler.js";
import { AppError } from "../utils/appError.js";
import { sendSuccess } from "../utils/apiResponse.js";
import { buildMeta, getPagination } from "../utils/pagination.js";

const jobsRouter = Router();

jobsRouter.get(
  "/",
  asyncHandler(async (req, res) => {
    const { page, limit, skip } = getPagination(req.query);
    const filters = {
      moderation_status: "approved",
      publication_status: "published",
    };

    if (req.query.accessibility_match) {
      filters.accessibility_match = req.query.accessibility_match;
    }
    if (req.query.source) {
      filters.source = req.query.source;
    }
    if (req.query.is_remote !== undefined) {
      filters.is_remote = req.query.is_remote === "true";
    }
    if (req.query.q) {
      filters.$text = { $search: req.query.q };
    }

    const [items, total] = await Promise.all([
      Job.find(filters)
        .sort({ published_at: -1, created_at: -1 })
        .skip(skip)
        .limit(limit),
      Job.countDocuments(filters),
    ]);

    return sendSuccess(res, items, buildMeta(page, limit, total));
  }),
);

jobsRouter.post(
  "/submissions",
  requireAuth,
  asyncHandler(async (req, res) => {
    const required = ["title", "company", "description"];
    for (const field of required) {
      if (!req.body[field]) {
        throw new AppError(`${field} is required`, 400, "VALIDATION_ERROR", [
          { field, reason: "required" },
        ]);
      }
    }

    const job = await Job.create({
      source: "user",
      title: req.body.title,
      company: req.body.company,
      location: req.body.location || null,
      description: req.body.description,
      employment_type: req.body.employment_type || null,
      is_remote: Boolean(req.body.is_remote),
      salary_min: req.body.salary_min ?? null,
      salary_max: req.body.salary_max ?? null,
      currency: req.body.currency || "EGP",
      accessibility_match: "unknown",
      moderation_status: "pending",
      publication_status: "draft",
      submitted_by: req.user.id,
    });

    return sendSuccess(res, job, null, 201);
  }),
);

jobsRouter.get(
  "/submissions/me",
  requireAuth,
  asyncHandler(async (req, res) => {
    const { page, limit, skip } = getPagination(req.query);
    const filters = { submitted_by: req.user.id };

    const [items, total] = await Promise.all([
      Job.find(filters).sort({ created_at: -1 }).skip(skip).limit(limit),
      Job.countDocuments(filters),
    ]);

    return sendSuccess(res, items, buildMeta(page, limit, total));
  }),
);

jobsRouter.get(
  "/:id",
  asyncHandler(async (req, res) => {
    if (!mongoose.isValidObjectId(req.params.id)) {
      throw new AppError("Invalid job id", 400, "VALIDATION_ERROR");
    }

    const job = await Job.findById(req.params.id);
    if (!job) {
      throw new AppError("Job not found", 404, "NOT_FOUND");
    }

    const isPublic =
      job.moderation_status === "approved" &&
      job.publication_status === "published";
    if (!isPublic) {
      throw new AppError("Job not found", 404, "NOT_FOUND");
    }

    return sendSuccess(res, job);
  }),
);

export { jobsRouter };

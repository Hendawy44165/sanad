import { Router } from "express";
import mongoose from "mongoose";

import { requireAuth, requireRole } from "../middleware/auth.js";
import { Job } from "../models/Job.js";
import { ModerationLog } from "../models/ModerationLog.js";
import { asyncHandler } from "../utils/asyncHandler.js";
import { AppError } from "../utils/appError.js";
import { sendSuccess } from "../utils/apiResponse.js";
import { buildMeta, getPagination } from "../utils/pagination.js";

const adminJobsRouter = Router();

adminJobsRouter.use(requireAuth, requireRole("admin"));

adminJobsRouter.get(
  "/moderation-queue",
  asyncHandler(async (req, res) => {
    const { page, limit, skip } = getPagination(req.query);
    const filters = { moderation_status: "pending" };
    if (req.query.source) {
      filters.source = req.query.source;
    }

    const [items, total] = await Promise.all([
      Job.find(filters).sort({ created_at: 1 }).skip(skip).limit(limit),
      Job.countDocuments(filters),
    ]);

    return sendSuccess(res, items, buildMeta(page, limit, total));
  }),
);

adminJobsRouter.patch(
  "/:id/moderate",
  asyncHandler(async (req, res) => {
    if (!mongoose.isValidObjectId(req.params.id)) {
      throw new AppError("Invalid job id", 400, "VALIDATION_ERROR");
    }

    const { action, reason } = req.body;
    if (!["approve", "reject"].includes(action)) {
      throw new AppError(
        "action must be approve or reject",
        400,
        "VALIDATION_ERROR",
      );
    }

    const job = await Job.findById(req.params.id);
    if (!job) {
      throw new AppError("Job not found", 404, "NOT_FOUND");
    }

    const previousStatus = job.moderation_status;
    if (action === "approve") {
      job.moderation_status = "approved";
      job.publication_status = "published";
      job.published_at = new Date();
      job.rejection_reason = null;
    } else {
      job.moderation_status = "rejected";
      job.publication_status = "archived";
      job.rejection_reason = reason || "Rejected by admin";
    }

    job.reviewed_by = req.user.id;
    job.reviewed_at = new Date();
    await job.save();

    await ModerationLog.create({
      job_id: job._id,
      action: action === "approve" ? "approved" : "rejected",
      reason: reason || null,
      previous_status: previousStatus,
      next_status: job.moderation_status,
      admin_user_id: req.user.id,
    });

    return sendSuccess(res, job);
  }),
);

adminJobsRouter.get(
  "/:id/moderation-history",
  asyncHandler(async (req, res) => {
    if (!mongoose.isValidObjectId(req.params.id)) {
      throw new AppError("Invalid job id", 400, "VALIDATION_ERROR");
    }

    const logs = await ModerationLog.find({ job_id: req.params.id }).sort({
      created_at: -1,
    });
    return sendSuccess(res, logs);
  }),
);

adminJobsRouter.delete(
  "/:id",
  asyncHandler(async (req, res) => {
    if (!mongoose.isValidObjectId(req.params.id)) {
      throw new AppError("Invalid job id", 400, "VALIDATION_ERROR");
    }

    const job = await Job.findById(req.params.id);
    if (!job) {
      throw new AppError("Job not found", 404, "NOT_FOUND");
    }

    await job.deleteOne();
    return sendSuccess(res, { deleted: true, id: req.params.id });
  }),
);

export { adminJobsRouter };

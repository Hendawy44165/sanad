import { Router } from "express";
import mongoose from "mongoose";

import { Doctor } from "../models/Doctor.js";
import { asyncHandler } from "../utils/asyncHandler.js";
import { AppError } from "../utils/appError.js";
import { sendSuccess } from "../utils/apiResponse.js";
import { buildMeta, getPagination } from "../utils/pagination.js";

const doctorsRouter = Router();

doctorsRouter.get(
  "/",
  asyncHandler(async (req, res) => {
    const { page, limit, skip } = getPagination(req.query);
    const filters = { is_active: true };

    if (req.query.specialty) {
      filters.specialty = req.query.specialty;
    }
    if (req.query.city) {
      filters["location.city"] = req.query.city;
    }
    if (req.query.q) {
      filters.$text = { $search: req.query.q };
    }

    const [items, total] = await Promise.all([
      Doctor.find(filters)
        .sort({ rating: -1, created_at: -1 })
        .skip(skip)
        .limit(limit),
      Doctor.countDocuments(filters),
    ]);

    return sendSuccess(res, items, buildMeta(page, limit, total));
  }),
);

doctorsRouter.get(
  "/:id",
  asyncHandler(async (req, res) => {
    if (!mongoose.isValidObjectId(req.params.id)) {
      throw new AppError("Invalid doctor id", 400, "VALIDATION_ERROR");
    }

    const doctor = await Doctor.findById(req.params.id);
    if (!doctor || !doctor.is_active) {
      throw new AppError("Doctor not found", 404, "NOT_FOUND");
    }

    return sendSuccess(res, doctor);
  }),
);

export { doctorsRouter };

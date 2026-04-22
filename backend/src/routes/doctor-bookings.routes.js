import { Router } from "express";
import mongoose from "mongoose";

import { requireAuth, requireRole } from "../middleware/auth.js";
import { Doctor } from "../models/Doctor.js";
import { DoctorBooking } from "../models/DoctorBooking.js";
import { asyncHandler } from "../utils/asyncHandler.js";
import { AppError } from "../utils/appError.js";
import { sendSuccess } from "../utils/apiResponse.js";
import { buildMeta, getPagination } from "../utils/pagination.js";

const doctorBookingsRouter = Router();

doctorBookingsRouter.use(requireAuth, requireRole("user"));

doctorBookingsRouter.post(
  "/",
  asyncHandler(async (req, res) => {
    const required = ["doctor_id", "appointment_date", "appointment_time"];
    for (const field of required) {
      if (!req.body[field]) {
        throw new AppError(`${field} is required`, 400, "VALIDATION_ERROR", [
          { field, reason: "required" },
        ]);
      }
    }

    if (!mongoose.isValidObjectId(req.body.doctor_id)) {
      throw new AppError("Invalid doctor_id", 400, "VALIDATION_ERROR");
    }

    const doctor = await Doctor.findById(req.body.doctor_id);
    if (!doctor || !doctor.is_active) {
      throw new AppError("Doctor not found", 404, "NOT_FOUND");
    }

    const booking = await DoctorBooking.create({
      user_id: req.user.id,
      doctor_id: doctor._id,
      appointment_date: req.body.appointment_date,
      appointment_time: req.body.appointment_time,
      status: "pending",
      notes: req.body.notes ?? null,

      doctor_name: doctor.name,
      doctor_specialty: doctor.specialty,
      doctor_rating: doctor.rating,
      doctor_location: {
        address: doctor.location?.address ?? null,
        city: doctor.location?.city ?? null,
      },
      doctor_schedule: doctor.work_schedule,
    });

    return sendSuccess(res, booking, null, 201);
  }),
);

doctorBookingsRouter.get(
  "/me",
  asyncHandler(async (req, res) => {
    const { page, limit, skip } = getPagination(req.query);
    const filters = { user_id: req.user.id };

    const [items, total] = await Promise.all([
      DoctorBooking.find(filters)
        .sort({ created_at: -1 })
        .skip(skip)
        .limit(limit),
      DoctorBooking.countDocuments(filters),
    ]);

    return sendSuccess(res, items, buildMeta(page, limit, total));
  }),
);

doctorBookingsRouter.patch(
  "/:id/cancel",
  asyncHandler(async (req, res) => {
    if (!mongoose.isValidObjectId(req.params.id)) {
      throw new AppError("Invalid booking id", 400, "VALIDATION_ERROR");
    }

    const booking = await DoctorBooking.findOne({
      _id: req.params.id,
      user_id: req.user.id,
    });
    if (!booking) {
      throw new AppError("Booking not found", 404, "NOT_FOUND");
    }

    booking.status = "cancelled";
    await booking.save();
    return sendSuccess(res, booking);
  }),
);

export { doctorBookingsRouter };

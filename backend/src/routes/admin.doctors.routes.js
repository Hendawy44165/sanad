import { Router } from "express";
import mongoose from "mongoose";

import { requireAuth, requireRole } from "../middleware/auth.js";
import { uploadImage } from "../middleware/upload.js";
import { Doctor } from "../models/Doctor.js";
import { asyncHandler } from "../utils/asyncHandler.js";
import { AppError } from "../utils/appError.js";
import { sendSuccess } from "../utils/apiResponse.js";

const adminDoctorsRouter = Router();

adminDoctorsRouter.use(requireAuth, requireRole("admin"));

function parseJsonField(value, fallback) {
  if (value === undefined || value === null || value === "") {
    return fallback;
  }
  if (typeof value === "object") {
    return value;
  }
  try {
    return JSON.parse(value);
  } catch (_error) {
    return fallback;
  }
}

function parseNumberField(value, fallback = 0) {
  if (value === undefined || value === null || value === "") {
    return fallback;
  }
  const parsed = Number(value);
  return Number.isNaN(parsed) ? fallback : parsed;
}

function parseBooleanField(value, fallback = true) {
  if (value === undefined || value === null || value === "") {
    return fallback;
  }
  if (typeof value === "boolean") {
    return value;
  }
  return String(value).toLowerCase() === "true";
}

adminDoctorsRouter.use((req, _res, next) => {
  if (req.method === "POST" || req.method === "PATCH") {
    req.uploadFolder = "doctors";
  }
  next();
});

adminDoctorsRouter.post(
  "/",
  uploadImage.single("image"),
  asyncHandler(async (req, res) => {
    const required = ["name", "specialty"];
    for (const field of required) {
      if (!req.body[field]) {
        throw new AppError(`${field} is required`, 400, "VALIDATION_ERROR", [
          { field, reason: "required" },
        ]);
      }
    }

    const location = parseJsonField(req.body.location, req.body.location);
    const workSchedule = parseJsonField(req.body.work_schedule, []);

    const doctor = await Doctor.create({
      name: req.body.name,
      specialty: req.body.specialty,
      description: req.body.description ?? null,
      rating: parseNumberField(req.body.rating, 0),
      rating_count: parseNumberField(req.body.rating_count, 0),
      location: {
        address: location?.address ?? null,
        city: location?.city ?? null,
        lat: location?.lat ?? null,
        lng: location?.lng ?? null,
      },
      work_schedule: Array.isArray(workSchedule) ? workSchedule : [],
      contact_phone: req.body.contact_phone ?? null,
      contact_email: req.body.contact_email ?? null,
      image_url: req.file
        ? `/uploads/doctors/${req.file.filename}`
        : (req.body.image_url ?? null),
      is_active: parseBooleanField(req.body.is_active, true),
    });

    return sendSuccess(res, doctor, null, 201);
  }),
);

adminDoctorsRouter.patch(
  "/:id",
  uploadImage.single("image"),
  asyncHandler(async (req, res) => {
    if (!mongoose.isValidObjectId(req.params.id)) {
      throw new AppError("Invalid doctor id", 400, "VALIDATION_ERROR");
    }

    const doctor = await Doctor.findById(req.params.id);
    if (!doctor) {
      throw new AppError("Doctor not found", 404, "NOT_FOUND");
    }

    const allowed = [
      "name",
      "specialty",
      "description",
      "rating",
      "rating_count",
      "work_schedule",
      "contact_phone",
      "contact_email",
      "image_url",
      "is_active",
    ];

    for (const field of allowed) {
      if (field in req.body) {
        doctor[field] = req.body[field];
      }
    }

    if ("rating" in req.body) {
      doctor.rating = parseNumberField(req.body.rating, doctor.rating);
    }
    if ("rating_count" in req.body) {
      doctor.rating_count = parseNumberField(
        req.body.rating_count,
        doctor.rating_count,
      );
    }
    if ("is_active" in req.body) {
      doctor.is_active = parseBooleanField(
        req.body.is_active,
        doctor.is_active,
      );
    }

    if ("location" in req.body) {
      const location = parseJsonField(req.body.location, req.body.location);
      doctor.location = {
        address: location?.address ?? null,
        city: location?.city ?? null,
        lat: location?.lat ?? null,
        lng: location?.lng ?? null,
      };
    }
    if ("work_schedule" in req.body) {
      const workSchedule = parseJsonField(req.body.work_schedule, []);
      doctor.work_schedule = Array.isArray(workSchedule) ? workSchedule : [];
    }
    if (req.file) {
      doctor.image_url = `/uploads/doctors/${req.file.filename}`;
    }

    await doctor.save();
    return sendSuccess(res, doctor);
  }),
);

adminDoctorsRouter.delete(
  "/:id",
  asyncHandler(async (req, res) => {
    if (!mongoose.isValidObjectId(req.params.id)) {
      throw new AppError("Invalid doctor id", 400, "VALIDATION_ERROR");
    }

    const doctor = await Doctor.findById(req.params.id);
    if (!doctor) {
      throw new AppError("Doctor not found", 404, "NOT_FOUND");
    }

    await doctor.deleteOne();
    return sendSuccess(res, { deleted: true, id: req.params.id });
  }),
);

export { adminDoctorsRouter };

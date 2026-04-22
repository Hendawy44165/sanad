import mongoose from "mongoose";

const doctorBookingSchema = new mongoose.Schema(
  {
    user_id: { type: String, required: true, index: true },
    doctor_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Doctor",
      required: true,
      index: true,
    },
    appointment_date: { type: String, required: true },
    appointment_time: { type: String, required: true },
    status: {
      type: String,
      enum: ["pending", "confirmed", "cancelled", "completed"],
      default: "pending",
      index: true,
    },
    notes: { type: String, default: null },

    doctor_name: { type: String, required: true },
    doctor_specialty: { type: String, required: true },
    doctor_rating: { type: Number, default: 0 },
    doctor_location: {
      address: { type: String, default: null },
      city: { type: String, default: null },
    },
    doctor_schedule: {
      type: [
        {
          day: { type: String },
          start_time: { type: String },
          end_time: { type: String },
          is_available: { type: Boolean },
        },
      ],
      default: [],
    },
  },
  { timestamps: { createdAt: "created_at", updatedAt: "updated_at" } },
);

export const DoctorBooking = mongoose.model(
  "DoctorBooking",
  doctorBookingSchema,
);

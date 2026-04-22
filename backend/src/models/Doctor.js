import mongoose from "mongoose";

const workSlotSchema = new mongoose.Schema(
  {
    day: {
      type: String,
      enum: [
        "monday",
        "tuesday",
        "wednesday",
        "thursday",
        "friday",
        "saturday",
        "sunday",
      ],
      required: true,
    },
    start_time: { type: String, required: true },
    end_time: { type: String, required: true },
    is_available: { type: Boolean, default: true },
  },
  { _id: false },
);

const doctorSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, index: true },
    specialty: { type: String, required: true, index: true },
    description: { type: String, default: null },
    rating: { type: Number, default: 0 },
    rating_count: { type: Number, default: 0 },
    location: {
      address: { type: String, default: null },
      city: { type: String, default: null },
      lat: { type: Number, default: null },
      lng: { type: Number, default: null },
    },
    work_schedule: { type: [workSlotSchema], default: [] },
    contact_phone: { type: String, default: null },
    contact_email: { type: String, default: null },
    image_url: { type: String, default: null },
    is_active: { type: Boolean, default: true, index: true },
  },
  { timestamps: { createdAt: "created_at", updatedAt: "updated_at" } },
);

doctorSchema.index({
  name: "text",
  specialty: "text",
  description: "text",
  "location.city": "text",
});

export const Doctor = mongoose.model("Doctor", doctorSchema);

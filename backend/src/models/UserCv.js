import mongoose from "mongoose";

const educationSchema = new mongoose.Schema(
  {
    institution: { type: String, required: true },
    degree: { type: String, default: null },
    field_of_study: { type: String, default: null },
    start_date: { type: Date, default: null },
    end_date: { type: Date, default: null },
    description: { type: String, default: null },
  },
  { _id: false },
);

const experienceSchema = new mongoose.Schema(
  {
    company: { type: String, required: true },
    role: { type: String, required: true },
    start_date: { type: Date, default: null },
    end_date: { type: Date, default: null },
    currently_working: { type: Boolean, default: false },
    description: { type: String, default: null },
  },
  { _id: false },
);

const userCvSchema = new mongoose.Schema(
  {
    user_id: { type: String, required: true, unique: true, index: true },
    full_name: { type: String, required: true },
    email: { type: String, default: null },
    phone: { type: String, default: null },
    city: { type: String, default: null },
    summary: { type: String, default: null },
    skills: { type: [String], default: [] },
    education: { type: [educationSchema], default: [] },
    experience: { type: [experienceSchema], default: [] },
    cv_file_url: { type: String, default: null },
  },
  { timestamps: { createdAt: "created_at", updatedAt: "updated_at" } },
);

export const UserCv = mongoose.model("UserCv", userCvSchema);

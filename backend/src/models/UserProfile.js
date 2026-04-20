import mongoose from "mongoose";

const userProfileSchema = new mongoose.Schema(
  {
    supabase_user_id: {
      type: String,
      required: true,
      unique: true,
      index: true,
    },
    email: { type: String, required: true, index: true },
    full_name: { type: String, default: null },
    phone: { type: String, default: null },
    avatar_url: { type: String, default: null },
    disability_type: {
      type: String,
      enum: [
        "visual",
        "hearing",
        "mobility",
        "cognitive",
        "chronic",
        "other",
        null,
      ],
      default: null,
    },
    language: { type: String, default: "ar" },
    notifications_enabled: { type: Boolean, default: true },
    role: { type: String, enum: ["user", "admin"], default: "user" },
    profile_completion: { type: Number, default: 10 },
    last_login_at: { type: Date, default: null },
    is_active: { type: Boolean, default: true },
  },
  { timestamps: { createdAt: "created_at", updatedAt: "updated_at" } },
);

export const UserProfile = mongoose.model("UserProfile", userProfileSchema);

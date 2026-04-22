import mongoose from "mongoose";

const moderationLogSchema = new mongoose.Schema(
  {
    job_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Job",
      required: true,
      index: true,
    },
    action: { type: String, enum: ["approved", "rejected"], required: true },
    reason: { type: String, default: null },
    previous_status: { type: String, required: true },
    next_status: { type: String, required: true },
    admin_user_id: { type: String, required: true, index: true },
  },
  { timestamps: { createdAt: "created_at", updatedAt: false } },
);

export const ModerationLog = mongoose.model(
  "ModerationLog",
  moderationLogSchema,
);

import mongoose from "mongoose";

const jobSchema = new mongoose.Schema(
  {
    source: {
      type: String,
      enum: ["user", "linkedin"],
      required: true,
      index: true,
    },
    external_id: { type: String, default: null },
    source_url: { type: String, default: null },

    title: { type: String, required: true, index: true },
    company: { type: String, required: true },
    location: { type: String, default: null },
    description: { type: String, required: true },
    employment_type: {
      type: String,
      enum: [
        "full_time",
        "part_time",
        "contract",
        "internship",
        "temporary",
        null,
      ],
      default: null,
    },
    is_remote: { type: Boolean, default: false },
    salary_min: { type: Number, default: null },
    salary_max: { type: Number, default: null },
    currency: { type: String, default: "EGP" },

    accessibility_match: {
      type: String,
      enum: ["yes", "no", "unknown"],
      default: "unknown",
      index: true,
    },
    ai_confidence: { type: Number, default: null },
    ai_reason: { type: String, default: null },

    moderation_status: {
      type: String,
      enum: ["pending", "approved", "rejected"],
      default: "pending",
      index: true,
    },
    publication_status: {
      type: String,
      enum: ["draft", "published", "archived"],
      default: "draft",
      index: true,
    },
    rejection_reason: { type: String, default: null },

    submitted_by: { type: String, default: null, index: true },
    reviewed_by: { type: String, default: null },
    reviewed_at: { type: Date, default: null },
    published_at: { type: Date, default: null },
  },
  { timestamps: { createdAt: "created_at", updatedAt: "updated_at" } },
);

jobSchema.index(
  { source: 1, external_id: 1 },
  {
    unique: true,
    partialFilterExpression: { external_id: { $type: "string" } },
  },
);
jobSchema.index({
  title: "text",
  company: "text",
  description: "text",
  location: "text",
});

export const Job = mongoose.model("Job", jobSchema);

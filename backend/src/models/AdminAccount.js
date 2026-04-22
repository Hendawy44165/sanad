import mongoose from "mongoose";

const adminAccountSchema = new mongoose.Schema(
  {
    username: { type: String, required: true, unique: true, index: true },
    password_hash: { type: String, required: true },
    is_active: { type: Boolean, default: true, index: true },
    last_login_at: { type: Date, default: null },
  },
  { timestamps: { createdAt: "created_at", updatedAt: "updated_at" } },
);

export const AdminAccount = mongoose.model("AdminAccount", adminAccountSchema);

import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import { Router } from "express";

import { env } from "../config/env.js";
import { requireAuth, requireRole } from "../middleware/auth.js";
import { AdminAccount } from "../models/AdminAccount.js";
import { asyncHandler } from "../utils/asyncHandler.js";
import { AppError } from "../utils/appError.js";
import { sendSuccess } from "../utils/apiResponse.js";

const adminAuthRouter = Router();

adminAuthRouter.post(
  "/login",
  asyncHandler(async (req, res) => {
    const { username, password } = req.body;
    if (!username || !password) {
      throw new AppError(
        "username and password are required",
        400,
        "VALIDATION_ERROR",
        [
          { field: "username", reason: "required" },
          { field: "password", reason: "required" },
        ],
      );
    }

    const account = await AdminAccount.findOne({
      username: String(username).toLowerCase(),
      is_active: true,
    });
    if (!account) {
      throw new AppError("Invalid admin credentials", 401, "UNAUTHORIZED");
    }

    const isValid = await bcrypt.compare(password, account.password_hash);
    if (!isValid) {
      throw new AppError("Invalid admin credentials", 401, "UNAUTHORIZED");
    }

    const token = jwt.sign(
      {
        sub: String(account._id),
        username: account.username,
        role: "admin",
        auth_provider: "local_admin",
        token_type: "admin_access",
      },
      env.APP_JWT_SECRET,
      { expiresIn: "12h" },
    );

    account.last_login_at = new Date();
    await account.save();

    return sendSuccess(res, {
      access_token: token,
      token_type: "Bearer",
      expires_in: 43200,
      admin: {
        id: String(account._id),
        username: account.username,
      },
    });
  }),
);

adminAuthRouter.get(
  "/me",
  requireAuth,
  requireRole("admin"),
  asyncHandler(async (req, res) => {
    const account = await AdminAccount.findById(req.user.id).select(
      "username is_active last_login_at created_at updated_at",
    );
    if (!account) {
      throw new AppError("Admin account not found", 404, "NOT_FOUND");
    }

    return sendSuccess(res, account);
  }),
);

export { adminAuthRouter };

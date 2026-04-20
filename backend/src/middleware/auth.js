import { createRemoteJWKSet, jwtVerify } from "jose";
import jwt from "jsonwebtoken";

import { env } from "../config/env.js";
import { AppError } from "../utils/appError.js";

let jwks = null;

function getJwks() {
  if (!env.SUPABASE_PROJECT_URL) {
    throw new AppError(
      "SUPABASE_PROJECT_URL is not configured",
      500,
      "CONFIG_ERROR",
    );
  }

  if (!jwks) {
    const jwksUrl = new URL(
      `${env.SUPABASE_PROJECT_URL}/auth/v1/.well-known/jwks.json`,
    );
    jwks = createRemoteJWKSet(jwksUrl);
  }

  return jwks;
}

function extractBearerToken(req) {
  const authHeader = req.headers.authorization || "";
  const [scheme, token] = authHeader.split(" ");
  if (scheme !== "Bearer" || !token) {
    throw new AppError("Missing bearer token", 401, "UNAUTHORIZED");
  }
  return token;
}

export async function requireAuth(req, _res, next) {
  try {
    const token = extractBearerToken(req);
    const { payload } = await jwtVerify(token, getJwks(), {
      audience: env.SUPABASE_JWT_AUDIENCE,
      issuer: `${env.SUPABASE_PROJECT_URL}/auth/v1`,
    });

    req.user = {
      id: payload.sub,
      email: payload.email,
      role: "user",
      auth_provider: "supabase",
      claims: payload,
    };

    next();
  } catch (error) {
    try {
      const token = extractBearerToken(req);
      const payload = jwt.verify(token, env.APP_JWT_SECRET);
      if (
        payload.token_type !== "admin_access" ||
        payload.auth_provider !== "local_admin"
      ) {
        throw new Error("Invalid admin token type");
      }

      req.user = {
        id: payload.sub,
        username: payload.username,
        role: payload.role,
        auth_provider: payload.auth_provider,
        claims: payload,
      };
      next();
    } catch (_localError) {
      next(new AppError("Invalid or expired token", 401, "UNAUTHORIZED"));
    }
  }
}

export function requireRole(...roles) {
  return (req, _res, next) => {
    if (!req.user) {
      return next(new AppError("Authentication required", 401, "UNAUTHORIZED"));
    }

    if (roles.includes("admin")) {
      const isAdminSession =
        req.user.role === "admin" && req.user.auth_provider === "local_admin";
      if (!isAdminSession) {
        return next(new AppError("Insufficient permissions", 403, "FORBIDDEN"));
      }
      return next();
    }

    if (!roles.includes(req.user.role)) {
      return next(new AppError("Insufficient permissions", 403, "FORBIDDEN"));
    }

    return next();
  };
}

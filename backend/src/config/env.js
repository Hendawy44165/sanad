import dotenv from "dotenv";

dotenv.config();

function toBoolean(value, fallback = false) {
  if (value === undefined) {
    return fallback;
  }
  return value === "true";
}

function toNumber(value, fallback) {
  if (value === undefined || value === "") {
    return fallback;
  }
  const parsed = Number(value);
  return Number.isNaN(parsed) ? fallback : parsed;
}

export const env = {
  NODE_ENV: process.env.NODE_ENV || "development",
  PORT: toNumber(process.env.PORT, 4000),
  MONGODB_URI: process.env.MONGODB_URI || "",
  APP_JWT_SECRET: process.env.APP_JWT_SECRET || "change_me_super_secret",
  SUPABASE_PROJECT_URL: process.env.SUPABASE_PROJECT_URL || "",
  SUPABASE_JWT_AUDIENCE: process.env.SUPABASE_JWT_AUDIENCE || "authenticated",
  DEFAULT_PAGE_SIZE: toNumber(process.env.DEFAULT_PAGE_SIZE, 20),
  MAX_PAGE_SIZE: toNumber(process.env.MAX_PAGE_SIZE, 100),
  ENABLE_INGESTION_SCHEDULER: toBoolean(
    process.env.ENABLE_INGESTION_SCHEDULER,
    false,
  ),
  INGESTION_CRON: process.env.INGESTION_CRON || "0 */3 * * *",
  GEMINI_API_KEY: process.env.GEMINI_API_KEY || "",
};

if (!env.MONGODB_URI) {
  console.warn(
    "Missing MONGODB_URI. Set it in backend/.env before running production workloads.",
  );
}

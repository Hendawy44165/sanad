import { env } from "../config/env.js";

export function getPagination(query) {
  const page = Math.max(Number(query.page) || 1, 1);
  const requestedLimit = Number(query.limit) || env.DEFAULT_PAGE_SIZE;
  const limit = Math.min(Math.max(requestedLimit, 1), env.MAX_PAGE_SIZE);
  const skip = (page - 1) * limit;
  return { page, limit, skip };
}

export function buildMeta(page, limit, total) {
  return {
    page,
    limit,
    total,
    has_next: page * limit < total,
  };
}

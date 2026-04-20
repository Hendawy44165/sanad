import { Router } from "express";

import { Product } from "../models/Product.js";
import { asyncHandler } from "../utils/asyncHandler.js";
import { AppError } from "../utils/appError.js";
import { sendSuccess } from "../utils/apiResponse.js";
import { buildMeta, getPagination } from "../utils/pagination.js";

const productsRouter = Router();

productsRouter.get(
  "/",
  asyncHandler(async (req, res) => {
    const { page, limit, skip } = getPagination(req.query);
    const filters = {};

    if (req.query.category) {
      filters.category = req.query.category;
    }
    if (req.query.in_stock !== undefined) {
      filters.in_stock = req.query.in_stock === "true";
    }
    if (req.query.tag) {
      filters.accessibility_tags = req.query.tag;
    }
    if (req.query.q) {
      filters.$text = { $search: req.query.q };
    }

    const [items, total] = await Promise.all([
      Product.find(filters).sort({ created_at: -1 }).skip(skip).limit(limit),
      Product.countDocuments(filters),
    ]);

    return sendSuccess(res, items, buildMeta(page, limit, total));
  }),
);

productsRouter.get(
  "/:id",
  asyncHandler(async (req, res) => {
    const item = await Product.findById(req.params.id);
    if (!item) {
      throw new AppError("Product not found", 404, "NOT_FOUND");
    }
    return sendSuccess(res, item);
  }),
);

export { productsRouter };

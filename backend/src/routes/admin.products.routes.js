import { Router } from "express";

import { requireAuth, requireRole } from "../middleware/auth.js";
import { uploadImage } from "../middleware/upload.js";
import { Product } from "../models/Product.js";
import { asyncHandler } from "../utils/asyncHandler.js";
import { AppError } from "../utils/appError.js";
import { sendSuccess } from "../utils/apiResponse.js";

const adminProductsRouter = Router();

adminProductsRouter.use(requireAuth, requireRole("admin"));

adminProductsRouter.use((req, _res, next) => {
  if (req.method === "POST" || req.method === "PATCH") {
    req.uploadFolder = "products";
  }
  next();
});

function parseJsonField(value, fallback) {
  if (value === undefined || value === null || value === "") {
    return fallback;
  }
  if (typeof value === "object") {
    return value;
  }
  try {
    return JSON.parse(value);
  } catch (_error) {
    return fallback;
  }
}

function parseNumberField(value, fallback) {
  if (value === undefined || value === null || value === "") {
    return fallback;
  }
  const parsed = Number(value);
  return Number.isNaN(parsed) ? fallback : parsed;
}

function parseBooleanField(value, fallback) {
  if (value === undefined || value === null || value === "") {
    return fallback;
  }
  if (typeof value === "boolean") {
    return value;
  }
  return String(value).toLowerCase() === "true";
}

adminProductsRouter.post(
  "/",
  uploadImage.single("image"),
  asyncHandler(async (req, res) => {
    const required = ["name", "category", "price"];
    for (const field of required) {
      if (
        req.body[field] === undefined ||
        req.body[field] === null ||
        req.body[field] === ""
      ) {
        throw new AppError(`${field} is required`, 400, "VALIDATION_ERROR", [
          { field, reason: "required" },
        ]);
      }
    }

    const imageUrls = parseJsonField(req.body.image_urls, []);

    const product = await Product.create({
      name: req.body.name,
      description: req.body.description || null,
      category: req.body.category,
      price: parseNumberField(req.body.price, 0),
      currency: req.body.currency || "EGP",
      in_stock: parseBooleanField(req.body.in_stock, true),
      stock_quantity: parseNumberField(req.body.stock_quantity, 0),
      accessibility_tags: parseJsonField(req.body.accessibility_tags, []),
      thumbnail_url: req.file
        ? `/uploads/products/${req.file.filename}`
        : req.body.thumbnail_url || null,
      image_urls: Array.isArray(imageUrls) ? imageUrls : [],
      brand: req.body.brand || null,
      sku: req.body.sku || undefined,
    });

    return sendSuccess(res, product, null, 201);
  }),
);

adminProductsRouter.patch(
  "/:id",
  uploadImage.single("image"),
  asyncHandler(async (req, res) => {
    const product = await Product.findById(req.params.id);
    if (!product) {
      throw new AppError("Product not found", 404, "NOT_FOUND");
    }

    const allowed = [
      "name",
      "description",
      "category",
      "price",
      "currency",
      "in_stock",
      "stock_quantity",
      "accessibility_tags",
      "thumbnail_url",
      "image_urls",
      "brand",
      "sku",
    ];
    for (const field of allowed) {
      if (field in req.body) {
        product[field] = req.body[field];
      }
    }

    if ("price" in req.body) {
      product.price = parseNumberField(req.body.price, product.price);
    }
    if ("stock_quantity" in req.body) {
      product.stock_quantity = parseNumberField(
        req.body.stock_quantity,
        product.stock_quantity,
      );
    }
    if ("in_stock" in req.body) {
      product.in_stock = parseBooleanField(req.body.in_stock, product.in_stock);
    }
    if ("accessibility_tags" in req.body) {
      const tags = parseJsonField(req.body.accessibility_tags, []);
      product.accessibility_tags = Array.isArray(tags) ? tags : [];
    }
    if ("image_urls" in req.body) {
      const images = parseJsonField(req.body.image_urls, []);
      product.image_urls = Array.isArray(images) ? images : [];
    }
    if (req.file) {
      product.thumbnail_url = `/uploads/products/${req.file.filename}`;
    }

    await product.save();
    return sendSuccess(res, product);
  }),
);

adminProductsRouter.delete(
  "/:id",
  asyncHandler(async (req, res) => {
    const product = await Product.findById(req.params.id);
    if (!product) {
      throw new AppError("Product not found", 404, "NOT_FOUND");
    }

    await product.deleteOne();
    return sendSuccess(res, { deleted: true, id: req.params.id });
  }),
);

export { adminProductsRouter };

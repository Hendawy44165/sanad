import mongoose from "mongoose";

const productSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, index: true },
    description: { type: String, default: null },
    category: { type: String, required: true, index: true },
    price: { type: Number, required: true },
    currency: { type: String, default: "EGP" },
    in_stock: { type: Boolean, default: true, index: true },
    stock_quantity: { type: Number, default: 0 },
    accessibility_tags: { type: [String], default: [] },
    thumbnail_url: { type: String, default: null },
    image_urls: { type: [String], default: [] },
    brand: { type: String, default: null },
    sku: { type: String, unique: true, sparse: true },
  },
  { timestamps: { createdAt: "created_at", updatedAt: "updated_at" } },
);

productSchema.index({
  name: "text",
  description: "text",
  brand: "text",
  category: "text",
});

export const Product = mongoose.model("Product", productSchema);

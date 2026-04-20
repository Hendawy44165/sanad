import fs from "fs";
import path from "path";

import multer from "multer";

const IMAGE_MIME_TYPES = new Set(["image/jpeg", "image/png", "image/webp"]);
const CV_MIME_TYPES = new Set([
  "application/pdf",
  "application/msword",
  "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
]);

function sanitizeFolder(folder) {
  return (
    String(folder)
      .replace(/[^a-zA-Z0-9_-]/g, "")
      .toLowerCase() || "general"
  );
}

function resolveFolder(req, fallback = "general") {
  return sanitizeFolder(
    req.uploadFolder || req.body.folder || req.query.folder || fallback,
  );
}

function makeStorage(defaultFolder) {
  return multer.diskStorage({
    destination: (req, _file, cb) => {
      const folder = resolveFolder(req, defaultFolder);
      const uploadDir = path.resolve(process.cwd(), "uploads", folder);
      fs.mkdirSync(uploadDir, { recursive: true });
      cb(null, uploadDir);
    },
    filename: (_req, file, cb) => {
      const ext = path.extname(file.originalname) || ".bin";
      const base =
        path
          .basename(file.originalname, ext)
          .replace(/[^a-zA-Z0-9_-]/g, "")
          .toLowerCase() || "file";
      cb(null, `${base}-${Date.now()}${ext}`);
    },
  });
}

function makeFilter(allowedMimes, errorMessage) {
  return (_req, file, cb) => {
    if (!allowedMimes.has(file.mimetype)) {
      return cb(new Error(errorMessage));
    }
    return cb(null, true);
  };
}

export const uploadImage = multer({
  storage: makeStorage("general"),
  fileFilter: makeFilter(
    IMAGE_MIME_TYPES,
    "Only JPG, PNG, and WEBP files are allowed",
  ),
  limits: {
    fileSize: 5 * 1024 * 1024,
  },
});

export const uploadCv = multer({
  storage: makeStorage("users-cv"),
  fileFilter: makeFilter(
    CV_MIME_TYPES,
    "Only PDF, DOC, and DOCX files are allowed",
  ),
  limits: {
    fileSize: 10 * 1024 * 1024,
  },
});

export function buildUploadedFilePayload(req, file) {
  const relativePath = path
    .relative(path.resolve(process.cwd(), "uploads"), file.path)
    .split(path.sep)
    .join("/");

  const fileUrl = `/uploads/${relativePath}`;
  return {
    file_url: fileUrl,
    file_url_absolute: `${req.protocol}://${req.get("host")}${fileUrl}`,
    file_name: file.filename,
    mime_type: file.mimetype,
    size: file.size,
  };
}

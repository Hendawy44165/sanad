# Uploads API

## Which endpoint to use?

1. Admin doctor image upload

- Use `POST /api/v1/admin/doctors` with multipart field `image` in the same request as doctor data.

2. Admin product image upload

- Use `POST /api/v1/admin/store/products` with multipart field `image` in the same request as product data.

3. User profile image upload

- Use `POST /api/v1/uploads/image`.

4. User CV file upload

- Use `POST /api/v1/uploads/cv`.

5. Generic admin image upload (optional utility)

- Use `POST /api/v1/admin/uploads/image` then reuse returned URL.

---

## Endpoint: POST /api/v1/admin/uploads/image

### Auth

- Required: local admin token.

### Content-Type

- `multipart/form-data`

### Fields

- `image` file (required)
- `folder` text (optional, examples: `doctors`, `products`)

### Success 201

```json
{
  "success": true,
  "data": {
    "file_url": "/uploads/doctors/image-1713471000000.jpg",
    "file_url_absolute": "http://localhost:4000/uploads/doctors/image-1713471000000.jpg",
    "image_url": "/uploads/doctors/image-1713471000000.jpg",
    "image_url_absolute": "http://localhost:4000/uploads/doctors/image-1713471000000.jpg",
    "file_name": "image-1713471000000.jpg",
    "mime_type": "image/jpeg",
    "size": 182347
  }
}
```

### Errors

- `400` missing file or invalid image type.
- `401` missing/invalid token.
- `403` non-admin token.

---

## Endpoint: POST /api/v1/uploads/image

### Auth

- Required: user token.

### Content-Type

- `multipart/form-data`

### Fields

- `image` file (required)

### Behavior

- Uploads file to `/uploads/users/*`.
- Updates current user profile `avatar_url` automatically.

### Success 201

```json
{
  "success": true,
  "data": {
    "file_url": "/uploads/users/avatar-1713471000000.jpg",
    "file_url_absolute": "http://localhost:4000/uploads/users/avatar-1713471000000.jpg",
    "image_url": "/uploads/users/avatar-1713471000000.jpg",
    "image_url_absolute": "http://localhost:4000/uploads/users/avatar-1713471000000.jpg",
    "profile_updated": true
  }
}
```

### Errors

- `400` missing file or invalid image type.
- `401` missing/invalid token.
- `403` non-user token.

---

## Endpoint: POST /api/v1/uploads/cv

### Auth

- Required: user token.

### Content-Type

- `multipart/form-data`

### Fields

- `cv` file (required)

### Allowed types

- PDF, DOC, DOCX

### Behavior

- Uploads file to `/uploads/users-cv/*`.
- Updates/creates current user CV record with `cv_file_url` automatically.

### Success 201

```json
{
  "success": true,
  "data": {
    "file_url": "/uploads/users-cv/cv-1713471000000.pdf",
    "file_url_absolute": "http://localhost:4000/uploads/users-cv/cv-1713471000000.pdf",
    "cv_file_url": "/uploads/users-cv/cv-1713471000000.pdf",
    "cv_file_url_absolute": "http://localhost:4000/uploads/users-cv/cv-1713471000000.pdf",
    "cv_updated": true
  }
}
```

### Errors

- `400` missing file or invalid document type.
- `401` missing/invalid token.
- `403` non-user token.

# Sanad Backend (Node.js + MongoDB)

Initial implementation includes:

- Supabase JWT auth validation middleware
- User profile sync and update APIs
- Employment APIs (user submissions + admin moderation)
- Store APIs (public catalog + admin CRUD)
- CV APIs (user-only add/update)
- Doctors APIs (admin CRUD + public list/details)
- Doctor booking APIs (user booking flow)
- Admin image upload API (for doctor/product image_url)
- Scheduler scaffold for LinkedIn ingestion every 3 hours

## Admin login rule (strict)

- No normal user can become admin from API.
- Admin access is only through pre-created admin accounts.
- System supports up to 5 active admin accounts.

Admin auth endpoints:

- `POST /api/v1/admin-auth/login`
- `GET /api/v1/admin-auth/me`

Current test admin account:

- username: `admin`
- password: `admin123`

## Quick start

1. Copy `.env.example` to `.env` and fill values.
2. Install dependencies:

```bash
npm install
```

3. Run development server:

```bash
npm run dev
```

4. Health check:

```bash
GET /api/v1/health
```

## API response format

Success:

```json
{
  "success": true,
  "data": {},
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 120,
    "has_next": true
  }
}
```

Error:

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "title is required",
    "details": [
      {
        "field": "title",
        "reason": "required"
      }
    ],
    "request_id": "uuid"
  }
}
```

## Initial endpoints

- `POST /api/v1/auth/sync-profile`
- `GET /api/v1/profile/me`
- `PATCH /api/v1/profile/me`
- `GET /api/v1/jobs`
- `POST /api/v1/jobs/submissions`
- `GET /api/v1/jobs/submissions/me`
- `GET /api/v1/admin/jobs/moderation-queue`
- `PATCH /api/v1/admin/jobs/:id/moderate`
- `DELETE /api/v1/admin/jobs/:id`
- `GET /api/v1/store/products`
- `GET /api/v1/store/products/:id`
- `POST /api/v1/admin/store/products`
- `PATCH /api/v1/admin/store/products/:id`
- `DELETE /api/v1/admin/store/products/:id`
- `PUT /api/v1/cv/me`
- `PATCH /api/v1/cv/me`
- `GET /api/v1/cv/me`
- `GET /api/v1/doctors`
- `GET /api/v1/doctors/:id`
- `POST /api/v1/admin/doctors`
- `PATCH /api/v1/admin/doctors/:id`
- `DELETE /api/v1/admin/doctors/:id`
- `POST /api/v1/doctor-bookings`
- `GET /api/v1/doctor-bookings/me`
- `PATCH /api/v1/doctor-bookings/:id/cancel`
- `POST /api/v1/admin/uploads/image` (multipart form-data with field name `image`)
- `POST /api/v1/admin-auth/login`
- `GET /api/v1/admin-auth/me`

### Admin add doctor with image in same request

You can now upload doctor image directly while creating doctor.

Endpoint:

- `POST /api/v1/admin/doctors`

Content type:

- `multipart/form-data`

Fields:

- `name` (required)
- `specialty` (required)
- `description`
- `rating`
- `rating_count`
- `location` as JSON string, example: `{"address":"Clinic A","city":"Cairo","lat":30.1,"lng":31.3}`
- `work_schedule` as JSON string array
- `contact_phone`
- `contact_email`
- `is_active`
- `image` (file upload)

When image is sent, backend saves and returns `image_url` automatically.

## Upload image flow (admin)

1. Admin uploads image using multipart endpoint.
2. API returns `image_url`.
3. Use that `image_url` in doctor/product create or update payload.

Example upload response:

```json
{
  "success": true,
  "data": {
    "image_url": "/uploads/doctors/image-1713471000000.jpg",
    "image_url_absolute": "http://localhost:4000/uploads/doctors/image-1713471000000.jpg",
    "file_name": "image-1713471000000.jpg",
    "mime_type": "image/jpeg",
    "size": 182347
  }
}
```

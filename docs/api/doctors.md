# Doctors API

## Endpoint: GET /api/v1/doctors

### Auth

- Not required.

### Query Parameters

- `page` number (optional)
- `limit` number (optional)
- `specialty` string (optional)
- `city` string (optional)
- `q` string for text search (optional)

### Success `200`

```json
{
  "success": true,
  "data": [
    {
      "_id": "69e3ef9cd3dac55ca606f347",
      "name": "Dr. Ahmed Nabil",
      "specialty": "Physical Medicine and Rehabilitation",
      "rating": 4.8,
      "image_url": "https://images.unsplash.com/photo-1612349317150-e413f6a5b16d"
    }
  ],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 1,
    "has_next": false
  }
}
```

### No Data Case `200`

```json
{
  "success": true,
  "data": [],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 0,
    "has_next": false
  }
}
```

## Endpoint: GET /api/v1/doctors/:id

### Auth

- Not required.

### Success `200`

- Returns doctor details.

### Not Found `404`

```json
{
  "success": false,
  "error": {
    "code": "NOT_FOUND",
    "message": "Doctor not found"
  }
}
```

### Validation Error `400`

- Invalid doctor id format.

## Endpoint: POST /api/v1/admin/doctors

### Auth

- Required: local admin bearer token.

### Content Type

- `multipart/form-data`

### Fields

- `name` (required)
- `specialty` (required)
- `description`
- `rating`
- `rating_count`
- `location` (JSON string)
- `work_schedule` (JSON string array)
- `contact_phone`
- `contact_email`
- `is_active`
- `image` (file upload, optional but recommended)

### Success `201`

```json
{
  "success": true,
  "data": {
    "_id": "69e3f6520f2d3b024761c8dc",
    "name": "Dr Test Upload",
    "specialty": "Neurology",
    "image_url": "/uploads/doctors/sanad_logo-1776547410128.jpeg"
  }
}
```

### Validation Error `400`

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "name is required"
  }
}
```

### Unauthenticated `401`

```json
{
  "success": false,
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Invalid or expired token"
  }
}
```

### Unauthorized `403`

```json
{
  "success": false,
  "error": {
    "code": "FORBIDDEN",
    "message": "Insufficient permissions"
  }
}
```

## Endpoint: PATCH /api/v1/admin/doctors/:id

### Auth

- Required: local admin bearer token.

### Content Type

- `multipart/form-data` (supports optional `image`) or JSON.

### Success `200`

- Returns updated doctor object.

### Validation Error `400`

- Invalid doctor id format.

### Not Found `404`

- Returned if target doctor does not exist.

### Auth Errors

- `401` unauthenticated.
- `403` unauthorized.

## Endpoint: DELETE /api/v1/admin/doctors/:id

### Auth

- Required: local admin bearer token.

### Success `200`

```json
{
  "success": true,
  "data": {
    "deleted": true,
    "id": "69e3f6520f2d3b024761c8dc"
  }
}
```

### Validation Error `400`

- Invalid doctor id format.

### Not Found `404`

- Doctor does not exist.

### Auth Errors

- `401` unauthenticated.
- `403` unauthorized.

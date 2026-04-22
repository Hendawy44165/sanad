# API Contract

## Base URL

- Local: `http://localhost:4000`
- Prefix: `/api/v1`

## Standard Success Envelope

```json
{
  "success": true,
  "data": {},
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 0,
    "has_next": false
  }
}
```

Notes:

- `meta` appears for paginated list endpoints.
- non-list endpoints usually return only `success` and `data`.

## Standard Error Envelope

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

## Status Code Policy

- `200` success read/update.
- `201` success create.
- `400` bad request or validation error.
- `401` unauthenticated: missing/invalid/expired token.
- `403` unauthorized (forbidden): authenticated but no permission.
- `404` resource or route not found.
- `500` unexpected server error.

## No Data Policy

For list endpoints with no records:

- return `200` with empty `data` array.
- return valid `meta` where `total = 0`.

Example:

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

## Auth Behavior

### Unauthenticated (Missing/Invalid token)

```json
{
  "success": false,
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Invalid or expired token"
  }
}
```

### Unauthorized (Insufficient permissions)

```json
{
  "success": false,
  "error": {
    "code": "FORBIDDEN",
    "message": "Insufficient permissions"
  }
}
```

## Token Types Used

1. User token

- Provider: Supabase JWT
- Used for user endpoints.

2. Admin token

- Provider: local admin auth (`/admin-auth/login`)
- Used for admin-only endpoints.

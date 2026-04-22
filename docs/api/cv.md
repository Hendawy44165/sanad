# CV API

## Authorization Rules

- All CV endpoints require authenticated user role (`user`).
- Admin sessions are forbidden.

## Endpoint: PUT /api/v1/cv/me

### Auth

- Required: user bearer token.

### Required fields

- `full_name`

### Success 200

- Upserts and returns current user CV.

### Validation Error 400

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "full_name is required"
  }
}
```

### Unauthenticated 401

- Missing/invalid token.

### Unauthorized 403

- Valid token without `user` role/session.

## Endpoint: PATCH /api/v1/cv/me

### Auth

- Required: user token.

### Success 200

- Returns updated CV.

### Not Found 404

```json
{
  "success": false,
  "error": {
    "code": "NOT_FOUND",
    "message": "CV not found. Use PUT /cv/me first."
  }
}
```

## Endpoint: GET /api/v1/cv/me

### Success 200

- Returns current CV.

### Not Found 404

- `CV not found`.

# Admin Auth API

## Purpose

Authenticate fixed admin users (pre-created accounts). Normal users cannot self-promote to admin.

## Endpoint: POST /api/v1/admin-auth/login

### Auth

- Not required.

### Request

```json
{
  "username": "admin",
  "password": "admin123"
}
```

### Success `200`

```json
{
  "success": true,
  "data": {
    "access_token": "<jwt>",
    "token_type": "Bearer",
    "expires_in": 43200,
    "admin": {
      "id": "69e3f514d3dac55ca606f348",
      "username": "admin"
    }
  }
}
```

### Validation Error `400`

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "username and password are required"
  }
}
```

### Invalid Credentials `401`

```json
{
  "success": false,
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Invalid admin credentials"
  }
}
```

## Endpoint: GET /api/v1/admin-auth/me

### Auth

- Required: local admin bearer token from `/admin-auth/login`.

### Success `200`

```json
{
  "success": true,
  "data": {
    "_id": "69e3f514d3dac55ca606f348",
    "username": "admin",
    "is_active": true,
    "last_login_at": "2026-04-18T21:23:08.189Z",
    "created_at": "2026-04-18T21:18:12.209Z",
    "updated_at": "2026-04-18T21:23:08.190Z"
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

Returned when token is valid but not admin session.

```json
{
  "success": false,
  "error": {
    "code": "FORBIDDEN",
    "message": "Insufficient permissions"
  }
}
```

### Not Found `404`

```json
{
  "success": false,
  "error": {
    "code": "NOT_FOUND",
    "message": "Admin account not found"
  }
}
```

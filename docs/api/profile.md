# Profile API

## Endpoint: POST /api/v1/auth/sync-profile

### Auth

- Required: valid bearer token.
- Supports user token (Supabase) and admin local token.

### Success 200

- Creates or updates current profile, then returns profile data.

### Unauthenticated 401

```json
{
  "success": false,
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Invalid or expired token"
  }
}
```

## Endpoint: GET /api/v1/profile/me

### Auth

- Required.

### Success 200

- Returns current profile object.

### Not Found 404

```json
{
  "success": false,
  "error": {
    "code": "PROFILE_NOT_FOUND",
    "message": "Profile not found. Call sync-profile first."
  }
}
```

### Unauthenticated 401

- Same as above.

## Endpoint: PATCH /api/v1/profile/me

### Auth

- Required.

### Allowed fields

- `full_name`, `phone`, `avatar_url`, `disability_type`, `language`, `notifications_enabled`.

### Success 200

- Returns updated profile.

### Not Found 404

- Same `PROFILE_NOT_FOUND` behavior as GET.

### Unauthenticated 401

- Same as above.

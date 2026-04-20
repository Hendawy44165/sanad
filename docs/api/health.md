# Health API

## Endpoint: GET /api/v1/health

### Auth

- Not required.

### Success 200

```json
{
  "success": true,
  "data": {
    "service": "sanad-backend",
    "status": "ok",
    "timestamp": "2026-04-20T12:00:00.000Z"
  }
}
```

### Error Cases

- No business validation errors expected.
- `404` if wrong route path is requested.

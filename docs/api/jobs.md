# Jobs API

## Endpoint: GET /api/v1/jobs

### Auth

- Not required.

### Query params

- `page`, `limit`, `accessibility_match`, `source`, `is_remote`, `q`

### Success 200

- Returns approved + published jobs list.

### No Data 200

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

## Endpoint: POST /api/v1/jobs/submissions

### Auth

- Required.

### Required fields

- `title`, `company`, `description`

### Success 201

- Creates submission with moderation `pending` and publication `draft`.

### Validation Error 400

- Missing required fields.

### Unauthenticated 401

- Invalid/missing token.

## Endpoint: GET /api/v1/jobs/submissions/me

### Auth

- Required.

### Success 200

- Returns current user submissions with pagination.

### No Data 200

- Empty array + pagination meta.

### Unauthenticated 401

- Invalid/missing token.

## Endpoint: GET /api/v1/jobs/:id

### Auth

- Not required.

### Success 200

- Returns public job only (approved + published).

### Validation Error 400

- Invalid ObjectId format.

### Not Found 404

- Job does not exist OR is not public.

## Admin Endpoints: /api/v1/admin/jobs/\*

### Shared auth

- Required: local admin session token.

### GET /moderation-queue

- Returns pending jobs.
- No data case: `200` with empty array.

### PATCH /:id/moderate

- `action` must be `approve` or `reject`.
- Success `200` updates moderation/publication state and writes moderation log.
- Errors: `400`, `404`, `401`, `403`.

### GET /:id/moderation-history

- Success `200` with logs array (can be empty).
- Errors: `400`, `401`, `403`.

### DELETE /:id

- Success `200` returns `deleted: true`.
- Errors: `400`, `404`, `401`, `403`.

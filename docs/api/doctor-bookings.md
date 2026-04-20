# Doctor Bookings API

## Authorization Rules

- All booking endpoints require authenticated user role (`user`).
- Admin sessions are forbidden.

## Endpoint: POST /api/v1/doctor-bookings

### Required fields

- `doctor_id`, `appointment_date`, `appointment_time`

### Success 201

- Creates booking with status `pending`.

### Validation Error 400

- Missing required fields or invalid `doctor_id` format.

### Not Found 404

- Target doctor not found or inactive.

### Auth Errors

- `401` unauthenticated.
- `403` unauthorized (not user role).

## Endpoint: GET /api/v1/doctor-bookings/me

### Success 200

- Returns user bookings list with pagination.

### No Data 200

- Empty list + pagination meta.

### Auth Errors

- `401` / `403`.

## Endpoint: PATCH /api/v1/doctor-bookings/:id/cancel

### Success 200

- Sets booking status to `cancelled`.

### Validation Error 400

- Invalid booking id format.

### Not Found 404

- Booking not found for current user.

### Auth Errors

- `401` / `403`.

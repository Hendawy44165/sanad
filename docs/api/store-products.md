# Store Products API

## Public Endpoints

### GET /api/v1/store/products

#### Auth

- Not required.

#### Query params

- `page`, `limit`, `category`, `in_stock`, `tag`, `q`

#### Success 200

- Returns products list with pagination.

#### No Data 200

- Empty `data` + `meta.total = 0`.

### GET /api/v1/store/products/:id

#### Success 200

- Returns single product.

#### Not Found 404

- `Product not found`.

## Admin Endpoints

### Shared auth

- Required: local admin token.

### POST /api/v1/admin/store/products

- Required fields: `name`, `category`, `price`.
- Supports `multipart/form-data` with optional `image` file.
- If `image` is provided, backend sets `thumbnail_url` automatically to `/uploads/products/...`.
- Success `201` with created product.
- Errors: `400`, `401`, `403`.

### PATCH /api/v1/admin/store/products/:id

- Supports JSON or `multipart/form-data` with optional `image` file.
- If `image` is provided, backend updates `thumbnail_url` automatically.
- Success `200` with updated product.
- Errors: `404`, `401`, `403`.

### DELETE /api/v1/admin/store/products/:id

- Success `200` with `{ deleted: true, id }`.
- Errors: `404`, `401`, `403`.

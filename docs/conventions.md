# Coding Conventions

To keep the codebase consistent, we follow these standards.

## Flutter / Dart

- **Naming**: Use `PascalCase` for classes and `camelCase` for variables/methods.
- **Widgets**: Prefer composition over large build methods. Break down complex UIs into smaller, reusable widgets.
- **Localization**: Use `AppLocalizations` for all user-facing strings.
- **Providers**: Keep providers scoped and avoid global state where possible.

## Documentation

- Document complex logic with inline comments.
- Update `/docs` when changing API contracts or data structures.

## Documentation Contract (Mandatory)

When changing backend code, documentation updates are required in the same change:

1. If schema changes:

- Update [data/schema.md](./data/schema.md).
- Mention new/removed/renamed fields.
- Mention required/default/index/enum changes.

2. If API changes:

- Update [api/README.md](./api/README.md) and endpoint-specific file under `docs/api`.
- Document request body/query/path params.
- Document success response and all known error responses.

3. API error documentation must include:

- Validation errors (`400`).
- Unauthorized (`401`) and forbidden (`403`).
- Not found (`404`).
- No data result (empty list with `200`, not an exception).

4. Auth behavior must always be documented:

- Which endpoint requires token.
- Accepted token type/provider.
- What happens if token is missing/invalid/expired.

5. DB documentation must always include:

- Database type (MongoDB).
- ORM/driver (Mongoose).
- Collection names and important indexes.

## API Documentation Minimum Template

For each endpoint, docs must include:

- Method + path.
- Auth required or not.
- Request example.
- Success response example.
- Error response examples (`400`, `401`, `403`, `404`, `500` when relevant).
- Empty data behavior example.

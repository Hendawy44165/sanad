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

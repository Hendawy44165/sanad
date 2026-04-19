# Sanad Frontend Coding Style Guide

This rule ensures that the agent adheres to the established coding standards of the Sanad project, specifically derived from the `welcome_screen.dart` implementation.

## 1. File Structure & Imports
- **Import Order**: 
    1. Flutter core packages (`package:flutter/...`)
    2. Third-party packages (e.g., `package:supabase_flutter/...`)
    3. Project-specific core utilities/themes (`../../../../core/theme/...`)
    4. Project-specific shared widgets (`../../../../core/widgets/...`)
- **Paths**: ALWAYS use relative paths for internal project imports. Do NOT use `package:sanad/...` for files within the same project unless explicitly required by the architecture.

## 2. Documentation & Comments
- **Class/Constructor Docs**: Use triple-slash (`///`) for class-level and constructor-level documentation.
- **Code Comments**: Keep comments concise and focused on "why" rather than "what".

## 3. Widget Architecture
- **Helper Methods**: Decompose large `build` methods into private helper methods prefixed with `_build` (e.g., `_buildLogo()`, `_buildFormCard()`).
- **Layout Orchestration**: The main `build` method should be a clean orchestration of these helper methods.
- **Immutability**: Use `const` extensively for widgets, decorators, and spacing.

## 4. Naming Conventions
- **Private Members**: Prefix all private variables, controllers, and methods with an underscore (`_`).
- **Event Handlers**: Use `_handle[Action]` naming for logic-triggering methods (e.g., `_handleLogin`, `_handleSignUp`).
- **UI Builders**: Use `_build[ComponentName]` for methods returning Widgets.

## 5. State Management & Async Logic
- **Local State**: Use `setState` for local UI states (loading, visibility, toggles).
- **Safe State Updates**: ALWAYS check `if (mounted)` before calling `setState` or updating UI after an `await`.
- **Error Handling**: Use `try-catch-finally` for async operations. Use `finally` to reset loading states.
- **Controllers**: Ensure `TextEditingController` and other disposable resources are cleaned up in the `dispose()` method.

## 6. Styling & UI Components
- **Theming**: Use the `AppColors` class for all colors. Avoid hardcoded hex codes.
- **Spacing**: Use `SizedBox` for vertical/horizontal spacing with consistent values (12, 20, 24, 32, 48).
- **Custom Widgets**: Prioritize using project-specific custom widgets (e.g., `CustomButton`, `CustomInput`) to maintain design consistency.
- **Feedback**: Use a dedicated `_showSnackBar(String message, {bool isError = false})` helper for user notifications.

---
*Note: This rule is active and must be followed for all Flutter/Dart code generated for this project.*

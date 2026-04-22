# Architecture Overview

This project follows **Clean Architecture** principles to ensure scalability and maintainability.

## Layers

1.  **Presentation**: Flutter widgets and Riverpod providers.
2.  **Logic**: Entities and Services (Business Logic).
3.  **Data**: Repositories, Data Sources, and Models (DTOs).

## Tech Stack

- **Frontend**: Flutter
- **State Management**: Riverpod
- **Backend**: Node.js + Express
- **Database**: MongoDB (via Mongoose)

## Backend Modules (Current)

1. Auth

- Supabase JWT verification for regular user endpoints.
- Local admin credential login (`admin-auth`) for admin-only routes.

2. Core Domains

- User profile and CV
- Jobs and moderation
- Store products
- Doctors and doctor bookings

3. File Uploads

- Multipart image uploads for admin flows.
- Static file serving from `/uploads`.

## Authorization Model (Current)

1. User APIs

- Authenticated through Supabase bearer token.
- Role is `user` for regular user actions.

2. Admin APIs

- Authenticated through local admin login endpoint.
- Receives local admin bearer token.
- Admin middleware allows only admin sessions from local admin auth provider.

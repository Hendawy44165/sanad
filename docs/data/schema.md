# Data Schemas

This document outlines the data structures used throughout the Sanad project.

## User Model

| Field                  | Type      | Required | Description                                      |
| ---------------------- | --------- | -------- | ------------------------------------------------ |
| `user_id`              | string    | yes      | Unique identifier for the user (UUID/Auth ID)    |
| `email`                | string    | yes      | User's email address                             |
| `full_name`            | string    | yes      | User's full name                                 |
| `phone`                | string    | no       | Contact phone number                             |
| `avatar_url`           | string    | no       | URL to user's profile picture                    |
| `disability_type`      | string    | no       | Type of disability (for specialized services)    |
| `language`             | string    | yes      | Preferred language (e.g., 'ar', 'en')            |
| `notifications_enabled`| boolean   | yes      | Whether user has enabled push notifications      |
| `role`                 | string    | yes      | `user` or `admin`                                |
| `profile_completion`   | number    | yes      | Percentage of profile completed (0-100)          |
| `last_login_at`        | timestamp | no       | Last recorded login time                         |
| `is_active`            | boolean   | yes      | Whether the account is active                    |
| `created_at`           | timestamp | yes      | Record creation timestamp                        |
| `updated_at`           | timestamp | yes      | Last record update timestamp                     |
| `CV`                   | string    | no       | URL or reference to the user's CV/Resume file    |

### Relationships
- A **User** can apply for many **Jobs**.
- A **User** can book many **Doctor Appointments**.
- A **User** can save many **Books**.

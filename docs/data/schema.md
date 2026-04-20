# Database & Schemas

## Database Engine

- Database: MongoDB
- ODM: Mongoose
- ID type: ObjectId (except external auth IDs stored as string)

## Collections

### 1) `userprofiles`

Purpose: store user account profile data synced from authentication layer.

| Field                   | Type        | Required | Notes                                                            |
| ----------------------- | ----------- | -------- | ---------------------------------------------------------------- |
| `supabase_user_id`      | string      | yes      | Unique external user ID, indexed, unique                         |
| `email`                 | string      | yes      | Indexed                                                          |
| `full_name`             | string      | no       |                                                                  |
| `phone`                 | string      | no       |                                                                  |
| `avatar_url`            | string      | no       |                                                                  |
| `disability_type`       | enum string | no       | `visual`, `hearing`, `mobility`, `cognitive`, `chronic`, `other` |
| `language`              | string      | yes      | default `ar`                                                     |
| `notifications_enabled` | boolean     | yes      | default `true`                                                   |
| `role`                  | enum string | yes      | `user` or `admin`                                                |
| `profile_completion`    | number      | yes      | default `10`                                                     |
| `last_login_at`         | date        | no       |                                                                  |
| `is_active`             | boolean     | yes      | default `true`                                                   |
| `created_at`            | date        | yes      | auto timestamp                                                   |
| `updated_at`            | date        | yes      | auto timestamp                                                   |

Indexes:

- unique: `supabase_user_id`
- index: `email`

### 2) `usercvs`

Purpose: user CV data (user can add/update own CV).

| Field         | Type     | Required | Notes           |
| ------------- | -------- | -------- | --------------- |
| `user_id`     | string   | yes      | unique, indexed |
| `full_name`   | string   | yes      |                 |
| `email`       | string   | no       |                 |
| `phone`       | string   | no       |                 |
| `city`        | string   | no       |                 |
| `summary`     | string   | no       |                 |
| `skills`      | string[] | no       | default `[]`    |
| `education`   | object[] | no       | nested entries  |
| `experience`  | object[] | no       | nested entries  |
| `cv_file_url` | string   | no       |                 |
| `created_at`  | date     | yes      | auto timestamp  |
| `updated_at`  | date     | yes      | auto timestamp  |

### 3) `adminaccounts`

Purpose: local admin authentication accounts.

| Field           | Type    | Required | Notes                      |
| --------------- | ------- | -------- | -------------------------- |
| `username`      | string  | yes      | unique, indexed, lowercase |
| `password_hash` | string  | yes      | bcrypt hash                |
| `is_active`     | boolean | yes      | default `true`             |
| `last_login_at` | date    | no       |                            |
| `created_at`    | date    | yes      | auto timestamp             |
| `updated_at`    | date    | yes      | auto timestamp             |

Business rule:

- active admin accounts maximum target: 5 (enforced in seed/admin creation flow).

### 4) `jobs`

Purpose: job posts from users and scraped sources.

| Field                 | Type        | Required | Notes                                                           |
| --------------------- | ----------- | -------- | --------------------------------------------------------------- |
| `source`              | enum string | yes      | `user` or `linkedin`                                            |
| `external_id`         | string      | no       | unique with source when present                                 |
| `source_url`          | string      | no       |                                                                 |
| `title`               | string      | yes      | indexed, text search                                            |
| `company`             | string      | yes      | text search                                                     |
| `location`            | string      | no       | text search                                                     |
| `description`         | string      | yes      | text search                                                     |
| `employment_type`     | enum string | no       | `full_time`, `part_time`, `contract`, `internship`, `temporary` |
| `is_remote`           | boolean     | yes      | default `false`                                                 |
| `salary_min`          | number      | no       |                                                                 |
| `salary_max`          | number      | no       |                                                                 |
| `currency`            | string      | yes      | default `EGP`                                                   |
| `accessibility_match` | enum string | yes      | `yes`, `no`, `unknown`                                          |
| `ai_confidence`       | number      | no       |                                                                 |
| `ai_reason`           | string      | no       |                                                                 |
| `moderation_status`   | enum string | yes      | `pending`, `approved`, `rejected`                               |
| `publication_status`  | enum string | yes      | `draft`, `published`, `archived`                                |
| `rejection_reason`    | string      | no       |                                                                 |
| `submitted_by`        | string      | no       | user id                                                         |
| `reviewed_by`         | string      | no       | admin id                                                        |
| `reviewed_at`         | date        | no       |                                                                 |
| `published_at`        | date        | no       |                                                                 |
| `created_at`          | date        | yes      | auto timestamp                                                  |
| `updated_at`          | date        | yes      | auto timestamp                                                  |

Indexes:

- unique partial: `{ source, external_id }` when `external_id` exists
- text index: `title`, `company`, `description`, `location`

### 5) `moderationlogs`

Purpose: admin actions on job moderation.

| Field             | Type        | Required | Notes                  |
| ----------------- | ----------- | -------- | ---------------------- |
| `job_id`          | ObjectId    | yes      | ref `jobs`, indexed    |
| `action`          | enum string | yes      | `approved`, `rejected` |
| `reason`          | string      | no       |                        |
| `previous_status` | string      | yes      |                        |
| `next_status`     | string      | yes      |                        |
| `admin_user_id`   | string      | yes      | indexed                |
| `created_at`      | date        | yes      | auto timestamp         |

### 6) `products`

Purpose: store catalog products.

| Field                | Type     | Required | Notes                   |
| -------------------- | -------- | -------- | ----------------------- |
| `name`               | string   | yes      | indexed, text search    |
| `description`        | string   | no       | text search             |
| `category`           | string   | yes      | indexed                 |
| `price`              | number   | yes      |                         |
| `currency`           | string   | yes      | default `EGP`           |
| `in_stock`           | boolean  | yes      | default `true`, indexed |
| `stock_quantity`     | number   | yes      | default `0`             |
| `accessibility_tags` | string[] | no       | default `[]`            |
| `thumbnail_url`      | string   | no       |                         |
| `image_urls`         | string[] | no       | default `[]`            |
| `brand`              | string   | no       | text search             |
| `sku`                | string   | no       | unique sparse           |
| `created_at`         | date     | yes      | auto timestamp          |
| `updated_at`         | date     | yes      | auto timestamp          |

### 7) `doctors`

Purpose: doctors directory for booking flow.

| Field           | Type     | Required | Notes                           |
| --------------- | -------- | -------- | ------------------------------- |
| `name`          | string   | yes      | indexed, text search            |
| `specialty`     | string   | yes      | indexed, text search            |
| `description`   | string   | no       | text search                     |
| `rating`        | number   | yes      | default `0`                     |
| `rating_count`  | number   | yes      | default `0`                     |
| `location`      | object   | no       | `address`, `city`, `lat`, `lng` |
| `work_schedule` | object[] | no       | day/time slots                  |
| `contact_phone` | string   | no       |                                 |
| `contact_email` | string   | no       |                                 |
| `image_url`     | string   | no       | uploaded or external            |
| `is_active`     | boolean  | yes      | default `true`, indexed         |
| `created_at`    | date     | yes      | auto timestamp                  |
| `updated_at`    | date     | yes      | auto timestamp                  |

### 8) `doctorbookings`

Purpose: user doctor bookings.

| Field              | Type        | Required | Notes                                            |
| ------------------ | ----------- | -------- | ------------------------------------------------ |
| `user_id`          | string      | yes      | indexed                                          |
| `doctor_id`        | ObjectId    | yes      | ref `doctors`, indexed                           |
| `appointment_date` | string      | yes      |                                                  |
| `appointment_time` | string      | yes      |                                                  |
| `status`           | enum string | yes      | `pending`, `confirmed`, `cancelled`, `completed` |
| `notes`            | string      | no       |                                                  |
| `doctor_name`      | string      | yes      | snapshot field                                   |
| `doctor_specialty` | string      | yes      | snapshot field                                   |
| `doctor_rating`    | number      | yes      | snapshot field                                   |
| `doctor_location`  | object      | no       | snapshot field                                   |
| `doctor_schedule`  | object[]    | no       | snapshot field                                   |
| `created_at`       | date        | yes      | auto timestamp                                   |
| `updated_at`       | date        | yes      | auto timestamp                                   |

## Relationships (Business)

- User (`userprofiles`) -> many CV versions logically one active (`usercvs`, unique by `user_id`)
- User -> many `jobs` submissions (`submitted_by`)
- Admin -> many job moderation actions (`moderationlogs`)
- Doctor -> many `doctorbookings`
- User -> many `doctorbookings`

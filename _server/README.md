<div align="center">

<img src="../lib/assets/images/logo.jpeg" width="100" alt="StudyApp Logo" />

# StudyApp — API Server

### NestJS REST API · PostgreSQL · Prisma ORM

[![NestJS](https://img.shields.io/badge/NestJS-E0234E?style=for-the-badge&logo=nestjs&logoColor=white)](https://nestjs.com/)
[![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?style=for-the-badge&logo=typescript&logoColor=white)](https://www.typescriptlang.org/)
[![Prisma](https://img.shields.io/badge/Prisma-3982CE?style=for-the-badge&logo=Prisma&logoColor=white)](https://www.prisma.io/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com/)

**Base URL (dev):** `http://localhost:3000`

</div>

---

## What is this?

The `_server/` directory is the NestJS backend for StudyApp — a peer-to-peer tutoring marketplace. It exposes a REST API consumed by the Flutter frontend. It handles authentication, user profiles, tutor listings, and (in progress) bookings, chat, and subscriptions.

---

## Architecture

```
_server/src/
│
├── main.ts                    ← Entry point. Starts NestJS + CORS + PORT
├── app.module.ts              ← Root module — imports all feature modules
├── prisma.service.ts          ← DB connection via PrismaClient (pg adapter)
├── prisma.module.ts           ← Makes PrismaService globally injectable
│
├── auth/                      ← Authentication domain ✅ COMPLETE
│   ├── auth.module.ts
│   ├── auth.controller.ts     ← POST /auth/signup, /auth/login, /auth/google
│   ├── auth.service.ts        ← Business logic: signup, login, Google OAuth, token gen
│   ├── jwt.strategy.ts        ← Passport JWT strategy — populates req.user
│   ├── auth.service.spec.ts   ← 18 unit tests
│   └── auth.controller.spec.ts← 8 unit tests
│
├── user/                      ← User & profile domain ✅ COMPLETE
│   ├── user.module.ts
│   ├── user.controller.ts     ← GET/PATCH /user/* routes
│   ├── user.service.ts        ← getAllTutors, filterTutors, getDetail, updateProfile
│   ├── dto/
│   │   └── update-profile.dto.ts
│   ├── user.service.spec.ts   ← 24 unit tests
│   └── user.controller.spec.ts← 12 unit tests
│
├── booking/                   ← Booking domain 🔲 NOT STARTED (planned)
├── chat/                      ← Messaging domain 🔲 NOT STARTED (planned)
├── subscription/              ← Subscription domain 🔲 NOT STARTED (planned)
├── notification/              ← Notifications 🔲 NOT STARTED (planned)
│
└── generated/prisma/          ← Auto-generated Prisma client (do not edit)
    ├── client.ts
    ├── models/
    │   ├── profiles.ts
    │   ├── bookings.ts
    │   ├── messages.ts
    │   ├── reviews.ts
    │   ├── transactions.ts
    │   ├── tutor_offers.ts
    │   ├── tutor_availabilities.ts
    │   ├── subjects.ts
    │   └── notifications.ts
    └── enums.ts
```

---

## System Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                   Flutter App (Client)                       │
│           AuthService  ·  UserApiService  ·  AuthState       │
└──────────────────────────────┬───────────────────────────────┘
                               │ HTTP / JSON
                               ▼
┌──────────────────────────────────────────────────────────────┐
│                  NestJS Backend (this server)                │
│                                                              │
│  ┌───────────────┐  ┌───────────────┐  ┌─────────────────┐  │
│  │  AuthModule   │  │  UserModule   │  │   PrismaModule  │  │
│  │  /auth/*      │  │  /user/*      │  │  (global, DB)   │  │
│  └───────────────┘  └───────────────┘  └─────────────────┘  │
│                                                              │
│  🔲 BookingModule   🔲 ChatModule   🔲 SubscriptionModule    │
│     /booking/*         /chat/*          /subscription/*      │
└──────────────────────────────┬───────────────────────────────┘
                               │ SQL via Prisma ORM
                               ▼
┌──────────────────────────────────────────────────────────────┐
│              PostgreSQL (hosted on Supabase)                 │
│                                                              │
│  profiles · bookings · messages · reviews · transactions     │
│  tutor_offers · tutor_availabilities · subjects · notifications│
└──────────────────────────────────────────────────────────────┘
```

**Key design decisions:**
- Auth is stateless — every protected request carries a JWT Bearer token (7-day expiry)
- Passwords hashed with **argon2** — never stored plaintext
- All DB access through `PrismaService` — no raw SQL anywhere
- `PrismaModule` is global — inject `PrismaService` into any module without re-importing
- JWT guard via Passport `AuthGuard('jwt')` — attach `@UseGuards(AuthGuard('jwt'))` to protect any route

---

## Database Schema

Schema file: `prisma/schema.prisma`

| Table | Purpose | Status |
|---|---|---|
| `profiles` | All users (students + tutors) — auth, bio, ratings, subjects | ✅ In use |
| `tutor_offers` | Tutor's service offerings (title, price, duration, subjects) | ✅ Schema ready |
| `tutor_availabilities` | Tutor schedule windows | ✅ Schema ready |
| `bookings` | Sessions between student + tutor | ✅ Schema ready |
| `messages` | Direct messages, optionally tied to a booking | ✅ Schema ready |
| `reviews` | Bi-directional ratings (student↔tutor) | ✅ Schema ready |
| `transactions` | Payments, payouts, refunds | ✅ Schema ready |
| `notifications` | User notifications with typed payloads | ✅ Schema ready |
| `subjects` | Subject catalog (slug + display name) | ✅ Schema ready |

### `profiles` — core user table

| Column | Type | Notes |
|---|---|---|
| `id` | UUID | PK, auto-generated |
| `email` | String | Unique |
| `password` | String? | Nullable — Google-only users have none |
| `full_name` | String? | Display name |
| `username` | String? | Unique handle |
| `bio` | String? | |
| `avatar_url` | String? | |
| `role` | String | `"STUDENT"` or `"TUTOR"`, default `"STUDENT"` |
| `book_price` | Float | Tutor base price, default `0` |
| `subjects` | String[] | Array of subject slugs |
| `overall_rating` | Float? | Calculated average |
| `tutor_rating` | Float? | |
| `student_rating` | Float? | |
| `rating_count` | Int | Number of reviews |
| `created_at` | DateTime | Auto-set |
| `updated_at` | DateTime | Manually updated on PATCH |

---

## API Reference

> **Protected routes** require: `Authorization: Bearer <access_token>`

### Auth — `/auth`

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| `GET` | `/auth` | None | Health check |
| `POST` | `/auth/signup` | None | Register with email + password |
| `POST` | `/auth/login` | None | Login with email + password |
| `POST` | `/auth/google` | None | Sign in/register via Google OAuth `idToken` |

#### `POST /auth/signup`
```json
// Request
{ "email": "john@example.com", "password": "secret", "role": "STUDENT" }

// Response 201
{ "message": "Authentication successful", "access_token": "eyJ...", "user": { "id": "uuid", "email": "...", "role": "STUDENT" } }
```

#### `POST /auth/login`
```json
// Request
{ "email": "john@example.com", "password": "secret" }

// Response 200
{ "message": "Authentication successful", "access_token": "eyJ...", "user": { "id": "uuid", "email": "...", "role": "STUDENT" } }
```

#### `POST /auth/google`
```json
// Request — idToken comes from Google Sign-In SDK on the client
{ "idToken": "google-id-token", "role": "STUDENT" }

// Response 200
{ "message": "Google Login successful!", "access_token": "eyJ...", "user": { "id": "uuid", "email": "...", "role": "STUDENT", "full_name": "John Doe", "avatar_url": "https://..." } }
```

---

### User — `/user`

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| `GET` | `/user` | None | Dummy health check |
| `GET` | `/user/tutors/all` | None | All tutor profiles |
| `GET` | `/user/student` | None | All student profiles |
| `GET` | `/user/tutors` | None | Filter tutors by `?search=`, `?subject=`, `?maxPrice=` |
| `GET` | `/user/tutor/:id` | None | Single tutor + their active offers |
| `PATCH` | `/user/update/profile` | JWT | Update authenticated user's own profile |

#### `GET /user/tutors?search=alice&subject=calculus&maxPrice=150000`
```json
// Response 200
[
  {
    "id": "uuid",
    "full_name": "Alice Smith",
    "username": "alice",
    "avatar_url": "https://...",
    "bio": "Math tutor",
    "book_price": 150000,
    "subjects": ["calculus"],
    "overall_rating": 4.8,
    "rating_count": 24,
    "tutor_rating": 4.9
  }
]
```

#### `GET /user/tutor/:id`
```json
// Response 200
{
  "id": "uuid",
  "full_name": "Alice Smith",
  "tutor_offers": [
    { "id": "offer-uuid", "title": "Calculus — 1hr", "price_per_hour": 150000, "duration_minutes": 60 }
  ]
}
```

#### `PATCH /user/update/profile` 🔒
```json
// Request (all fields optional)
{ "full_name": "John", "username": "john", "bio": "...", "avatar_url": "https://...", "role": "TUTOR" }

// Response 200
{ "message": "Profile updated successfully!", "user": { ... } }
```

---

### Planned Modules (not yet implemented)

| Module | Endpoints planned |
|---|---|
| `BookingModule` | `POST /booking` · `GET /booking/:id` · `PATCH /booking/:id/status` |
| `ChatModule` | `POST /chat/message` · `GET /chat/thread/:userId` · `GET /chat/list` |
| `SubscriptionModule` | `GET /subscription/plans` · `POST /subscription/subscribe` |
| `NotificationModule` | `GET /notification` · `PATCH /notification/:id/seen` |
| `ReviewModule` | `POST /review` · `GET /review/tutor/:id` |

---

## Current Progress

### ✅ Done

| Feature | What's built |
|---|---|
| Auth module | signup, login, Google OAuth, JWT token generation, argon2 password hashing |
| JWT guard | Passport strategy, `req.user` population, route protection |
| User module | getAllTutors, getAllStudents, filterTutors (search/subject/price), getTutorDetail, updateProfile |
| Prisma setup | Schema with 9 tables, migrations, generated client, global PrismaService |
| Test suite | **62 tests** across 5 suites — auth service (18), auth controller (8), user service (24), user controller (12) |
| CORS | Enabled for all origins (dev) |

### 🔄 In Progress (current branch: `api/expanding-the-api`)

- Planning and scaffolding the next set of API modules
- Deciding scope: booking system endpoints, chat endpoints, or student-specific profile endpoints

### 🔲 Todo

| Priority | Task |
|---|---|
| High | `BookingModule` — CRUD for sessions (POST/GET/PATCH) |
| High | `GET /user/profile/me` — get own profile (auth required) |
| High | `POST /booking` — create booking between student + tutor |
| High | `PATCH /booking/:id/status` — confirm/cancel/complete a booking |
| Medium | `ChatModule` — message threads, send/read messages |
| Medium | `GET /user/tutor/:id/availability` — tutor schedule |
| Medium | `POST /user/tutor/offer` — tutor creates an offer |
| Medium | `ReviewModule` — post and read reviews |
| Medium | `SubscriptionModule` — plan listing and subscription |
| Low | `NotificationModule` — notification CRUD |
| Low | WebSocket gateway for real-time chat |
| Low | Rate limiting (`@nestjs/throttler`) |
| Low | Request validation (`class-validator` + ValidationPipe) |
| Low | Swagger/OpenAPI documentation |
| Low | Production deployment config |

---

## Test Suite

**62 unit tests · 5 suites · all passing**

```bash
cd _server && npm test
```

| Suite | Tests | What's covered |
|---|---|---|
| `auth.service.spec.ts` | 18 | signUp (duplicate, hash, role default), login (valid/invalid), googleLogin (new/existing user, token verify) |
| `auth.controller.spec.ts` | 8 | All 4 endpoints, delegation to service, error propagation |
| `user.service.spec.ts` | 24 | getAllTutors, getAllStudents, filterTutors (all filter combos), getTutorDetail (404), updateProfile (partial, 400, 404) |
| `user.controller.spec.ts` | 12 | All routes, query param parsing, userId extraction (3 fallbacks), 401 when absent |

```bash
npm run test          # run all
npm run test:watch    # watch mode
npm run test:cov      # with coverage report
npm run test:e2e      # end-to-end
```

---

## Local Setup

### Prerequisites

- Node.js `v18+`
- npm
- Supabase project (PostgreSQL)

### Steps

```bash
cd _server
npm install

cp .env.example .env
# Fill in:
#   DATABASE_URL=postgresql://...   (Supabase pooled)
#   DIRECT_URL=postgresql://...     (Supabase direct, for migrations)
#   JWT_SECRET=...                  (32+ random chars)
#   GOOGLE_CLIENT_ID=...            (from Google Cloud Console)

npx prisma generate
npx prisma migrate deploy

npm run start:dev   # hot reload dev server at http://localhost:3000
```

### Environment Variables

| Variable | Required | Description |
|---|---|---|
| `DATABASE_URL` | Yes | Supabase pooled connection — used by Prisma for all queries |
| `DIRECT_URL` | Yes | Supabase direct connection — used for migrations |
| `JWT_SECRET` | Yes | Token signing secret. Must be 32+ chars and match across deployments |
| `GOOGLE_CLIENT_ID` | Yes | OAuth 2.0 Client ID from Google Cloud Console |
| `PORT` | No | Defaults to `3000` |

Generate a JWT secret:
```bash
node -e "console.log(require('crypto').randomBytes(48).toString('hex'))"
```

### Useful Commands

```bash
npx prisma studio           # browser UI to inspect/edit DB at localhost:5555
npx prisma migrate dev --name <name>  # create + apply a migration
npx prisma generate         # regenerate TS client after schema changes
npx prisma migrate deploy   # apply migrations in production
```

---

## How to Add a New Module

1. Create files: `src/feature/feature.module.ts`, `.controller.ts`, `.service.ts`, `dto/`
2. Wire controller + service in the module
3. Register the module in `app.module.ts` imports
4. Inject `PrismaService` in the service constructor
5. Write tests in `.service.spec.ts` (mock Prisma) and `.controller.spec.ts` (mock service)

See `docs.md` at the project root for detailed step-by-step examples.

---

## How to Protect a Route

```typescript
import { UseGuards, Request } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@UseGuards(AuthGuard('jwt'))
@Get('protected')
async myRoute(@Request() req: any) {
  const userId = req.user.userId || req.user.sub || req.user.id;
  if (!userId) throw new UnauthorizedException('Missing identification');
  // ...
}
```

---

<div align="center">

Part of **StudyApp** — peer-to-peer tutoring marketplace

[![GitHub](https://img.shields.io/badge/GitHub-hiyokun--d%2Fstudy--app-181717?style=flat-square&logo=github)](https://github.com/hiyokun-d/study-app)

</div>

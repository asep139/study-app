<div align="center">

# 🎓 StudyApp

### Peer-to-Peer Tutoring Marketplace

*Connect with expert tutors. Learn on your terms.*

<br/>

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![NestJS](https://img.shields.io/badge/NestJS-E0234E?style=for-the-badge&logo=nestjs&logoColor=white)](https://nestjs.com/)
[![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?style=for-the-badge&logo=typescript&logoColor=white)](https://www.typescriptlang.org/)
[![Prisma](https://img.shields.io/badge/Prisma-3982CE?style=for-the-badge&logo=Prisma&logoColor=white)](https://www.prisma.io/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com/)

[![GitHub Stars](https://img.shields.io/github/stars/hiyokun-d/study-app?style=social)](https://github.com/hiyokun-d/study-app/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/hiyokun-d/study-app?style=social)](https://github.com/hiyokun-d/study-app/network/members)
[![GitHub Issues](https://img.shields.io/github/issues/hiyokun-d/study-app)](https://github.com/hiyokun-d/study-app/issues)
[![GitHub PRs](https://img.shields.io/github/issues-pr/hiyokun-d/study-app)](https://github.com/hiyokun-d/study-app/pulls)

</div>

---

## 📖 What is StudyApp?

**StudyApp** is a modern, decoupled educational platform designed to connect students directly with expert tutors. Instead of rigid, one-size-fits-all curriculums, StudyApp puts the learner in control — choose **what** to learn, **who** to learn from, and **when** to learn it.

> "Education is not the filling of a pail, but the lighting of a fire." — W.B. Yeats

<br/>

## ✨ Features

| Feature | Description |
|---|---|
| 🔐 **JWT Authentication** | Secure login & registration with token-based auth |
| 🔑 **Google Sign-In** | One-tap OAuth login via Google |
| 👨‍🏫 **Tutor Profiles** | Browse and connect with expert tutors |
| 🎓 **Student Dashboard** | Track learning progress and upcoming sessions |
| 💬 **Real-time Chat** | Direct messaging between students and tutors |
| 📦 **Subscription Plans** | Flexible plans for different learning needs |
| 📱 **Cross-platform** | Flutter-powered: runs on Android, iOS, and Web |

<br/>

## 🛠 Tech Stack

### Frontend — Flutter (Dart)

| Tool | Purpose |
|---|---|
| **Flutter 3.5+** | Cross-platform UI framework |
| **Google Fonts** | Custom typography |
| **Font Awesome Flutter** | Icon library |
| **HTTP** | REST API communication |
| **Google Sign-In** | OAuth authentication |
| **Material 3** | Design system |

### Backend — NestJS (TypeScript)

| Tool | Purpose |
|---|---|
| **NestJS** | Modular Node.js framework |
| **Prisma ORM** | Type-safe database access & migrations |
| **PostgreSQL** | Relational database (hosted on Supabase) |
| **JWT** | Stateless authentication tokens |
| **Jest** | Unit & end-to-end testing |

<br/>

## 🏗 Architecture

```
StudyApp
├── Flutter Frontend (Mobile / Web)
│     └── Communicates via REST API ──────────────────┐
│                                                      ▼
└── NestJS Backend                           ┌─────────────────┐
      ├── Auth Module (JWT + Google OAuth)   │   PostgreSQL DB  │
      ├── User Module                        │  (via Supabase)  │
      ├── Student Module                     └─────────────────┘
      ├── Teacher Module
      ├── Chat Module
      └── Subscription Module
```

**Frontend Architecture:** Feature-first modular design. Each feature (auth, chat, student, teacher) is self-contained with its own screens.

**Backend Architecture:** Domain-driven NestJS modules with Prisma handling all database operations. Each domain (auth, user, teacher, student, chat, subscription) is fully isolated.

<br/>

## 📂 Project Structure

```
study-app/
│
├── lib/                          # Flutter Frontend
│   ├── features/                 # Feature modules
│   │   ├── auth/                 #   Login & registration screens
│   │   ├── chat/                 #   Messaging screens
│   │   ├── student/              #   Student dashboard & views
│   │   └── teacher/              #   Tutor profile & views
│   ├── core/                     # Shared utilities
│   │   ├── constants/            #   App-wide constants
│   │   ├── themes/               #   Material 3 theme config
│   │   └── widgets/              #   Reusable UI components
│   ├── models/                   # Shared data models (DTOs)
│   └── routes/                   # App navigation & routing
│
├── _server/                      # NestJS Backend
│   ├── src/
│   │   ├── auth/                 #   JWT auth + Google OAuth
│   │   ├── user/                 #   User management
│   │   ├── student/              #   Student-related logic
│   │   ├── teacher/              #   Teacher-related logic
│   │   ├── chat/                 #   Messaging system
│   │   ├── subscription/         #   Subscription plans
│   │   ├── prisma.service.ts     #   Database connection
│   │   └── main.ts               #   App entry point
│   └── prisma/
│       ├── schema.prisma         #   Database schema
│       └── migrations/           #   Migration history
│
├── docs.md                       # Full architectural documentation
└── pubspec.yaml                  # Flutter dependencies
```

<br/>

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `^3.5.0`
- [Node.js](https://nodejs.org/) `v18+` & npm
- [Git](https://git-scm.com/)
- A [Supabase](https://supabase.com/) project (for the PostgreSQL database)

---

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/hiyokun-d/study-app.git
cd study-app
```

---

### 2️⃣ Frontend Setup (Flutter)

```bash
# Install Flutter dependencies
flutter pub get

# Run the app (make sure a device/emulator is running)
flutter run

# Or target a specific platform
flutter run -d chrome      # Web
flutter run -d android     # Android
```

---

### 3️⃣ Backend Setup (NestJS)

```bash
# Navigate to the server directory
cd _server

# Install Node dependencies
npm install

# Set up environment variables
cp .env.example .env
# Open .env and fill in:
#   DATABASE_URL=...   (Supabase pooled connection)
#   DIRECT_URL=...     (Supabase direct connection)
#   JWT_SECRET=...     (a long random secret)

# Generate the Prisma client
npx prisma generate

# Run database migrations
npx prisma migrate deploy

# Start the development server (hot reload)
npm run start:dev
```

The API will be available at `http://localhost:3000`.

<br/>

## 🧪 Testing

### Backend Tests

```bash
cd _server

npm run test          # Unit tests
npm run test:e2e      # End-to-end tests
npm run test:cov      # Coverage report
```

### Frontend Tests

```bash
flutter test
```

<br/>

## 👥 Contributors

Thanks to these amazing people who built StudyApp together!

<br/>

<div align="center">

[![Contributors](https://contrib.rocks/image?repo=hiyokun-d/study-app)](https://github.com/hiyokun-d/study-app/graphs/contributors)

</div>

> Want to contribute? Read the [collaboration guide](#-github-collaboration-guide) below!

<br/>

## 🤝 GitHub Collaboration Guide

To keep code quality high and avoid conflicts, everyone follows this workflow:

### The Golden Rule

> **Never push directly to `main`.** All changes must go through a Feature Branch + Pull Request.

---

### Branching Strategy

| Branch Prefix | When to Use |
|---|---|
| `feat/` | New features — `feat/tutor-profile-page` |
| `fix/` | Bug fixes — `fix/login-crash-on-android` |
| `docs/` | Documentation — `docs/update-setup-guide` |
| `refactor/` | Code cleanup — `refactor/auth-module` |

```bash
# Create and switch to a feature branch
git checkout -b feat/my-feature-name
```

---

### Commit Message Style

Follow this concise, action-based format:

```
feat: add social login with Google
fix: resolve text overflow on tutor card
docs: update backend setup instructions
refactor: simplify auth token validation
```

---

### Pull Request Process

1. **Push your branch:** `git push origin feat/your-feature-name`
2. **Open a PR** on GitHub → "Compare & pull request"
3. **Describe your changes** — what you did and why
4. **Wait for review** — address any feedback
5. **Merge** — once approved, squash-merge into `main`

<br/>

## 📖 Full Documentation

For the complete architectural breakdown, API contracts, database schema, and design decisions, read the **[docs.md](./docs.md)** file.

<br/>

## 📄 License

This project is currently under development and not yet licensed for public distribution. Contact the repository owner for licensing inquiries.

---

<div align="center">

Made with ❤️ by the StudyApp team — **keep learning, keep building!**

[![GitHub](https://img.shields.io/badge/GitHub-hiyokun--d%2Fstudy--app-181717?style=flat-square&logo=github)](https://github.com/hiyokun-d/study-app)

</div>

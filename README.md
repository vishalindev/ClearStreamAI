# ClearStreamAI True SaaS Starter (Flutter + FastAPI + Redis)

This repository now includes a cross-platform Flutter app (Android, iOS, Windows) and a FastAPI backend with Redis support for a multi-tenant SaaS foundation.

## What is implemented

- **Multi-tenant backend** with tenant creation, member invites, invite acceptance, and login mock token flow.
- **Redis-backed repository** with in-memory fallback when Redis is unavailable.
- **Role-based route catalog** mirroring the Angular routing map you shared.
- **Flutter app shell** with:
  - Dark theme inspired by your Shark AI screenshots.
  - `go_router` route setup that mirrors the Angular route paths.
  - Role-aware route gating (redirects unauthorized users to dashboard).
  - Tenant/member onboarding controls on the dashboard.

## Project layout

- `frontend/` – Flutter app.
- `backend/` – FastAPI API service.
- `docker-compose.yml` – Runs API + Redis together.

## Backend run

```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

API docs: `http://localhost:8000/docs`

## Docker run

```bash
docker compose up --build
```

## Flutter run

```bash
cd frontend
flutter pub get
flutter run -d windows
# or android/ios device
```

## SaaS endpoints

- `POST /api/tenants`
- `GET /api/tenants`
- `GET /api/tenants/{tenant_id}/members`
- `POST /api/tenants/{tenant_id}/invites?invited_by=<email>`
- `GET /api/tenants/{tenant_id}/invites`
- `POST /api/invites/accept`
- `POST /api/auth/login`
- `GET /api/routes?role=<RoleName>`

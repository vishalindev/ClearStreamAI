from __future__ import annotations

import os
from contextlib import asynccontextmanager
from datetime import UTC, datetime
from uuid import uuid4

from fastapi import Depends, FastAPI, HTTPException
from redis.asyncio import Redis

from .models import (
    AcceptInviteRequest,
    InviteRequest,
    LoginRequest,
    LoginResponse,
    RoleName,
    Tenant,
    TenantCreateRequest,
    TenantInvite,
    User,
)
from .repository import SaaSRepository
from .route_catalog import ROUTES


@asynccontextmanager
async def lifespan(_: FastAPI):
    redis_url = os.getenv("REDIS_URL", "redis://localhost:6379/0")
    redis_client: Redis | None = None
    try:
        redis_client = Redis.from_url(redis_url, decode_responses=True)
        await redis_client.ping()
    except Exception:
        redis_client = None
    app.state.repo = SaaSRepository(redis_client)
    yield
    if redis_client:
        await redis_client.aclose()


app = FastAPI(
    title="ClearStreamAI SaaS API",
    version="1.0.0",
    lifespan=lifespan,
    description="Multi-tenant SaaS backend for tenant onboarding, invites, auth, and role-based route configuration.",
)


def get_repo() -> SaaSRepository:
    return app.state.repo


@app.get("/health")
async def healthcheck() -> dict[str, str]:
    return {"status": "ok"}


@app.post("/api/tenants", response_model=Tenant)
async def create_tenant(payload: TenantCreateRequest, repo: SaaSRepository = Depends(get_repo)) -> Tenant:
    existing = await repo.get_tenant_by_slug(payload.slug)
    if existing:
        raise HTTPException(status_code=409, detail="Tenant slug already exists")

    tenant = Tenant(name=payload.name, slug=payload.slug)
    admin = User(
        tenant_id=tenant.id,
        email=payload.admin_email,
        full_name=payload.admin_name,
        role=RoleName.platform_admin,
    )
    return await repo.create_tenant(tenant, admin)


@app.get("/api/tenants", response_model=list[Tenant])
async def list_tenants(repo: SaaSRepository = Depends(get_repo)) -> list[Tenant]:
    return await repo.list_tenants()


@app.get("/api/tenants/{tenant_id}/members", response_model=list[User])
async def list_tenant_members(tenant_id: str, repo: SaaSRepository = Depends(get_repo)) -> list[User]:
    return await repo.list_users_by_tenant(tenant_id)


@app.post("/api/tenants/{tenant_id}/invites", response_model=TenantInvite)
async def invite_tenant_member(
    tenant_id: str,
    payload: InviteRequest,
    invited_by: str,
    repo: SaaSRepository = Depends(get_repo),
) -> TenantInvite:
    inviter = await repo.find_user(tenant_id=tenant_id, email=invited_by)
    if not inviter:
        raise HTTPException(status_code=404, detail="Inviter not found for tenant")
    if inviter.role not in [RoleName.super_admin, RoleName.platform_admin, RoleName.manager]:
        raise HTTPException(status_code=403, detail="Role cannot invite members")

    invite = TenantInvite(
        tenant_id=tenant_id,
        email=payload.email,
        full_name=payload.full_name,
        role=payload.role,
        invited_by=invited_by,
    )
    return await repo.create_invite(invite)


@app.get("/api/tenants/{tenant_id}/invites", response_model=list[TenantInvite])
async def list_invites(tenant_id: str, repo: SaaSRepository = Depends(get_repo)) -> list[TenantInvite]:
    return await repo.list_invites_by_tenant(tenant_id)


@app.post("/api/invites/accept", response_model=User)
async def accept_invite(payload: AcceptInviteRequest, repo: SaaSRepository = Depends(get_repo)) -> User:
    invite = await repo.get_invite_by_token(payload.invite_token)
    if not invite:
        raise HTTPException(status_code=404, detail="Invite token invalid")

    if invite.accepted_at:
        raise HTTPException(status_code=409, detail="Invite already accepted")

    user = User(
        tenant_id=invite.tenant_id,
        email=invite.email,
        full_name=invite.full_name,
        role=invite.role,
    )
    invite.accepted_at = datetime.now(UTC)
    await repo.update_invite(invite)
    return await repo.upsert_user(user)


@app.post("/api/auth/login", response_model=LoginResponse)
async def login(payload: LoginRequest, repo: SaaSRepository = Depends(get_repo)) -> LoginResponse:
    tenant = await repo.get_tenant_by_slug(payload.tenant_slug)
    if not tenant:
        raise HTTPException(status_code=404, detail="Tenant not found")

    user = await repo.find_user(tenant.id, payload.email)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    access_token = f"mock-{uuid4()}"
    return LoginResponse(access_token=access_token, user=user, tenant=tenant)


@app.get("/api/routes")
async def get_routes(role: RoleName) -> dict[str, object]:
    allowed = [route for route in ROUTES if role in route.roles]
    return {"role": role, "items": allowed}

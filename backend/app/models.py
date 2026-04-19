from __future__ import annotations

from datetime import UTC, datetime
from enum import StrEnum
from uuid import uuid4

from pydantic import BaseModel, EmailStr, Field


class RoleName(StrEnum):
    super_admin = "SuperAdmin"
    platform_admin = "PlatformAdmin"
    platform_user = "PlatformUser"
    manager = "Manager"
    corporate = "Corporate"


class TenantStatus(StrEnum):
    active = "active"
    suspended = "suspended"


class User(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid4()))
    tenant_id: str
    email: EmailStr
    full_name: str
    role: RoleName
    created_at: datetime = Field(default_factory=lambda: datetime.now(UTC))


class Tenant(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid4()))
    name: str
    slug: str
    status: TenantStatus = TenantStatus.active
    created_at: datetime = Field(default_factory=lambda: datetime.now(UTC))


class TenantCreateRequest(BaseModel):
    name: str = Field(min_length=2, max_length=100)
    slug: str = Field(min_length=2, max_length=32, pattern=r"^[a-z0-9-]+$")
    admin_email: EmailStr
    admin_name: str = Field(min_length=2, max_length=100)


class InviteRequest(BaseModel):
    email: EmailStr
    full_name: str = Field(min_length=2, max_length=100)
    role: RoleName


class TenantInvite(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid4()))
    tenant_id: str
    email: EmailStr
    full_name: str
    role: RoleName
    invited_by: str
    invite_token: str = Field(default_factory=lambda: str(uuid4()))
    created_at: datetime = Field(default_factory=lambda: datetime.now(UTC))
    accepted_at: datetime | None = None


class AcceptInviteRequest(BaseModel):
    invite_token: str


class LoginRequest(BaseModel):
    email: EmailStr
    tenant_slug: str


class LoginResponse(BaseModel):
    access_token: str
    user: User
    tenant: Tenant


class AppRoute(BaseModel):
    path: str
    roles: list[RoleName]
    title: str
    has_params: bool = False

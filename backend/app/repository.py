from __future__ import annotations

import json
from collections.abc import Iterable
from typing import Any

from redis.asyncio import Redis

from .models import Tenant, TenantInvite, User


class MemoryStore:
    def __init__(self) -> None:
        self.tenants: dict[str, Tenant] = {}
        self.users: dict[str, User] = {}
        self.invites: dict[str, TenantInvite] = {}


class SaaSRepository:
    def __init__(self, redis_client: Redis | None = None) -> None:
        self.redis = redis_client
        self.memory = MemoryStore()

    async def _hset_json(self, hash_key: str, record_id: str, payload: dict[str, Any]) -> None:
        if not self.redis:
            return
        await self.redis.hset(hash_key, record_id, json.dumps(payload))

    async def _hgetall_json(self, hash_key: str) -> list[dict[str, Any]]:
        if not self.redis:
            return []
        records = await self.redis.hgetall(hash_key)
        return [json.loads(v) for v in records.values()]

    async def create_tenant(self, tenant: Tenant, admin: User) -> Tenant:
        self.memory.tenants[tenant.id] = tenant
        self.memory.users[admin.id] = admin
        await self._hset_json("tenants", tenant.id, tenant.model_dump(mode="json"))
        await self._hset_json("users", admin.id, admin.model_dump(mode="json"))
        return tenant

    async def list_tenants(self) -> list[Tenant]:
        tenants = list(self.memory.tenants.values())
        if tenants:
            return tenants
        redis_tenants = await self._hgetall_json("tenants")
        return [Tenant.model_validate(item) for item in redis_tenants]

    async def list_users_by_tenant(self, tenant_id: str) -> list[User]:
        users = [u for u in self.memory.users.values() if u.tenant_id == tenant_id]
        if users:
            return users
        redis_users = await self._hgetall_json("users")
        return [User.model_validate(item) for item in redis_users if item["tenant_id"] == tenant_id]

    async def get_tenant_by_slug(self, slug: str) -> Tenant | None:
        for tenant in await self.list_tenants():
            if tenant.slug == slug:
                return tenant
        return None

    async def find_user(self, tenant_id: str, email: str) -> User | None:
        users = await self.list_users_by_tenant(tenant_id)
        target = email.lower()
        for user in users:
            if user.email.lower() == target:
                return user
        return None

    async def create_invite(self, invite: TenantInvite) -> TenantInvite:
        self.memory.invites[invite.id] = invite
        await self._hset_json("invites", invite.id, invite.model_dump(mode="json"))
        return invite

    async def list_invites_by_tenant(self, tenant_id: str) -> list[TenantInvite]:
        invites = [i for i in self.memory.invites.values() if i.tenant_id == tenant_id]
        if invites:
            return invites
        redis_invites = await self._hgetall_json("invites")
        return [TenantInvite.model_validate(item) for item in redis_invites if item["tenant_id"] == tenant_id]

    async def get_invite_by_token(self, token: str) -> TenantInvite | None:
        invites: Iterable[TenantInvite] = self.memory.invites.values()
        for invite in invites:
            if invite.invite_token == token:
                return invite
        redis_invites = await self._hgetall_json("invites")
        for item in redis_invites:
            if item["invite_token"] == token:
                return TenantInvite.model_validate(item)
        return None

    async def upsert_user(self, user: User) -> User:
        self.memory.users[user.id] = user
        await self._hset_json("users", user.id, user.model_dump(mode="json"))
        return user

    async def update_invite(self, invite: TenantInvite) -> TenantInvite:
        self.memory.invites[invite.id] = invite
        await self._hset_json("invites", invite.id, invite.model_dump(mode="json"))
        return invite

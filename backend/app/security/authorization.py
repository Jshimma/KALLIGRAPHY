from collections.abc import Callable

from fastapi import Depends, HTTPException, status

from app.core.roles import UserRole
from app.models.user import User
from app.security.dependencies import get_current_user


def require_role(*allowed_roles: UserRole) -> Callable:
    def dependency(
        current_user: User = Depends(get_current_user),
    ) -> User:
        if current_user.role not in {role.value for role in allowed_roles}:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions",
            )

        return current_user

    return dependency

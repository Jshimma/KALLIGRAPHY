from fastapi import APIRouter, Depends

from app.core.roles import UserRole
from app.models.user import User
from app.security.authorization import require_role


router = APIRouter(
    prefix="/photographer",
    tags=["photographer"],
)


@router.get("/profile")
def get_photographer_profile(
    current_user: User = Depends(
        require_role(UserRole.PHOTOGRAPHER, UserRole.ADMIN)
    ),
) -> dict:
    return {
        "id": current_user.id,
        "email": current_user.email,
        "full_name": current_user.full_name,
        "role": current_user.role,
    }

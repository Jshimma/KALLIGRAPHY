from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.roles import UserRole
from app.db.session import get_db
from app.models.inquiry import Inquiry
from app.models.user import User
from app.schemas.inquiry import InquiryResponse, InquiryStatusUpdate
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


@router.get(
    "/inquiries",
    response_model=list[InquiryResponse],
)
def get_inquiries(
    db: Session = Depends(get_db),
    current_user: User = Depends(
        require_role(UserRole.PHOTOGRAPHER, UserRole.ADMIN)
    ),
) -> list[Inquiry]:
    statement = select(Inquiry).order_by(Inquiry.created_at.desc())
    return list(db.scalars(statement).all())


@router.get(
    "/inquiries/{inquiry_id}",
    response_model=InquiryResponse,
)
def get_inquiry(
    inquiry_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(
        require_role(UserRole.PHOTOGRAPHER, UserRole.ADMIN)
    ),
) -> Inquiry:
    inquiry = db.get(Inquiry, inquiry_id)

    if inquiry is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Inquiry not found",
        )

    return inquiry


@router.patch(
    "/inquiries/{inquiry_id}/status",
    response_model=InquiryResponse,
)
def update_inquiry_status(
    inquiry_id: int,
    payload: InquiryStatusUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(
        require_role(UserRole.PHOTOGRAPHER, UserRole.ADMIN)
    ),
) -> Inquiry:
    inquiry = db.get(Inquiry, inquiry_id)

    if inquiry is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Inquiry not found",
        )

    inquiry.status = payload.status
    db.commit()
    db.refresh(inquiry)

    return inquiry

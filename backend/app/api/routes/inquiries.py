from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.models.inquiry import Inquiry
from app.schemas.inquiry import InquiryCreate, InquiryResponse

router = APIRouter(
    prefix="/inquiries",
    tags=["inquiries"],
)


@router.post(
    "",
    response_model=InquiryResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_inquiry(
    payload: InquiryCreate,
    db: Session = Depends(get_db),
) -> Inquiry:
    inquiry = Inquiry(
        name=payload.name,
        email=payload.email,
        service=payload.service,
        preferred_date=payload.preferred_date,
        location=payload.location,
        message=payload.message,
        status="new",
    )

    db.add(inquiry)
    db.commit()
    db.refresh(inquiry)

    return inquiry

from datetime import datetime
from typing import Literal

from pydantic import BaseModel, ConfigDict, EmailStr


InquiryStatus = Literal["new", "contacted", "confirmed", "closed"]


class InquiryCreate(BaseModel):
    name: str
    email: EmailStr
    service: str
    preferred_date: str | None = None
    location: str | None = None
    message: str | None = None


class InquiryResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    name: str
    email: EmailStr
    service: str
    preferred_date: str | None
    location: str | None
    message: str | None
    status: str
    created_at: datetime


class InquiryStatusUpdate(BaseModel):
    status: InquiryStatus

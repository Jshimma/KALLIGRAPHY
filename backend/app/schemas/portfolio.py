from datetime import datetime

from pydantic import BaseModel, ConfigDict


class PortfolioCategoryCreate(BaseModel):
    name: str
    slug: str
    description: str | None = None
    display_order: int = 0


class PortfolioCategoryUpdate(BaseModel):
    name: str | None = None
    slug: str | None = None
    description: str | None = None
    display_order: int | None = None


class PortfolioCategoryResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    name: str
    slug: str
    description: str | None
    cover_image: str | None
    display_order: int
    created_at: datetime


class PortfolioPhotoResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    category_id: int | None
    title: str
    description: str | None
    original_filename: str
    mime_type: str
    file_size: int
    width: int | None
    height: int | None
    location: str | None
    captured_at: datetime | None
    featured: bool
    display_order: int
    processing_status: str
    created_at: datetime
    updated_at: datetime
    preview_url: str | None = None

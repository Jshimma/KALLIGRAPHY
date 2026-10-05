from datetime import datetime

from pydantic import BaseModel, ConfigDict


class ClientCreate(BaseModel):
    full_name: str
    email: str | None = None
    phone: str | None = None
    notes: str | None = None


class ClientResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    full_name: str
    email: str | None
    phone: str | None
    notes: str | None
    created_at: datetime
    updated_at: datetime


class GalleryCreate(BaseModel):
    client_id: int
    name: str
    slug: str
    description: str | None = None
    status: str = "draft"
    is_download_enabled: bool = True
    is_favorites_enabled: bool = True
    expires_at: datetime | None = None


class GalleryUpdate(BaseModel):
    name: str | None = None
    slug: str | None = None
    description: str | None = None
    status: str | None = None
    is_download_enabled: bool | None = None
    is_favorites_enabled: bool | None = None
    expires_at: datetime | None = None


class GalleryResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    client_id: int
    name: str
    slug: str
    description: str | None
    status: str
    cover_photo_id: int | None
    is_download_enabled: bool
    is_favorites_enabled: bool
    expires_at: datetime | None
    created_at: datetime
    updated_at: datetime


class GallerySummary(GalleryResponse):
    client_name: str
    photo_count: int

class PublicGalleryPhoto(BaseModel):
    id: int
    title: str
    preview_url: str


class PublicGalleryResponse(BaseModel):
    name: str
    description: str | None
    photo_count: int
    is_download_enabled: bool
    is_favorites_enabled: bool
    expires_at: datetime | None
    photos: list[PublicGalleryPhoto]


class GalleryPhotoReorderItem(BaseModel):
    photo_id: int
    display_order: int


class GalleryPhotoReorderRequest(BaseModel):
    photos: list[GalleryPhotoReorderItem]

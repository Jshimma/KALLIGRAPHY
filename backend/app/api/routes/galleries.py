from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.core.roles import UserRole
from app.db.session import get_db
from app.models.client import Client
from app.models.gallery import Gallery, GalleryPhoto
from app.models.user import User
from app.schemas.gallery import (
    ClientCreate,
    ClientResponse,
    GalleryCreate,
    GalleryResponse,
    GallerySummary,
    GalleryUpdate,
)
from app.security.authorization import require_role

router = APIRouter(
    prefix="/photographer/galleries",
    tags=["photographer galleries"],
)


@router.get("", response_model=list[GallerySummary])
def list_galleries(
    db: Session = Depends(get_db),
    _: User = Depends(
        require_role(UserRole.PHOTOGRAPHER, UserRole.ADMIN),
    ),
):
    statement = (
        select(
            Gallery,
            Client.full_name.label("client_name"),
            func.count(GalleryPhoto.id).label("photo_count"),
        )
        .join(Client, Client.id == Gallery.client_id)
        .outerjoin(
            GalleryPhoto,
            GalleryPhoto.gallery_id == Gallery.id,
        )
        .group_by(
            Gallery.id,
            Client.full_name,
        )
        .order_by(Gallery.created_at.desc())
    )

    rows = db.execute(statement).all()

    return [
        GallerySummary(
            **GalleryResponse.model_validate(gallery).model_dump(),
            client_name=client_name,
            photo_count=int(photo_count),
        )
        for gallery, client_name, photo_count in rows
    ]


@router.post(
    "/clients",
    response_model=ClientResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_client(
    payload: ClientCreate,
    db: Session = Depends(get_db),
    _: User = Depends(
        require_role(UserRole.PHOTOGRAPHER, UserRole.ADMIN),
    ),
):
    email = payload.email.strip() if payload.email else None

    if email:
        existing = db.scalar(
            select(Client).where(Client.email == email),
        )

        if existing is not None:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="A client with this email already exists.",
            )

    client = Client(
        full_name=payload.full_name.strip(),
        email=email,
        phone=payload.phone.strip() if payload.phone else None,
        notes=payload.notes.strip() if payload.notes else None,
    )

    db.add(client)
    db.commit()
    db.refresh(client)

    return client


@router.post(
    "",
    response_model=GalleryResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_gallery(
    payload: GalleryCreate,
    db: Session = Depends(get_db),
    _: User = Depends(
        require_role(UserRole.PHOTOGRAPHER, UserRole.ADMIN),
    ),
):
    client = db.get(Client, payload.client_id)

    if client is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Client not found.",
        )

    slug = payload.slug.strip()

    existing = db.scalar(
        select(Gallery).where(Gallery.slug == slug),
    )

    if existing is not None:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="A gallery with this slug already exists.",
        )

    gallery = Gallery(
        client_id=payload.client_id,
        name=payload.name.strip(),
        slug=slug,
        description=(
            payload.description.strip()
            if payload.description
            else None
        ),
        status=payload.status,
        is_download_enabled=payload.is_download_enabled,
        is_favorites_enabled=payload.is_favorites_enabled,
        expires_at=payload.expires_at,
    )

    db.add(gallery)
    db.commit()
    db.refresh(gallery)

    return gallery


@router.get(
    "/{gallery_id}",
    response_model=GalleryResponse,
)
def get_gallery(
    gallery_id: int,
    db: Session = Depends(get_db),
    _: User = Depends(
        require_role(UserRole.PHOTOGRAPHER, UserRole.ADMIN),
    ),
):
    gallery = db.get(Gallery, gallery_id)

    if gallery is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Gallery not found.",
        )

    return gallery


@router.patch(
    "/{gallery_id}",
    response_model=GalleryResponse,
)
def update_gallery(
    gallery_id: int,
    payload: GalleryUpdate,
    db: Session = Depends(get_db),
    _: User = Depends(
        require_role(UserRole.PHOTOGRAPHER, UserRole.ADMIN),
    ),
):
    gallery = db.get(Gallery, gallery_id)

    if gallery is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Gallery not found.",
        )

    if payload.slug is not None:
        slug = payload.slug.strip()

        existing = db.scalar(
            select(Gallery).where(
                Gallery.slug == slug,
                Gallery.id != gallery.id,
            ),
        )

        if existing is not None:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="A gallery with this slug already exists.",
            )

    updates = payload.model_dump(exclude_unset=True)

    for field, value in updates.items():
        if isinstance(value, str):
            value = value.strip() or None

        setattr(gallery, field, value)

    db.commit()
    db.refresh(gallery)

    return gallery

from pathlib import Path
import shutil
from uuid import uuid4
from fastapi import APIRouter, Depends, File, HTTPException, UploadFile, status
from fastapi.responses import FileResponse
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.core.roles import UserRole
from app.db.session import get_db
from app.models.client import Client
from app.models.gallery import Gallery, GalleryAccess, GalleryPhoto
from app.models.portfolio import PortfolioPhoto
from app.models.user import User
from app.schemas.gallery import (
    ClientCreate,
    ClientResponse,
    GalleryCreate,
    GalleryResponse,
    GalleryPhotoReorderRequest,
    GallerySummary,
    GalleryUpdate,
    PublicGalleryPhoto,
    PublicGalleryResponse,
)
from app.schemas.portfolio import PortfolioPhotoResponse
from app.security.authorization import require_role
from app.services.portfolio_photos import (
    ALLOWED_MIME_TYPES,
    InvalidPhotoError,
    create_portfolio_photo,
)
from app.services.storage import PREVIEWS_DIR, TEMP_DIR

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


@router.get(
    "/{gallery_id}/photos",
    response_model=list[PortfolioPhotoResponse],
)
def list_gallery_photos(
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

    statement = (
        select(PortfolioPhoto, GalleryPhoto.display_order)
        .join(
            GalleryPhoto,
            GalleryPhoto.portfolio_photo_id == PortfolioPhoto.id,
        )
        .where(GalleryPhoto.gallery_id == gallery_id)
        .order_by(GalleryPhoto.display_order, GalleryPhoto.id)
    )

    rows = db.execute(statement).all()

    responses = []

    for photo, _ in rows:
        response = PortfolioPhotoResponse.model_validate(photo)
        response.preview_url = (
            f"/photographer/galleries/{gallery_id}/photos/"
            f"{photo.id}/preview"
        )
        responses.append(response)

    return responses


@router.delete(
    "/{gallery_id}/photos/{photo_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
def remove_gallery_photo(
    gallery_id: int,
    photo_id: int,
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

    gallery_photo = db.scalar(
        select(GalleryPhoto).where(
            GalleryPhoto.gallery_id == gallery_id,
            GalleryPhoto.portfolio_photo_id == photo_id,
        )
    )

    if gallery_photo is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Gallery photo not found.",
        )

    if gallery.cover_photo_id == photo_id:
        gallery.cover_photo_id = None

    db.delete(gallery_photo)
    db.commit()

    return None


@router.patch(
    "/{gallery_id}/photos/reorder",
)
def reorder_gallery_photos(
    gallery_id: int,
    payload: GalleryPhotoReorderRequest,
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

    gallery_photos = db.scalars(
        select(GalleryPhoto).where(
            GalleryPhoto.gallery_id == gallery_id,
        )
    ).all()

    existing_by_photo_id = {
        gallery_photo.portfolio_photo_id: gallery_photo
        for gallery_photo in gallery_photos
    }

    submitted_ids = [item.photo_id for item in payload.photos]

    if len(submitted_ids) != len(set(submitted_ids)):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="A photo cannot appear more than once.",
        )

    if set(submitted_ids) != set(existing_by_photo_id):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="The reorder list must contain every photo in the gallery.",
        )

    for item in payload.photos:
        existing_by_photo_id[item.photo_id].display_order = item.display_order

    db.commit()

    return {
        "message": "Gallery photo order updated.",
    }


@router.patch(
    "/{gallery_id}/cover/{photo_id}",
)
def set_gallery_cover_photo(
    gallery_id: int,
    photo_id: int,
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

    gallery_photo = db.scalar(
        select(GalleryPhoto).where(
            GalleryPhoto.gallery_id == gallery_id,
            GalleryPhoto.portfolio_photo_id == photo_id,
        )
    )

    if gallery_photo is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Gallery photo not found.",
        )

    gallery.cover_photo_id = photo_id
    db.commit()

    return {
        "message": "Gallery cover photo updated.",
        "cover_photo_id": photo_id,
    }


@router.get(
    "/{gallery_id}/photos/{photo_id}/preview",
)
def get_gallery_photo_preview(
    gallery_id: int,
    photo_id: int,
    db: Session = Depends(get_db),
    _: User = Depends(
        require_role(UserRole.PHOTOGRAPHER, UserRole.ADMIN),
    ),
):
    statement = (
        select(PortfolioPhoto)
        .join(
            GalleryPhoto,
            GalleryPhoto.portfolio_photo_id == PortfolioPhoto.id,
        )
        .where(
            GalleryPhoto.gallery_id == gallery_id,
            PortfolioPhoto.id == photo_id,
        )
    )

    photo = db.scalar(statement)

    if photo is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Gallery photo not found.",
        )

    preview_path = Path(photo.preview_path)

    if not preview_path.is_file():
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Photo preview not found.",
        )

    return FileResponse(
        path=preview_path,
        media_type="image/jpeg",
        filename=f"{photo.id}-preview.jpg",
    )


@router.post(
    "/{gallery_id}/photos",
    response_model=list[PortfolioPhotoResponse],
    status_code=status.HTTP_201_CREATED,
)
def upload_gallery_photos(
    gallery_id: int,
    files: list[UploadFile] = File(...),
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

    if not files:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="At least one photo is required.",
        )

    TEMP_DIR.mkdir(parents=True, exist_ok=True)

    uploaded_photos = []

    for index, file in enumerate(files):
        mime_type = file.content_type or ""
        suffix = Path(file.filename or "").suffix.lower()

        extension_to_mime = {
            ".jpg": "image/jpeg",
            ".jpeg": "image/jpeg",
            ".png": "image/png",
            ".webp": "image/webp",
        }

        if mime_type not in ALLOWED_MIME_TYPES:
            mime_type = extension_to_mime.get(suffix, "")

        if mime_type not in ALLOWED_MIME_TYPES:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Unsupported image type: {file.filename or 'upload'}",
            )

        temporary_path = TEMP_DIR / f"gallery-upload-{uuid4().hex}{suffix}"

        try:
            with temporary_path.open("wb") as destination:
                shutil.copyfileobj(file.file, destination)

            photo = create_portfolio_photo(
                db,
                source=temporary_path,
                original_filename=file.filename or "upload",
                mime_type=mime_type,
                title=Path(file.filename or "Photo").stem,
                description=None,
                category_id=None,
                location=None,
                captured_at=None,
                featured=False,
                display_order=index,
            )

            gallery_photo = GalleryPhoto(
                gallery_id=gallery.id,
                portfolio_photo_id=photo.id,
                display_order=index,
            )

            db.add(gallery_photo)
            db.commit()

            uploaded_photos.append(photo)

        except InvalidPhotoError as exc:
            db.rollback()

            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=str(exc),
            ) from exc

        finally:
            temporary_path.unlink(missing_ok=True)
            file.file.close()

    if uploaded_photos and gallery.cover_photo_id is None:
        gallery.cover_photo_id = uploaded_photos[0].id
        db.commit()

    return uploaded_photos


# ---------------------------------------------------------------------------
# Public client gallery access
# ---------------------------------------------------------------------------

from datetime import datetime, timezone
import hashlib


def _hash_gallery_token(token: str) -> str:
    return hashlib.sha256(token.encode("utf-8")).hexdigest()


def _get_public_gallery_access(
    token: str,
    db: Session,
) -> tuple[Gallery, object]:
    token_hash = _hash_gallery_token(token)

    statement = (
        select(GalleryAccess, Gallery)
        .join(
            Gallery,
            Gallery.id == GalleryAccess.gallery_id,
        )
        .where(
            GalleryAccess.access_token_hash == token_hash,
            GalleryAccess.is_active.is_(True),
        )
    )

    result = db.execute(statement).first()

    if result is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Gallery not found.",
        )

    access, gallery = result

    if gallery.status != "published":
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Gallery not found.",
        )

    now = datetime.now(timezone.utc)

    if gallery.expires_at is not None:
        expires_at = gallery.expires_at

        if expires_at.tzinfo is None:
            expires_at = expires_at.replace(tzinfo=timezone.utc)

        if expires_at <= now:
            raise HTTPException(
                status_code=status.HTTP_410_GONE,
                detail="This gallery link has expired.",
            )

    access.last_accessed_at = now
    db.commit()

    return gallery, access


@router.post(
    "/{gallery_id}/share",
)
def create_gallery_share_link(
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

    if gallery.status != "published":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Publish the gallery before creating a client link.",
        )

    token = uuid4().hex + uuid4().hex
    token_hash = _hash_gallery_token(token)

    existing_access = db.scalar(
        select(GalleryAccess).where(
            GalleryAccess.gallery_id == gallery.id,
            GalleryAccess.is_active.is_(True),
        ),
    )

    if existing_access is not None:
        existing_access.is_active = False

    access = GalleryAccess(
        gallery_id=gallery.id,
        client_id=gallery.client_id,
        access_token_hash=token_hash,
        is_active=True,
    )

    db.add(access)
    db.commit()

    return {
        "token": token,
        "gallery_id": gallery.id,
        "slug": gallery.slug,
    }


@router.post(
    "/{gallery_id}/share/revoke",
)
def revoke_gallery_share_link(
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

    accesses = db.scalars(
        select(GalleryAccess).where(
            GalleryAccess.gallery_id == gallery.id,
            GalleryAccess.is_active.is_(True),
        ),
    ).all()

    for access in accesses:
        access.is_active = False

    db.commit()

    return {"message": "Gallery share link revoked."}


@router.get(
    "/public/{token}",
    response_model=PublicGalleryResponse,
)
def get_public_gallery(
    token: str,
    db: Session = Depends(get_db),
):
    gallery, _ = _get_public_gallery_access(token, db)

    statement = (
        select(PortfolioPhoto, GalleryPhoto.display_order)
        .join(
            GalleryPhoto,
            GalleryPhoto.portfolio_photo_id == PortfolioPhoto.id,
        )
        .where(GalleryPhoto.gallery_id == gallery.id)
        .order_by(GalleryPhoto.display_order, GalleryPhoto.id)
    )

    rows = db.execute(statement).all()

    photos = [
        PublicGalleryPhoto(
            id=photo.id,
            title=photo.title,
            preview_url=(
                f"/photographer/galleries/public/{token}/"
                f"photos/{photo.id}/preview"
            ),
        )
        for photo, _ in rows
    ]

    return PublicGalleryResponse(
        name=gallery.name,
        description=gallery.description,
        photo_count=len(photos),
        is_download_enabled=gallery.is_download_enabled,
        is_favorites_enabled=gallery.is_favorites_enabled,
        expires_at=gallery.expires_at,
        photos=photos,
    )


@router.get(
    "/public/{token}/photos/{photo_id}/preview",
)
def get_public_gallery_photo_preview(
    token: str,
    photo_id: int,
    db: Session = Depends(get_db),
):
    gallery, _ = _get_public_gallery_access(token, db)

    statement = (
        select(PortfolioPhoto)
        .join(
            GalleryPhoto,
            GalleryPhoto.portfolio_photo_id == PortfolioPhoto.id,
        )
        .where(
            GalleryPhoto.gallery_id == gallery.id,
            PortfolioPhoto.id == photo_id,
        )
    )

    photo = db.scalar(statement)

    if photo is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Gallery photo not found.",
        )

    preview_path = Path(photo.preview_path)

    if not preview_path.is_file():
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Photo preview not found.",
        )

    return FileResponse(
        path=preview_path,
        media_type="image/jpeg",
        filename=f"{photo.id}-preview.jpg",
    )

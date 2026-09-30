import hashlib
import shutil
from pathlib import Path

from PIL import Image, UnidentifiedImageError
from sqlalchemy.orm import Session

from app.models.portfolio import PortfolioPhoto
from app.services.image_processing import process_image
from app.services.storage import (
    ORIGINALS_DIR,
    PREVIEWS_DIR,
    THUMBNAILS_DIR,
    create_photo_directory,
    ensure_storage_directories,
)


ALLOWED_MIME_TYPES = {
    "image/jpeg": ".jpg",
    "image/png": ".png",
    "image/webp": ".webp",
}

MAX_FILE_SIZE = 50 * 1024 * 1024


class InvalidPhotoError(ValueError):
    pass


def calculate_checksum(path: Path) -> str:
    digest = hashlib.sha256()

    with path.open("rb") as file:
        for chunk in iter(lambda: file.read(1024 * 1024), b""):
            digest.update(chunk)

    return digest.hexdigest()


def create_portfolio_photo(
    db: Session,
    *,
    source: Path,
    original_filename: str,
    mime_type: str,
    title: str,
    description: str | None,
    category_id: int | None,
    location: str | None,
    captured_at,
    featured: bool,
    display_order: int,
) -> PortfolioPhoto:
    ensure_storage_directories()

    if mime_type not in ALLOWED_MIME_TYPES:
        raise InvalidPhotoError("Unsupported image type")

    file_size = source.stat().st_size

    if file_size > MAX_FILE_SIZE:
        raise InvalidPhotoError("Image exceeds the 50 MB limit")

    try:
        with Image.open(source) as image:
            image.verify()

        with Image.open(source) as image:
            width, height = image.size

    except (UnidentifiedImageError, OSError):
        raise InvalidPhotoError("Uploaded file is not a valid image")

    checksum = calculate_checksum(source)
    photo_key = create_photo_directory()

    extension = ALLOWED_MIME_TYPES[mime_type]

    original_path = ORIGINALS_DIR / photo_key / f"original{extension}"
    preview_path = PREVIEWS_DIR / photo_key / "preview.jpg"
    thumbnail_path = THUMBNAILS_DIR / photo_key / "thumbnail.jpg"

    try:
        shutil.copy2(source, original_path)

        process_image(
            original_path,
            preview_path,
            thumbnail_path,
        )

        photo = PortfolioPhoto(
            category_id=category_id,
            title=title,
            description=description,
            original_path=str(original_path),
            preview_path=str(preview_path),
            thumbnail_path=str(thumbnail_path),
            original_filename=original_filename,
            mime_type=mime_type,
            file_size=file_size,
            width=width,
            height=height,
            checksum=checksum,
            location=location,
            captured_at=captured_at,
            featured=featured,
            display_order=display_order,
            processing_status="ready",
        )

        db.add(photo)
        db.commit()
        db.refresh(photo)

        return photo

    except Exception:
        db.rollback()

        shutil.rmtree(
            ORIGINALS_DIR / photo_key,
            ignore_errors=True,
        )
        shutil.rmtree(
            PREVIEWS_DIR / photo_key,
            ignore_errors=True,
        )
        shutil.rmtree(
            THUMBNAILS_DIR / photo_key,
            ignore_errors=True,
        )

        raise

from pathlib import Path
from uuid import uuid4

from app.core.config import settings


STORAGE_ROOT = Path(settings.storage_root)

ORIGINALS_DIR = STORAGE_ROOT / "originals"
PREVIEWS_DIR = STORAGE_ROOT / "previews"
THUMBNAILS_DIR = STORAGE_ROOT / "thumbnails"
TEMP_DIR = STORAGE_ROOT / "temp"


def ensure_storage_directories() -> None:
    for directory in (
        ORIGINALS_DIR,
        PREVIEWS_DIR,
        THUMBNAILS_DIR,
        TEMP_DIR,
    ):
        directory.mkdir(parents=True, exist_ok=True)


def create_photo_directory() -> str:
    photo_id = uuid4().hex

    for base_directory in (
        ORIGINALS_DIR,
        PREVIEWS_DIR,
        THUMBNAILS_DIR,
    ):
        (base_directory / photo_id).mkdir(
            parents=True,
            exist_ok=False,
        )

    return photo_id

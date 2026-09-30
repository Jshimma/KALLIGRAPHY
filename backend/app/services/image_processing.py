from pathlib import Path

from PIL import Image


PREVIEW_MAX_SIZE = (2400, 2400)
THUMBNAIL_MAX_SIZE = (800, 800)


def process_image(
    source: Path,
    preview_destination: Path,
    thumbnail_destination: Path,
) -> tuple[int, int]:
    with Image.open(source) as image:
        image = image.convert("RGB")

        width, height = image.size

        preview = image.copy()
        preview.thumbnail(PREVIEW_MAX_SIZE, Image.Resampling.LANCZOS)
        preview.save(
            preview_destination,
            format="JPEG",
            quality=88,
            optimize=True,
        )

        thumbnail = image.copy()
        thumbnail.thumbnail(
            THUMBNAIL_MAX_SIZE,
            Image.Resampling.LANCZOS,
        )
        thumbnail.save(
            thumbnail_destination,
            format="JPEG",
            quality=82,
            optimize=True,
        )

    return width, height

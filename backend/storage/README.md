# KALLYGRAPHY Storage

KALLYGRAPHY owns and controls its photography storage.

## Directories

- `originals/` — original photographer uploads
- `previews/` — optimized high-quality images for viewing
- `thumbnails/` — smaller images used in grids and previews
- `temp/` — temporary upload and processing files

## Ownership

Photos must not depend on third-party image-storage platforms.

The production implementation will store files on infrastructure controlled by KALLYGRAPHY and keep file metadata in PostgreSQL.

## Rules

1. Original files are never overwritten during image processing.
2. Public clients should not receive direct filesystem paths.
3. API authorization controls access to private galleries.
4. Thumbnails and previews are generated from originals.
5. File records contain metadata rather than storing image binaries in PostgreSQL.

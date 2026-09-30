from datetime import datetime

from sqlalchemy import (
    Boolean,
    DateTime,
    ForeignKey,
    Integer,
    String,
    Text,
    UniqueConstraint,
    func,
)
from sqlalchemy.orm import Mapped, mapped_column

from app.db.session import Base


class Gallery(Base):
    __tablename__ = "galleries"

    id: Mapped[int] = mapped_column(primary_key=True)
    client_id: Mapped[int] = mapped_column(
        ForeignKey("clients.id", ondelete="CASCADE"),
        index=True,
    )

    name: Mapped[str] = mapped_column(String(200))
    slug: Mapped[str] = mapped_column(String(220), unique=True, index=True)
    description: Mapped[str | None] = mapped_column(Text)

    status: Mapped[str] = mapped_column(
        String(30),
        default="draft",
    )

    cover_photo_id: Mapped[int | None] = mapped_column(
        ForeignKey("portfolio_photos.id", ondelete="SET NULL"),
        nullable=True,
    )

    is_download_enabled: Mapped[bool] = mapped_column(
        Boolean,
        default=True,
    )
    is_favorites_enabled: Mapped[bool] = mapped_column(
        Boolean,
        default=True,
    )

    expires_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True),
        nullable=True,
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
    )


class GalleryPhoto(Base):
    __tablename__ = "gallery_photos"

    id: Mapped[int] = mapped_column(primary_key=True)

    gallery_id: Mapped[int] = mapped_column(
        ForeignKey("galleries.id", ondelete="CASCADE"),
        index=True,
    )

    portfolio_photo_id: Mapped[int] = mapped_column(
        ForeignKey("portfolio_photos.id", ondelete="CASCADE"),
        index=True,
    )

    display_order: Mapped[int] = mapped_column(
        Integer,
        default=0,
    )

    __table_args__ = (
        UniqueConstraint(
            'gallery_id',
            'portfolio_photo_id',
            name='uq_gallery_photo',
        ),
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
    )


class GalleryAccess(Base):
    __tablename__ = "gallery_access"

    id: Mapped[int] = mapped_column(primary_key=True)

    gallery_id: Mapped[int] = mapped_column(
        ForeignKey("galleries.id", ondelete="CASCADE"),
        index=True,
    )

    client_id: Mapped[int] = mapped_column(
        ForeignKey("clients.id", ondelete="CASCADE"),
        index=True,
    )

    access_token_hash: Mapped[str] = mapped_column(
        String(255),
        unique=True,
        index=True,
    )

    is_active: Mapped[bool] = mapped_column(
        Boolean,
        default=True,
    )

    last_accessed_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True),
        nullable=True,
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
    )


class GalleryFavorite(Base):
    __tablename__ = "gallery_favorites"

    id: Mapped[int] = mapped_column(primary_key=True)

    gallery_id: Mapped[int] = mapped_column(
        ForeignKey("galleries.id", ondelete="CASCADE"),
        index=True,
    )

    gallery_photo_id: Mapped[int] = mapped_column(
        ForeignKey("gallery_photos.id", ondelete="CASCADE"),
        index=True,
    )

    client_id: Mapped[int] = mapped_column(
        ForeignKey("clients.id", ondelete="CASCADE"),
        index=True,
    )

    __table_args__ = (
        UniqueConstraint(
            'gallery_id',
            'gallery_photo_id',
            'client_id',
            name='uq_gallery_favorite',
        ),
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
    )


class GalleryDownload(Base):
    __tablename__ = "gallery_downloads"

    id: Mapped[int] = mapped_column(primary_key=True)

    gallery_id: Mapped[int] = mapped_column(
        ForeignKey("galleries.id", ondelete="CASCADE"),
        index=True,
    )

    gallery_photo_id: Mapped[int] = mapped_column(
        ForeignKey("gallery_photos.id", ondelete="CASCADE"),
        nullable=True,
        index=True,
    )

    client_id: Mapped[int] = mapped_column(
        ForeignKey("clients.id", ondelete="CASCADE"),
        index=True,
    )

    downloaded_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
    )

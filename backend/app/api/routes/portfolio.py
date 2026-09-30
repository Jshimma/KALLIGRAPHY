from datetime import datetime
from pathlib import Path
import shutil
from uuid import uuid4

from fastapi import (
    APIRouter,
    Depends,
    File,
    Form,
    HTTPException,
    UploadFile,
    status,
)
from sqlalchemy.orm import Session

from app.core.roles import UserRole
from app.db.session import get_db
from app.models.portfolio import PortfolioPhoto
from app.models.user import User
from app.schemas.portfolio import (
    PortfolioCategoryCreate,
    PortfolioCategoryResponse,
    PortfolioPhotoResponse,
)
from app.security.authorization import require_role
from app.services.portfolio import create_category, list_categories
from app.services.portfolio_photos import (
    ALLOWED_MIME_TYPES,
    InvalidPhotoError,
    create_portfolio_photo,
)
from app.services.storage import TEMP_DIR


router = APIRouter(
    prefix="/photographer/portfolio",
    tags=["portfolio"],
)


@router.get(
    "/categories",
    response_model=list[PortfolioCategoryResponse],
)
def get_categories(
    db: Session = Depends(get_db),
    _: User = Depends(
        require_role(UserRole.PHOTOGRAPHER, UserRole.ADMIN)
    ),
) -> list:
    return list_categories(db)


@router.post(
    "/categories",
    response_model=PortfolioCategoryResponse,
    status_code=status.HTTP_201_CREATED,
)
def add_category(
    payload: PortfolioCategoryCreate,
    db: Session = Depends(get_db),
    _: User = Depends(
        require_role(UserRole.PHOTOGRAPHER, UserRole.ADMIN)
    ),
) -> object:
    return create_category(
        db,
        name=payload.name,
        slug=payload.slug,
        description=payload.description,
        display_order=payload.display_order,
    )


@router.post(
    "/photos",
    response_model=PortfolioPhotoResponse,
    status_code=status.HTTP_201_CREATED,
)
def upload_photo(
    file: UploadFile = File(...),
    title: str = Form(...),
    description: str | None = Form(None),
    category_id: int | None = Form(None),
    location: str | None = Form(None),
    captured_at: datetime | None = Form(None),
    featured: bool = Form(False),
    display_order: int = Form(0),
    db: Session = Depends(get_db),
    _: User = Depends(
        require_role(UserRole.PHOTOGRAPHER, UserRole.ADMIN)
    ),
) -> PortfolioPhoto:
    suffix = Path(file.filename or "").suffix.lower()
    mime_type = file.content_type or ""

    if mime_type not in ALLOWED_MIME_TYPES:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Unsupported image type",
        )

    TEMP_DIR.mkdir(parents=True, exist_ok=True)

    temporary_path = TEMP_DIR / f"upload-{uuid4().hex}{suffix}"

    try:
        with temporary_path.open("wb") as destination:
            shutil.copyfileobj(file.file, destination)

        return create_portfolio_photo(
            db,
            source=temporary_path,
            original_filename=file.filename or "upload",
            mime_type=mime_type,
            title=title,
            description=description,
            category_id=category_id,
            location=location,
            captured_at=captured_at,
            featured=featured,
            display_order=display_order,
        )

    except InvalidPhotoError as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(exc),
        ) from exc

    finally:
        temporary_path.unlink(missing_ok=True)
        file.file.close()

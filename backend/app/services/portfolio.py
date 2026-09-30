from sqlalchemy import select
from sqlalchemy.orm import Session

from app.models.portfolio import PortfolioCategory


def list_categories(db: Session) -> list[PortfolioCategory]:
    return list(
        db.scalars(
            select(PortfolioCategory)
            .order_by(
                PortfolioCategory.display_order,
                PortfolioCategory.name,
            )
        ).all()
    )


def get_category(
    db: Session,
    category_id: int,
) -> PortfolioCategory | None:
    return db.get(PortfolioCategory, category_id)


def create_category(
    db: Session,
    *,
    name: str,
    slug: str,
    description: str | None,
    display_order: int,
) -> PortfolioCategory:
    category = PortfolioCategory(
        name=name,
        slug=slug,
        description=description,
        display_order=display_order,
    )

    db.add(category)
    db.commit()
    db.refresh(category)

    return category

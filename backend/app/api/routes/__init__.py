from app.api.routes.auth import router as auth_router
from app.api.routes.photographer import router as photographer_router
from app.api.routes.portfolio import router as portfolio_router

__all__ = [
    "auth_router",
    "photographer_router",
    "portfolio_router",
]

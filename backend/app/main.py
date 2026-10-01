from fastapi import FastAPI

from app.api.routes import (
    auth_router,
    photographer_router,
    portfolio_router,
)


app = FastAPI(
    title="KALLYGRAPHY API",
    version="1.0.0",
)


app.include_router(auth_router)
app.include_router(photographer_router)
app.include_router(portfolio_router)

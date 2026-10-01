from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.routes import (
    auth_router,
    inquiries_router,
    photographer_router,
    portfolio_router,
)

app = FastAPI(
    title="KALLYGRAPHY API",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "https://musical-broccoli-7vx47jqwqwjp2xqp7-8080.app.github.dev",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


app.include_router(auth_router)
app.include_router(inquiries_router)
app.include_router(photographer_router)
app.include_router(portfolio_router)

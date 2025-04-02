from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer
from typing import Optional
import uvicorn
from database import engine, Base
from app.api import users, aid_requests, volunteers

# Create database tables
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Disaster Relief Platform API",
    description="API for connecting disaster victims with volunteers and relief organizations",
    version="1.0.0"
)

# CORS middleware configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# OAuth2 scheme for token authentication
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

# Include routers
app.include_router(users.router)
app.include_router(aid_requests.router)
app.include_router(volunteers.router)

@app.get("/")
async def root():
    return {
        "message": "Welcome to the Disaster Relief Platform API",
        "docs_url": "/docs",
        "redoc_url": "/redoc"
    }

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True) 
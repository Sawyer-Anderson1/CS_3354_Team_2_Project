# 1_code/main.py

import os
import sys
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.gzip import GZipMiddleware
import firebase_admin
from firebase_admin import credentials, firestore
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Ensure the current directory is in sys.path for module discovery
current_dir = os.path.dirname(os.path.abspath(__file__))
if current_dir not in sys.path:
    sys.path.insert(0, current_dir)

# Import routers
from app.api import users, aid_requests, volunteers, resources, alerts
from database import engine, Base
from models import UserRole, User

# Create database tables
Base.metadata.create_all(bind=engine)

# Firebase Admin SDK Setup
try:
    cred_path = os.getenv("GOOGLE_APPLICATION_CREDENTIALS", "serviceAccountKey.json")
    if not os.path.exists(cred_path):
        raise FileNotFoundError(f"Service account key file not found at: {cred_path}")
    
    if not firebase_admin._apps:
        cred = credentials.Certificate(cred_path)
        firebase_admin.initialize_app(cred)
        print("Firebase Admin SDK initialized successfully.")
    else:
        print("Firebase Admin SDK already initialized.")
except Exception as e:
    print(f"Error during Firebase initialization: {e}")
    exit(1)

# FastAPI Application Setup
app = FastAPI(
    title="Crowdsourced Disaster Relief Platform",
    description="API for connecting disaster victims with volunteers and relief organizations",
    version="1.0.0"
)

# Add middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
app.add_middleware(GZipMiddleware, minimum_size=1000)

# Include routers
app.include_router(users.router)
app.include_router(aid_requests.router)
app.include_router(volunteers.router)
app.include_router(resources.router)
app.include_router(alerts.router)

# Root endpoint
@app.get("/")
async def root():
    return {
        "message": "Welcome to the Disaster Relief Platform API",
        "docs_url": "/docs",
        "redoc_url": "/redoc"
    }

# Health check endpoint
@app.get("/health")
async def health_check():
    return {"status": "healthy"}

# Error handlers
@app.exception_handler(HTTPException)
async def http_exception_handler(request, exc):
    return {
        "detail": exc.detail,
        "status_code": exc.status_code
    }

# Startup event
@app.lifespan("startup")
async def startup_event():
    # Initialize admin user if not exists
    from database import SessionLocal
    from auth import get_password_hash
    
    db = SessionLocal()
    try:
        admin = db.query(User).filter(User.email == "admin@example.com").first()
        if not admin:
            admin_user = User(
                email="admin@example.com",
                hashed_password=get_password_hash("admin123"),  # Change this in production!
                full_name="System Administrator",
                role=UserRole.ADMIN,
                is_active=True
            )
            db.add(admin_user)
            db.commit()
            print("Admin user created successfully")
    finally:
        db.close()

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8001, reload=True)
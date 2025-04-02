from sqlalchemy.orm import Session
from database import SessionLocal, engine
import models
from auth import get_password_hash

def init_db():
    # Create all tables
    models.Base.metadata.create_all(bind=engine)
    
    db = SessionLocal()
    try:
        # Check if admin user exists
        admin = db.query(models.User).filter(models.User.email == "admin@example.com").first()
        if not admin:
            # Create admin user
            admin_user = models.User(
                email="admin@example.com",
                hashed_password=get_password_hash("admin123"),  # Change this in production!
                full_name="System Administrator",
                role=models.UserRole.ADMIN,
                is_active=True
            )
            db.add(admin_user)
            db.commit()
            print("Admin user created successfully")
        else:
            print("Admin user already exists")
    finally:
        db.close()

if __name__ == "__main__":
    print("Initializing database...")
    init_db()
    print("Database initialization complete") 
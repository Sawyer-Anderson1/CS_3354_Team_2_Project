from sqlalchemy import Boolean, Column, ForeignKey, Integer, String, Float, DateTime, Enum
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime
import enum

Base = declarative_base()

class UserRole(str, enum.Enum):
    VICTIM = "victim"
    VOLUNTEER = "volunteer"
    NGO = "ngo"
    ADMIN = "admin"

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    hashed_password = Column(String)
    full_name = Column(String)
    role = Column(Enum(UserRole))
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # Relationships
    aid_requests = relationship("AidRequest", back_populates="requester")
    volunteer_profile = relationship("VolunteerProfile", back_populates="user", uselist=False)

class VolunteerProfile(Base):
    __tablename__ = "volunteer_profiles"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    skills = Column(String)  # Comma-separated list of skills
    availability = Column(Boolean, default=True)
    current_latitude = Column(Float)
    current_longitude = Column(Float)
    last_location_update = Column(DateTime)

    # Relationships
    user = relationship("User", back_populates="volunteer_profile")
    assigned_requests = relationship("AidRequest", back_populates="assigned_volunteer")

class AidRequest(Base):
    __tablename__ = "aid_requests"

    id = Column(Integer, primary_key=True, index=True)
    requester_id = Column(Integer, ForeignKey("users.id"))
    type = Column(String)  # e.g., "medical", "food", "shelter"
    description = Column(String)
    latitude = Column(Float)
    longitude = Column(Float)
    status = Column(String)  # "pending", "assigned", "completed"
    created_at = Column(DateTime, default=datetime.utcnow)
    assigned_volunteer_id = Column(Integer, ForeignKey("volunteer_profiles.id"), nullable=True)

    # Relationships
    requester = relationship("User", back_populates="aid_requests")
    assigned_volunteer = relationship("VolunteerProfile", back_populates="assigned_requests") 
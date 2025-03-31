from pydantic import BaseModel, EmailStr, Field
from typing import Optional, List
from datetime import datetime
from models import UserRole

class UserBase(BaseModel):
    email: EmailStr
    full_name: str
    role: UserRole

class UserCreate(UserBase):
    password: str

class User(UserBase):
    id: int
    is_active: bool
    created_at: datetime

    class Config:
        from_attributes = True

class VolunteerProfileBase(BaseModel):
    skills: str
    availability: bool = True
    current_latitude: Optional[float] = None
    current_longitude: Optional[float] = None

class VolunteerProfileCreate(VolunteerProfileBase):
    pass

class VolunteerProfile(VolunteerProfileBase):
    id: int
    user_id: int
    last_location_update: Optional[datetime]

    class Config:
        from_attributes = True

class AidRequestBase(BaseModel):
    type: str
    description: str
    latitude: float
    longitude: float

class AidRequestCreate(AidRequestBase):
    pass

class AidRequest(AidRequestBase):
    id: int
    requester_id: int
    status: str
    created_at: datetime
    assigned_volunteer_id: Optional[int]

    class Config:
        from_attributes = True

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    email: Optional[str] = None 
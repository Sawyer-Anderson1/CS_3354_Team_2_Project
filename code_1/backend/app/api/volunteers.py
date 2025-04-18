from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from datetime import datetime

from database import get_db
import models
import schemas
from auth import get_current_active_user

router = APIRouter(
    prefix="/volunteers",
    tags=["volunteers"]
)

@router.post("/profile", response_model=schemas.VolunteerProfile)
def create_volunteer_profile(
    profile: schemas.VolunteerProfileCreate,
    current_user: models.User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    if current_user.role != models.UserRole.VOLUNTEER:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only volunteers can create profiles"
        )
    
    # Check if profile already exists
    existing_profile = db.query(models.VolunteerProfile).filter(
        models.VolunteerProfile.user_id == current_user.id
    ).first()
    if existing_profile:
        raise HTTPException(
            status_code=400,
            detail="Profile already exists"
        )
    
    db_profile = models.VolunteerProfile(
        **profile.dict(),
        user_id=current_user.id
    )
    db.add(db_profile)
    db.commit()
    db.refresh(db_profile)
    return db_profile

@router.get("/profile", response_model=schemas.VolunteerProfile)
def read_volunteer_profile(
    current_user: models.User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    if current_user.role != models.UserRole.VOLUNTEER:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only volunteers can access profiles"
        )
    
    profile = db.query(models.VolunteerProfile).filter(
        models.VolunteerProfile.user_id == current_user.id
    ).first()
    if not profile:
        raise HTTPException(
            status_code=404,
            detail="Profile not found"
        )
    return profile

@router.put("/profile", response_model=schemas.VolunteerProfile)
def update_volunteer_profile(
    profile_update: schemas.VolunteerProfileBase,
    current_user: models.User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    if current_user.role != models.UserRole.VOLUNTEER:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only volunteers can update profiles"
        )
    
    profile = db.query(models.VolunteerProfile).filter(
        models.VolunteerProfile.user_id == current_user.id
    ).first()
    if not profile:
        raise HTTPException(
            status_code=404,
            detail="Profile not found"
        )
    
    for field, value in profile_update.dict(exclude_unset=True).items():
        setattr(profile, field, value)
    
    if profile_update.current_latitude is not None or profile_update.current_longitude is not None:
        profile.last_location_update = datetime.utcnow()
    
    db.commit()
    db.refresh(profile)
    return profile

@router.get("/", response_model=List[schemas.VolunteerProfile])
def read_volunteers(
    skip: int = 0,
    limit: int = 100,
    current_user: models.User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    if current_user.role not in [models.UserRole.NGO, models.UserRole.ADMIN]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not enough permissions"
        )
    
    volunteers = db.query(models.VolunteerProfile).offset(skip).limit(limit).all()
    return volunteers

@router.put("/{volunteer_id}/availability", response_model=schemas.VolunteerProfile)
def update_volunteer_availability(
    volunteer_id: int,
    availability: bool,
    current_user: models.User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    if current_user.role != models.UserRole.VOLUNTEER:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only volunteers can update availability"
        )
    
    profile = db.query(models.VolunteerProfile).filter(
        models.VolunteerProfile.id == volunteer_id
    ).first()
    if not profile:
        raise HTTPException(
            status_code=404,
            detail="Profile not found"
        )
    
    if profile.user_id != current_user.id:
        raise HTTPException(
            status_code=403,
            detail="Not authorized to update this profile"
        )
    
    profile.availability = availability
    db.commit()
    db.refresh(profile)
    return profile 
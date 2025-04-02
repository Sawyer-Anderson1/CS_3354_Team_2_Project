from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from datetime import datetime

from database import get_db
import models
import schemas
from auth import get_current_active_user
from matching import find_matching_volunteers

router = APIRouter(
    prefix="/aid-requests",
    tags=["aid-requests"]
)

@router.post("/", response_model=schemas.AidRequest)
def create_aid_request(
    request: schemas.AidRequestCreate,
    current_user: models.User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    if current_user.role != models.UserRole.VICTIM:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only victims can create aid requests"
        )
    
    db_request = models.AidRequest(
        **request.dict(),
        requester_id=current_user.id,
        status="pending"
    )
    db.add(db_request)
    db.commit()
    db.refresh(db_request)
    
    # Find matching volunteers
    matches = find_matching_volunteers(db, db_request)
    # TODO: Send notifications to matched volunteers
    
    return db_request

@router.get("/", response_model=List[schemas.AidRequest])
def read_aid_requests(
    skip: int = 0,
    limit: int = 100,
    current_user: models.User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    if current_user.role == models.UserRole.VICTIM:
        requests = db.query(models.AidRequest).filter(
            models.AidRequest.requester_id == current_user.id
        ).offset(skip).limit(limit).all()
    elif current_user.role == models.UserRole.VOLUNTEER:
        requests = db.query(models.AidRequest).filter(
            models.AidRequest.status == "pending"
        ).offset(skip).limit(limit).all()
    else:  # NGO or ADMIN
        requests = db.query(models.AidRequest).offset(skip).limit(limit).all()
    return requests

@router.get("/{request_id}", response_model=schemas.AidRequest)
def read_aid_request(
    request_id: int,
    current_user: models.User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    request = db.query(models.AidRequest).filter(models.AidRequest.id == request_id).first()
    if not request:
        raise HTTPException(status_code=404, detail="Aid request not found")
    
    if current_user.role == models.UserRole.VICTIM and request.requester_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not enough permissions")
    
    return request

@router.put("/{request_id}/status", response_model=schemas.AidRequest)
def update_request_status(
    request_id: int,
    status: str,
    current_user: models.User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    request = db.query(models.AidRequest).filter(models.AidRequest.id == request_id).first()
    if not request:
        raise HTTPException(status_code=404, detail="Aid request not found")
    
    if current_user.role not in [models.UserRole.VOLUNTEER, models.UserRole.ADMIN]:
        raise HTTPException(status_code=403, detail="Not enough permissions")
    
    if current_user.role == models.UserRole.VOLUNTEER:
        volunteer_profile = db.query(models.VolunteerProfile).filter(
            models.VolunteerProfile.user_id == current_user.id
        ).first()
        if not volunteer_profile:
            raise HTTPException(status_code=404, detail="Volunteer profile not found")
        
        if request.assigned_volunteer_id != volunteer_profile.id:
            raise HTTPException(status_code=403, detail="Not assigned to this request")
    
    request.status = status
    if status == "completed":
        request.assigned_volunteer_id = None
    
    db.commit()
    db.refresh(request)
    return request

@router.put("/{request_id}/assign", response_model=schemas.AidRequest)
def assign_volunteer(
    request_id: int,
    volunteer_id: int,
    current_user: models.User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    if current_user.role not in [models.UserRole.NGO, models.UserRole.ADMIN]:
        raise HTTPException(status_code=403, detail="Not enough permissions")
    
    request = db.query(models.AidRequest).filter(models.AidRequest.id == request_id).first()
    if not request:
        raise HTTPException(status_code=404, detail="Aid request not found")
    
    volunteer_profile = db.query(models.VolunteerProfile).filter(
        models.VolunteerProfile.id == volunteer_id
    ).first()
    if not volunteer_profile:
        raise HTTPException(status_code=404, detail="Volunteer profile not found")
    
    request.assigned_volunteer_id = volunteer_id
    request.status = "assigned"
    
    db.commit()
    db.refresh(request)
    return request 
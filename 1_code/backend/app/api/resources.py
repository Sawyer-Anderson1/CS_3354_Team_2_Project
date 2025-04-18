from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from datetime import datetime

from database import get_db, get_firestore
import models
import schemas
from auth import get_current_active_user

router = APIRouter(
    prefix="/resources",
    tags=["resources"]
)

@router.post("/", response_model=schemas.Resource)
def create_resource(
    resource: schemas.ResourceCreate,
    current_user: models.User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """
    Create a new resource entry. Only NGO and ADMIN roles can create resources.
    """
    if current_user.role not in [models.UserRole.NGO, models.UserRole.ADMIN]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only NGOs and admins can create resources"
        )
    
    db_resource = models.Resource(
        **resource.dict(),
        created_by=current_user.id,
        created_at=datetime.utcnow()
    )
    db.add(db_resource)
    db.commit()
    db.refresh(db_resource)
    
    # Also store in Firestore for real-time updates
    firestore_db = get_firestore()
    resource_data = {
        **resource.dict(),
        "id": str(db_resource.id),
        "created_by": str(current_user.id),
        "created_at": datetime.utcnow().isoformat(),
        "updated_at": datetime.utcnow().isoformat()
    }
    firestore_db.collection("resources").document(str(db_resource.id)).set(resource_data)
    
    return db_resource

@router.get("/", response_model=List[schemas.Resource])
def read_resources(
    skip: int = 0,
    limit: int = 100,
    region: str = None,
    resource_type: str = None,
    db: Session = Depends(get_db)
):
    """
    List all resources with optional filtering by region and type.
    """
    query = db.query(models.Resource)
    
    if region:
        query = query.filter(models.Resource.region == region)
    if resource_type:
        query = query.filter(models.Resource.resource_type == resource_type)
    
    return query.offset(skip).limit(limit).all()

@router.get("/{resource_id}", response_model=schemas.Resource)
def read_resource(
    resource_id: int,
    db: Session = Depends(get_db)
):
    """
    Get a specific resource by ID.
    """
    resource = db.query(models.Resource).filter(models.Resource.id == resource_id).first()
    if not resource:
        raise HTTPException(status_code=404, detail="Resource not found")
    return resource

@router.put("/{resource_id}", response_model=schemas.Resource)
def update_resource(
    resource_id: int,
    resource_update: schemas.ResourceUpdate,
    current_user: models.User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """
    Update a resource. Only the creator, NGO, or ADMIN can update.
    """
    resource = db.query(models.Resource).filter(models.Resource.id == resource_id).first()
    if not resource:
        raise HTTPException(status_code=404, detail="Resource not found")
    
    if (current_user.role not in [models.UserRole.NGO, models.UserRole.ADMIN] and 
        resource.created_by != current_user.id):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to update this resource"
        )
    
    for field, value in resource_update.dict(exclude_unset=True).items():
        setattr(resource, field, value)
    
    resource.updated_at = datetime.utcnow()
    db.commit()
    db.refresh(resource)
    
    # Update Firestore
    firestore_db = get_firestore()
    resource_data = {
        **resource_update.dict(exclude_unset=True),
        "updated_at": datetime.utcnow().isoformat()
    }
    firestore_db.collection("resources").document(str(resource_id)).update(resource_data)
    
    return resource

@router.delete("/{resource_id}")
def delete_resource(
    resource_id: int,
    current_user: models.User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """
    Delete a resource. Only the creator, NGO, or ADMIN can delete.
    """
    resource = db.query(models.Resource).filter(models.Resource.id == resource_id).first()
    if not resource:
        raise HTTPException(status_code=404, detail="Resource not found")
    
    if (current_user.role not in [models.UserRole.NGO, models.UserRole.ADMIN] and 
        resource.created_by != current_user.id):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to delete this resource"
        )
    
    db.delete(resource)
    db.commit()
    
    # Delete from Firestore
    firestore_db = get_firestore()
    firestore_db.collection("resources").document(str(resource_id)).delete()
    
    return {"message": "Resource deleted successfully"} 
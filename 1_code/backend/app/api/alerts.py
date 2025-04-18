from fastapi import APIRouter, Depends, HTTPException, status, WebSocket
from sqlalchemy.orm import Session
from typing import List
from datetime import datetime
import json

from database import get_db, get_firestore
import models
import schemas
from auth import get_current_active_user

router = APIRouter(
    prefix="/alerts",
    tags=["alerts"]
)

# Store active WebSocket connections
active_connections = set()

@router.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    active_connections.add(websocket)
    try:
        while True:
            # Keep the connection alive
            await websocket.receive_text()
    except Exception:
        active_connections.remove(websocket)

async def broadcast_alert(alert_data: dict):
    """
    Broadcast an alert to all connected WebSocket clients.
    """
    for connection in active_connections:
        try:
            await connection.send_json(alert_data)
        except Exception:
            active_connections.remove(connection)

@router.post("/", response_model=schemas.Alert)
async def create_alert(
    alert: schemas.AlertCreate,
    current_user: models.User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """
    Create a new emergency alert. Only NGO and ADMIN roles can create alerts.
    """
    if current_user.role not in [models.UserRole.NGO, models.UserRole.ADMIN]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only NGOs and admins can create alerts"
        )
    
    db_alert = models.Alert(
        **alert.dict(),
        created_by=current_user.id,
        created_at=datetime.utcnow()
    )
    db.add(db_alert)
    db.commit()
    db.refresh(db_alert)
    
    # Store in Firestore for real-time updates
    firestore_db = get_firestore()
    alert_data = {
        **alert.dict(),
        "id": str(db_alert.id),
        "created_by": str(current_user.id),
        "created_at": datetime.utcnow().isoformat()
    }
    firestore_db.collection("alerts").document(str(db_alert.id)).set(alert_data)
    
    # Broadcast the alert to all connected clients
    await broadcast_alert(alert_data)
    
    return db_alert

@router.get("/", response_model=List[schemas.Alert])
def read_alerts(
    skip: int = 0,
    limit: int = 100,
    region: str = None,
    alert_type: str = None,
    severity: str = None,
    db: Session = Depends(get_db)
):
    """
    List all alerts with optional filtering by region, type, and severity.
    """
    query = db.query(models.Alert)
    
    if region:
        query = query.filter(models.Alert.region == region)
    if alert_type:
        query = query.filter(models.Alert.alert_type == alert_type)
    if severity:
        query = query.filter(models.Alert.severity == severity)
    
    return query.order_by(models.Alert.created_at.desc()).offset(skip).limit(limit).all()

@router.get("/{alert_id}", response_model=schemas.Alert)
def read_alert(
    alert_id: int,
    db: Session = Depends(get_db)
):
    """
    Get a specific alert by ID.
    """
    alert = db.query(models.Alert).filter(models.Alert.id == alert_id).first()
    if not alert:
        raise HTTPException(status_code=404, detail="Alert not found")
    return alert

@router.put("/{alert_id}", response_model=schemas.Alert)
async def update_alert(
    alert_id: int,
    alert_update: schemas.AlertUpdate,
    current_user: models.User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """
    Update an alert. Only the creator, NGO, or ADMIN can update.
    """
    alert = db.query(models.Alert).filter(models.Alert.id == alert_id).first()
    if not alert:
        raise HTTPException(status_code=404, detail="Alert not found")
    
    if (current_user.role not in [models.UserRole.NGO, models.UserRole.ADMIN] and 
        alert.created_by != current_user.id):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to update this alert"
        )
    
    for field, value in alert_update.dict(exclude_unset=True).items():
        setattr(alert, field, value)
    
    db.commit()
    db.refresh(alert)
    
    # Update Firestore
    firestore_db = get_firestore()
    alert_data = {
        **alert_update.dict(exclude_unset=True),
        "updated_at": datetime.utcnow().isoformat()
    }
    firestore_db.collection("alerts").document(str(alert_id)).update(alert_data)
    
    # Broadcast the update to all connected clients
    await broadcast_alert({
        "type": "update",
        "alert_id": str(alert_id),
        **alert_data
    })
    
    return alert

@router.delete("/{alert_id}")
async def delete_alert(
    alert_id: int,
    current_user: models.User = Depends(get_current_active_user),
    db: Session = Depends(get_db)
):
    """
    Delete an alert. Only the creator, NGO, or ADMIN can delete.
    """
    alert = db.query(models.Alert).filter(models.Alert.id == alert_id).first()
    if not alert:
        raise HTTPException(status_code=404, detail="Alert not found")
    
    if (current_user.role not in [models.UserRole.NGO, models.UserRole.ADMIN] and 
        alert.created_by != current_user.id):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized to delete this alert"
        )
    
    db.delete(alert)
    db.commit()
    
    # Delete from Firestore
    firestore_db = get_firestore()
    firestore_db.collection("alerts").document(str(alert_id)).delete()
    
    # Broadcast the deletion to all connected clients
    await broadcast_alert({
        "type": "delete",
        "alert_id": str(alert_id)
    })
    
    return {"message": "Alert deleted successfully"} 
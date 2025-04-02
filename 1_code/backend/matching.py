from sklearn.neighbors import NearestNeighbors
import numpy as np
from typing import List, Tuple
from sqlalchemy.orm import Session
import models
from math import radians, sin, cos, sqrt, atan2

def haversine_distance(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
    """Calculate the great circle distance between two points on Earth."""
    R = 6371  # Earth's radius in kilometers

    lat1, lon1, lat2, lon2 = map(radians, [lat1, lon1, lat2, lon2])
    dlat = lat2 - lat1
    dlon = lon2 - lon1

    a = sin(dlat/2)**2 + cos(lat1) * cos(lat2) * sin(dlon/2)**2
    c = 2 * atan2(sqrt(a), sqrt(1-a))
    distance = R * c

    return distance

def create_volunteer_feature_vector(volunteer: models.VolunteerProfile) -> np.ndarray:
    """Create a feature vector for a volunteer based on their skills and location."""
    # Simple feature vector: [latitude, longitude]
    # Can be extended with more features like skills encoding
    return np.array([volunteer.current_latitude, volunteer.current_longitude])

def find_matching_volunteers(
    db: Session,
    aid_request: models.AidRequest,
    max_distance: float = 50.0,  # Maximum distance in kilometers
    k: int = 3  # Number of volunteers to return
) -> List[Tuple[models.VolunteerProfile, float]]:
    """Find the k nearest available volunteers for an aid request."""
    
    # Get all available volunteers
    available_volunteers = (
        db.query(models.VolunteerProfile)
        .filter(models.VolunteerProfile.availability == True)
        .all()
    )

    if not available_volunteers:
        return []

    # Create feature vectors for all volunteers
    volunteer_features = np.array([
        create_volunteer_feature_vector(v) for v in available_volunteers
    ])

    # Create feature vector for the aid request
    # will probably need to add more features to this
    # such as the type of aid request and help needed, level of urgency, etc.
    request_features = np.array([[aid_request.latitude, aid_request.longitude]])

    # Initialize and fit the nearest neighbors model
    nbrs = NearestNeighbors(n_neighbors=min(k, len(available_volunteers)), algorithm='ball_tree')
    nbrs.fit(volunteer_features)

    # Find k nearest neighbors
    distances, indices = nbrs.kneighbors(request_features)

    # Filter volunteers within max_distance and create result list
    matches = []
    for distance, idx in zip(distances[0], indices[0]):
        # Convert distance to kilometers (assuming coordinates are in degrees)
        distance_km = haversine_distance(
            aid_request.latitude,
            aid_request.longitude,
            available_volunteers[idx].current_latitude,
            available_volunteers[idx].current_longitude
        )
        
        if distance_km <= max_distance:
            matches.append((available_volunteers[idx], distance_km))

    return sorted(matches, key=lambda x: x[1])  # Sort by distance

def calculate_matching_score(
    volunteer: models.VolunteerProfile,
    aid_request: models.AidRequest
) -> float:
    """Calculate a matching score between a volunteer and an aid request."""
    # Base score is inverse of distance
    distance = haversine_distance(
        aid_request.latitude,
        aid_request.longitude,
        volunteer.current_latitude,
        volunteer.current_longitude
    )
    
    # Avoid division by zero
    distance_score = 1 / (1 + distance)
    
    # Add skill matching score here if needed
    # For now, we're just using distance
    
    return distance_score 
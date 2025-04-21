# 1_code/matching_ai.py

import numpy as np
from sklearn.neighbors import NearestNeighbors
from sklearn.preprocessing import OneHotEncoder, StandardScaler
import joblib  # For persistence (if needed in the future)
from geopy.geocoders import Nominatim
from geopy.exc import GeocoderTimedOut, GeocoderServiceError
from typing import List, Dict, Any, Tuple
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Configuration and Encoder Setup
KNOWN_SKILLS = ['Medical', 'Food Logistics', 'Rescue', 'Shelter Management', 
                'Transportation', 'Communication', 'General Labor', 'Technical Support',
                'Psychological Support', 'Language Translation']

REQUEST_TYPES = ['Medical', 'Food', 'Shelter', 'Rescue', 'Transport', 'Communication',
                'Technical', 'Psychological', 'Translation', 'Other']

URGENCY_LEVELS = ['low', 'medium', 'high', 'critical']

encoder_skills = OneHotEncoder(categories=[KNOWN_SKILLS], sparse_output=False, handle_unknown='ignore')
encoder_skills.fit(np.array(KNOWN_SKILLS).reshape(-1, 1))

encoder_types = OneHotEncoder(categories=[REQUEST_TYPES], sparse_output=False, handle_unknown='ignore')
encoder_types.fit(np.array(REQUEST_TYPES).reshape(-1, 1))

# Initialize geolocator with better error handling
geolocator = Nominatim(user_agent="disaster_matching_ai", timeout=10)

def get_lat_long(address: str) -> Tuple[float, float]:
    """
    Convert an address string to a (latitude, longitude) tuple with improved error handling.
    Returns (0.0, 0.0) if the address cannot be resolved.
    """
    try:
        location = geolocator.geocode(address)
        if location:
            return location.latitude, location.longitude
        logger.warning(f"Could not geocode address: {address}")
    except (GeocoderTimedOut, GeocoderServiceError) as e:
        logger.error(f"Geocoding error for address {address}: {str(e)}")
    return (0.0, 0.0)

def calculate_distance(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
    """
    Calculate the Haversine distance between two points in kilometers.
    """
    R = 6371  # Earth's radius in kilometers
    lat1, lon1, lat2, lon2 = map(np.radians, [lat1, lon1, lat2, lon2])
    dlat = lat2 - lat1
    dlon = lon2 - lon1
    a = np.sin(dlat/2)**2 + np.cos(lat1) * np.cos(lat2) * np.sin(dlon/2)**2
    c = 2 * np.arcsin(np.sqrt(a))
    return R * c

def extract_features_request(request_data: Dict[str, Any]) -> np.ndarray:
    """
    Enhanced feature extraction from an aid request.
    Includes type, location, urgency, and additional metadata.
    """
    try:
        req_type = request_data.get('type', '')
        encoded_type = encoder_types.transform([[req_type]])[0]
        
        lat, lon = get_lat_long(request_data.get('location', ''))
        
        urgency_mapping = {level: idx+1 for idx, level in enumerate(URGENCY_LEVELS)}
        urgency_score = urgency_mapping.get(request_data.get('urgency', 'low'), 1)
        
        # Additional features
        timestamp = request_data.get('timestamp', 0)
        num_people = request_data.get('num_people', 1)
        
        return np.concatenate((
            [lat, lon],
            encoded_type,
            [urgency_score, timestamp, num_people]
        ))
    except Exception as e:
        logger.error(f"Error extracting request features: {str(e)}")
        raise

def extract_features_volunteer(volunteer_data: Dict[str, Any]) -> np.ndarray:
    """
    Enhanced feature extraction from a volunteer profile.
    Includes skills, location, availability, and additional metadata.
    """
    try:
        skills = volunteer_data.get('skills', [])
        encoded_skills = np.zeros(len(KNOWN_SKILLS))
        for skill in skills:
            if skill in KNOWN_SKILLS:
                idx = KNOWN_SKILLS.index(skill)
                encoded_skills[idx] = 1
        
        lat, lon = get_lat_long(volunteer_data.get('location', ''))
        
        availability = 1 if volunteer_data.get('availability', False) else 0
        experience = volunteer_data.get('experience_years', 0)
        rating = volunteer_data.get('rating', 0)
        
        return np.concatenate((
            [lat, lon],
            encoded_skills,
            [availability, experience, rating]
        ))
    except Exception as e:
        logger.error(f"Error extracting volunteer features: {str(e)}")
        raise

def build_feature_matrix(volunteers: List[Dict[str, Any]]) -> np.ndarray:
    """
    Build a feature matrix from a list of volunteer dictionaries with error handling.
    """
    try:
        features = [extract_features_volunteer(vol) for vol in volunteers]
        return np.vstack(features)
    except Exception as e:
        logger.error(f"Error building feature matrix: {str(e)}")
        raise

def get_best_matches(request_features: np.ndarray, volunteers: List[Dict[str, Any]], 
                    k: int = 3, max_distance: float = 50.0) -> List[Dict[str, Any]]:
    """
    Enhanced matching function with distance constraints and better error handling.
    """
    try:
        if not volunteers:
            return []
            
        X = build_feature_matrix(volunteers)
        scaler = StandardScaler()
        X_scaled = scaler.fit_transform(X)
        req_scaled = scaler.transform([request_features])
        
        nn = NearestNeighbors(n_neighbors=min(k, len(volunteers)), metric='euclidean')
        nn.fit(X_scaled)
        distances, indices = nn.kneighbors(req_scaled)
        
        # Filter by distance and create matches
        matches = []
        for dist, idx in zip(distances[0], indices[0]):
            volunteer = volunteers[idx]
            req_lat, req_lon = request_features[0], request_features[1]
            vol_lat, vol_lon = X[idx][0], X[idx][1]
            
            actual_distance = calculate_distance(req_lat, req_lon, vol_lat, vol_lon)
            if actual_distance <= max_distance:
                matches.append({
                    'volunteer': volunteer,
                    'distance_km': actual_distance,
                    'matching_score': 1 / (1 + dist)  # Normalized matching score
                })
        
        return sorted(matches, key=lambda x: x['matching_score'], reverse=True)
        
    except Exception as e:
        logger.error(f"Error in matching process: {str(e)}")
        raise

def get_best_matches_debug(request_features: np.ndarray, volunteers: List[Dict[str, Any]], 
                          k: int = 3) -> Dict[str, Any]:
    """
    Debug function with detailed matching information and error handling.
    """
    try:
        if not volunteers:
            return {
                "message": "No volunteers available",
                "matched_volunteers": []
            }
            
        X = build_feature_matrix(volunteers)
        scaler = StandardScaler()
        X_scaled = scaler.fit_transform(X)
        req_scaled = scaler.transform([request_features])
        
        nn = NearestNeighbors(n_neighbors=min(k, len(volunteers)), metric='euclidean')
        nn.fit(X_scaled)
        distances, indices = nn.kneighbors(req_scaled)
        
        matches = []
        for dist, idx in zip(distances[0], indices[0]):
            volunteer = volunteers[idx]
            req_lat, req_lon = request_features[0], request_features[1]
            vol_lat, vol_lon = X[idx][0], X[idx][1]
            actual_distance = calculate_distance(req_lat, req_lon, vol_lat, vol_lon)
            
            matches.append({
                'volunteer': volunteer,
                'distance_km': actual_distance,
                'matching_score': 1 / (1 + dist),
                'feature_vector': X[idx].tolist()
            })
        
        return {
            "request_features": request_features.tolist(),
            "volunteer_features": X.tolist(),
            "X_scaled": X_scaled.tolist(),
            "req_scaled": req_scaled[0].tolist(),
            "distances": distances[0].tolist(),
            "indices": indices[0].tolist(),
            "matched_volunteers": matches
        }
        
    except Exception as e:
        logger.error(f"Error in debug matching: {str(e)}")
        return {
            "error": str(e),
            "message": "Error occurred during matching process"
        }
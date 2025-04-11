# 1_code/matching_ai.py

import numpy as np
from sklearn.neighbors import NearestNeighbors
from sklearn.preprocessing import OneHotEncoder, StandardScaler
import joblib  # For persistence (if needed in the future)
from geopy.geocoders import Nominatim
from geopy.exc import GeocoderTimedOut, GeocoderServiceError

# Configuration and Encoder Setup
KNOWN_SKILLS = ['Medical', 'Food Logistics', 'Rescue', 'Shelter Management', 'Transportation', 'Communication', 'General Labor']

encoder = OneHotEncoder(categories=[KNOWN_SKILLS], sparse_output=False, handle_unknown='ignore')
encoder.fit(np.array(KNOWN_SKILLS).reshape(-1, 1))

# Initialize global scaler (if needed) and geolocator
global_scaler = StandardScaler()  # Not used globally, as each matching gets its own scaler.
geolocator = Nominatim(user_agent="disaster_matching_ai")

# Geocoding Function
def get_lat_long(address):
    """
    Convert an address string to a (latitude, longitude) tuple.
    Returns (0.0, 0.0) if the address cannot be resolved.
    """
    try:
        location = geolocator.geocode(address, timeout=10)
        if location:
            return location.latitude, location.longitude
    except (GeocoderTimedOut, GeocoderServiceError):
        pass
    return (0.0, 0.0)

# Feature Extraction Functions
def extract_features_request(request_data):
    """
    Extract features from an aid request.
    Expected keys: 'type', 'location', 'urgency'
    Returns: [latitude, longitude] + one-hot encoded type + [urgency_score]
    """
    req_type = request_data.get('type', '')
    encoded_type = encoder.transform([[req_type]])[0]
    lat, lon = get_lat_long(request_data.get('location', ''))
    urgency_mapping = {"low": 1, "medium": 2, "high": 3}
    urgency_score = urgency_mapping.get(request_data.get('urgency', 'low'), 1)
    return np.concatenate(([lat, lon], encoded_type, [urgency_score]))

def extract_features_volunteer(volunteer_data):
    """
    Extract features from a volunteer.
    Expected keys: 'skills', 'location', 'availability'
    Returns: [latitude, longitude] + one-hot encoded skill + [availability_flag]
    """
    v_skill = volunteer_data.get('skills', '')
    encoded_skill = encoder.transform([[v_skill]])[0]
    lat, lon = get_lat_long(volunteer_data.get('location', ''))
    availability = 1 if volunteer_data.get('availability', 'available').lower() == 'available' else 0
    return np.concatenate(([lat, lon], encoded_skill, [availability]))

# Matching Functions
def build_feature_matrix(volunteers):
    """
    Build a feature matrix from a list of volunteer dictionaries.
    Each row represents one volunteer's feature vector.
    """
    features = [extract_features_volunteer(vol) for vol in volunteers]
    return np.vstack(features)

def get_best_matches(request_features, volunteers, k=3):
    """
    Production function: Uses KNN to find the top k matching volunteers.
    Returns a list of volunteer dictionaries for the best matches.
    """
    if not volunteers:
        return []
    X = build_feature_matrix(volunteers)
    scaler_local = StandardScaler()
    X_scaled = scaler_local.fit_transform(X)
    req_scaled = scaler_local.transform([request_features])
    nn = NearestNeighbors(n_neighbors=min(k, len(volunteers)), metric='euclidean')
    nn.fit(X_scaled)
    distances, indices = nn.kneighbors(req_scaled)
    matches = [volunteers[i] for i in indices[0]]
    return matches

def get_best_matches_debug(request_features, volunteers, k=3):
    """
    Debug function: Similar to get_best_matches, but returns detailed matching info.
    Returns a dictionary with:
      - Raw request feature vector.
      - Volunteer feature matrix.
      - Scaled feature matrix.
      - Scaled request vector.
      - Distances and indices from KNN.
      - Final matched volunteer dictionaries.
    """
    if not volunteers:
        return {
            "message": "No volunteers available",
            "matched_volunteers": []
        }
    X = build_feature_matrix(volunteers)
    from sklearn.preprocessing import StandardScaler
    scaler_local = StandardScaler()
    X_scaled = scaler_local.fit_transform(X)
    req_scaled = scaler_local.transform([request_features])
    nn = NearestNeighbors(n_neighbors=min(k, len(volunteers)), metric='euclidean')
    nn.fit(X_scaled)
    distances, indices = nn.kneighbors(req_scaled)
    distances_list = distances[0].tolist()
    indices_list = indices[0].tolist()
    matched_vols = [volunteers[i] for i in indices_list]
    return {
        "request_features": request_features.tolist(),
        "volunteer_features": X.tolist(),
        "X_scaled": X_scaled.tolist(),
        "req_scaled": req_scaled[0].tolist(),
        "distances": distances_list,
        "indices": indices_list,
        "matched_volunteers": matched_vols
    }
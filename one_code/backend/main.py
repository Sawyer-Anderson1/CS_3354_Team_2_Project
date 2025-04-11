# 1_code/main.py

import os
import sys

# Ensure the current directory is in sys.path for module discovery.
current_dir = os.path.dirname(os.path.abspath(__file__))
if current_dir not in sys.path:
    sys.path.insert(0, current_dir)

# Import the necessary functions from matching_ai.
from matching_ai import extract_features_request, get_best_matches  # production matching
# We will use get_best_matches_debug for the debug endpoint.
import numpy as np
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from firebase_admin import credentials, firestore
import firebase_admin

# Firebase Admin SDK Setup
try:
    # Set the service account key path via environment variable, default to "1_code/serviceAccountKey.json".
    cred_path = os.getenv("GOOGLE_APPLICATION_CREDENTIALS", "1_code/serviceAccountKey.json")
    if not os.path.exists(cred_path):
        raise FileNotFoundError(f"Service account key file not found at: {cred_path}. Set GOOGLE_APPLICATION_CREDENTIALS.")
    
    if not firebase_admin._apps:
        cred = credentials.Certificate(cred_path)
        firebase_admin.initialize_app(cred)
        print("Firebase Admin SDK initialized successfully.")
    else:
        print("Firebase Admin SDK already initialized.")
except FileNotFoundError as fnf_error:
    print(f"Error: {fnf_error}")
    exit(1)
except Exception as e:
    print(f"Unexpected error during Firebase initialization: {e}")
    exit(1)

# Get Firestore client.
try:
    db = firestore.client()
    print("Firestore client obtained successfully.")
except Exception as e:
    print(f"Error obtaining Firestore client: {e}")
    exit(1)


# FastAPI Application Setup
app = FastAPI(title="Crowdsourced Disaster Relief API (Firebase)")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Firestore collection references.
volunteers_ref = db.collection('volunteers')
requests_ref = db.collection('requests')

# API Endpoints
@app.get("/")
def read_root():
    return {"message": "Welcome to the Crowdsourced Disaster Relief API (Firebase)"}

@app.get("/match/{request_id}")
def match_volunteers_firebase(request_id: str):
    """
    Production endpoint: returns matched volunteers for the given request_id.
    """
    try:
        request_doc = requests_ref.document(request_id).get()
        if not request_doc.exists:
            raise HTTPException(status_code=404, detail="Request not found")
        req_data = request_doc.to_dict()
        req_data['id'] = request_doc.id
    except Exception as e:
        print(f"Error fetching request {request_id}: {e}")
        raise HTTPException(status_code=500, detail=f"Error fetching request data: {e}")

    try:
        volunteer_docs = volunteers_ref.stream()
        all_volunteers = []
        for doc in volunteer_docs:
            v_data = doc.to_dict()
            v_data['id'] = doc.id
            all_volunteers.append(v_data)
        if not all_volunteers:
            raise HTTPException(status_code=404, detail="No volunteers available")
    except Exception as e:
        print(f"Error fetching volunteers: {e}")
        raise HTTPException(status_code=500, detail=f"Error fetching volunteer data: {e}")

    # Extract features from the request.
    request_features = extract_features_request(req_data)
    # Perform AI matching using KNN.
    matches = get_best_matches(request_features, all_volunteers, k=3)
    return {"matched_volunteers": matches}

@app.get("/debug-match/{request_id}")
def debug_match(request_id: str):
    """
    Debug endpoint: returns detailed matching process information.
    """
    try:
        request_doc = requests_ref.document(request_id).get()
        if not request_doc.exists:
            raise HTTPException(status_code=404, detail="Request not found")
        req_data = request_doc.to_dict()
        req_data['id'] = request_doc.id
    except Exception as e:
        print(f"Error fetching request {request_id}: {e}")
        raise HTTPException(status_code=500, detail=f"Error fetching request data: {e}")

    try:
        volunteer_docs = volunteers_ref.stream()
        all_volunteers = []
        for doc in volunteer_docs:
            v_data = doc.to_dict()
            v_data['id'] = doc.id
            all_volunteers.append(v_data)
        if not all_volunteers:
            raise HTTPException(status_code=404, detail="No volunteers available")
    except Exception as e:
        print(f"Error fetching volunteers: {e}")
        raise HTTPException(status_code=500, detail=f"Error fetching volunteer data: {e}")

    # Extract the request feature vector.
    request_features = extract_features_request(req_data)
    
    # Import the debug function from matching_ai.
    try:
        from matching_ai import get_best_matches_debug
    except ImportError:
        raise HTTPException(status_code=500, detail="Debug matching function not found in matching_ai.py")
    
    debug_data = get_best_matches_debug(request_features, all_volunteers, k=3)
    return debug_data
# 1_code/main.py

import os
import sys

    # Ensure the current directory is in sys.path for module discovery.
current_dir = os.path.dirname(os.path.abspath(__file__))
if current_dir not in sys.path:
        sys.path.insert(0, current_dir)

    # Import the necessary functions from matching_ai.
from matching_ai import extract_features_request, get_best_matches, get_best_matches_debug
import numpy as np
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from firebase_admin import credentials, firestore
import firebase_admin

    # Import your new router(s)
from routers import resources # Import the resources router

    # ---------------------------------------------------------------------------
    # Firebase Admin SDK Setup
    # ---------------------------------------------------------------------------
try:
        # Set the service account key path via environment variable, default to "1_code/serviceAccountKey.json".
        cred_path = os.getenv("GOOGLE_APPLICATION_CREDENTIALS", os.path.join(current_dir, "serviceAccountKey.json")) # Use current_dir
        if not os.path.exists(cred_path):
            raise FileNotFoundError(f"Service account key file not found at: {cred_path}. Set GOOGLE_APPLICATION_CREDENTIALS or place key file correctly.")

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

    # ---------------------------------------------------------------------------
    # FastAPI Application Setup
    # ---------------------------------------------------------------------------
app = FastAPI(title="Crowdsourced Disaster Relief API (Firebase)")

    # Add CORS middleware (already configured to be open)
app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"], # Allows all origins
        allow_credentials=True,
        allow_methods=["*"], # Allows all methods
        allow_headers=["*"], # Allows all headers
    )

    # Include your routers here
app.include_router(resources.router)
    # --- Include other routers (donations, auth, etc.) when you create them ---
    # Example: from routers import donations, auth
    # app.include_router(donations.router)
    # app.include_router(auth.router)


    # Firestore collection references (can be moved to routers or kept here)
volunteers_ref = db.collection('volunteers')
requests_ref = db.collection('requests')
    # Add reference for resources if needed globally, or handle within the router
    # resources_ref = db.collection('resources')

    # ---------------------------------------------------------------------------
    # Existing Matching API Endpoints (Keep these)
    # ---------------------------------------------------------------------------
@app.get("/")
def read_root():
        return {"message": "Welcome to the Crowdsourced Disaster Relief API (Firebase)"}

@app.get("/match/{request_id}", tags=["Matching"]) # Add tag for organization
def match_volunteers_firebase(request_id: str):
        """
        Production endpoint: returns matched volunteers for the given request_id.
        """
        try:
            request_doc = requests_ref.document(request_id).get()
            if not request_doc.exists:
                raise HTTPException(status_code=404, detail="Request not found")
            req_data = request_doc.to_dict()
            req_data['id'] = request_doc.id # Add the ID to the data
        except Exception as e:
            print(f"Error fetching request {request_id}: {e}")
            raise HTTPException(status_code=500, detail=f"Error fetching request data: {e}")

        try:
            volunteer_docs = volunteers_ref.stream()
            all_volunteers = []
            for doc in volunteer_docs:
                v_data = doc.to_dict()
                v_data['id'] = doc.id # Add the ID to the data
                all_volunteers.append(v_data)
            if not all_volunteers:
                # Return empty list instead of 404 if no volunteers exist
                return {"matched_volunteers": []}
                # raise HTTPException(status_code=404, detail="No volunteers available")
        except Exception as e:
            print(f"Error fetching volunteers: {e}")
            raise HTTPException(status_code=500, detail=f"Error fetching volunteer data: {e}")

        try:
            # Extract features from the request.
            request_features = extract_features_request(req_data)
            # Perform AI matching using KNN.
            matches = get_best_matches(request_features, all_volunteers, k=3)
            return {"matched_volunteers": matches}
        except Exception as e:
            # Handle potential errors during feature extraction or matching
            print(f"Error during matching for request {request_id}: {e}")
            raise HTTPException(status_code=500, detail=f"Error performing volunteer matching: {e}")


@app.get("/debug-match/{request_id}", tags=["Matching"]) # Add tag for organization
def debug_match(request_id: str):
        """
        Debug endpoint: returns detailed matching process information.
        """
        try:
            request_doc = requests_ref.document(request_id).get()
            if not request_doc.exists:
                raise HTTPException(status_code=404, detail="Request not found")
            req_data = request_doc.to_dict()
            req_data['id'] = request_doc.id # Add the ID to the data
        except Exception as e:
            print(f"Error fetching request {request_id}: {e}")
            raise HTTPException(status_code=500, detail=f"Error fetching request data: {e}")

        try:
            volunteer_docs = volunteers_ref.stream()
            all_volunteers = []
            for doc in volunteer_docs:
                v_data = doc.to_dict()
                v_data['id'] = doc.id # Add the ID to the data
                all_volunteers.append(v_data)
            if not all_volunteers:
                 raise HTTPException(status_code=404, detail="No volunteers available for debug matching")
                # Return specific debug message if no volunteers
                # return {"message": "No volunteers available for debug matching", "matched_volunteers": []}
        except Exception as e:
            print(f"Error fetching volunteers: {e}")
            raise HTTPException(status_code=500, detail=f"Error fetching volunteer data: {e}")

        try:
            # Extract the request feature vector.
            request_features = extract_features_request(req_data)

            # Import the debug function from matching_ai.
            # (Already imported at the top)

            debug_data = get_best_matches_debug(request_features, all_volunteers, k=3)
            return debug_data
        except Exception as e:
             # Handle potential errors during feature extraction or matching
            print(f"Error during debug matching for request {request_id}: {e}")
            raise HTTPException(status_code=500, detail=f"Error performing debug volunteer matching: {e}")


    # Add a simple check for Firestore initialization at startup (optional)
@app.on_event("startup")
async def startup_event():
        try:
            # Attempt a simple read to verify connection/permissions
            # This is just an example, might impact startup time slightly
            await db.collection('volunteers').limit(1).get()
            print("Firestore connection verified on startup.")
        except Exception as e:
            print(f"WARNING: Firestore connection check failed on startup: {e}")
            # Decide if you want to exit or just log the warning
            # exit(1)

    # Note: If you run this with `uvicorn main:app --reload`, it will restart on code changes.
    
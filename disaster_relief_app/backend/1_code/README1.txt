Project: Crowdsourced Disaster Relief Platform – AI Matching Backend
Course: CS 3354 Spring 2025
Group: 2
Members: Casey Nguyen, Kevin Pulikkottil, Andy Jih, Sawyer Anderson

Overview:
This backend system is designed to streamline disaster relief by matching victims’ aid requests with volunteers using an AI-powered matching algorithm. The system is built with FastAPI and integrates with Firebase Firestore for persistent data storage. The AI matching module (located in matching_ai.py) extracts key features such as request type, location, urgency, volunteer skills, and availability and uses a K-Nearest Neighbors (KNN) algorithm (via scikit-learn) to determine the best matches.

Key Features:
  - FastAPI-based RESTful backend.
  - Firebase Firestore integration.
  - AI Matching using:
      • One-hot encoding to process request types and volunteer skills.
      • Geocoding (using geopy) to transform addresses to latitude/longitude.
      • KNN to compute and rank volunteer matches.
  - Production endpoint: /match/{request_id}
  - Debug endpoint: /debug-match/{request_id} (returns detailed matching process data)
  - Unit testing with pytest.
  - Optional Docker support for containerized deployment.

Directory Structure (excerpt):
  1_code/
    ├── main.py                → FastAPI entry point (includes /match and /debug-match endpoints)
    ├── matching_ai.py         → AI module for feature extraction and matching logic
    ├── docker-compose.yml     → Docker configuration (optional)
    ├── serviceAccountKey.json → Firebase credentials (manually added; excluded from Git)
    └── venv/                  → Virtual environment (excluded from Git)
  (Additional folders: 2_data_collection/, 3_basic_function_testing/, etc.)

Notes:
  - Ensure your serviceAccountKey.json is placed in the 1_code/ directory.
  - The debug endpoint is provided for development purposes only.
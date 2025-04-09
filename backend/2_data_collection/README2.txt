Overview:
This module provides a script to populate your Firebase Firestore database with sample data. This sample data is used for testing and to demonstrate the AI-powered matching functionality by providing volunteer profiles and disaster aid requests.

Prerequisites:
  1. Firebase Credentials:
     - Download your Firebase service account key JSON file.
     - Rename it to "serviceAccountKey.json" and place it in the 1_code/ directory.
     - (This file is excluded from Git via .gitignore.)
  2. Environment Setup:
     - Run "make setup" to create the virtual environment (located at 1_code/venv/) and install all dependencies from 1_code/requirements.txt.

Populating the Database:
To seed the Firestore database with sample data, run:
   make populate-db

What the Script Does:
  - Connects to Firebase using the service account key.
  - Clears existing documents from the "volunteers" and "requests" collections.
  - Inserts 7 sample volunteer records and 6 aid requests (with predefined IDs such as "101", "102", etc.) using batch writes for efficiency.

Expected Console Output (sample):
  Firebase Admin SDK initialized successfully for population script.
  Firestore client obtained successfully.
  Running Firestore population script...
  Clearing existing data...
  Deleted 7 documents from volunteers.
  Deleted 6 documents from requests.
  Existing data cleared.
  Adding 7 volunteers...
  Adding 6 requests...
  Firestore populated successfully using batch writes.
  Population script finished.
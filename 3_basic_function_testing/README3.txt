Overview:
This module contains automated tests for the AI volunteer matching system. 
These tests verify that the matching endpoint works as expected for valid and invalid request IDs.
This is our basic function testing 

Prerequisites:
  - Populate the Firestore database with sample data using:
      make populate-db
  - Start the FastAPI backend server (ensure it is accessible at http://localhost:8000) using:
      make run

Running Tests:
Execute the following command to run the tests:
   make test

Testing Details:
  - The tests in test_matching.py validate that:
      • Valid request IDs (e.g., /match/101, /match/102) return an HTTP 200 status with a JSON payload containing "matched_volunteers".
      • An invalid request ID (e.g., /match/999) returns an appropriate error (typically a 404).
  - Additionally, you can use the debug endpoint (/debug-match/{request_id}) to view detailed information about the matching process, 
  such as:
      • Raw feature vectors for the request.
      • The feature matrix and scaled vectors for volunteers.
      • Distance calculations and nearest neighbor indices.
      • Final matched volunteer records.

Sample Test Output:
   3_basic_function_testing/test_matching.py ..... [100%]

Note:
  - Update the test cases in test_matching.py as your data or AI logic evolves.
  - Make sure the backend server and Firebase are running before running the tests.
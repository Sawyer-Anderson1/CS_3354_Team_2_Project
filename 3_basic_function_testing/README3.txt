README3.txt

Crowdsourced Disaster Relief Platform - Basic Function Testing
==============================================================

Project: Crowdsourced Disaster Relief Platform
Course: CS 3354 Spring 2025
Group Number: 2
Group Members: Casey Nguyen, Kevin Pulikkottil, Andy Jih, Sawyer

Description:
------------
This folder includes scripts for running basic functional tests against your backend API endpoints. These tests ensure the backend responds correctly to requests, providing clear feedback for Flutter frontend integration.

Included Files:
---------------
- `test_matching.py`: A Python script to automatically test the volunteer matching endpoint `/match/{request_id}`.

Prerequisites:
--------------
- Python 3.9 or later
- Backend running locally on `http://localhost:8000`
- Dependencies installed:
  ```bash
  pip install requests
  ```

Running the Basic Functional Tests:
-----------------------------------
1. Ensure your FastAPI backend (`main.py`) is running:
   ```bash
   uvicorn main:app --reload
   ```

2. Execute the test script from your project's root directory:
   ```bash
   python test_matching.py
   ```

3. You will see clearly formatted results indicating success or failure for each request:
   ```
   ✅ Request ID 101 - Success:
   {"matched_volunteers": [{...}]}
   ------------------------------------------------------------
   ❌ Request ID 999 - Failed:
   Status: 404, Error: {"error": "Request not found"}
   ------------------------------------------------------------
   ```

Flutter Integration Notes:
--------------------------
Use these test cases to verify that your backend consistently returns correct responses to the Flutter frontend. The test results provide example data structures your Flutter app should correctly parse and handle.

Test IDs and Expected Results:
------------------------------
- Successful Responses:
  - `101`, `102`, `103`, `104`: Valid requests returning matched volunteers.

- Failed Response:
  - `999`: Non-existent request to verify proper error handling.

Adjust or expand the test cases in `test_matching.py` as necessary for additional coverage.

README2.txt

Crowdsourced Disaster Relief Platform - Data Collection Scripts
===============================================================

Project: Crowdsourced Disaster Relief Platform
Course: CS 3354 Spring 2025
Group Number: 2
Group Members: Casey Nguyen, Kevin Pulikkottil, Andy Jih, Sawyer

Description:
------------
This folder provides scripts to populate your PostgreSQL database with initial test data, essential for demonstrating and testing your backend API, specifically tailored for integration with a Flutter frontend.

Included Files:
---------------
- `populate_database.py`: Python script to automatically insert predefined volunteers and disaster aid requests into the PostgreSQL database.

Prerequisites:
--------------
- Python 3.9 or later
- PostgreSQL database (`disaster_relief`) created
- Python dependencies installed:
  ```bash
  pip install sqlalchemy psycopg2-binary
  ```

Running the Data Collection Script:
-----------------------------------
1. Ensure PostgreSQL is running and the backend is set up.

2. (Optional) Set `DATABASE_URL` environment variable or modify it directly in `populate_database.py`:
   ```bash
   export DATABASE_URL="postgresql://postgres:password@localhost/disaster_relief"
   ```

3. Execute the script from your project's root directory:
   ```bash
   python populate_database.py
   ```

4. Successful execution will output:
   ```
   Database populated successfully with volunteers and aid requests.
   ```

Flutter Integration Notes:
--------------------------
This data population is structured to support clear frontend integration with Flutter. Use this data to verify that the Flutter app correctly retrieves and displays matched volunteers.

Sample Data for Testing:
------------------------
- Volunteers:
  - Alice (Medical, Houston)
  - Bob (Food Logistics, Austin)
  - Charlie (Rescue, Dallas)
  - Diana (Shelter Management, San Antonio)
  - Ethan (Medical, Fort Worth)

- Requests:
  - 101: Medical in Houston
  - 102: Food in Austin
  - 103: Rescue in Dallas
  - 104: Shelter in San Antonio

These records are ideal for initial demonstrations and API endpoint verification through your Flutter frontend.
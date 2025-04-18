Project: Crowdsourced Disaster Relief Platform 
Course: CS 3354 Spring 2025
Group: 2
Members: Casey Nguyen, Kevin Pulikkottil, Andy Jih, Sawyer Anderson

Overview:
- This backend system is designed to streamline disaster relief by matching victims’ aid requests with volunteers using an 
AI-powered matching algorithm. The system is built with FastAPI and integrates with Firebase Firestore for persistent data storage. 
The AI matching module (located in matching_ai.py) extracts key features such as request type, location, urgency, volunteer skills, 
and availability and uses a K-Nearest Neighbors (KNN) algorithm (via scikit-learn) to determine the best matches.
- The webiste and system has 5 initial features on thr frontend. The first function is the resource inventory screen where users 
can click on and see the curret resources available in their area. The second function will be a page where users can request for help. 
They can identify what kind of help they need and a description of it. The they will use the geolocator to pinpot their exact location 
and then send it to the system where it will AI match with the nearest help and further instructions. The third function is a donations 
page where users can donate money or resources. The fourth page is where users can see emergency alerts. The alerts will be displayed 
nd will be marked as old or new and if it is still on going or not. The last page for this setup is a sign up and sign in page where 
users can sign up or log in. Their data will get sent to our database for storage in deliverable 2. 

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
  - Resource Inventory Screen 
  - User Request Posting Screen 
  - Donations Screen
  - Emergency Alerts Screen 
  - Sign Up / Sign In Screen 

HOW TO RUN
## Testing

**Step 1: Create a Firebase Project**

1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Click **“Add project”** and follow the steps (you can skip Google Analytics if you prefer).
3. Once created, your project dashboard will load. You’re now ready to generate a key.

**Step 2: Generate a Service Account Private Key**

1. In the Firebase Console, click the ⚙️ **gear icon** next to **Project Overview** and choose **Project settings**.
2. Go to the **Service accounts** tab.
3. Make sure **Python** is selected under  **Admin SDK configuration snippet** **.**
4. Click the blue **“Generate new private key”** button.
5. A **.json** key file will download to your system automatically.

**Step 3: Rename and Move the Key File**

1. Rename the downloaded **.json** file to:

```
serviceAccountKey.json
```

Move this file into `code_1/backend`

**Step 4: Running the Code**

Now, run:

```bash
make run-all # starts both the backend and frontend
```

If you get error 48, run `lsof -i :8001` and then kill the listed processes via `kill -9 PID1 PID2` and then rerun. You should run this after every program run.

Uses `pytest` to validate:

- Successful match queries
- Data structure of responses
- Handling of invalid IDs

Run:

```
make test
```

DEPENDENCIES:
-------------
- flutter
- flutter_localizations
- http
- etc 

NOTES:
------
- Runs entirely in Chrome (no Android/iOS needed).
- Ensure your serviceAccountKey.json is placed in the 1_code/ directory.
- The debug endpoint is provided for development purposes only.


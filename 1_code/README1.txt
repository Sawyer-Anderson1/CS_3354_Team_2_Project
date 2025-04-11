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

HOW TO RUN (for Web):
-----------------------
- Our project we all did on VSCode. Make sure to have flutter installed as an extenstion 
- Then download the flutter SDK on your laptop, preferably in your downloads folder 
- After that follow the on screen instructions 
- Open our zipfile and download the main code 
- Open our code, navigate to one_code (flutter doesnt allow numbers)
- in VSCode, on the bottom right, click for chrome to run as a webiste 
- go to the one_code/lib/main.dart file and run our code on the play button
- there, out website will be loaded in the debug stage 
- all 5 buttons on the screen should be working
- only exception is sign up and sign in as it works we just need to integrate the backend for data storage but professor said do it for 
deliverable 2
- Also follow the below instructions from the official flutter page. in the terminal flutter pub get is important so run that after 
downloading and opening the code. Or just go to pubspec.yaml and save with command + S on mac to run pub get

1. Make sure Flutter is installed and enabled for web:
   flutter channel stable
   flutter upgrade
   flutter config --enable-web

2. Install dependencies:
   flutter pub get

3. Run on Chrome:
   flutter run -d chrome

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


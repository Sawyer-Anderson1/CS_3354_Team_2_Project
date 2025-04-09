# Crowdsourced Disaster Relief Platform (CS 3354 - Team 2)

## Overview

This project is a platform designed to connect victims, volunteers, and potentially NGOs during disaster situations. It aims to streamline relief efforts by providing features like aid requests, resource inventory management, donations, emergency alerts, and an AI-powered system to match volunteers with relevant aid requests based on skills and location.

The project consists of a Flutter frontend (for web, mobile, and desktop) and a Python FastAPI backend interacting with a Firebase Firestore database.

## Features

* **AI Volunteer Matching:** Backend service matches volunteers to aid requests based on skills, location, urgency, and availability (using KNN). (`/match/{request_id}` endpoint implemented).
* **Aid Request Posting:** Frontend screen allows users to submit requests for help, capturing type, description, and location. (Frontend implemented,  **needs backend endpoint for creation** ).
* **Resource Inventory:** Frontend screen displays available resources. (Frontend implemented using local JSON,  **needs backend CRUD endpoints** ).
* **Donations:** Frontend screen allows users to submit donations. (Frontend implemented using local JSON,  **needs backend CRUD endpoints** ).
* **Emergency Alerts:** Frontend screen displays emergency alerts. (Frontend implemented using local JSON,  **needs backend CRUD endpoints** ).
* **User Authentication:** Frontend screen for Sign Up / Sign In. (Frontend implemented,  **needs backend Auth endpoints** ).

## Technology Stack

* **Backend:**
  * Python 3
  * FastAPI (Web framework)
  * Uvicorn (ASGI server)
  * Firebase Admin SDK (for Firestore interaction)
  * Scikit-learn (for KNN matching)
  * Geopy (for geocoding addresses)
  * Pydantic (Data validation)
* **Frontend:**
  * Flutter (UI framework)
  * Dart
  * `http` package (for API calls)
  * `geolocator` package (for location)
* **Database:**
  * Google Cloud Firestore (NoSQL cloud database)
* **Development & Deployment:**
  * Git & GitHub (Version control)
  * Makefile (Backend task automation)
  * Docker & Docker Compose (Optional containerization for backend)

## Project Structure

```plaintext
CS_3354_Team_2_Project/
├── .gitignore                  # Git ignore configuration
├── backend/                    # Contains backend code and related files
│   ├── 1_code/                 # FastAPI backend source code
│   │   ├── main.py             # FastAPI app entry point, includes matching endpoints
│   │   ├── matching_ai.py      # AI module for feature extraction and KNN matching
│   │   ├── requirements.txt    # Python dependencies
│   │   ├── serviceAccountKey.json  # Firebase credentials (MUST BE ADDED MANUALLY)
│   │   ├── routers/            # API routers (e.g., resources.py)
│   │   ├── models/             # Pydantic models (e.g., resource_models.py)
│   │   ├── docker-compose.yml  # Docker configuration (optional)
│   │   └── venv/               # Python virtual environment (created by 'make setup')
│   ├── 2_data_collection/      # Data collection scripts
│   │   └── populate_database.py  # Script to populate Firestore with sample data
│   ├── 3_basic_function_testing/  # Basic function testing scripts
│   │   └── test_matching.py    # Pytest tests for the matching endpoint
│   └── 4_documentation/        # Project documentation files (.docx)
├── Makefile                    # Backend task runner
└── README.md               	# Specific README for the backend part
├── frontend/                   # Contains the main Flutter frontend project
│   ├── lib/                    # Flutter codebase
│   │   ├── main.dart           # Flutter app entry point
│   │   ├── models/             # Dart data models (Resource, Donation, etc.)
│   │   ├── screens/            # Flutter UI screens
│   │   └── services/           # Dart services for API calls / data fetching
│   ├── assets/                 # Static assets (JSON data - currently used)
│   ├── android/                # Android specific files
│   ├── ios/                    # iOS specific files
│   ├── web/                    # Web specific files
│   ├── windows/                # Windows specific files
│   ├── macos/                  # macOS specific files
│   ├── linux/                  # Linux specific files
│   ├── test/                   # Flutter tests
│   └── pubspec.yaml            # Flutter dependencies
└── README.md                   # Main project README
```

*(Note: The root project directory is `CS_3354_Team_2_Project`.)*

## Prerequisites

* **Git:** For cloning the repository.
* **Python:** Version 3.9 or newer.
* **Flutter SDK:** Install for your operating system ([Flutter installation guide](https://docs.flutter.dev/get-started/install)). Ensure `flutter doctor` runs without critical errors.
* **Firebase Project:**
  * Create a Firebase project on the [Firebase Console](https://console.firebase.google.com/).
  * Enable Firestore Database in your project.
  * Generate a private key file (Service Account key) for your project.
* **IDE:** VS Code, Android Studio, or IntelliJ IDEA with Flutter and Dart plugins recommended.
* **Docker & Docker Compose:** (Optional) If you plan to use Docker for running the backend.

## Setup Instructions

1. **Clone the Repository:**
   ```bash
   git clone <your-repository-url>
   cd <repository-directory>
   ```
2. **Firebase Setup:**
   * Download the private key JSON file you generated from your Firebase project settings (Service Accounts tab).
   * **Rename** this file to `serviceAccountKey.json`.
   * **Place** this `serviceAccountKey.json` file inside the `backend/1_code/` directory.
   * **IMPORTANT:** Ensure this file is listed in your root `.gitignore` file (it should be, based on the example provided earlier) to prevent committing it.
3. **Backend Setup:**
   * Open your terminal in the **root directory** of the project (where the `Makefile` is).
   * Run the setup command:
     ```bash
     make setup
     ```
   * This will create a Python virtual environment inside `backend/1_code/venv/` and install all backend dependencies listed in `requirements.txt`.
4. **Frontend Setup:**
   * Navigate to the Flutter project directory:
     ```bash
     cd frontend
     ```
   * Get Flutter dependencies:
     ```bash
     flutter pub get
     ```
   * Go back to the root directory:
     ```bash
     cd ..
     ```
5. **Populate Database (Optional but Recommended):**
   * To add sample data (volunteers, requests) to your Firestore database for testing the matching feature:
     ```bash
     make populate-db
     ```

## Running the Application (Backend + Frontend)

To run the full application, you need both the backend server and the frontend client running simultaneously.

**Step 1: Run the Backend Server**

* Open a terminal in the **root directory** of the project.
* Run the backend using the Makefile:
  ```bash
  make run
  ```
* This command starts the FastAPI server using Uvicorn. It will typically be accessible at `http://0.0.0.0:8000`. Keep this terminal window open.
* You should see output indicating the server is running, like:
  ```
  INFO:     Uvicorn running on [http://0.0.0.0:8000](http://0.0.0.0:8000) (Press CTRL+C to quit)
  INFO:     Started reloader process [...]
  INFO:     Started server process [...]
  INFO:     Waiting for application startup.
  Firebase Admin SDK initialized successfully.
  Firestore client obtained successfully.
  Firestore connection verified on startup.
  INFO:     Application startup complete.
  ```

**Step 2: Configure Frontend Backend URL**

* The Flutter app needs to know the URL of the running backend. This URL depends on where you are running the Flutter app:
  * **Flutter Web (`flutter run -d chrome`):** Use `http://localhost:8000` or `http://127.0.0.1:8000`.
  * **Android Emulator:** Use `http://10.0.2.2:8000` (this special IP routes to the host machine's localhost).
  * **iOS Simulator:** Use `http://localhost:8000` or `http://127.0.0.1:8000`.
  * **Physical Device (Android/iOS):** Use your computer's local network IP address (e.g., `http://192.168.1.105:8000`). Find your IP using `ipconfig` (Windows) or `ifconfig` (macOS/Linux). Your device must be on the same Wi-Fi network as your computer.
* **Update the Code:** Open the service files in the Flutter project (`frontend/lib/services/`). Find the `_baseUrl` constant (as shown in the `resource_service.dart` example provided previously) and set it to the correct URL for your target platform.
  * *Example (`resource_service.dart`):*
    ```dart
    // const String _baseUrl = 'http://10.0.2.2:8000'; // For Android Emulator
    const String _baseUrl = 'http://localhost:8000'; // For Web/iOS Sim
    // const String _baseUrl = 'http://192.168.1.105:8000'; // For Physical Device (replace IP)
    ```
  * **IMPORTANT:** You will need to add this `_baseUrl` constant and update all service files (`auth_service.dart`, `donation_service.dart`, etc.) as you implement the backend API calls for them.

**Step 3: Run the Frontend Application**

* Open a **new** terminal window.
* Navigate to the Flutter project directory:
  ```bash
  cd frontend
  ```
* Choose your target device/platform and run:
  * **Web (Chrome):** `flutter run -d chrome`
  * **Connected Emulator/Simulator:** `flutter run` (usually picks the running one automatically)
  * **Specific Device:** `flutter run -d <device_id>` (Find device IDs with `flutter devices`)
* The Flutter application should build and launch on your chosen target. It will now attempt to communicate with the backend server running at the URL you configured in Step 2.

## Backend Details

* The backend is built using FastAPI, providing asynchronous request handling.
* It connects to Firestore using the Firebase Admin SDK. Credentials must be provided via `serviceAccountKey.json`.
* The core implemented feature is AI-powered volunteer matching using `matching_ai.py`.
* API documentation (Swagger UI) is automatically available at `http://localhost:8000/docs` when the server is running.
* CORS is configured to allow requests from any origin (`*`) for development ease.

## Frontend Details

* The frontend is built using Flutter, allowing cross-platform deployment (Web, Android, iOS, Desktop).
* It uses a standard structure with screens (`lib/screens/`), data models (`lib/models/`), and services (`lib/services/`) for interacting with data (currently mostly local JSON, needs updating for API calls).
* Key packages include `http` for API calls and `geolocator` for location services.

## Integration Status & Next Steps

* **Current State:** The backend primarily provides the AI matching endpoints (`/match`, `/debug-match`). The frontend has UI screens for most features but currently loads data for Resources, Donations, Alerts, and Requests from static JSON files in the `assets/` directory. Authentication calls a placeholder URL.
* **Major Task:** The main integration work involves **implementing the missing backend API endpoints** for CRUD operations (Create, Read, Update, Delete) for Resources, Donations, Alerts, Requests (Create), and implementing Authentication/Authorization. These endpoints need to interact with the Firestore database.
* **Frontend Updates:** Once the backend endpoints are available, the corresponding Flutter service files in `lib/services/` must be updated to call these APIs using the `http` package, replacing the local JSON loading logic. The example provided for `resource_service.dart` demonstrates this pattern.

## Makefile Usage (Backend)

The `Makefile` in the root directory helps manage backend tasks:

* `make setup`: Initializes the Python environment and installs dependencies.
* `make run`: Starts the FastAPI development server.
* `make test`: Runs backend tests.
* `make populate-db`: Seeds Firestore with sample data.
* `make docker-up`: Runs the backend using Docker (optional).
* `make docker-down`: Stops Docker services (optional).
* `make clean`: Removes `__pycache__` files.
* `make help`: Shows available commands.

*(Refer to the `Makefile` itself for detailed commands)*

## Team / Contributing

*(Optional: Add team member names/roles or guidelines for contributing if this were a shared/open project).*

* Casey Nguyen
* Kevin Pulikkottil
* Andy Jih
* Sawyer Anderson

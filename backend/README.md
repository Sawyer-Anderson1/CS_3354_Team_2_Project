# CS 3354 Team 2 Project: Crowdsourced Disaster Relief Platform - AI Matching Backend

This project is a FastAPI-based volunteer/request matching system that interacts with a Firebase Firestore database. It leverages an AI-powered matching module to intelligently connect disaster aid requests with the most appropriate volunteers. The project includes a backend service, data population scripts, functional tests, and optional Docker support.

---

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/Sawyer-Anderson1/CS_3354_Team_2_Project.git
cd CS_3354_Team_2_Project
```

### 2. Set Up Your Environment

```bash
make setup
```

This command will:

- Create a Python virtual environment in `1_code/venv/`
- Install all dependencies from `1_code/requirements.txt`

---

## Firebase Setup

1. **Download** your Firebase service account key (JSON file).
2. **Place it** in the `1_code/` directory.
3. **Ensure the filename is:** `serviceAccountKey.json`

> This file is excluded from Git using `.gitignore` and must be added manually.

---

## Running the Backend Server

Start the FastAPI server with:

```bash
make run
```

This command:

- Activates the virtual environment.
- Sets the `GOOGLE_APPLICATION_CREDENTIALS` environment variable.
- Launches the server at [http://localhost:8000](http://localhost:8000).

Swagger UI is available at [http://localhost:8000/docs](http://localhost:8000/docs).

---

## AI Matching Implementation

The backend uses an AI matching module (in `matching_ai.py`) to process disaster aid requests and match them with volunteers. The process includes:

- **Feature Extraction:**The module converts request and volunteer data into numerical feature vectors using:

  - One-hot encoding for categorical attributes (request type and volunteer skills)
  - Geocoding (using geopy) to convert addresses into latitude/longitude coordinates
  - Numeric mapping for urgency (for requests) and availability (for volunteers)
- **KNN Matching:**The feature vectors are normalized using StandardScaler, and scikit-learn’s K-Nearest Neighbors (KNN) algorithm computes Euclidean distances to determine the top matches.
- **Debug Endpoint:**A dedicated endpoint (`/debug-match/{request_id}`) returns detailed matching information including:

  - Raw feature vectors
  - Scaled feature matrices
  - Distance calculations and neighbor indices
  - The final list of matched volunteer records

---

## Populating the Firestore Database

Populate your Firestore database with sample data by running:

```bash
make populate-db
```

This command:

- Connects to Firebase using your service account key.
- Clears existing documents from the `volunteers` and `requests` collections.
- Inserts sample data (7 volunteer records and 6 aid requests with predefined IDs) using batch writes for efficiency.

---

## Running Tests

To run unit tests for the matching endpoint, execute:

```bash
make test
```

This command uses pytest to run tests defined in `3_basic_function_testing/test_matching.py`. The tests verify that:

- Valid request IDs (e.g., `/match/101`, `/match/102`) return HTTP 200 with a properly formed JSON response.
- An invalid request ID (e.g., `/match/999`) returns the appropriate error (404).

---

## Docker (Optional)

> **Note:** Ensure Docker Desktop is running before using Docker commands.

### Starting Docker Containers

```bash
make docker-up
```

If Docker Desktop isn't running, you'll see an error. Start Docker Desktop, then try again.

### Stopping Docker Containers

Stop the server with CTRL+C and then run:

```bash
make docker-down
```

---

## Project Structure

```
CS_3354_Team_2_Project/
├── 1_code/
│   ├── main.py                  # FastAPI app with /match and /debug-match endpoints
│   ├── matching_ai.py           # AI module for feature extraction and KNN matching
│   ├── docker-compose.yml       # Docker configuration (optional)
│   ├── serviceAccountKey.json   # Firebase credentials (manually added; not in Git)
│   └── venv/                    # Python virtual environment (excluded from Git)
├── 2_data_collection/
│   └── populate_database.py     # Script to populate Firestore with sample data
├── 3_basic_function_testing/
│   └── test_matching.py         # Pytest tests for the matching endpoint
├── requirements.txt             # Python dependencies
├── Makefile                     # CLI shortcuts (setup, run, test, populate-db, Docker)
├── .gitignore                   # Excludes sensitive files and auto-generated content
└── README.md                    # This comprehensive project documentation
```

---

## Cleaning Up

To remove auto-generated files and `__pycache__` folders, run:

```bash
make clean
```

---

## Sample API Output

### Standard Matching Endpoint

**API Call:**

```
GET http://localhost:8000/match/101
```

**Sample JSON Response:**

```json
{
  "matched_volunteers": [
    {
      "id": "Ez7DJu4ZGrTljzHbiazy",
      "name": "Alice",
      "skills": "Medical",
      "location": "Houston, TX"
    },
    {
      "id": "AbozkwHssJX2zBEWlLXb",
      "name": "Ethan",
      "skills": "Medical",
      "location": "Fort Worth, TX"
    },
    {
      "id": "CNMZLygFonduGYU06vrg",
      "name": "Fiona",
      "skills": "Transportation",
      "location": "Houston, TX"
    }
  ]
}
```

### Debug Matching Endpoint

To view detailed matching information, visit:

```
GET http://localhost:8000/debug-match/101
```

This endpoint returns debugging details such as:

- Raw and scaled feature vectors for the aid request and volunteers.
- Distance calculations and neighbor indices from the KNN matching process.
- The final list of matched volunteer records.

---

## Notes

- The Makefile automates common tasks (setup, run, test, populate-db, Docker).
- Docker commands require Docker Desktop to be running.
- Ensure the `serviceAccountKey.json` file is placed in the `1_code/` directory and is not committed to Git.
- The debug endpoint is intended for development purposes only; secure or disable it in production.
- The AI matching system is a prototype—you can refine the feature extraction and KNN parameters as more data becomes available.

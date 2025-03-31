# Crowdsourced Disaster Relief Platform

## Overview

This project is a backend system for a Crowdsourced Disaster Relief Platform. It uses AI-powered matching to connect disaster relief requests with suitable volunteers based on skills and geographic proximity. The backend is built with FastAPI, PostgreSQL, SQLAlchemy, and scikit-learn, and is designed to integrate seamlessly with a Flutter frontend.

---

## Table of Contents

1. [Tech Stack](#tech-stack)
2. [Prerequisites](#prerequisites)
3. [Setup and Installation](#setup-and-installation)
4. [Running the Backend](#running-the-backend)
5. [Populating the Database](#populating-the-database)
6. [Testing the Backend](#testing-the-backend)
7. [Docker Deployment](#docker-deployment)
8. [Troubleshooting](#troubleshooting)

---

## Tech Stack

- **Backend Framework**: FastAPI
- **Database**: PostgreSQL
- **ORM**: SQLAlchemy
- **AI Algorithm**: K-Nearest Neighbors (scikit-learn)
- **Containerization**: Docker & Docker Compose
- **Frontend**: Flutter (integration-ready)

---

## Prerequisites

Before running the project, ensure you have the following installed:

- Python 3.9+
- PostgreSQL
- Docker (optional, for containerized deployment)
- Required Python packages:
  ```bash
  pip install fastapi uvicorn sqlalchemy psycopg2-binary scikit-learn numpy requests
  ```

---

## Setup and Installation

### 1. Clone the Repository

Clone the project to your local machine:

```bash
git clone <repository-url>
cd <repository-folder>
```

### 2. Set Up the Database

Create and configure the PostgreSQL database:

```sql
CREATE DATABASE disaster_relief;
CREATE USER postgres WITH PASSWORD 'password';
ALTER DATABASE disaster_relief OWNER TO postgres;
```

Update the `DATABASE_URL` in the environment or directly in the code (default is already set):

```python
DATABASE_URL = "postgresql://postgres:password@localhost/disaster_relief"
```

---

## Running the Backend

### 1. Start the Backend

Run the FastAPI backend using Uvicorn:

```bash
uvicorn main:app --reload
```

The API will be available at:

```
http://localhost:8000
```

### 2. Verify the API

Visit the interactive API documentation at:

```
http://localhost:8000/docs
```

---

## Populating the Database

### 1. Populate with Sample Data

Run the `populate_database.py` script to insert predefined volunteers and requests:

```bash
python 2_data_collection/populate_database.py
```

Expected output:

```
Database populated successfully with volunteers and aid requests.
```

---

## Testing the Backend

### 1. Run Functional Tests

Use the `test_matching.py` script to test the `/match/{request_id}` endpoint:

```bash
python 3_basic_function_testing/test_matching.py
```

Expected output:

```
✅ Request ID 101 - Success:
{"matched_volunteers": [{...}]}
------------------------------------------------------------
❌ Request ID 999 - Failed:
Status: 404, Error: {"error": "Request not found"}
------------------------------------------------------------
```

### 2. Test API Manually

You can also test the API manually using tools like `curl` or Postman. Example:

```bash
curl http://localhost:8000/match/101
```

Expected response:

```json
{
  "matched_volunteers": [
    {"id": 1, "name": "Alice", "skills": "Medical", "location": "Houston"},
    {"id": 2, "name": "Bob", "skills": "Food Logistics", "location": "Austin"},
    {"id": 3, "name": "Charlie", "skills": "Rescue", "location": "Dallas"}
  ]
}
```

---

## Docker Deployment

### 1. Build and Run with Docker Compose

Use Docker Compose to build and run the backend and database:

```bash
docker-compose up --build
```

The API will be available at:

```
http://localhost:8000
```

### 2. Verify Services

- **API**: Visit `http://localhost:8000/docs` to confirm the backend is running.
- **Database**: Ensure PostgreSQL is running on port `5432`.

---

## Troubleshooting

### Common Issues

1. **Database Connection Error**:

   - Ensure PostgreSQL is running and the `DATABASE_URL` is correctly configured.
   - Verify the database credentials in `docker-compose.yml` or `main.py`.
2. **Missing Dependencies**:

   - Install missing Python packages:
     ```bash
     pip install -r requirements.txt
     ```
3. **Docker Issues**:

   - Ensure Docker is installed and running.
   - Rebuild the containers if necessary:
     ```bash
     docker-compose down
     docker-compose up --build
     ```

---

## Notes for Flutter Integration

- The backend supports CORS, allowing cross-origin requests from the Flutter frontend.
- Use the `/match/{request_id}` endpoint to fetch matched volunteers for a specific request.

Example Flutter HTTP call:

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> fetchMatchedVolunteers(int requestId) async {
  final response = await http.get(
    Uri.parse('http://localhost:8000/match/$requestId'),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print(data);  // handle/display data in Flutter UI
  } else {
    print('Request failed: ${response.statusCode}');
  }
}
```

---

## Contributors

- Casey Nguyen
- Kevin Pulikkottil
- Andy Jih
- Sawyer

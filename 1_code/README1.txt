README1.txt

Crowdsourced Disaster Relief Platform - AI Matching Backend
===========================================================

Project Information:
--------------------
- Project: Crowdsourced Disaster Relief Platform
- Course: CS 3354 Spring 2025
- Group Number: 2
- Group Members: Casey Nguyen, Kevin Pulikkottil, Andy Jih, Sawyer

Description:
------------
This backend system implements an AI-powered matching algorithm using FastAPI, PostgreSQL, SQLAlchemy, and K-Nearest Neighbors (KNN) from scikit-learn. It efficiently matches disaster relief aid requests with suitable volunteers based on skills and geographic proximity. This backend is specifically tailored to integrate seamlessly with a Flutter frontend.

Tech Stack:
-----------
- FastAPI (Python)
- PostgreSQL
- SQLAlchemy
- scikit-learn (KNN Algorithm)
- Docker & Docker Compose
- Flutter (frontend integration)

Prerequisites:
--------------
- Python 3.9+
- PostgreSQL
- Docker (optional, for deployment)

Installation:
-------------
Install necessary Python packages:

```bash
pip install fastapi uvicorn sqlalchemy psycopg2-binary scikit-learn numpy
```

Database Setup:
---------------
1. Create and configure PostgreSQL database:

```sql
CREATE DATABASE disaster_relief;
CREATE USER postgres WITH PASSWORD 'password';
ALTER DATABASE disaster_relief OWNER TO postgres;
```

2. Update `DATABASE_URL` in `main.py` if needed:

```python
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://postgres:password@localhost/disaster_relief")
```

Running the Application:
------------------------
Launch the backend API using Uvicorn:

```bash
uvicorn main:app --reload
```

Access the API at:

```
http://localhost:8000
```

Flutter Integration:
--------------------
The backend supports Flutter frontend integration with enabled CORS for cross-origin requests.

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

Example API Call:
-----------------
Get matched volunteers for a specific request:

```bash
GET http://localhost:8000/match/101
```

Sample Response:

```json
{
  "matched_volunteers": [
    {"id": 1, "name": "Alice", "skills": "Medical", "location": "Houston"},
    {"id": 2, "name": "Bob", "skills": "Food Logistics", "location": "Austin"},
    {"id": 3, "name": "Charlie", "skills": "Rescue", "location": "Dallas"}
  ]
}
```

Docker Deployment:
------------------
Use Docker Compose to easily deploy:

```bash
docker-compose up --build
```

API available at:

```
http://localhost:8000
```

Troubleshooting:
----------------
- Ensure PostgreSQL is running.
- Verify Python dependencies installation.
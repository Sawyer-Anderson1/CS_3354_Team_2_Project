# Crowdsourced Disaster Relief Platform

A full-stack web application designed to facilitate disaster response efforts through crowdsourcing. The platform connects individuals in need with volunteers and donors, providing real-time data on available resources and emergency alerts.

## Features

- **AI-Based Volunteer Matching**: Matches aid requests with suitable volunteers using KNN algorithm.
- **Resource Management**: Real-time resource inventory by region.
- **Donation & Request Handling**: Interfaces for submitting aid requests and making donations.
- **Emergency Alerts**: Live and historical alert system for disaster events.
- **Secure Firebase Backend**: Cloud-hosted NoSQL database via Firestore.
- **Mobile-Friendly**: Built with Flutter for cross-platform deployment.

## Tech Stack

**Frontend**
- Flutter (Dart)

**Backend**
- FastAPI (Python)
- Firebase Firestore
- AI Matching: scikit-learn, NumPy, Geopy, Joblib

**Other Tools**
- Docker (optional deployment)
- VSCode
- Pytest for testing

## Architecture

- **Frontend** interacts with users and posts data to backend APIs.
- **Backend** handles logic, including AI-based volunteer matching.
- **Database** stores all structured data like users, requests, donations, alerts, and resources.

## Data Models

- **Users**: Basic login info.
- **Requests**: Type, location, and description of help needed.
- **Donations**: Donor info and donation type/description.
- **Alerts**: Emergency type, description, severity, and date.
- **Resources**: Inventory tracking by area.

## AI Matching

- Uses one-hot encoding and K-Nearest Neighbors (KNN).
- Inputs: Request type, location, urgency.
- Matches with volunteers based on skills, location, and availability.

## API Endpoints

- `GET /`: API welcome message.
- `GET /match/{request_id}`: Get top 3 volunteer matches.
- `GET /debug-match/{request_id}`: Get detailed matching diagnostics.

## Frontend Pages

- Home: Navigation to all features.
- Request Help: Submit aid requests.
- Donate: Monetary or material contributions.
- Emergency Alerts: View disaster warnings.
- Resource Inventory: Check resource availability.
- Sign Up / Sign In: Placeholder UI for user authentication.

## Testing

To test:
```bash
uvicorn main:app --reload  # Start backend
make populate-db           # Populate database
make test                  # Run tests
```

Uses `pytest` to validate:
- Successful match queries
- Data structure of responses
- Handling of invalid IDs

## Deployment

- **Backend**: Run with Uvicorn or via Docker.
- **Frontend**: Flutter web app deployable via standard web server.
- Docker setup provided for containerized deployment.

## Security

- Firebase credentials are secured and excluded via `.gitignore`.
- Placeholder user auth exists in frontend, backend integration pending.

## Known Limitations

- Frontend/backend not yet fully integrated.
- Auth not implemented in backend.
- Basic UI, full design coming in next iteration.

## Team

- Casey Nguyen  
- Kevin Pulikkottil  
- Andy Jih  
- Sawyer Anderson

---

2025 Group 2 - CS 3354

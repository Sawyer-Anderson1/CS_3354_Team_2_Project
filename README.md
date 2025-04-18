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

* **Root:**
  [http://localhost:8001/](vscode-file://vscode-app/Applications/Visual%20Studio%20Code.app/Contents/Resources/app/out/vs/code/electron-sandbox/workbench/workbench.html)
* **Production Match Endpoint:**
  [http://localhost:8001/match/{request_id}](vscode-file://vscode-app/Applications/Visual%20Studio%20Code.app/Contents/Resources/app/out/vs/code/electron-sandbox/workbench/workbench.html)
* **Debug Match Endpoint:**
  [http://localhost:8001/debug-match/{request_id}](vscode-file://vscode-app/Applications/Visual%20Studio%20Code.app/Contents/Resources/app/out/vs/code/electron-sandbox/workbench/workbench.html)
* **Swagger UI:**
  [http://localhost:8001/docs](vscode-file://vscode-app/Applications/Visual%20Studio%20Code.app/Contents/Resources/app/out/vs/code/electron-sandbox/workbench/workbench.html)
* **ReDoc:**
  [http://localhost:8001/redoc](vscode-file://vscode-app/Applications/Visual%20Studio%20Code.app/Contents/Resources/app/out/vs/code/electron-sandbox/workbench/workbench.html)

## Frontend Pages

- Home: Navigation to all features.
- Request Help: Submit aid requests.
- Donate: Monetary or material contributions.
- Emergency Alerts: View disaster warnings.
- Resource Inventory: Check resource availability.
- Sign Up / Sign In: Placeholder UI for user authentication.

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

## Deployment

- **Backend**: Run with Uvicorn or via Docker. `127.0.0.1:8001/match/101`
- **Frontend**: Flutter web app deployable via standard web server. `127.0.0.1:PORT`
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

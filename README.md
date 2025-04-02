# Crowdsourced Disaster Relief Platform

A real-time platform connecting disaster victims with volunteers and relief organizations.

## Project Overview

This platform aims to streamline disaster response through:
- Real-time communication between victims, volunteers, and NGOs
- AI-powered matching of aid requests with available volunteers
- Resource tracking and allocation optimization
- Live mapping of disaster areas and relief efforts

## System Architecture

- **Frontend**:
  - Web Application (React)
  - Mobile Application (Flutter)
- **Backend**:
  - FastAPI
  - PostgreSQL Database
  - AI Matching System (scikit-learn)
- **Real-time Features**:
  - WebSocket for live updates
  - Push notifications

## Setup Instructions

### Prerequisites
- Python 3.8+
- Node.js 16+
- Flutter SDK
- PostgreSQL 13+

### Backend Setup
1. Navigate to the backend directory:
```bash
cd backend
```
2. Create a virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```
3. Install dependencies:
```bash
pip install -r requirements.txt
```

### Frontend Web Setup
1. Navigate to the frontend/web directory:
```bash
cd frontend/web
```
2. Install dependencies:
```bash
npm install
```
3. Start development server:
```bash
npm start
```

### Frontend Mobile Setup
1. Navigate to the frontend/mobile directory:
```bash
cd frontend/mobile
```
2. Install Flutter dependencies:
```bash
flutter pub get
```
3. Run the app:
```bash
flutter run
```

## Project Structure
```
.
├── backend/             # FastAPI backend
├── frontend/           
│   ├── web/            # React web application
│   └── mobile/         # Flutter mobile application
├── database/           # Database migrations and schemas
└── docs/              # Project documentation
```

## Team Members
- Casey Nguyen: Project Management & Full-stack Development
- Kevin Pulikkottil: Backend Development & AI Implementation
- Sawyer: Frontend Development & Database Integration
- Andy Jih: Frontend Development & Documentation

## Timeline
- Week 1-2: Project Setup & Core Features
- Week 3-4: AI Matching & Integration
- Week 5-6: Security & Performance
- Week 7-8: Testing & Deployment 
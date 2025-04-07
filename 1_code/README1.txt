Project Structure Overview
  backend (/backend):
    Key files:
    main.py: The main entry point for the backend server
    matching.py: contains the matching algorithm logic
    auth.py: Handles authentication and authorization
    models.py: Defines the database models
    schemas.py: Contains data validation schemas
    database.py: Database connection and configuration
    init_db.py: Database initialization script
    requirements.txt: Lists Python dependencies
    alembic.ini: Configuration for database migrations
    .env.example: Template for environment variables

    Key Functionality
    Authentication System (auth.py)
      Handles user authentication and authorization
      Manages user sessions and security
    Matching Algorithm (matching.py)
      Contains the core logic for matching users or items
      Implements matching based off distance from volunteers, and uses the KNN algorithm with ball tree.
    Database Management
      Uses SQLAlchemy (based on the presence of alembic.ini)
      Includes models for data structure
      Has migration support for database versioning
    API Layer
      The main.py file serves as the API entry point
      Handles routing and request processing
   

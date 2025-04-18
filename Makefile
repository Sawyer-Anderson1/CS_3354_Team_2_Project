# MAKEFILE - CS_3354_Team_2_Project
#
# This file provides convenient targets to:
#   - Set up the virtual environment and install dependencies (make setup)
#   - Run the FastAPI backend server (make run)
#   - Run unit tests with pytest (make test)
#   - Populate the Firestore database with sample data (make populate-db)
#   - Build and run Docker containers (make docker-up)
#   - Tear down Docker containers (make docker-down)
#   - Clean up __pycache__ folders (make clean)
#   - Run both backend and Flutter frontend concurrently (make run-all)
#
# The AI matching functionality is integrated in main.py and matching_ai.py.
# Ensure that your Firebase service account key (serviceAccountKey.json) is located
# in the code_1/ directory (this file is ignored by Git via .gitignore).
#
# RUNNING INSTRUCTIONS:
#   - Run "make setup" to prepare your environment.
#   - Run "make populate-db" to load sample data into Firestore.
#   - Run "make run" to launch your FastAPI backend.
#   - Run "make test" to conduct unit tests.
#   - Run "make run-all" to launch both the backend at http://127.0.0.1:8001/match/101 
#     and the Flutter frontend at http://localhost:55242/.

.PHONY: run setup test docker-up docker-down clean populate-db run-all

# Path to the virtual environment directory
VENV_DIR=code_1/backend/venv

# Command to activate the virtual environment
ACTIVATE=. $(VENV_DIR)/bin/activate;

# FastAPI app entry point: APP=code_1/backend/main.py

# Path to the requirements file
REQS=code_1/backend/requirements.txt

# Path to the Flutter executable
FLUTTER_BIN := $(shell command -v flutter 2>/dev/null)
ifndef FLUTTER_BIN
$(error ❌ Flutter executable not found in PATH. Please ensure Flutter is installed and added to PATH.)
endif

# Default target: run the FastAPI server with the service account environment variable set.
run:
	GOOGLE_APPLICATION_CREDENTIALS=code_1/backend/serviceAccountKey.json $(ACTIVATE) uvicorn code_1.backend.main:app --reload --port 8001

# One-time setup: create the virtual environment & install dependencies
setup:
	python3 -m venv $(VENV_DIR)
	$(ACTIVATE) pip install --upgrade pip
	$(ACTIVATE) pip install -r $(REQS)

# Run unit tests with pytest
test:
	$(ACTIVATE) pytest 3_basic_function_testing/test_matching.py

# Populate Firestore with sample data
populate-db:
	GOOGLE_APPLICATION_CREDENTIALS=code_1/backend/serviceAccountKey.json $(ACTIVATE) python 2_data_collection/populate_database.py

# Build and run Docker containers with the Compose file in code_1/
docker-up:
	@docker info > /dev/null 2>&1 || (\
		echo "❌ Docker daemon is not running. Please start Docker Desktop first."; \
		exit 1; \
	)
	docker compose -f code_1/backend/docker-compose.yml up --build --remove-orphans

# Tear down Docker containers
docker-down:
	docker compose -f code_1/backend/docker-compose.yml down --remove-orphans

# Clean up Python __pycache__ directories
clean:
	find . -type d -name '__pycache__' -exec rm -r {} +

# New target to run both backend and frontend
run-all: setup populate-db
	@echo "Starting backend server..."
	# Run the backend in the background so that the terminal is free for Flutter
	( $(MAKE) run & )
	@echo "Waiting for backend to be ready..."
	@while ! nc -z 127.0.0.1 8001; do sleep 1; done
	@echo "Backend is ready."
	@echo "Starting Flutter frontend..."
	# Change directory to code_1 and run the Flutter app
	cd code_1 && $(FLUTTER_BIN) run lib/main.dart

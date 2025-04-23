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

.PHONY: run setup test docker-up docker-down clean populate-db run-all lint format check-deps

# Path to the virtual environment directory
VENV_DIR=code_1/backend/venv

# Command to activate the virtual environment
ACTIVATE=. $(VENV_DIR)/bin/activate;

# Paths
REQS=code_1/backend/requirements.txt
SERVICE_KEY=code_1/backend/serviceAccountKey.json
BACKEND_PORT=8000

# Check for required executables
PYTHON := $(shell command -v python3 2>/dev/null)
FLUTTER_BIN := $(shell command -v flutter 2>/dev/null)
DOCKER := $(shell command -v docker 2>/dev/null)

# Check dependencies
check-deps:
ifndef PYTHON
	$(error ❌ Python3 not found. Please install Python 3.x)
endif
ifndef FLUTTER_BIN
	$(error ❌ Flutter not found. Please install Flutter and add to PATH)
endif
ifndef DOCKER
	$(error ❌ Docker not found. Please install Docker)
endif

# Check for service account key
check-service-key:
	@if [ ! -f $(SERVICE_KEY) ]; then \
		echo "❌ Firebase service account key not found at $(SERVICE_KEY)"; \
		echo "Please place your serviceAccountKey.json in the code_1/backend/ directory"; \
		exit 1; \
	fi

# Default target: run the FastAPI server
run: check-deps check-service-key
	GOOGLE_APPLICATION_CREDENTIALS=$(SERVICE_KEY) $(ACTIVATE) uvicorn code_1.backend.main:app --reload --port $(BACKEND_PORT)

# One-time setup: create virtual environment & install dependencies
setup: check-deps
	python3 -m venv $(VENV_DIR)
	$(ACTIVATE) pip install --upgrade pip
	$(ACTIVATE) pip install -r $(REQS)
	$(ACTIVATE) pip install black flake8 pytest pytest-cov

# Run unit tests with pytest and coverage
test: check-deps
	$(ACTIVATE) pytest 3_basic_function_testing/test_matching.py --cov=code_1/backend --cov-report=term-missing

# Populate Firestore with sample data
populate-db: check-deps check-service-key
	GOOGLE_APPLICATION_CREDENTIALS=$(SERVICE_KEY) $(ACTIVATE) python 2_data_collection/populate_database.py

# Build and run Docker containers
docker-up: check-deps check-service-key
	@docker info > /dev/null 2>&1 || (\
		echo "❌ Docker daemon is not running. Please start Docker Desktop first."; \
		exit 1; \
	)
	docker compose -f code_1/backend/docker-compose.yml up --build --remove-orphans

# Tear down Docker containers
docker-down:
	docker compose -f code_1/backend/docker-compose.yml down --remove-orphans

# Clean up Python cache and build artifacts
clean:
	find . -type d -name '__pycache__' -exec rm -r {} +
	find . -type d -name '.pytest_cache' -exec rm -r {} +
	find . -type d -name '.coverage' -exec rm -r {} +
	find . -type f -name '*.pyc' -delete

# Format code with black
format: check-deps
	$(ACTIVATE) black code_1/backend/

# Lint code with flake8
lint: check-deps
	$(ACTIVATE) flake8 code_1/backend/

# Run both backend and frontend
run-all: setup populate-db
	@echo "Starting backend server..."
	@$(MAKE) run & 
	@echo "Waiting for backend to be ready..."
	@timeout 30 sh -c 'until curl -s http://localhost:$(BACKEND_PORT)/health; do sleep 1; done' || (\
		echo "❌ Backend failed to start within 30 seconds"; \
		exit 1; \
	)
	@echo "Backend is ready."
	@echo "Starting Flutter frontend..."
	cd code_1 && $(FLUTTER_BIN) run lib/main.dart

# Show help
help:
	@echo "Available targets:"
	@echo "  setup        - Set up virtual environment and install dependencies"
	@echo "  run          - Run the FastAPI backend server"
	@echo "  test         - Run unit tests with coverage"
	@echo "  lint         - Check code style with flake8"
	@echo "  format       - Format code with black"
	@echo "  populate-db  - Load sample data into Firestore"
	@echo "  docker-up    - Build and run Docker containers"
	@echo "  docker-down  - Stop and remove Docker containers"
	@echo "  clean        - Remove Python cache and build artifacts"
	@echo "  run-all     - Run both backend and frontend"
	@echo "  help         - Show this help message"

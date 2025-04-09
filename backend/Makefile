# ==============================================================================
# MAKEFILE - CS_3354_Team_2_Project (Crowdsourced Disaster Relief)
# ==============================================================================
#
# This Makefile simplifies common development tasks for the Python backend.
#
# Targets:
#   - setup:         Creates a Python virtual environment and installs dependencies.
#   - run:           Runs the FastAPI backend server with auto-reload for development.
#   - test:          Executes unit tests using pytest.
#   - populate-db:   Populates the Firestore database with sample data.
#   - docker-up:     Builds and starts the backend service using Docker Compose.
#   - docker-down:   Stops and removes the Docker Compose services.
#   - clean:         Removes Python bytecode cache directories (__pycache__).
#
# Prerequisites:
#   - Python 3 (python3 command)
#   - Docker and Docker Compose (for docker-* targets)
#   - Firebase service account key file located at `1_code/serviceAccountKey.json`.
#     (This file MUST NOT be committed to Git - ensure it's in your .gitignore).
#
# Common Workflow:
#   1. `make setup`        (Run once initially, or after changing requirements.txt)
#   2. `make populate-db`  (Run when you need sample data in Firestore)
#   3. `make run`          (To start the development server)
#   4. `make test`         (To run tests - ensure server is running if tests hit live API)
#
# ==============================================================================

# Use bash for better command handling within Make
SHELL := /bin/bash

# Define project-specific variables
PROJECT_DIR         := $(shell pwd)
BACKEND_CODE_DIR    := $(PROJECT_DIR)/1_code
VENV_DIR            := $(BACKEND_CODE_DIR)/venv
PYTHON_EXEC         := $(VENV_DIR)/bin/python3 # Use python3 explicitly if needed
PIP_EXEC            := $(VENV_DIR)/bin/pip
PYTEST_EXEC         := $(VENV_DIR)/bin/pytest
APP_MODULE          := 1_code.main:app
REQUIREMENTS_FILE   := $(BACKEND_CODE_DIR)/requirements.txt
CREDENTIALS_PATH    := $(BACKEND_CODE_DIR)/serviceAccountKey.json
POPULATE_SCRIPT     := $(PROJECT_DIR)/2_data_collection/populate_database.py
TEST_SCRIPT         := $(PROJECT_DIR)/3_basic_function_testing/test_matching.py
DOCKER_COMPOSE_FILE := $(BACKEND_CODE_DIR)/docker-compose.yml

# Phony targets don't represent files
.PHONY: all run setup test docker-up docker-down clean populate-db help

# Default target executed when running `make` without arguments
all: help

# Target to display help information
help:
	@echo "Makefile for CS_3354_Team_2_Project Backend"
	@echo ""
	@echo "Usage:"
	@echo "  make setup         Set up Python virtual environment and install dependencies."
	@echo "  make run           Run the FastAPI development server (http://0.0.0.0:8000)."
	@echo "  make test          Run backend unit tests."
	@echo "  make populate-db   Populate Firestore database with sample data."
	@echo "  make docker-up     Build and run services with Docker Compose."
	@echo "  make docker-down   Stop and remove Docker Compose services."
	@echo "  make clean         Remove Python __pycache__ directories."
	@echo "  make help          Show this help message."
	@echo ""
	@echo "Note: Ensure '$(CREDENTIALS_PATH)' exists for Firestore access."

# Run the FastAPI server with auto-reload and accessible externally
# Sets GOOGLE_APPLICATION_CREDENTIALS environment variable for the command.
run: $(VENV_DIR)/bin/activate # Ensure venv exists
	@echo "🚀 Starting FastAPI server with auto-reload on http://0.0.0.0:8000 ..."
	@echo "   Using credentials: $(CREDENTIALS_PATH)"
	GOOGLE_APPLICATION_CREDENTIALS=$(CREDENTIALS_PATH) $(PYTHON_EXEC) -m uvicorn $(APP_MODULE) --reload --host 0.0.0.0 --port 8000

# One-time setup: create the virtual environment & install dependencies
# Checks if venv directory exists before creating.
setup: $(VENV_DIR)/bin/activate

$(VENV_DIR)/bin/activate: $(REQUIREMENTS_FILE)
	@echo "🛠️ Setting up Python virtual environment in $(VENV_DIR)..."
	@if [ ! -d "$(VENV_DIR)" ]; then \
		python3 -m venv $(VENV_DIR); \
		echo "   Virtual environment created."; \
	else \
		echo "   Virtual environment already exists."; \
	fi
	@echo "   Upgrading pip..."
	@$(PIP_EXEC) install --upgrade pip
	@echo "   Installing dependencies from $(REQUIREMENTS_FILE)..."
	@$(PIP_EXEC) install -r $(REQUIREMENTS_FILE)
	@echo "✅ Setup complete."
	@touch $(VENV_DIR)/bin/activate # Update timestamp

# Run unit tests using pytest
# Sets GOOGLE_APPLICATION_CREDENTIALS in case tests need it (though ideally mocked).
test: $(VENV_DIR)/bin/activate # Ensure venv exists
	@echo "🧪 Running unit tests..."
	GOOGLE_APPLICATION_CREDENTIALS=$(CREDENTIALS_PATH) $(PYTEST_EXEC) $(TEST_SCRIPT)

# Populate Firestore with sample data
# Sets GOOGLE_APPLICATION_CREDENTIALS environment variable for the script.
populate-db: $(VENV_DIR)/bin/activate # Ensure venv exists
	@echo "🅿️ Populating Firestore database..."
	@echo "   Using credentials: $(CREDENTIALS_PATH)"
	GOOGLE_APPLICATION_CREDENTIALS=$(CREDENTIALS_PATH) $(PYTHON_EXEC) $(POPULATE_SCRIPT)

# Build and run Docker containers using Docker Compose
# Includes a check to ensure Docker daemon is running.
docker-up:
	@echo "🐳 Building and starting Docker containers..."
	@docker info > /dev/null 2>&1 || ( \
		echo "❌ Docker daemon is not running. Please start Docker Desktop (or your Docker service) first."; \
		exit 1; \
	)
	docker compose -f $(DOCKER_COMPOSE_FILE) up --build --remove-orphans

# Stop and remove Docker containers defined in the Compose file
docker-down:
	@echo "🛑 Stopping and removing Docker containers..."
	docker compose -f $(DOCKER_COMPOSE_FILE) down --remove-orphans

# Clean up Python __pycache__ directories and *.pyc files
clean:
	@echo "🧹 Cleaning up Python cache files..."
	find . -type d -name '__pycache__' -exec rm -r {} +
	find . -type f -name '*.pyc' -delete
	find . -type f -name '*.pyo' -delete
	@echo "✅ Cleanup complete."

# Note on Windows Activation:
# The $(PYTHON_EXEC) method avoids needing manual activation.
# If running python/pip commands manually on Windows outside 'make':
# - Command Prompt: `.\path\to\venv\Scripts\activate.bat`
# - PowerShell: `.\path\to\venv\Scripts\Activate.ps1` (may require execution policy changes)

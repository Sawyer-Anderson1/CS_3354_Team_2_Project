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
#
# The AI matching functionality is integrated in main.py and matching_ai.py.
# Ensure that your Firebase service account key (serviceAccountKey.json) is located
# in the 1_code/ directory (this file is ignored by Git via .gitignore).

# RUNNING INSTRUCTIONS:
# make setup to prepare your environment,
# make populate-db to load sample data into Firestore,
# make run to launch your FastAPI backend,
# make test to run your unit tests

.PHONY: run setup test docker-up docker-down clean populate-db

# Path to the virtual environment directory
VENV_DIR=1_code/venv

# Command to activate the virtual environment
ACTIVATE=. $(VENV_DIR)/bin/activate;

# FastAPI app entry point
APP=1_code.main:app

# Path to the requirements file
REQS=1_code/requirements.txt

# Default target: run the FastAPI server with the service account environment variable set.
run:
	GOOGLE_APPLICATION_CREDENTIALS=1_code/serviceAccountKey.json $(ACTIVATE) uvicorn $(APP) --reload

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
	GOOGLE_APPLICATION_CREDENTIALS=1_code/serviceAccountKey.json $(ACTIVATE) python 2_data_collection/populate_database.py

# Build and run Docker containers with the Compose file in 1_code/
docker-up:
	@docker info > /dev/null 2>&1 || (\
		echo "❌ Docker daemon is not running. Please start Docker Desktop first."; \
		exit 1; \
	)
	docker compose -f 1_code/docker-compose.yml up --build --remove-orphans

# Tear down Docker containers
docker-down:
	docker compose -f 1_code/docker-compose.yml down --remove-orphans

# Clean up Python __pycache__ directories
clean:
	find . -type d -name '__pycache__' -exec rm -r {} +
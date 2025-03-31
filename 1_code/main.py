from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.orm import sessionmaker, Session, declarative_base
import numpy as np
from sklearn.neighbors import NearestNeighbors
import os
from fastapi.responses import JSONResponse

# initialize fastapi application
app = FastAPI()

# enable cors (cross-origin resource sharing) for flutter
# this allows the api to be accessed from different domains/origins
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # replace with specific origin for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# database configuration and connection setup
# uses postgresql database with sqlalchemy orm
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://postgres:password@localhost/disaster_relief")
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# create base class for sqlalchemy models
Base = declarative_base()

# define volunteer database model
# stores volunteer information including skills and location
class Volunteer(Base):
    __tablename__ = "volunteers"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    skills = Column(String)
    location = Column(String)

# define request database model
# stores disaster relief requests with type and location
class Request(Base):
    __tablename__ = "requests"
    id = Column(Integer, primary_key=True, index=True)
    type = Column(String, index=True)
    location = Column(String)

# create database tables based on the models
Base.metadata.create_all(bind=engine)

# database dependency injection
# creates a new database session for each request
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# api endpoint to match volunteers with requests
# uses k-nearest neighbors algorithm to find best matches
@app.get("/match/{request_id}")
def match_volunteers(request_id: int, db: Session = Depends(get_db)):
    # retrieve the request from database
    req = db.query(Request).filter(Request.id == request_id).first()
    if not req:
        return JSONResponse(status_code=404, content={"error": "Request not found"})

    # get all volunteers from database
    volunteers = db.query(Volunteer).all()
    if len(volunteers) < 3:
        return JSONResponse(status_code=400, content={"error": "Not enough volunteers available."})

    # create feature vectors for knn algorithm
    # convert skills and location to numeric values using hash function
    X = np.array([[hash(v.skills), hash(v.location)] for v in volunteers])
    request_vector = np.array([[hash(req.type), hash(req.location)]])

    # initialize and fit knn model
    # find 3 nearest neighbors (or less if not enough volunteers)
    knn = NearestNeighbors(n_neighbors=min(3, len(volunteers)), metric='euclidean')
    knn.fit(X)
    distances, indices = knn.kneighbors(request_vector)

    # get the matched volunteers based on knn results
    matched_volunteers = [volunteers[i] for i in indices[0]]

    # return matched volunteers' information
    return {
        "matched_volunteers": [
            {"id": v.id, "name": v.name, "skills": v.skills, "location": v.location}
            for v in matched_volunteers
        ]
    }
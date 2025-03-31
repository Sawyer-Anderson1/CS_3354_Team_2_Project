# populate_database.py
# this script connects to the database and inserts predefined records
import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from main import Volunteer, Request, Base

# connect to the PostgreSQL database
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://postgres:password@localhost/disaster_relief")
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(bind=engine)

def populate():
    # begins a new session for database operations
    db = SessionLocal()
    
    # remove old data to avoid duplicates
    db.query(Volunteer).delete()
    db.query(Request).delete()
    
    # insert sample volunteers to the database
    volunteers = [
        Volunteer(name='Alice', skills='Medical', location='Houston'),
        Volunteer(name='Bob', skills='Food Logistics', location='Austin'),
        Volunteer(name='Charlie', skills='Rescue', location='Dallas'),
        Volunteer(name='Diana', skills='Shelter Management', location='San Antonio'),
        Volunteer(name='Ethan', skills='Medical', location='Fort Worth'),
    ]
    
    # insert sample requests to the database
    requests = [
        Request(id=101, type='Medical', location='Houston'),
        Request(id=102, type='Food', location='Austin'),
        Request(id=103, type='Rescue', location='Dallas'),
        Request(id=104, type='Shelter', location='San Antonio'),
    ]
    
    db.add_all(volunteers)
    db.add_all(requests)
    
    # commit changes and close session
    db.commit()
    db.close()

    print("database populated successfully with volunteers and aid requests.")

if __name__ == "__main__":
    # ensure tables are created
    Base.metadata.create_all(engine)
    populate()

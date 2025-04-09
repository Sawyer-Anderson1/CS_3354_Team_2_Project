from pydantic import BaseModel, Field
from typing import Optional

# Model for creating a resource (doesn't include ID, as Firestore generates it)
class ResourceCreate(BaseModel):
        name: str = Field(..., example="Water Bottles")
        quantity: int = Field(..., example=200, gt=0) # Ensure quantity is positive
        location: str = Field(..., example="Dallas, TX")
        # Add other relevant fields like description, unit (e.g., 'bottles', 'gallons'), category etc.

        class Config:
            # Example data for API docs
            json_schema_extra = {
                "example": {
                    "name": "First Aid Kits",
                    "quantity": 50,
                    "location": "Richardson, TX"
                }
            }

    # Model for updating a resource (all fields optional)
class ResourceUpdate(BaseModel):
        name: Optional[str] = None
        quantity: Optional[int] = Field(None, gt=0) # Ensure quantity is positive if provided
        location: Optional[str] = None
        # Add other fields as needed

        class Config:

         # Example data for API docs
            json_schema_extra = {
                "example": {
                    "quantity": 45,
                    "location": "Plano, TX"
                }
            }

    # Model for representing a resource retrieved from Firestore (includes ID)
class ResourceOut(ResourceCreate):
        id: str = Field(..., example="aBcDeFgHiJkLmNoPqRsT") # Firestore document ID

        class Config:
            # Allows Pydantic to work with ORM objects (though we use dicts from Firestore)
            from_attributes = True

         # Example data for API docs
            json_schema_extra = {
                "example": {
                    "id": "aBcDeFgHiJkLmNoPqRsT",
                    "name": "Blankets",
                    "quantity": 100,
                    "location": "Frisco, TX"
                }


            }
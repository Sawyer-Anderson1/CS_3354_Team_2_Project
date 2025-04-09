# 1_code/routers/resources.py
from fastapi import APIRouter, HTTPException, Depends, status
from typing import List
import firebase_admin
from firebase_admin import firestore

    # Import your Pydantic models (adjust path if necessary)
from models.resource_models import ResourceCreate, ResourceUpdate, ResourceOut

    # Define the router
router = APIRouter(
        prefix="/resources", # All routes in this file will start with /resources
        tags=["Resources"]   # Tag for API documentation (Swagger UI)
    )

    # Dependency to get the Firestore client
    # Ensures Firestore is initialized before handling requests
def get_db():
        if not firebase_admin._apps:
            # This is a fallback, initialization should happen in main.py
            # Consider a more robust dependency injection for the db client
            raise HTTPException(status_code=500, detail="Firebase app not initialized")
        return firestore.client()

    # --- API Endpoints ---

@router.post("/", response_model=ResourceOut, status_code=status.HTTP_201_CREATED)
async def create_resource(resource: ResourceCreate, db: firestore.Client = Depends(get_db)):
        """
        Create a new resource item in the inventory.
        """
        try:
            # Add a new document with an auto-generated ID to the 'resources' collection
            # Convert Pydantic model to dict for Firestore
            resource_dict = resource.model_dump()
            doc_ref = db.collection('resources').document() # Auto-generate ID
            await doc_ref.set(resource_dict) # Use await for async Firestore client

            # Prepare the response object including the generated ID
            created_resource = ResourceOut(id=doc_ref.id, **resource_dict)
            return created_resource
        except Exception as e:
            # Basic error handling
            raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                                detail=f"Failed to create resource: {e}")

@router.get("/", response_model=List[ResourceOut])
async def get_all_resources(db: firestore.Client = Depends(get_db)):
        """
        Retrieve all resource items from the inventory.
        """
        try:
            resources_ref = db.collection('resources')
            docs_stream = resources_ref.stream() # Use stream for async iteration
            resources_list = []
            async for doc in docs_stream:
                 # Combine document ID and data into the ResourceOut model
                resource_data = doc.to_dict()
                if resource_data: # Ensure doc has data
                    resource_data["id"] = doc.id
                    resources_list.append(ResourceOut(**resource_data))
            return resources_list
        except Exception as e:
            raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                                detail=f"Failed to retrieve resources: {e}")

@router.get("/{resource_id}", response_model=ResourceOut)
async def get_resource_by_id(resource_id: str, db: firestore.Client = Depends(get_db)):
        """
        Retrieve a specific resource item by its ID.
        """
        try:
            doc_ref = db.collection('resources').document(resource_id)
            doc = await doc_ref.get() # Use await
            if not doc.exists:
                raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                                    detail=f"Resource with id {resource_id} not found")
            resource_data = doc.to_dict()
            resource_data["id"] = doc.id
            return ResourceOut(**resource_data)
        except Exception as e:
             # Catch potential exceptions during Firestore operation
            if isinstance(e, HTTPException): # Re-raise HTTPExceptions
                 raise e
            raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                                detail=f"Failed to retrieve resource {resource_id}: {e}")

@router.put("/{resource_id}", response_model=ResourceOut)
async def update_resource(resource_id: str, resource_update: ResourceUpdate, db: firestore.Client = Depends(get_db)):
        """
        Update an existing resource item by its ID.
        Only updates fields provided in the request body.
        """
        try:
            doc_ref = db.collection('resources').document(resource_id)
            # Get current data to ensure it exists before updating
            doc = await doc_ref.get()
            if not doc.exists:
                 raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                                    detail=f"Resource with id {resource_id} not found")

            # Prepare update data, excluding unset fields
            update_data = resource_update.model_dump(exclude_unset=True)

            if not update_data:
                 raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                                     detail="No update data provided")

            await doc_ref.update(update_data) # Use await

            # Fetch the updated document to return it
            updated_doc = await doc_ref.get()
            updated_data = updated_doc.to_dict()
            updated_data["id"] = updated_doc.id
            return ResourceOut(**updated_data)
        except Exception as e:
            if isinstance(e, HTTPException): # Re-raise HTTPExceptions
                 raise e
            raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                                detail=f"Failed to update resource {resource_id}: {e}")

@router.delete("/{resource_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_resource(resource_id: str, db: firestore.Client = Depends(get_db)):
        """
        Delete a resource item by its ID.
        """
        try:
             # Check if document exists before attempting delete for better feedback (optional)
             doc_ref = db.collection('resources').document(resource_id)
             doc = await doc_ref.get()
             if not doc.exists:
                 raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                                     detail=f"Resource with id {resource_id} not found")

             await db.collection('resources').document(resource_id).delete() # Use await
             # No content is returned on successful deletion (HTTP 204)
             return None # Or return Response(status_code=status.HTTP_204_NO_CONTENT)
        except Exception as e:
            if isinstance(e, HTTPException): # Re-raise HTTPExceptions
                 raise e
            raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                                detail=f"Failed to delete resource {resource_id}: {e}")

    # --- Add Authentication Later ---
    # You would typically add dependencies like Depends(get_current_active_user)
    # to endpoints that require authentication, e.g., create, update, delete.
    
from fastapi import APIRouter, Depends, HTTPException, status
from ...api.dependancies import require_roles
from typing import List
from ...models.schemas import GuestCreate, GuestOut
from ...services.booking_service import create_guest, get_guest
from ...services.guest_service import get_all_guests

router = APIRouter(prefix="/guests", tags=["guests"])

@router.get("/", response_model=List[dict])
def list_guests(user=Depends(require_roles("Admin", "Manager", "Reception"))):
    """Get all guests for dropdown selection."""
    return get_all_guests()

@router.post("/", status_code=201)
def create_guest_endpoint(
    payload: GuestCreate, 
    user=Depends(require_roles("Admin", "Manager", "Reception"))
):
    """Create a new guest."""
    # Server-side validation
    if not str(payload.phone).isdigit():
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Phone must contain digits only")
    if len(str(payload.phone)) != 10:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Phone must be exactly 10 digits")
    if not str(payload.id_number).isdigit():
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="ID Number must contain digits only")
    # simple email check
    import re
    if not re.match(r"^[^\s@]+@[^\s@]+\.[^\s@]+$", payload.email or ""):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid email format")

    try:
        guest_id = create_guest(
            payload.first_name, 
            payload.last_name, 
            payload.phone, 
            payload.email, 
            payload.id_number
        )
        return {"guest_id": guest_id, "message": "Guest created successfully"}
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

@router.get("/{guest_id}", response_model=GuestOut)
def get_guest_endpoint(
    guest_id: int, 
    user=Depends(require_roles("Admin", "Manager", "Reception"))
):
    """Get guest information by ID."""
    guest = get_guest(guest_id)
    if not guest:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Guest not found")
    return guest
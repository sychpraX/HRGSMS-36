from fastapi import APIRouter, Depends, HTTPException, status
from ...api.dependencies import require_roles
from ...models.schemas import ReservationCreate, ReservationOut
from ...services.booking_service import is_room_available, create_booking, get_booking

router = APIRouter()

@router.post("/", response_model=ReservationOut, status_code=201)
def create_reservation(payload: ReservationCreate, user=Depends(require_roles("Admin", "Manager", "FrontDesk"))):
    if not is_room_available(payload.room_id, payload.check_in_date, payload.check_out_date):
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="Room is not available in the given range")
    booking_id = create_booking(payload.guest_id, payload.room_id, payload.check_in_date, payload.check_out_date)
    row = get_booking(booking_id)
    return row

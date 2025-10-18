from pydantic import BaseModel, field_validator
from datetime import date, datetime
from typing import Optional

# --- Auth ---
class LoginRequest(BaseModel):
    username: str
    password: str

class LoginResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    role: str

class RegisterRequest(BaseModel):
    username: str
    password: str
    role: str = "Reception"

    @field_validator("role")
    @classmethod
    def valid_role(cls, v):
        allowed = {"Admin", "Manager", "Reception", "Staff"}
        if v not in allowed:
            raise ValueError("Invalid role")
        return v

# --- Guests ---
class GuestCreate(BaseModel):
    first_name: str
    last_name: str
    phone: str
    email: Optional[str] = None
    id_number: str

class GuestOut(BaseModel):
    guestID: int
    firstName: str
    lastName: str
    phone: str
    email: Optional[str]
    idNumber: str

# --- Rooms ---
class RoomOut(BaseModel):
    room_id: int
    room_no: int
    type_name: str
    capacity: int
    curr_rate: float
    room_status: str
    branch_location: str

# --- Reservations ---
class ReservationCreate(BaseModel):
    guest_id: int
    branch_id: int
    room_id: int
    check_in_date: date
    check_out_date: date
    num_guests: int

class ReservationOut(BaseModel):
    booking_id: int
    guest_id: int
    branch_id: int
    room_id: int
    check_in_date: datetime
    check_out_date: datetime
    num_guests: int
    booking_status: str

# --- Services ---
class ServiceUsageCreate(BaseModel):
    booking_id: int
    service_id: int
    quantity: int = 1

# --- Payments ---
class InvoiceCreate(BaseModel):
    booking_id: int
    policy_id: Optional[int] = None
    discount_code: Optional[int] = None
    late_policy_id: Optional[int] = None


class PaymentCreate(BaseModel):
    invoice_id: int
    amount: float
    payment_method: str

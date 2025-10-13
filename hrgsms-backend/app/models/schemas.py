from pydantic import BaseModel, EmailStr, field_validator
from datetime import date, datetime
from typing import Optional

# --- Auth ---
class LoginRequest(BaseModel):
    email: EmailStr
    password: str

class LoginResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    role: str

class RegisterRequest(BaseModel):
    email: EmailStr
    password: str
    role: str = "FrontDesk"

    @field_validator("role")
    @classmethod
    def valid_role(cls, v):
        allowed = {"Admin", "Manager", "FrontDesk", "ServiceStaff"}
        if v not in allowed:
            raise ValueError("Invalid role")
        return v

# --- Rooms ---
class RoomOut(BaseModel):
    room_id: int
    room_number: str
    type_name: str
    base_rate: float
    status: str
    branch_name: str

# --- Reservations ---
class ReservationCreate(BaseModel):
    guest_id: int
    room_id: int
    check_in_date: date
    check_out_date: date

class ReservationOut(BaseModel):
    booking_id: int
    guest_id: int
    room_id: int
    check_in_date: date
    check_out_date: date
    status: str

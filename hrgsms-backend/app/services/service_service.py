# app/services/service_service.py
from ..database.queries import call_proc

def add_service_usage(booking_id: int, service_id: int, used_on: str, qty: int):
    return call_proc('sp_add_service_usage', (booking_id, service_id, used_on, qty))

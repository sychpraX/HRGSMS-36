from datetime import date
from ..database.connection import get_db_cursor
from ..database.queries import BOOKING_QUERIES, ROOM_QUERIES

def is_room_available(room_id: int, check_in: date, check_out: date) -> bool:
    # Query any available rooms in range and check membership
    with get_db_cursor() as (conn, cur):
        cur.execute(ROOM_QUERIES["available_in_range"], (check_in, check_out))
        ids = {r["room_id"] for r in cur.fetchall()}
        return room_id in ids

def create_booking(guest_id: int, room_id: int, check_in: date, check_out: date) -> int:
    with get_db_cursor() as (conn, cur):
        cur.execute(BOOKING_QUERIES["create"], (guest_id, room_id, check_in, check_out))
        return cur.lastrowid

def get_booking(booking_id: int) -> dict | None:
    with get_db_cursor() as (conn, cur):
        cur.execute(BOOKING_QUERIES["get"], (booking_id,))
        return cur.fetchone()

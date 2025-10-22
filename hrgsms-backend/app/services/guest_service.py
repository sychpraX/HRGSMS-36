from typing import List, Dict
from ..database.connection import get_db_cursor

def get_all_guests() -> List[Dict]:
    """Return list of all guests for dropdown."""
    with get_db_cursor() as (conn, cur):
        cur.execute("""
            SELECT guestID, CONCAT(firstName, ' ', lastName) as name, phone, email 
            FROM Guest 
            ORDER BY firstName, lastName
        """)
        return cur.fetchall()
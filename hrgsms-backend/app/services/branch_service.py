from typing import List, Dict
from ..database.connection import get_db_cursor

def get_branches() -> List[Dict]:
    """Return list of branches as dicts with branchID and location."""
    with get_db_cursor() as (conn, cur):
        cur.execute("SELECT branchID, location FROM Branch ORDER BY branchID")
        rows = cur.fetchall()
        return rows

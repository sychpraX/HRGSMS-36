from fastapi import APIRouter, Depends
from typing import List
from ...api.dependencies import require_roles
from ...models.schemas import RoomOut
from ...database.connection import get_db_cursor
from ...database.queries import ROOM_QUERIES

router = APIRouter()

@router.get("/", response_model=List[RoomOut])
def list_rooms(user=Depends(require_roles("Admin", "Manager", "FrontDesk"))):
    with get_db_cursor() as (conn, cur):
        cur.execute(ROOM_QUERIES["all"])
        return cur.fetchall()

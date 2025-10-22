from fastapi import APIRouter, HTTPException
from mysql.connector import Error
from app.db import pool  # adjust to where your MySQL pool is exposed

router = APIRouter()

@router.get("/health/db")
def db_health():
    try:
        conn = pool.get_connection()
        try:
            # option A: simple query
            cur = conn.cursor()
            cur.execute("SELECT 1")
            ok = cur.fetchone()
            cur.close()

            # option B: or use conn.is_connected()
            # ok = (1,) if conn.is_connected() else None

            conn.close()
            if ok and ok[0] == 1:
                return {"database": "ok"}
            raise HTTPException(status_code=500, detail="unexpected db response")
        finally:
            if conn.is_connected():
                conn.close()
    except Error as e:
        raise HTTPException(status_code=500, detail=str(e))
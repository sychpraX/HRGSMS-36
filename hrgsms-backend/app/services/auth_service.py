from typing import Optional
from ..database.connection import get_db_cursor, DBError
from ..database.queries import USER_QUERIES
from ..utils.security import verify_password, hash_password, create_access_token

def authenticate(email: str, password: str) -> Optional[dict]:
    with get_db_cursor() as (conn, cur):
        cur.execute(USER_QUERIES["get_by_email"], (email,))
        row = cur.fetchone()
        if not row or not verify_password(password, row["password_hash"]):
            return None
        return {"user_id": row["user_id"], "email": row["email"], "role": row["role"]}

def register(email: str, password: str, role: str) -> int:
    pw_hash = hash_password(password)
    with get_db_cursor() as (conn, cur):
        cur.execute(USER_QUERIES["create"], (email, pw_hash, role))
        return cur.lastrowid

def issue_token(user: dict) -> str:
    sub = {"user_id": user["user_id"], "email": user["email"], "role": user["role"]}
    return create_access_token(sub)

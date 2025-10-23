from jose import JWTError, jwt
from passlib.context import CryptContext
from datetime import datetime, timedelta
from typing import Optional, Dict, Any
from ..config import settings

# Password hashing utilities

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def hash_password(password: str) -> str:
    """Hash a password using bcrypt."""
    return pwd_context.hash(password)

def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Verify a password against its hash."""
    return pwd_context.verify(plain_password, hashed_password)


# JWT utilities

def create_access_token(data: Dict[str, Any], expires_delta: Optional[timedelta] = None) -> str:
    """
    Create a JWT access token.
    Expected payload includes:
        {
            "sub": user_id,
            "username": username,
            "role": role,
            "branch_id": branch_id
        }
    """
    to_encode = data.copy()
    
    # Set token expiration
    expire = datetime.utcnow() + (expires_delta or timedelta(minutes=settings.JWT_EXP_MINUTES))
    to_encode.update({"exp": expire})

    # Encode JWT with secret and algorithm
    encoded_jwt = jwt.encode(to_encode, settings.JWT_SECRET, algorithm=settings.JWT_ALGORITHM)
    return encoded_jwt


def verify_token(token: str) -> Optional[Dict[str, Any]]:
    """
    Verify and decode a JWT token.
    Returns decoded payload if valid, None otherwise.
    """
    try:
        payload = jwt.decode(token, settings.JWT_SECRET, algorithms=[settings.JWT_ALGORITHM])

        # Ensure all expected fields are present
        # (branch_id may be None for Admin users)
        return {
            "sub": payload.get("sub"),
            "username": payload.get("username"),
            "role": payload.get("role"),
            "branch_id": payload.get("branch_id")
        }

    except JWTError:
        return None

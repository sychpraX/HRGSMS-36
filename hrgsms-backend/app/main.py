# app/main.py
from fastapi import FastAPI, HTTPException, Request
from fastapi.responses import JSONResponse
from .api.routes import auth, rooms, reservations, services, payments, reports, guests
from .api.routes import branches
from fastapi.middleware.cors import CORSMiddleware
from starlette.middleware.base import BaseHTTPMiddleware
from typing import Callable

class SecurityHeadersMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next: Callable):
        response = await call_next(request)
        response.headers["X-Content-Type-Options"] = "nosniff"
        response.headers["X-Frame-Options"] = "DENY"
        response.headers["X-XSS-Protection"] = "1; mode=block"
        response.headers["Strict-Transport-Security"] = "max-age=31536000; includeSubDomains"
        response.headers["Content-Security-Policy"] = "default-src 'self'"
        return response

app = FastAPI(title="HRGSMS API", version="1.0.0", description="Hotel Room and Guest Services Management System")


# CORS configuration

origins = [
    "http://localhost:3000",
    "http://127.0.0.1:3000",
    "http://localhost:3001",
    "http://127.0.0.1:3001",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,           # ok if you ever use cookies
    allow_methods=["*"],               # or list: ["GET","POST","PUT","DELETE","OPTIONS"]
    allow_headers=["*"],               # make sure "content-type" & "authorization" are allowed
)



# Add security headers middleware
app.add_middleware(SecurityHeadersMiddleware)

# Include all routers
app.include_router(auth.router)
app.include_router(rooms.router)
app.include_router(branches.router)
app.include_router(reservations.router)
app.include_router(services.router)
app.include_router(payments.router)
app.include_router(reports.router)
app.include_router(guests.router)

@app.get("/")
def root():
    return {"message": "HRGSMS API is running", "version": "1.0.0"}

@app.get("/health")
def health_check():
    """Health check endpoint to verify API and database connectivity"""
    try:
        from .database.connection import get_connection_pool
        # Try to get a connection to verify database connectivity
        pool = get_connection_pool()
        conn = pool.get_connection()
        conn.close()
        return {"status": "healthy", "database": "connected"}
    except Exception as e:
        return {"status": "unhealthy", "database": "disconnected", "error": str(e)}

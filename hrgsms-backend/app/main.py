# app/main.py
from fastapi import FastAPI, HTTPException
from .api.routes import auth, rooms, reservations, services, payments, reports, guests
from fastapi.middleware.cors import CORSMiddleware

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



# Include all routers
app.include_router(auth.router)
app.include_router(rooms.router)
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

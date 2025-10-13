# app/main.py
from fastapi import FastAPI
from .api.routes import auth, rooms, reservations, services, payments, reports

app = FastAPI(title="HRGSMS API")
app.include_router(auth.router)
app.include_router(rooms.router)
app.include_router(reservations.router)
app.include_router(services.router)
app.include_router(payments.router)
app.include_router(reports.router)

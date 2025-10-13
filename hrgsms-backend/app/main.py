from fastapi import FastAPI
from app.api.routes import auth_routes

app = FastAPI(title="HRGSMS API")
app.include_router(auth_routes.router)

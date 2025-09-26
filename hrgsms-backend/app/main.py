from fastapi import FastAPI
from app.routers import items

app = FastAPI(title="My Structured FastAPI App", version="1.0.0")

# Include Routers
app.include_router(items.router)

@app.get("/")
def root():
    return {"message": "Hello, Structured FastAPI!"}

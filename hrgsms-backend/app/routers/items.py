from fastapi import APIRouter
from app.models import Item

router = APIRouter(prefix="/items", tags=["items"])

@router.get("/{item_id}")
def read_item(item_id: int, q: str | None = None):
    return {"item_id": item_id, "query": q}

@router.post("/")
def create_item(item: Item):
    return {"message": "Item created successfully", "item": item}

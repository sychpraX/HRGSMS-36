from fastapi import APIRouter
from ...services.branch_service import get_branches

router = APIRouter(prefix="/branches", tags=["branches"])

@router.get("/")
def list_branches():
    """Return simple list of branches for dropdowns."""
    return get_branches()

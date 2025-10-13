# app/api/routes/reports.py
from fastapi import APIRouter, Depends, Query
from datetime import date
from typing import List, Dict
from ...services.report_service import get_revenue_report
from ...api.dependancies import require_roles

router = APIRouter(prefix="/reports", tags=["reports"])

@router.get("/revenue")
def revenue_report(
    branch_id: int = Query(..., description="Branch ID"),
    start_date: date = Query(..., description="Start date"),
    end_date: date = Query(..., description="End date"),
    user=Depends(require_roles("Admin", "Manager"))
):
    """Get revenue report for a branch within a date range."""
    return get_revenue_report(branch_id, start_date, end_date)

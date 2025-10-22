# app/api/routes/reports.py
from fastapi import APIRouter, Depends, Query, HTTPException, status
from datetime import date
from typing import List, Dict
from ...services.report_service import get_revenue_report, get_room_occupancy_report, get_guest_billing_summary, get_service_usage_per_room
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

@router.get("/roomOccupancy")
def occupancy_report(
    branch_id: int = Query(..., description="Branch ID"),
    start_date: date = Query(..., description="Start date"),
    end_date: date = Query(..., description="End date"),
    user=Depends(require_roles("Admin", "Manager"))
):
    """Get room occupancy for a specific branch within a date range.

    The underlying stored procedure returns occupancy across branches; we filter
    the results server-side to only return rows for the requested branch.
    """
    rows = get_room_occupancy_report(start_date, end_date)
    # The stored procedure returns `location` (branch name). Map branch_id -> location
    try:
        from ...services.branch_service import get_branches
        branches = get_branches()
    except Exception:
        branches = []

    branch_location = None
    for b in branches:
        if b.get('branchID') == branch_id or b.get('branchId') == branch_id:
            branch_location = b.get('location')
            break

    if branch_location is None:
        # If branch not found in DB, return 404 to help frontend diagnose
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Branch not found")

    filtered = [r for r in (rows or []) if str(r.get('location','')).strip().lower() == str(branch_location).strip().lower()]
    return filtered


@router.get("/guestBilling")
def occupancy_report(
    user=Depends(require_roles("Admin", "Manager"))
):
    """Get revenue report for a branch within a date range."""
    return get_guest_billing_summary()


@router.get("/serviceUsage")
def occupancy_report(
    user=Depends(require_roles("Admin", "Manager"))
):
    """Get revenue report for a branch within a date range."""
    return get_service_usage_per_room()

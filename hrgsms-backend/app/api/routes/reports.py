# app/api/routes/reports.py
from fastapi import APIRouter, Depends
from ...services.report_service import (
  billing_summary, report_occupancy, report_guest_billing_summary,
  report_service_breakdown, report_monthly_revenue, report_top_services
)
from ...api.dependencies import require_roles

router = APIRouter(prefix="/reports", tags=["reports"])

@router.get("/billing/{booking_id}")
def billing(booking_id: int, discountPolicyID: int = 1, user=Depends(require_roles("Admin","Manager","Staff"))):
    return billing_summary(booking_id, discountPolicyID)

@router.get("/occupancy")
def occupancy(start: str, end: str, user=Depends(require_roles("Admin","Manager","Staff"))):
    return report_occupancy(start, end)

@router.get("/guest-billing")
def guest_billing(user=Depends(require_roles("Admin","Manager"))):
    return report_guest_billing_summary()

@router.get("/service-breakdown")
def service_breakdown(start: str, end: str, user=Depends(require_roles("Admin","Manager"))):
    return report_service_breakdown(start, end)

@router.get("/monthly-revenue")
def monthly_revenue(year: int, user=Depends(require_roles("Admin","Manager"))):
    return report_monthly_revenue(year)

@router.get("/top-services")
def top_services(start: str, end: str, limit: int = 10, user=Depends(require_roles("Admin","Manager"))):
    return report_top_services(start, end, limit)

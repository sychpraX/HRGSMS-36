# app/api/routes/payments.py
from fastapi import APIRouter, Depends, HTTPException
from ...models.schemas import PaymentRequest
from ...services.payment_service import add_payment
from ...api.dependencies import require_roles

router = APIRouter(prefix="/payments", tags=["payments"])

@router.post("")
def pay(body: PaymentRequest, user=Depends(require_roles("Admin","Manager","Staff"))):
    row = add_payment(body.bookingID, body.amount, body.method, body.note)
    if not row: raise HTTPException(400, "Failed to add payment")
    return row[0]

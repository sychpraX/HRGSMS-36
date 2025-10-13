from ..database.queries import call_proc
from typing import Dict

def create_invoice(booking_id: int, policy_id: int = None, discount_code: int = None) -> int:
    """Create invoice for a booking using stored procedure."""
    result = call_proc("sp_create_invoice", (booking_id, policy_id, discount_code))
    if result and len(result) > 0:
        return result[0]["invoiceID"]
    raise Exception("Failed to create invoice")

def add_payment(invoice_id: int, amount: float, method: str) -> int:
    """Add payment to an invoice using stored procedure."""
    # Note: This procedure would need to be created in the database
    result = call_proc("sp_add_payment", (invoice_id, amount, method))
    if result and len(result) > 0:
        return result[0]["transactionID"]
    raise Exception("Failed to add payment")
    



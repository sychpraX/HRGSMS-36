from ..database.queries import call_proc
from datetime import date
from typing import List, Dict

def get_revenue_report(branch_id: int, start_date: date, end_date: date) -> List[Dict]:
    """Get revenue report for a branch using stored procedure."""
    result = call_proc("sp_get_revenue_report", (branch_id, start_date, end_date))
    return result if result else []
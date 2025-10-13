from database.queries import call_proc

def add_payment(bookingID: int, amount: float, method: str, note: str):
    return call_proc("sp_add_payment", (bookingID, amount, method, note))
    



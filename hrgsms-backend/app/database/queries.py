# Group related raw SQL queries here. Always parameterize with %s.

USER_QUERIES = {
    "get_by_email": """SELECT user_id, email, password_hash, role FROM User WHERE email = %s LIMIT 1;""",
    "create": """INSERT INTO User (email, password_hash, role, created_at) VALUES (%s, %s, %s, NOW());""",
}

ROOM_QUERIES = {
    "all": """
        SELECT r.room_id, r.room_number, rt.type_name, rt.base_rate, r.status, b.branch_name
        FROM Room r
        JOIN RoomType rt ON r.room_type_id = rt.room_type_id
        JOIN Branch b ON r.branch_id = b.branch_id
        ORDER BY r.room_number;
    """,
    "available_in_range": """
        SELECT r.room_id, r.room_number
        FROM Room r
        WHERE r.status = 'Available' AND r.room_id NOT IN (
            SELECT room_id FROM Booking
            WHERE NOT (check_out_date <= %s OR check_in_date >= %s)
        );
    """
}

BOOKING_QUERIES = {
    "create": """
        INSERT INTO Booking (guest_id, room_id, check_in_date, check_out_date, status, created_at)
        VALUES (%s, %s, %s, %s, 'Booked', NOW());
    """,
    "get": """
        SELECT * FROM Booking WHERE booking_id = %s;
    """
}

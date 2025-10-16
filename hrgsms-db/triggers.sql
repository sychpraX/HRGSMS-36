DELIMITER $$

-- Trigger to update room status to 'Occupied' on check-in
CREATE TRIGGER trg_room_occupied_after_checkin
AFTER UPDATE ON Booking
FOR EACH ROW
BEGIN
  IF NEW.bookingStatus = 'CheckedIn' THEN
    UPDATE Room
    SET roomStatus = 'Occupied'
    WHERE roomID = NEW.roomID;
  END IF;
END $$

-- Trigger to update room status to 'Available' on check-out
CREATE TRIGGER trg_room_available_after_checkout
AFTER UPDATE ON Booking
FOR EACH ROW
BEGIN
  IF NEW.bookingStatus = 'CheckedOut' THEN
    UPDATE Room
    SET roomStatus = 'Available'
    WHERE roomID = NEW.roomID;
  END IF;
END $$

DELIMITER ;
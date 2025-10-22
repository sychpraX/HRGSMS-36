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

DELIMITER $$
-- Trigger to validate invoice settlement before checkout

CREATE TRIGGER trg_before_checkout
BEFORE UPDATE ON Booking
FOR EACH ROW
BEGIN
  DECLARE v_roomCharges DECIMAL(15,2) DEFAULT 0.00;
  DECLARE v_serviceCharges DECIMAL(15,2) DEFAULT 0.00;
  DECLARE v_taxAmount DECIMAL(15,2) DEFAULT 0.00;
  DECLARE v_discountAmount DECIMAL(15,2) DEFAULT 0.00;
  DECLARE v_lateAmount DECIMAL(15,2) DEFAULT 0.00;
  DECLARE v_settledAmount DECIMAL(15,2) DEFAULT 0.00;
  DECLARE v_totalAmount DECIMAL(15,2) DEFAULT 0.00;

  -- Only fire when moving from CheckedIn → CheckedOut
  IF NEW.bookingStatus = 'CheckedOut' AND OLD.bookingStatus = 'CheckedIn' THEN

    -- Fetch all components of the invoice
    SELECT 
      COALESCE(roomCharges, 0),
      COALESCE(serviceCharges, 0),
      COALESCE(taxAmount, 0),
      COALESCE(discountAmount, 0),
      COALESCE(amount, 0),
      COALESCE(settledAmount, 0)
    INTO
      v_roomCharges,
      v_serviceCharges,
      v_taxAmount,
      v_discountAmount,
      v_lateAmount,
      v_settledAmount
    FROM Invoice
    WHERE bookingID = OLD.bookingID;

    -- Calculate derived total
    SET v_totalAmount = (v_roomCharges + v_serviceCharges + v_taxAmount + v_lateAmount) - v_discountAmount;

    -- Validate payment
    IF v_settledAmount < v_totalAmount THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Checkout blocked: Invoice not fully settled';
    END IF;
  END IF;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_after_booking_insert
AFTER INSERT ON Booking
FOR EACH ROW
BEGIN
  -- Insert a placeholder invoice linked to the new booking
  INSERT INTO Invoice (bookingID)
  VALUES (NEW.bookingID);
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER trg_before_invoice_update
BEFORE UPDATE ON Invoice
FOR EACH ROW
BEGIN
  DECLARE v_totalDue DECIMAL(15,2);

  SET v_totalDue = COALESCE(NEW.roomCharges, 0)
                 + COALESCE(NEW.serviceCharges, 0)
                 + COALESCE(NEW.taxAmount, 0)
                 + COALESCE(NEW.lateFee, 0)
                 - COALESCE(NEW.discountAmount, 0);

  IF COALESCE(NEW.settledAmount, 0) = 0 THEN
    SET NEW.invoiceStatus = 'Pending';
  ELSEIF COALESCE(NEW.settledAmount, 0) < v_totalDue THEN
    SET NEW.invoiceStatus = 'Partially Paid';
  ELSE
    SET NEW.invoiceStatus = 'Paid';
  END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_before_invoice_update
BEFORE UPDATE ON Invoice
FOR EACH ROW
BEGIN
  DECLARE v_totalDue DECIMAL(15,2);

  SET v_totalDue = COALESCE(NEW.roomCharges, 0)
                 + COALESCE(NEW.serviceCharges, 0)
                 + COALESCE(NEW.taxAmount, 0)
                 + COALESCE(NEW.lateAmount, 0)
                 - COALESCE(NEW.discountAmount, 0);

  IF COALESCE(NEW.settledAmount, 0) = 0 THEN
    SET NEW.invoiceStatus = 'Pending';
  ELSEIF COALESCE(NEW.settledAmount, 0) < v_totalDue THEN
    SET NEW.invoiceStatus = 'Partially Paid';
  ELSE
    SET NEW.invoiceStatus = 'Paid';
  END IF;
END$$

DELIMITER ;

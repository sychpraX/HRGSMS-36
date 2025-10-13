--Used to create the user with hashed password
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_create_user $$
CREATE PROCEDURE sp_create_user(
  IN p_username VARCHAR(50),
  IN p_plain VARCHAR(255),
  IN p_role VARCHAR(20)
)
BEGIN
    IF EXISTS (SELECT 1 FROM User_Account WHERE username = p_username) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username already exists';
    END IF;

    IF p_role NOT IN ('Admin','Manager','Reception','Staff') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid role';
    END IF;

    SET @salt := RANDOM_BYTES(16);
    SET @hash := fn_password_hash(@salt, p_plain);

    INSERT INTO User_Account(username, password_hash, salt, userRole)
    VALUES (p_username, @hash, @salt, p_role);

    SELECT LAST_INSERT_ID() AS userID;
END $$

-- Used for login verification
DROP PROCEDURE IF EXISTS sp_login $$
CREATE PROCEDURE sp_login(
  IN p_username VARCHAR(50),
  IN p_plain VARCHAR(255)
)
BEGIN
  DECLARE v_userID BIGINT UNSIGNED;
  DECLARE v_role VARCHAR(20);
  DECLARE v_salt VARBINARY(16);
  DECLARE v_hash VARBINARY(32);

  SELECT userID, userRole, salt, password_hash
    INTO v_userID, v_role, v_salt, v_hash
  FROM User_Account
  WHERE username = p_username
  LIMIT 1;

  IF v_userID IS NULL THEN
    SELECT 0 AS success, NULL AS userID, NULL AS username, NULL AS userRole;
  ELSE
    IF fn_password_hash(v_salt, p_plain) = v_hash THEN
      SELECT 1 AS success, v_userID AS userID, p_username AS username, v_role AS userRole;
    ELSE
      SELECT 0 AS success, NULL AS userID, NULL AS username, NULL AS userRole;
    END IF;
  END IF;
END $$

-- Room Management Procedures
DROP PROCEDURE IF EXISTS sp_get_available_rooms $$
CREATE PROCEDURE sp_get_available_rooms(
  IN p_branchID BIGINT UNSIGNED,
  IN p_checkIn DATETIME,
  IN p_checkOut DATETIME
)
BEGIN
  SELECT 
    r.roomID,
    r.roomNo,
    rt.typeName,
    rt.capacity,
    rt.currRate,
    r.roomStatus,
    b.branchLocation
  FROM Room r
  INNER JOIN Room_Type rt ON r.typeID = rt.typeID
  INNER JOIN Branch b ON r.branchID = b.branchID
  WHERE r.branchID = p_branchID
    AND r.roomStatus = 'Available'
    AND r.roomID NOT IN (
      SELECT roomID FROM Booking 
      WHERE bookingStatus IN ('Booked', 'CheckedIn')
        AND (
          (checkInDate <= p_checkIn AND checkOutDate > p_checkIn) OR
          (checkInDate < p_checkOut AND checkOutDate >= p_checkOut) OR
          (checkInDate >= p_checkIn AND checkOutDate <= p_checkOut)
        )
    );
END $$

-- Booking Management Procedures
DROP PROCEDURE IF EXISTS sp_create_booking $$
CREATE PROCEDURE sp_create_booking(
  IN p_guestID BIGINT UNSIGNED,
  IN p_branchID BIGINT UNSIGNED,
  IN p_roomID BIGINT UNSIGNED,
  IN p_checkInDate DATETIME,
  IN p_checkOutDate DATETIME,
  IN p_numGuests INT UNSIGNED
)
BEGIN
  DECLARE v_rate DECIMAL(10,2);
  DECLARE v_bookingID BIGINT UNSIGNED;
  
  -- Get current rate for the room
  SELECT rt.currRate INTO v_rate
  FROM Room r
  INNER JOIN Room_Type rt ON r.typeID = rt.typeID
  WHERE r.roomID = p_roomID;
  
  -- Check if room is available
  IF EXISTS (
    SELECT 1 FROM Booking 
    WHERE roomID = p_roomID 
      AND bookingStatus IN ('Booked', 'CheckedIn')
      AND (
        (checkInDate <= p_checkInDate AND checkOutDate > p_checkInDate) OR
        (checkInDate < p_checkOutDate AND checkOutDate >= p_checkOutDate) OR
        (checkInDate >= p_checkInDate AND checkOutDate <= p_checkOutDate)
      )
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Room is not available for the selected dates';
  END IF;
  
  INSERT INTO Booking (guestID, branchID, roomID, rate, checkInDate, checkOutDate, numGuests)
  VALUES (p_guestID, p_branchID, p_roomID, v_rate, p_checkInDate, p_checkOutDate, p_numGuests);
  
  SET v_bookingID = LAST_INSERT_ID();
  
  -- Update room status
  UPDATE Room SET roomStatus = 'Occupied' WHERE roomID = p_roomID;
  
  SELECT v_bookingID AS bookingID;
END $$

-- Guest Management Procedures
DROP PROCEDURE IF EXISTS sp_create_guest $$
CREATE PROCEDURE sp_create_guest(
  IN p_firstName VARCHAR(50),
  IN p_lastName VARCHAR(50),
  IN p_phone VARCHAR(20),
  IN p_email VARCHAR(100),
  IN p_idNumber VARCHAR(30)
)
BEGIN
  INSERT INTO Guest (firstName, lastName, phone, email, idNumber)
  VALUES (p_firstName, p_lastName, p_phone, p_email, p_idNumber);
  
  SELECT LAST_INSERT_ID() AS guestID;
END $$

DROP PROCEDURE IF EXISTS sp_get_guest_by_id $$
CREATE PROCEDURE sp_get_guest_by_id(
  IN p_guestID BIGINT UNSIGNED
)
BEGIN
  SELECT guestID, firstName, lastName, phone, email, idNumber
  FROM Guest
  WHERE guestID = p_guestID;
END $$

-- Check-in/Check-out Procedures
DROP PROCEDURE IF EXISTS sp_checkin $$
CREATE PROCEDURE sp_checkin(
  IN p_bookingID BIGINT UNSIGNED
)
BEGIN
  UPDATE Booking 
  SET bookingStatus = 'CheckedIn'
  WHERE bookingID = p_bookingID 
    AND bookingStatus = 'Booked';
    
  IF ROW_COUNT() = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Booking not found or already checked in';
  END IF;
  
  SELECT 'Check-in successful' AS message;
END $$

DROP PROCEDURE IF EXISTS sp_checkout $$
CREATE PROCEDURE sp_checkout(
  IN p_bookingID BIGINT UNSIGNED
)
BEGIN
  DECLARE v_roomID BIGINT UNSIGNED;
  
  SELECT roomID INTO v_roomID
  FROM Booking
  WHERE bookingID = p_bookingID;
  
  UPDATE Booking 
  SET bookingStatus = 'CheckedOut'
  WHERE bookingID = p_bookingID 
    AND bookingStatus = 'CheckedIn';
    
  IF ROW_COUNT() = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Booking not found or not checked in';
  END IF;
  
  -- Update room status
  UPDATE Room SET roomStatus = 'Available' WHERE roomID = v_roomID;
  
  SELECT 'Check-out successful' AS message;
END $$

-- Service Management Procedures
DROP PROCEDURE IF EXISTS sp_add_service_usage $$
CREATE PROCEDURE sp_add_service_usage(
  IN p_bookingID BIGINT UNSIGNED,
  IN p_serviceID INT UNSIGNED,
  IN p_quantity INT UNSIGNED
)
BEGIN
  DECLARE v_rate DECIMAL(10,2);
  
  -- Get current service rate
  SELECT ratePerUnit INTO v_rate
  FROM Chargeble_Service
  WHERE serviceID = p_serviceID;
  
  INSERT INTO Service_Usage (bookingID, serviceID, rate, quantity, usedAt)
  VALUES (p_bookingID, p_serviceID, v_rate, p_quantity, NOW());
  
  SELECT LAST_INSERT_ID() AS usageID;
END $$

-- Payment and Invoice Procedures
DROP PROCEDURE IF EXISTS sp_create_invoice $$
CREATE PROCEDURE sp_create_invoice(
  IN p_bookingID BIGINT UNSIGNED,
  IN p_policyID INT UNSIGNED,
  IN p_discountCode INT UNSIGNED
)
BEGIN
  DECLARE v_roomCharges DECIMAL(15,2) DEFAULT 0.00;
  DECLARE v_serviceCharges DECIMAL(15,2) DEFAULT 0.00;
  DECLARE v_taxAmount DECIMAL(10,2) DEFAULT 0.00;
  DECLARE v_discountAmount DECIMAL(10,2) DEFAULT 0.00;
  DECLARE v_invoiceID BIGINT UNSIGNED;
  
  -- Calculate room charges
  SELECT 
    rate * DATEDIFF(checkOutDate, checkInDate) INTO v_roomCharges
  FROM Booking
  WHERE bookingID = p_bookingID;
  
  -- Calculate service charges
  SELECT COALESCE(SUM(rate * quantity), 0) INTO v_serviceCharges
  FROM Service_Usage
  WHERE bookingID = p_bookingID;
  
  -- Calculate tax
  IF p_policyID IS NOT NULL THEN
    SELECT (v_roomCharges + v_serviceCharges) * rate INTO v_taxAmount
    FROM Tax_Policy
    WHERE policyID = p_policyID;
  END IF;
  
  -- Calculate discount
  IF p_discountCode IS NOT NULL THEN
    SELECT 
      CASE 
        WHEN discountValue <= 1 THEN (v_roomCharges + v_serviceCharges) * discountValue
        ELSE discountValue
      END INTO v_discountAmount
    FROM Discount
    WHERE discountCode = p_discountCode
      AND CURDATE() BETWEEN validFrom AND validTo;
  END IF;
  
  INSERT INTO Invoice (
    bookingID, policyID, discountCode, 
    roomCharges, serviceCharges, taxAmount, discountAmount
  )
  VALUES (
    p_bookingID, p_policyID, p_discountCode,
    v_roomCharges, v_serviceCharges, v_taxAmount, v_discountAmount
  );
  
  SET v_invoiceID = LAST_INSERT_ID();
  SELECT v_invoiceID AS invoiceID;
END $$

-- Payment Procedures
DROP PROCEDURE IF EXISTS sp_add_payment $$
CREATE PROCEDURE sp_add_payment(
  IN p_invoiceID BIGINT UNSIGNED,
  IN p_amount DECIMAL(15,2),
  IN p_paymentMethod ENUM('Cash','Card','Online','Other')
)
BEGIN
  DECLARE v_currentSettled DECIMAL(15,2);
  DECLARE v_totalDue DECIMAL(15,2);
  
  -- Get current settled amount and calculate total due
  SELECT 
    i.settledAmount,
    (i.roomCharges + i.serviceCharges + i.taxAmount - i.discountAmount)
  INTO v_currentSettled, v_totalDue
  FROM Invoice i
  WHERE i.invoiceID = p_invoiceID;
  
  -- Check if payment amount is valid
  IF (v_currentSettled + p_amount) > v_totalDue THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Payment amount exceeds due amount';
  END IF;
  
  -- Insert payment record
  INSERT INTO Payment (invoiceID, transactionDate, paymentMethod, amount)
  VALUES (p_invoiceID, CURDATE(), p_paymentMethod, p_amount);
  
  -- Update settled amount in invoice
  UPDATE Invoice 
  SET settledAmount = settledAmount + p_amount,
      invoiceStatus = CASE 
        WHEN (settledAmount + p_amount) >= (roomCharges + serviceCharges + taxAmount - discountAmount) 
        THEN 'Paid'
        ELSE 'Partially Paid'
      END
  WHERE invoiceID = p_invoiceID;
  
  SELECT LAST_INSERT_ID() AS transactionID;
END $$

-- Reporting Procedures
DROP PROCEDURE IF EXISTS sp_get_revenue_report $$
CREATE PROCEDURE sp_get_revenue_report(
  IN p_branchID BIGINT UNSIGNED,
  IN p_startDate DATE,
  IN p_endDate DATE
)
BEGIN
  SELECT 
    DATE(b.checkInDate) as date,
    COUNT(b.bookingID) as bookings,
    SUM(i.roomCharges + i.serviceCharges + i.taxAmount - i.discountAmount) as total_revenue,
    SUM(i.settledAmount) as collected_amount
  FROM Booking b
  INNER JOIN Invoice i ON b.bookingID = i.bookingID
  WHERE b.branchID = p_branchID
    AND DATE(b.checkInDate) BETWEEN p_startDate AND p_endDate
  GROUP BY DATE(b.checkInDate)
  ORDER BY DATE(b.checkInDate);
END $$

DELIMITER ;


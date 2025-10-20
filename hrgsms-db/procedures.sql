DELIMITER $$
CREATE DEFINER=`hrgsms_usr`@`127.0.0.1` PROCEDURE `sp_add_payment`(
  IN p_invoiceID BIGINT UNSIGNED,
  IN p_amount DECIMAL(15,2),
  IN p_paymentMethod VARCHAR(20)
)
BEGIN
  DECLARE v_currentSettled DECIMAL(15,2);
  DECLARE v_totalDue DECIMAL(15,2);
  
  
  -- Error handler for rollback on exception
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' 
      SET MESSAGE_TEXT = 'Payment transaction failed — rolled back';
  END;
  
  START TRANSACTION;

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

  COMMIT;
  
  SELECT LAST_INSERT_ID() AS transactionID;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`hrgsms_usr`@`127.0.0.1` PROCEDURE `sp_add_service_usage`(
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
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`hrgsms_usr`@`127.0.0.1` PROCEDURE `sp_checkin`(
  IN p_bookingID BIGINT UNSIGNED
)
BEGIN
  UPDATE Booking 
  SET bookingStatus = 'CheckedIn'
  WHERE bookingID = p_bookingID 
    AND bookingStatus = 'Booked';

    -- A trigger is available to handle the invoice creation upon checking in
    
  IF ROW_COUNT() = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Booking not found or already checked in';
  END IF;
  
  SELECT 'Check-in successful' AS message;
END$$
DELIMITER ;

DELIMITER $$

CREATE DEFINER=`hrgsms_usr`@`127.0.0.1` PROCEDURE `sp_generate_final_invoice`(
  IN p_bookingID BIGINT UNSIGNED,
  IN p_policyID INT UNSIGNED,        -- optional tax policy
  IN p_discountCode INT UNSIGNED,    -- optional discount
  IN p_latePolicyID INT UNSIGNED     -- optional late checkout policy
)
BEGIN
  DECLARE v_roomCharges DECIMAL(15,2) DEFAULT 0.00;
  DECLARE v_serviceCharges DECIMAL(15,2) DEFAULT 0.00;
  DECLARE v_taxAmount DECIMAL(10,2) DEFAULT 0.00;
  DECLARE v_discountAmount DECIMAL(10,2) DEFAULT 0.00;
  DECLARE v_lateAmount DECIMAL(10,2) DEFAULT 0.00;

  --  Base room charge
  SELECT rate * DATEDIFF(checkOutDate, checkInDate)
    INTO v_roomCharges
  FROM Booking
  WHERE bookingID = p_bookingID;

  -- Late checkout fee
  IF p_latePolicyID IS NOT NULL THEN
    SELECT fee INTO v_lateAmount
    FROM Late_Checkout_Policy
    WHERE policyID = p_latePolicyID;
    SET v_roomCharges = v_roomCharges + v_lateAmount;
  END IF;

  --  Service charges
  SELET COALESCE(SUM(rate * quantity), 0)
    INTO v_serviceCharges
  FROM Service_Usage
  WHERE bookingID = p_bookingID;

  --  Tax
  IF p_policyID IS NOT NULL THEN
    SELECT (v_roomCharges + v_serviceCharges + v_lateAmount) * rate
      INTO v_taxAmount
    FROM Tax_Policy
    WHERE policyID = p_policyID;
  END IF;

  --  Discount
  IF p_discountCode IS NOT NULL THEN
    SELECT discountValue
      INTO v_discountAmount
    FROM Discount
    WHERE discountCode = p_discountCode
      AND CURDATE() BETWEEN validFrom AND validTo;
  END IF;

  --  Update or insert invoice
  IF EXISTS (SELECT 1 FROM Invoice WHERE bookingID = p_bookingID) THEN
    UPDATE Invoice
    SET policyID       = p_policyID,
        discountCode   = p_discountCode,
        roomCharges    = v_roomCharges,
        serviceCharges = v_serviceCharges,
        taxAmount      = v_taxAmount,
        discountAmount = v_discountAmount,
        lateFee        = v_lateAmount
    WHERE bookingID = p_bookingID;
  ELSE
    INSERT INTO Invoice (
      bookingID, policyID, discountCode,
      roomCharges, serviceCharges, taxAmount, discountAmount, lateFee
    )
    VALUES (
      p_bookingID, p_policyID, p_discountCode,
      v_roomCharges, v_serviceCharges, v_taxAmount, v_discountAmount, v_lateAmount
    );
  END IF;

  --  Return calculated totals
  SELECT
    v_roomCharges    AS room_charges,
    v_serviceCharges AS service_charges,
    v_lateAmount     AS late_checkout_fee,
    v_taxAmount      AS tax,
    v_discountAmount AS discount;
END$$

DELIMITER ;

DELIMITER $$

CREATE DEFINER=`hrgsms_usr`@`127.0.0.1` PROCEDURE `sp_checkout`(
  IN p_bookingID BIGINT UNSIGNED
)

BEGIN
  DECLARE v_roomID BIGINT UNSIGNED;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Checkout failed — transaction rolled back';
  END;

  START TRANSACTION;

  -- Validate booking and lock it
  SELECT roomID INTO v_roomID
  FROM Booking
  WHERE bookingID = p_bookingID AND bookingStatus = 'CheckedIn'
  FOR UPDATE;

  IF v_roomID IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Booking not found or not checked in';
  END IF;

  -- Mark booking as checked out
  UPDATE Booking
  SET bookingStatus = 'CheckedOut'
  WHERE bookingID = p_bookingID;

  -- Update room to available
  UPDATE Room
  SET roomStatus = 'Available'
  WHERE roomID = v_roomID;

  COMMIT;

  --  Return summary
  SELECT
    'Checkout completed successfully' AS message,
END$$

DELIMITER ;


DELIMITER $$
CREATE DEFINER=`hrgsms_usr`@`127.0.0.1` PROCEDURE `sp_create_booking`(
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
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Booking transaction failed — rolled back';
  END;
  
  START TRANSACTION;
  
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
	FOR UPDATE
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Room is not available for the selected dates';
  END IF;
  
  INSERT INTO Booking (guestID, branchID, roomID, rate, checkInDate, checkOutDate, numGuests)
  VALUES (p_guestID, p_branchID, p_roomID, v_rate, p_checkInDate, p_checkOutDate, p_numGuests);
  
  SET v_bookingID = LAST_INSERT_ID();
  
  -- Update room status
  UPDATE Room SET roomStatus = 'Occupied' WHERE roomID = p_roomID;

  -- A trigger is available to handle the invoice creation upon booking
  
  COMMIT;
  
  SELECT v_bookingID AS bookingID;
END

DELIMITER $$
CREATE DEFINER=`hrgsms_usr`@`127.0.0.1` PROCEDURE `sp_create_guest`(
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
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`hrgsms_usr`@`127.0.0.1` PROCEDURE `sp_create_invoice`(
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
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`hrgsms_usr`@`127.0.0.1` PROCEDURE `sp_create_user`(
  IN p_username VARCHAR(50),
  IN p_plain VARCHAR(255),
  IN p_role VARCHAR(20)
)
BEGIN
    IF EXISTS (SELECT 1 FROM User_Account WHERE username = p_username) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username already exists';
    END IF;

  IF p_role NOT IN ('Admin','Manager','Reception','Staff','Guest') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid role';
  END IF;

    SET @salt := RANDOM_BYTES(16);
    SET @hash := fn_password_hash(@salt, p_plain);

    INSERT INTO User_Account(username, password_hash, salt, userRole)
    VALUES (p_username, @hash, @salt, p_role);

    SELECT LAST_INSERT_ID() AS userID;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`hrgsms_usr`@`127.0.0.1` PROCEDURE `sp_get_available_rooms`(
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
    b.location
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
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`hrgsms_usr`@`127.0.0.1` PROCEDURE `sp_get_guest_billing_summary`()
BEGIN
    SELECT 
        i.invoiceID, 
        CONCAT(g.firstName, ' ', g.lastName) AS guestName,
        (i.roomCharges + i.serviceCharges + i.taxAmount + l.amount - i.discountAmount - i.settledAmount) AS unpaid_amount
    FROM Invoice i
    INNER JOIN Booking b ON i.bookingID = b.bookingID
    INNER JOIN Guest g ON g.guestID = b.guestID
    LEFT JOIN Late_Checkout_Policy l ON i.latePolicyID = l.latePolicyID
    WHERE (i.roomCharges + i.serviceCharges + i.taxAmount + IFNULL(l.amount, 0) - i.discountAmount - i.settledAmount) > 0
    ORDER BY guestName, i.invoiceID;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`hrgsms_usr`@`127.0.0.1` PROCEDURE `sp_get_guest_by_id`(
  IN p_guestID BIGINT UNSIGNED
)
BEGIN
  SELECT guestID, firstName, lastName, phone, email, idNumber
  FROM Guest
  WHERE guestID = p_guestID;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`hrgsms_usr`@`127.0.0.1` PROCEDURE `sp_get_revenue_report`(
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
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`hrgsms_usr`@`127.0.0.1` PROCEDURE `sp_get_room_occupancy_report`(
  IN p_startDate DATE,
  IN p_endDate DATE
)
BEGIN
  SELECT 
    b.location,
    r.roomNo,
    CASE 
      WHEN EXISTS (
        SELECT 1 FROM Booking bk
        WHERE bk.roomID = r.roomID
          AND bk.checkInDate < p_endDate
          AND bk.checkOutDate > p_startDate
          AND bk.bookingStatus IN ('Booked','CheckedIn')
      )
      THEN 'Unavailable'
      ELSE 'Available'
    END AS availability
  FROM Branch b
  INNER JOIN Room r ON b.branchID = r.branchID
  ORDER BY b.location, r.roomNo;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`hrgsms_usr`@`127.0.0.1` PROCEDURE `sp_get_service_usage_per_room`()
BEGIN
  SELECT
    b.location,
    r.roomNo,
    cs.serviceType,
    SUM(su.quantity) AS total_quantity,
    SUM(su.rate * su.quantity) AS total_amount
  FROM Service_Usage su
  INNER JOIN Booking bk ON su.bookingID = bk.bookingID
  INNER JOIN Room r ON bk.roomID = r.roomID
  INNER JOIN Branch b ON r.branchID = b.branchID
  INNER JOIN Chargeble_Service cs ON su.serviceID = cs.serviceID
  GROUP BY b.location, r.roomNo, cs.serviceType
  ORDER BY b.location, r.roomNo, cs.serviceType;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`hrgsms_usr`@`127.0.0.1` PROCEDURE `sp_login`(
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
END$$
DELIMITER ;

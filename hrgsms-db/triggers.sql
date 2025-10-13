USE hrgsms_db;

DELIMITER $$

-- Trigger to automatically update room status when booking is checked in
DROP TRIGGER IF EXISTS tr_update_room_status_checkin $$
CREATE TRIGGER tr_update_room_status_checkin
    AFTER UPDATE ON Booking
    FOR EACH ROW
BEGIN
    IF NEW.bookingStatus = 'CheckedIn' AND OLD.bookingStatus != 'CheckedIn' THEN
        UPDATE Room 
        SET roomStatus = 'Occupied' 
        WHERE roomID = NEW.roomID;
        
        -- Log the check-in event
        INSERT INTO Log (branchID, bookingID, logAction, logDescription)
        VALUES (NEW.branchID, NEW.bookingID, 'CheckIn', 
                CONCAT('Guest checked in to room ', 
                       (SELECT roomNo FROM Room WHERE roomID = NEW.roomID)));
    END IF;
END $$

-- Trigger to automatically update room status when booking is checked out
DROP TRIGGER IF EXISTS tr_update_room_status_checkout $$
CREATE TRIGGER tr_update_room_status_checkout
    AFTER UPDATE ON Booking
    FOR EACH ROW
BEGIN
    IF NEW.bookingStatus = 'CheckedOut' AND OLD.bookingStatus != 'CheckedOut' THEN
        UPDATE Room 
        SET roomStatus = 'Available' 
        WHERE roomID = NEW.roomID;
        
        -- Log the check-out event
        INSERT INTO Log (branchID, bookingID, logAction, logDescription)
        VALUES (NEW.branchID, NEW.bookingID, 'CheckOut', 
                CONCAT('Guest checked out from room ', 
                       (SELECT roomNo FROM Room WHERE roomID = NEW.roomID)));
    END IF;
END $$

-- Trigger to prevent booking of occupied rooms
DROP TRIGGER IF EXISTS tr_check_room_availability $$
CREATE TRIGGER tr_check_room_availability
    BEFORE INSERT ON Booking
    FOR EACH ROW
BEGIN
    DECLARE room_status VARCHAR(20);
    DECLARE overlapping_bookings INT DEFAULT 0;
    
    -- Check current room status
    SELECT roomStatus INTO room_status 
    FROM Room 
    WHERE roomID = NEW.roomID;
    
    -- Check for overlapping bookings
    SELECT COUNT(*) INTO overlapping_bookings
    FROM Booking 
    WHERE roomID = NEW.roomID 
      AND bookingStatus IN ('Booked', 'CheckedIn')
      AND NOT (NEW.checkOutDate <= checkInDate OR NEW.checkInDate >= checkOutDate);
    
    IF overlapping_bookings > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Room is not available for the selected dates';
    END IF;
END $$

-- Trigger to automatically calculate invoice amounts
DROP TRIGGER IF EXISTS tr_calculate_invoice_amounts $$
CREATE TRIGGER tr_calculate_invoice_amounts
    BEFORE INSERT ON Invoice
    FOR EACH ROW
BEGIN
    DECLARE booking_nights INT DEFAULT 0;
    DECLARE booking_rate DECIMAL(10,2) DEFAULT 0;
    DECLARE total_service_charges DECIMAL(15,2) DEFAULT 0;
    DECLARE late_checkout_amount DECIMAL(10,2) DEFAULT 0;
    DECLARE discount_amount DECIMAL(10,2) DEFAULT 0;
    DECLARE tax_rate DECIMAL(5,4) DEFAULT 0;
    DECLARE calculated_tax DECIMAL(10,2) DEFAULT 0;
    
    -- Calculate room charges (nights * rate)
    SELECT 
        DATEDIFF(checkOutDate, checkInDate) as nights,
        rate
    INTO booking_nights, booking_rate
    FROM Booking 
    WHERE bookingID = NEW.bookingID;
    
    SET NEW.roomCharges = booking_nights * booking_rate;
    
    -- Calculate service charges
    SELECT COALESCE(SUM(rate * quantity), 0) 
    INTO total_service_charges
    FROM Service_Usage 
    WHERE bookingID = NEW.bookingID;
    
    -- Add late checkout charges if any
    SELECT COALESCE(amount, 0)
    INTO late_checkout_amount
    FROM Late_Checkout 
    WHERE bookingID = NEW.bookingID;
    
    SET NEW.serviceCharges = total_service_charges + late_checkout_amount;
    
    -- Calculate discount amount
    IF NEW.discountCode IS NOT NULL THEN
        SELECT discountValue 
        INTO discount_amount
        FROM Discount 
        WHERE discountCode = NEW.discountCode
          AND CURDATE() BETWEEN validFrom AND validTo;
        
        -- Apply discount percentage to room charges
        SET NEW.discountAmount = (NEW.roomCharges * discount_amount / 100);
    END IF;
    
    -- Calculate tax amount
    IF NEW.policyID IS NOT NULL THEN
        SELECT rate 
        INTO tax_rate
        FROM Tax_Policy 
        WHERE policyID = NEW.policyID;
        
        SET calculated_tax = ((NEW.roomCharges + NEW.serviceCharges - NEW.discountAmount) * tax_rate);
        SET NEW.taxAmount = calculated_tax;
    END IF;
END $$

-- Trigger to update invoice status when payment is made
DROP TRIGGER IF EXISTS tr_update_invoice_status $$
CREATE TRIGGER tr_update_invoice_status
    AFTER INSERT ON Payment
    FOR EACH ROW
BEGIN
    DECLARE total_due DECIMAL(15,2);
    DECLARE total_paid DECIMAL(15,2);
    
    -- Calculate total amount due for this invoice
    SELECT (roomCharges + serviceCharges + taxAmount - discountAmount)
    INTO total_due
    FROM Invoice 
    WHERE invoiceID = NEW.invoiceID;
    
    -- Calculate total amount paid so far
    SELECT COALESCE(SUM(amount), 0)
    INTO total_paid
    FROM Payment 
    WHERE invoiceID = NEW.invoiceID;
    
    -- Update settled amount and status
    UPDATE Invoice 
    SET settledAmount = total_paid,
        invoiceStatus = CASE 
            WHEN total_paid >= total_due THEN 'Paid'
            WHEN total_paid > 0 THEN 'Partially Paid'
            ELSE 'Pending'
        END
    WHERE invoiceID = NEW.invoiceID;
    
    -- Log the payment
    INSERT INTO Log (bookingID, logAction, logDescription)
    SELECT bookingID, 'Payment', 
           CONCAT('Payment of ', NEW.amount, ' received via ', NEW.paymentMethod)
    FROM Invoice 
    WHERE invoiceID = NEW.invoiceID;
END $$

-- Trigger to log booking creation
DROP TRIGGER IF EXISTS tr_log_booking_creation $$
CREATE TRIGGER tr_log_booking_creation
    AFTER INSERT ON Booking
    FOR EACH ROW
BEGIN
    INSERT INTO Log (branchID, bookingID, logAction, logDescription)
    VALUES (NEW.branchID, NEW.bookingID, 'Create', 
            CONCAT('New booking created for room ', 
                   (SELECT roomNo FROM Room WHERE roomID = NEW.roomID),
                   ' from ', DATE(NEW.checkInDate), ' to ', DATE(NEW.checkOutDate)));
END $$

-- Trigger to log booking updates
DROP TRIGGER IF EXISTS tr_log_booking_update $$
CREATE TRIGGER tr_log_booking_update
    AFTER UPDATE ON Booking
    FOR EACH ROW
BEGIN
    IF OLD.bookingStatus != NEW.bookingStatus THEN
        INSERT INTO Log (branchID, bookingID, logAction, logDescription)
        VALUES (NEW.branchID, NEW.bookingID, 'Update', 
                CONCAT('Booking status changed from ', OLD.bookingStatus, ' to ', NEW.bookingStatus));
    END IF;
END $$

-- Trigger to prevent deletion of checked-in bookings
DROP TRIGGER IF EXISTS tr_prevent_checkedin_booking_deletion $$
CREATE TRIGGER tr_prevent_checkedin_booking_deletion
    BEFORE DELETE ON Booking
    FOR EACH ROW
BEGIN
    IF OLD.bookingStatus = 'CheckedIn' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Cannot delete a checked-in booking. Please check out first.';
    END IF;
END $$

-- Trigger to validate service usage booking status
DROP TRIGGER IF EXISTS tr_validate_service_usage $$
CREATE TRIGGER tr_validate_service_usage
    BEFORE INSERT ON Service_Usage
    FOR EACH ROW
BEGIN
    DECLARE booking_status VARCHAR(20);
    
    SELECT bookingStatus INTO booking_status
    FROM Booking 
    WHERE bookingID = NEW.bookingID;
    
    IF booking_status NOT IN ('CheckedIn', 'CheckedOut') THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Services can only be used for checked-in or checked-out bookings';
    END IF;
END $$

DELIMITER ;

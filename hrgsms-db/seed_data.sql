USE hrgsms_db;

-- Insert sample branches
INSERT INTO Branch (branchLocation, rating, phone, email) VALUES 
('Colombo', 4.5, '+94112345678', 'colombo@hrgsms.com'),
('Kandy', 4.2, '+94812345678', 'kandy@hrgsms.com'),
('Galle', 4.7, '+94912345678', 'galle@hrgsms.com'),
('Negombo', 4.3, '+94312345678', 'negombo@hrgsms.com');

-- Insert room types
INSERT INTO Room_Type (typeName, capacity, currRate) VALUES 
('Standard Single', 1, 5000.00),
('Standard Double', 2, 7500.00),
('Deluxe Single', 1, 8000.00),
('Deluxe Double', 2, 12000.00),
('Suite', 4, 20000.00),
('Family Room', 6, 15000.00),
('Executive Suite', 3, 25000.00);

-- Insert rooms for each branch
-- Colombo Branch (branchID = 1)
INSERT INTO Room (branchID, typeID, roomNo, roomStatus) VALUES 
(1, 1, 101, 'Available'), (1, 1, 102, 'Available'), (1, 1, 103, 'Available'),
(1, 2, 201, 'Available'), (1, 2, 202, 'Available'), (1, 2, 203, 'Available'),
(1, 3, 301, 'Available'), (1, 3, 302, 'Available'),
(1, 4, 401, 'Available'), (1, 4, 402, 'Available'),
(1, 5, 501, 'Available'), (1, 7, 601, 'Available');

-- Kandy Branch (branchID = 2)
INSERT INTO Room (branchID, typeID, roomNo, roomStatus) VALUES 
(2, 1, 101, 'Available'), (2, 1, 102, 'Available'),
(2, 2, 201, 'Available'), (2, 2, 202, 'Available'), (2, 2, 203, 'Available'),
(2, 3, 301, 'Available'), (2, 4, 401, 'Available'),
(2, 5, 501, 'Available'), (2, 6, 601, 'Available');

-- Galle Branch (branchID = 3)
INSERT INTO Room (branchID, typeID, roomNo, roomStatus) VALUES 
(3, 1, 101, 'Available'), (3, 1, 102, 'Available'), (3, 1, 103, 'Available'),
(3, 2, 201, 'Available'), (3, 2, 202, 'Available'),
(3, 4, 301, 'Available'), (3, 4, 302, 'Available'),
(3, 5, 401, 'Available'), (3, 6, 501, 'Available');

-- Negombo Branch (branchID = 4)
INSERT INTO Room (branchID, typeID, roomNo, roomStatus) VALUES 
(4, 1, 101, 'Available'), (4, 1, 102, 'Available'),
(4, 2, 201, 'Available'), (4, 2, 202, 'Available'),
(4, 3, 301, 'Available'), (4, 4, 401, 'Available'),
(4, 5, 501, 'Available'), (4, 6, 601, 'Available'),
(4, 7, 701, 'Available');

-- Insert sample guests
INSERT INTO Guest (firstName, lastName, phone, email, idNumber) VALUES 
('John', 'Smith', '+94771234567', 'john.smith@email.com', '199012345678V'),
('Sarah', 'Johnson', '+94772345678', 'sarah.johnson@email.com', '198523456789V'),
('Michael', 'Brown', '+94773456789', 'michael.brown@email.com', '199234567890V'),
('Emma', 'Davis', '+94774567890', 'emma.davis@email.com', '199445678901V'),
('David', 'Wilson', '+94775678901', 'david.wilson@email.com', '198756789012V'),
('Lisa', 'Taylor', '+94776789012', 'lisa.taylor@email.com', '199067890123V'),
('Robert', 'Anderson', '+94777890123', 'robert.anderson@email.com', '198878901234V'),
('Jennifer', 'Thomas', '+94778901234', 'jennifer.thomas@email.com', '199189012345V'),
('William', 'Garcia', '+94779012345', 'william.garcia@email.com', '199290123456V'),
('Ashley', 'Martinez', '+94771123456', 'ashley.martinez@email.com', '199301234567V');

-- Insert chargeable services
INSERT INTO Chargeble_Service (serviceType, unit, ratePerUnit) VALUES 
('Spa services', 'per person', 2500.00),
('Pool access', 'per person', 500.00),
('room service', 'per request', 1000.00),
('laundry', 'per kg', 300.00),
('minibar usage', 'per item', 250.00);

-- Insert tax policies
INSERT INTO Tax_Policy (rate, appliesTo, policyName) VALUES 
(0.1200, 'Room Charges', 'VAT 12%'),
(0.1000, 'Service Charges', 'Service Tax 10%'),
(0.0500, 'Total Bill', 'Tourism Tax 5%');

-- Insert discount offers
INSERT INTO Discount (discountName, discountCondition, discountValue, validFrom, validTo) VALUES 
('Early Bird Special', 'Book 30 days in advance', 15.00, '2024-01-01', '2024-12-31'),
('Weekend Getaway', 'Stay during weekends', 10.00, '2024-01-01', '2024-12-31'),
('Long Stay Discount', 'Stay 7 nights or more', 20.00, '2024-01-01', '2024-12-31'),
('Loyalty Customer', 'Return customer discount', 12.00, '2024-01-01', '2024-12-31'),
('Summer Special', 'Summer season discount', 18.00, '2024-05-01', '2024-08-31'),
('Corporate Rate', 'Corporate booking discount', 25.00, '2024-01-01', '2024-12-31');

-- Create user accounts using the stored procedure
CALL sp_create_user('admin', 'admin123', 'Admin');
CALL sp_create_user('manager_colombo', 'manager123', 'Manager');
CALL sp_create_user('reception_colombo', 'reception123', 'Reception');
CALL sp_create_user('staff_colombo', 'staff123', 'Staff');
CALL sp_create_user('manager_kandy', 'manager123', 'Manager');
CALL sp_create_user('reception_kandy', 'reception123', 'Reception');

-- Insert sample bookings
INSERT INTO Booking (guestID, branchID, roomID, rate, checkInDate, checkOutDate, numGuests, bookingStatus) VALUES 
(1, 1, 1, 5000.00, '2024-10-15 14:00:00', '2024-10-18 11:00:00', 1, 'CheckedOut'),
(2, 1, 4, 7500.00, '2024-10-16 15:00:00', '2024-10-20 12:00:00', 2, 'CheckedOut'),
(3, 2, 13, 5000.00, '2024-10-17 14:00:00', '2024-10-19 11:00:00', 1, 'CheckedOut'),
(4, 1, 7, 8000.00, '2024-10-18 16:00:00', '2024-10-22 10:00:00', 1, 'CheckedIn'),
(5, 3, 22, 7500.00, '2024-10-19 14:00:00', '2024-10-23 11:00:00', 2, 'CheckedIn'),
(6, 1, 11, 20000.00, '2024-10-20 15:00:00', '2024-10-25 12:00:00', 4, 'Booked'),
(7, 2, 21, 15000.00, '2024-10-21 14:00:00', '2024-10-26 11:00:00', 6, 'Booked'),
(8, 4, 30, 5000.00, '2024-10-22 16:00:00', '2024-10-24 10:00:00', 1, 'Booked'),
(9, 1, 2, 5000.00, '2024-10-25 14:00:00', '2024-10-28 11:00:00', 1, 'Booked'),
(10, 3, 25, 12000.00, '2024-10-26 15:00:00', '2024-10-30 12:00:00', 2, 'Booked');

-- Insert sample service usages for checked-out and checked-in bookings
INSERT INTO Service_Usage (usageID, bookingID, serviceID, rate, quantity, usedAt) VALUES 
(1, 1, 2, 500.00, 1, '2024-10-16 10:00:00'),
(2, 1, 3, 1000.00, 2, '2024-10-16 19:00:00'),
(3, 2, 1, 2500.00, 2, '2024-10-17 14:00:00'),
(4, 2, 5, 250.00, 3, '2024-10-17 20:00:00'),
(5, 3, 2, 500.00, 1, '2024-10-18 09:00:00'),
(6, 4, 3, 1000.00, 1, '2024-10-19 18:00:00'),
(7, 4, 5, 250.00, 2, '2024-10-20 21:00:00'),
(8, 5, 1, 2500.00, 1, '2024-10-20 16:00:00'),
(9, 5, 4, 300.00, 2, '2024-10-21 08:00:00');

-- Insert late checkout records
INSERT INTO Late_Checkout (bookingID, checkOutTime, amount) VALUES 
(1, '2024-10-18 14:30:00', 1500.00),
(2, '2024-10-20 15:45:00', 2000.00);

-- Insert invoices for completed bookings
INSERT INTO Invoice (bookingID, policyID, discountCode, paymentPlan, invoiceStatus) VALUES 
(1, 1, 1, 'Full', 'Pending'),
(2, 1, 2, 'Full', 'Pending'),
(3, 1, NULL, 'Full', 'Pending');

-- Insert payments for the invoices
INSERT INTO Payment (invoiceID, transactionDate, paymentMethod, amount) VALUES 
(1, '2024-10-18', 'Card', 15000.00),
(1, '2024-10-18', 'Card', 2500.00),
(2, '2024-10-20', 'Cash', 25000.00),
(3, '2024-10-19', 'Online', 10000.00);

-- Insert some initial log entries
INSERT INTO Log (branchID, userID, bookingID, logAction, logDescription) VALUES 
(1, 1, NULL, 'Other', 'System initialized'),
(1, 2, 1, 'Create', 'Initial booking data loaded'),
(1, 2, 2, 'Create', 'Initial booking data loaded'),
(2, 5, 3, 'Create', 'Initial booking data loaded');

-- Update branch information with user assignments (if needed)
UPDATE User_Account SET branchID = 1 WHERE userID IN (2, 3, 4);
UPDATE User_Account SET branchID = 2 WHERE userID IN (5, 6);

-- Some rooms are currently occupied based on checked-in bookings
UPDATE Room SET roomStatus = 'Occupied' WHERE roomID IN (
    SELECT roomID FROM Booking WHERE bookingStatus = 'CheckedIn'
);

-- Add some additional sample data for testing

-- Additional guests for testing
INSERT INTO Guest (firstName, lastName, phone, email, idNumber) VALUES 
('Priya', 'Fernando', '+94771234568', 'priya.fernando@email.com', '199112345679V'),
('Kasun', 'Perera', '+94772345679', 'kasun.perera@email.com', '198823456780V'),
('Nimali', 'Silva', '+94773456780', 'nimali.silva@email.com', '199334567891V'),
('Ruwan', 'Jayasinghe', '+94774567891', 'ruwan.jayasinghe@email.com', '199445678902V'),
('Sanduni', 'Wijesinghe', '+94775678902', 'sanduni.wijesinghe@email.com', '198756789013V');

-- Future bookings for testing
INSERT INTO Booking (guestID, branchID, roomID, rate, checkInDate, checkOutDate, numGuests, bookingStatus) VALUES 
(11, 1, 3, 5000.00, '2024-11-01 14:00:00', '2024-11-03 11:00:00', 1, 'Booked'),
(12, 2, 14, 7500.00, '2024-11-02 15:00:00', '2024-11-05 12:00:00', 2, 'Booked'),
(13, 3, 23, 8000.00, '2024-11-03 14:00:00', '2024-11-06 11:00:00', 1, 'Booked'),
(14, 4, 31, 12000.00, '2024-11-04 16:00:00', '2024-11-08 10:00:00', 2, 'Booked'),
(15, 1, 12, 25000.00, '2024-11-05 15:00:00', '2024-11-10 12:00:00', 3, 'Booked');

-- Add more service types if needed
INSERT INTO Chargeble_Service (serviceType, unit, ratePerUnit) VALUES 
('Spa services', 'per request', 5000.00),
('Pool access', 'per request', 1000.00);

-- Insert sample data to show reporting capabilities
-- Some cancelled bookings for analytics
INSERT INTO Booking (guestID, branchID, roomID, rate, checkInDate, checkOutDate, numGuests, bookingStatus) VALUES 
(1, 1, 5, 7500.00, '2024-10-10 14:00:00', '2024-10-12 11:00:00', 2, 'Cancelled'),
(3, 2, 15, 5000.00, '2024-10-12 14:00:00', '2024-10-14 11:00:00', 1, 'Cancelled');

-- Log entries for cancelled bookings
INSERT INTO Log (branchID, userID, bookingID, logAction, logDescription) VALUES 
(1, 3, 16, 'Update', 'Booking cancelled by guest request'),
(2, 6, 17, 'Update', 'Booking cancelled due to room maintenance');

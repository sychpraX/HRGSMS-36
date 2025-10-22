USE hrgsms_db;

-- ==============================
-- BRANCHES
-- ==============================
INSERT INTO Branch (location, rating, phone, email)
VALUES 
('Colombo', 4.5, '011-2223344', 'colombo@skynest.com'),
('Kandy', 4.2, '081-4455667', 'kandy@skynest.com'),
('Galle', 4.0, '091-7788990', 'galle@skynest.com');

-- ==============================
-- ROOM TYPES
-- ==============================
INSERT INTO Room_Type (typeName, capacity, currRate)
VALUES 
('Standard', 2, 12000.00),
('Deluxe', 3, 18000.00),
('Suite', 4, 25000.00);

-- ==============================
-- ROOMS (10 per branch)
-- ==============================
-- Colombo
INSERT INTO Room (branchID, typeID, roomNo, roomStatus)
VALUES
(1, 1, 101, 'Available'), (1, 1, 102, 'Available'),
(1, 2, 103, 'Available'), (1, 2, 104, 'Available'),
(1, 2, 105, 'Available'), (1, 3, 106, 'Available'),
(1, 3, 107, 'Available'), (1, 3, 108, 'Available'),
(1, 1, 109, 'Available'), (1, 2, 110, 'Available');

-- Kandy
INSERT INTO Room (branchID, typeID, roomNo, roomStatus)
VALUES
(2, 1, 201, 'Available'), (2, 1, 202, 'Available'),
(2, 2, 203, 'Available'), (2, 2, 204, 'Available'),
(2, 2, 205, 'Available'), (2, 3, 206, 'Available'),
(2, 3, 207, 'Available'), (2, 3, 208, 'Available'),
(2, 1, 209, 'Available'), (2, 2, 210, 'Available');

-- Galle
INSERT INTO Room (branchID, typeID, roomNo, roomStatus)
VALUES
(3, 1, 301, 'Available'), (3, 1, 302, 'Available'),
(3, 2, 303, 'Available'), (3, 2, 304, 'Available'),
(3, 2, 305, 'Available'), (3, 3, 306, 'Available'),
(3, 3, 307, 'Available'), (3, 3, 308, 'Available'),
(3, 1, 309, 'Available'), (3, 2, 310, 'Available');

-- ==============================
-- CHARGEABLE SERVICES
-- ==============================
INSERT INTO Chargeble_Service (unit, ratePerUnit, serviceType)
VALUES
('per person', 3000.00, 'Spa'),
('per request', 1500.00, 'Room Service'),
('per item', 800.00, 'Laundry'),
('per request', 1000.00, 'Minibar'),
('per person', 2500.00, 'Pool'),
('per request', 5000.00, 'Airport Shuttle');

-- ==============================
-- TAX AND DISCOUNT POLICIES
-- ==============================
INSERT INTO Tax_Policy (rate, appliesTo, policyName)
VALUES
(0.08, 'All', 'Standard Tax'),
(0.10, 'Luxury', 'Luxury Tax');

INSERT INTO Discount (discountName, discountCondition, validFrom, validTo, discountValue)
VALUES
('Loyalty Bonus', 'For returning customers', '2025-01-01', '2025-12-31', 1000.00),
('Seasonal Offer', 'During off-season', '2025-06-01', '2025-12-31', 1500.00);

-- ==============================
-- LATE CHECKOUT POLICY
-- ==============================
INSERT INTO Late_Checkout_Policy (latePolicyID, amount)
VALUES (1, 3000.00), (2, 5000.00);

-- ==============================
-- GUESTS
-- ==============================
INSERT INTO Guest (firstName, lastName, phone, email, idNumber)
VALUES
('Ruwan', 'Perera', '0771112233', 'ruwan@example.com', 'NIC123'),
('Anjali', 'Fernando', '0772223344', 'anjali@example.com', 'NIC124'),
('Kavindu', 'Silva', '0773334455', 'kavindu@example.com', 'NIC125'),
('Sithmi', 'De Silva', '0774445566', 'sithmi@example.com', 'NIC126'),
('Nimal', 'Jayasinghe', '0775556677', 'nimal@example.com', 'NIC127'),
('Chamari', 'Ranasinghe', '0776667788', 'chamari@example.com', 'NIC128'),
('Kasun', 'Hettiarachchi', '0777778899', 'kasun@example.com', 'NIC129');

-- ==============================
-- BOOKINGS
-- ==============================
INSERT INTO Booking (guestID, branchID, roomID, rate, checkInDate, checkOutDate, numGuests, bookingStatus)
VALUES
(1, 1, 101, 12000, '2025-10-10', '2025-10-12', 2, 'CheckedOut'),
(2, 1, 102, 12000, '2025-10-18', '2025-10-20', 2, 'CheckedIn'),
(3, 2, 201, 12000, '2025-10-15', '2025-10-18', 2, 'CheckedOut'),
(4, 2, 203, 18000, '2025-10-21', '2025-10-23', 3, 'Booked'),
(5, 3, 301, 12000, '2025-10-05', '2025-10-07', 2, 'CheckedOut'),
(6, 3, 305, 18000, '2025-10-20', '2025-10-23', 2, 'CheckedIn'),
(7, 1, 107, 25000, '2025-09-30', '2025-10-03', 3, 'CheckedOut');

-- ==============================
-- INVOICES
-- ==============================
INSERT INTO Invoice (bookingID, policyID, discountCode, roomCharges, serviceCharges, discountAmount, settledAmount, invoiceStatus, taxAmount, latePolicyID, lateAmount)
VALUES
(1, 1, 1, 24000, 4000, 1000, 29000, 'Paid', 2000, 1, 3000),
(2, 1, NULL, 24000, 3000, 0, 10000, 'Partially Paid', 1800, NULL, 0),
(3, 2, NULL, 36000, 2500, 0, 38500, 'Paid', 4000, NULL, 0),
(4, 1, 2, 36000, 0, 1500, 0, 'Pending', 2880, NULL, 0),
(5, 1, NULL, 24000, 1500, 0, 25500, 'Paid', 1920, NULL, 0),
(6, 2, 1, 54000, 6000, 1000, 30000, 'Partially Paid', 4800, NULL, 0),
(7, 1, NULL, 75000, 5000, 0, 80000, 'Paid', 6400, NULL, 0);

-- ==============================
-- SERVICE USAGE (10 entries)
-- ==============================
INSERT INTO Service_Usage (usageID, bookingID, serviceID, rate, quantity, usedAt)
VALUES
(1, 1, 2, 1500, 2, '2025-10-10 10:00:00'),
(2, 1, 4, 1000, 1, '2025-10-10 11:00:00'),
(3, 2, 1, 3000, 1, '2025-10-19 09:00:00'),
(4, 3, 3, 800, 2, '2025-10-16 14:00:00'),
(5, 4, 2, 1500, 1, '2025-10-21 18:00:00'),
(6, 5, 6, 5000, 1, '2025-10-06 06:00:00'),
(7, 6, 1, 3000, 2, '2025-10-21 09:30:00'),
(8, 6, 3, 800, 3, '2025-10-22 16:00:00'),
(9, 7, 4, 1000, 2, '2025-09-30 10:30:00'),
(10, 7, 2, 1500, 1, '2025-09-30 12:00:00');

-- ==============================
-- PAYMENTS (Including 4 partial)
-- ==============================
INSERT INTO Payment (invoiceID, transactionDate, paymentMethod, amount)
VALUES
(1, '2025-10-12', 'Card', 29000.00),
(2, '2025-10-19', 'Cash', 5000.00),
(2, '2025-10-20', 'Card', 5000.00),
(3, '2025-10-18', 'Online', 38500.00),
(4, '2025-10-22', 'Cash', 0.00),
(5, '2025-10-07', 'Card', 25500.00),
(6, '2025-10-21', 'Online', 20000.00),
(6, '2025-10-22', 'Cash', 10000.00),
(7, '2025-10-03', 'Card', 80000.00);

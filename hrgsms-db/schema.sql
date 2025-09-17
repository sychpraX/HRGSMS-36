USE hrgsms_db;

CREATE TABLE IF NOT EXISTS Branch (
	branchID BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    branchLocation VARCHAR(20) NOT NULL,
	rating NUMERIC(2,1),
    phone char(12) NOT NULL,
    email varchar(30) NOT NULL,
    CONSTRAINT chk_phone CHECK(
		phone like "+94%"),
	CONSTRAINT chk_rating CHECK(
		rating >=0 AND rating <= 5)
);
    
CREATE TABLE IF NOT EXISTS Room (
	roomID BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	branchID BIGINT UNSIGNED NOT NULL,
	typeID	INT UNSIGNED NOT NULL,
	roomNo	INT UNSIGNED NOT NULL,
	roomStatus	ENUM("Occupied", "Available") NOT NULL,
);

CREATE TABLE IF NOT EXISTS Room_Type (
	typeID	INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	typeName VARCHAR(20) NOT NULL,
	capacity INT NOT NULL,
	rate NUMERIC(10,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS Guest (
  guestID     BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  firstName   VARCHAR(50) NOT NULL,
  lastName    VARCHAR(50) NOT NULL,
  phone       VARCHAR(20),
  email       VARCHAR(100),
  idNumber    VARCHAR(30),          
);

CREATE TABLE IF NOT EXISTS Booking (
  bookingID     BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  guestID       BIGINT UNSIGNED NOT NULL,
  branchID      BIGINT UNSIGNED NOT NULL,
  roomID        BIGINT UNSIGNED NOT NULL,
  checkInDate   DATETIME NOT NULL,
  checkOutDate  DATETIME NOT NULL,
  numGuests     INT NOT NULL,
  bookingStatus ENUM('Booked','CheckedIn','CheckedOut','Cancelled') NOT NULL DEFAULT 'Booked',
);

CREATE TABLE IF NOT EXISTS Chargable_Service (
  serviceID   INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  serviceType ENUM( "Spa services", "Pool access", "room service", "laundry", "minibar usage") NOT NULL, 
  unit ENUM("per person","per kg", "per item", "per request"), 
  ratePerUnit  DECIMAL(10,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS Service_Usage ( 
  usageID	BIGINT UNSIGNED PRIMARY KEY NOT NULL,
  bookingID  BIGINT UNSIGNED NOT NULL,
  serviceID  INT UNSIGNED NOT NULL,
  quantity   INT NOT NULL DEFAULT 1,
  usedAt	TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS Late_Checkout (
	lateID BIGINT UNSIGNED PRIMARY KEY NOT NULL,
	bookingID BIGINT UNSIGNED NOT NULL,
	checkOutTime TIMESTAMP,
	amount NUMERIC(10,2)
);

CREATE TABLE IF NOT EXISTS Invoice (
  invoiceID       BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  bookingID       BIGINT UNSIGNED NOT NULL,
  policyID        INT UNSIGNED NULL,         
  discountCode    INT UNSIGNED NULL,         
  paymentPlan     ENUM('Full','Installment') NOT NULL DEFAULT 'Full',
  roomCharges     DECIMAL(15,2) NOT NULL DEFAULT 0.00,
  serviceCharges  DECIMAL(15,2) NOT NULL DEFAULT 0.00,
  totalAmount     DECIMAL(15,2) NOT NULL DEFAULT 0.00,
  taxAmount       DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  discountAmount  DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  finalAmount     DECIMAL(15,2) NOT NULL DEFAULT 0.00,   
  settledAmount   DECIMAL(15,2) NOT NULL DEFAULT 0.00,   
  invoiceStatus          ENUM('Pending','Partially Paid','Paid','Cancelled') NOT NULL DEFAULT 'Pending',
);

CREATE TABLE IF NOT EXISTS Payment (
  transactionID   BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  invoiceID       BIGINT UNSIGNED NOT NULL,
  transactionDate DATE NOT NULL,
  paymentMethod   ENUM('Cash','Card','Online','Other') NOT NULL,
  amount          DECIMAL(15,2) NOT NULL
) ;

CREATE TABLE IF NOT EXISTS Tax_Policy (
  policyID   INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  rate       DECIMAL(5,4) NOT NULL,       
  appliesTo  VARCHAR(20) NOT NULL,        
  policyName       VARCHAR(100) NOT NULL        
);

CREATE TABLE IF NOT EXISTS Discount (
  discountCode  INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  discountName  VARCHAR(100) NOT NULL,            
  condition     VARCHAR(200),                     
  discountType  ENUM('Percent','Fixed') NOT NULL, 
  discountValue   DECIMAL(5,2) NOT NULL,            
  validFrom     DATE NOT NULL,
  validTo       DATE NOT NULL
) ;

CREATE TABLE IF NOT EXISTS User_Account (
  userID      INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  branchID    INT UNSIGNED NULL,
  username    VARCHAR(100) NOT NULL UNIQUE,
  userPassword    VARCHAR(255) NOT NULL,             
  userRole        ENUM('Admin','Manager','Reception','Staff') NOT NULL,
  NIC         VARCHAR(20) UNIQUE,
  first_name  VARCHAR(20) NOT NULL,
  last_name   VARCHAR(20) NOT NULL,
  phone       VARCHAR(15),
  email       VARCHAR(30) UNIQUE,
) ;

CREATE TABLE IF NOT EXISTS Log (
  logID        BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  event_time   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  branchID     INT UNSIGNED NULL,
  userID       INT UNSIGNED NULL,
  bookingID    BIGINT UNSIGNED NULL,
  logAction       ENUM('Create','Update','Delete','CheckIn','CheckOut','Payment','Other') NOT NULL,
  logDescription  VARCHAR(255),
) ;










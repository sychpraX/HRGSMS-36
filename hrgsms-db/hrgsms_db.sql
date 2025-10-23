CREATE DATABASE  IF NOT EXISTS `hrgsms_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `hrgsms_db`;
-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: hrgsms_db
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `booking`
--

DROP TABLE IF EXISTS `booking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking` (
  `bookingID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `guestID` bigint unsigned NOT NULL,
  `branchID` bigint unsigned NOT NULL,
  `roomID` bigint unsigned NOT NULL,
  `rate` decimal(10,2) unsigned NOT NULL,
  `checkInDate` datetime NOT NULL,
  `checkOutDate` datetime NOT NULL,
  `numGuests` int unsigned NOT NULL,
  `bookingStatus` enum('Booked','CheckedIn','CheckedOut','Cancelled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Booked',
  PRIMARY KEY (`bookingID`),
  KEY `fk_guestID` (`guestID`),
  KEY `fk_branchID_booking` (`branchID`),
  KEY `fk_roomID_booking` (`roomID`),
  KEY `idx_booking_dates` (`checkInDate`,`checkOutDate`),
  CONSTRAINT `fk_branchID_booking` FOREIGN KEY (`branchID`) REFERENCES `branch` (`branchID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_guestID` FOREIGN KEY (`guestID`) REFERENCES `guest` (`guestID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_roomID_booking` FOREIGN KEY (`roomID`) REFERENCES `room` (`roomID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_date` CHECK ((`checkInDate` <= `checkOutDate`))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking`
--

LOCK TABLES `booking` WRITE;
/*!40000 ALTER TABLE `booking` DISABLE KEYS */;
INSERT INTO `booking` VALUES (1,1,1,1,12000.00,'2025-10-10 00:00:00','2025-10-12 00:00:00',2,'CheckedOut'),(2,2,1,2,12000.00,'2025-10-18 00:00:00','2025-10-20 00:00:00',2,'CheckedIn'),(3,3,2,11,12000.00,'2025-10-15 00:00:00','2025-10-18 00:00:00',2,'CheckedOut'),(4,4,2,13,18000.00,'2025-10-21 00:00:00','2025-10-23 00:00:00',3,'Booked'),(5,5,3,21,12000.00,'2025-10-05 00:00:00','2025-10-07 00:00:00',2,'CheckedOut'),(6,6,3,25,18000.00,'2025-10-20 00:00:00','2025-10-23 00:00:00',2,'CheckedIn'),(7,7,1,7,25000.00,'2025-09-30 00:00:00','2025-10-03 00:00:00',3,'CheckedOut'),(8,2,2,15,18000.00,'2025-12-12 00:00:00','2025-12-15 00:00:00',2,'CheckedOut'),(9,3,3,30,18000.00,'2025-12-12 00:00:00','2025-12-15 00:00:00',2,'Booked'),(10,3,2,15,18000.00,'2026-10-28 00:00:00','2026-10-30 00:00:00',2,'CheckedIn');
/*!40000 ALTER TABLE `booking` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`hrgsms_usr`@`127.0.0.1`*/ /*!50003 TRIGGER `trg_log_booking_insert` AFTER INSERT ON `booking` FOR EACH ROW BEGIN
    INSERT INTO log (bookingID, branchID, logAction, logDescription, event_time)
    VALUES (
        NEW.bookingID,
        NEW.branchID,
        'Create',
        CONCAT('New booking created for guest ', NEW.guestID, 
               ' in room ', NEW.roomID, 
               ' from ', NEW.checkInDate, ' to ', NEW.checkOutDate),
        NOW()
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`hrgsms_usr`@`127.0.0.1`*/ /*!50003 TRIGGER `trg_before_checkout` BEFORE UPDATE ON `booking` FOR EACH ROW BEGIN
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
      COALESCE(lateAmount, 0),
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`hrgsms_usr`@`127.0.0.1`*/ /*!50003 TRIGGER `trg_room_occupied_after_checkin` AFTER UPDATE ON `booking` FOR EACH ROW BEGIN
  IF NEW.bookingStatus = 'CheckedIn' THEN
    UPDATE Room
    SET roomStatus = 'Occupied'
    WHERE roomID = NEW.roomID;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`hrgsms_usr`@`127.0.0.1`*/ /*!50003 TRIGGER `trg_room_available_after_checkout` AFTER UPDATE ON `booking` FOR EACH ROW BEGIN
  IF NEW.bookingStatus = 'CheckedOut' THEN
    UPDATE Room
    SET roomStatus = 'Available'
    WHERE roomID = NEW.roomID;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`hrgsms_usr`@`127.0.0.1`*/ /*!50003 TRIGGER `trg_after_booking_checkin` AFTER UPDATE ON `booking` FOR EACH ROW BEGIN
  -- Only run when status changes TO 'CheckedIn'
  IF NEW.bookingStatus = 'CheckedIn' AND OLD.bookingStatus = 'Booked' THEN
    
    -- Only insert if no invoice exists already
    IF NOT EXISTS (SELECT 1 FROM Invoice WHERE bookingID = NEW.bookingID) THEN
      INSERT INTO Invoice (bookingID)
      VALUES (NEW.bookingID);
    END IF;
    
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`hrgsms_usr`@`127.0.0.1`*/ /*!50003 TRIGGER `trg_log_booking_update` AFTER UPDATE ON `booking` FOR EACH ROW BEGIN
    -- Log check-in
    IF NEW.bookingStatus = 'CheckedIn' AND OLD.bookingStatus = 'Booked' THEN
        INSERT INTO log (bookingID, branchID, logAction, logDescription, event_time)
        VALUES (
            NEW.bookingID,
            NEW.branchID,
            'CheckIn',
            CONCAT('Guest checked in to room ', NEW.roomID, 
                   ' for booking ', NEW.bookingID),
            NOW()
        );
    END IF;

    -- Log check-out
    IF NEW.bookingStatus = 'CheckedOut' AND OLD.bookingStatus = 'CheckedIn' THEN
        INSERT INTO log (bookingID, branchID, logAction, logDescription, event_time)
        VALUES (
            NEW.bookingID,
            NEW.branchID,
            'CheckOut',
            CONCAT('Guest checked out from room ', NEW.roomID, 
                   ' for booking ', NEW.bookingID),
            NOW()
        );
    END IF;

    -- Log booking cancellation
    IF NEW.bookingStatus = 'Cancelled' AND OLD.bookingStatus != 'Cancelled' THEN
        INSERT INTO log (bookingID, branchID, logAction, logDescription, event_time)
        VALUES (
            NEW.bookingID,
            NEW.branchID,
            'Update',
            CONCAT('Booking ', NEW.bookingID, ' cancelled'),
            NOW()
        );
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `branch`
--

DROP TABLE IF EXISTS `branch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `branch` (
  `branchID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `location` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rating` decimal(2,1) DEFAULT NULL,
  `phone` char(12) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`branchID`),
  CONSTRAINT `chk_phone` CHECK ((`phone` like _utf8mb4'+94%')),
  CONSTRAINT `chk_rating` CHECK (((`rating` >= 0) and (`rating` <= 5)))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branch`
--

LOCK TABLES `branch` WRITE;
/*!40000 ALTER TABLE `branch` DISABLE KEYS */;
INSERT INTO `branch` VALUES (1,'Colombo',4.5,'+94772223344','colombo@skynest.com'),(2,'Kandy',4.2,'+94814455667','kandy@skynest.com'),(3,'Galle',4.0,'+94817788990','galle@skynest.com'),(4,'Colombo',4.5,'+94772223344','colombo@skynest.com'),(5,'Kandy',4.2,'+94814455667','kandy@skynest.com'),(6,'Galle',4.0,'+94817788990','galle@skynest.com');
/*!40000 ALTER TABLE `branch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chargeble_service`
--

DROP TABLE IF EXISTS `chargeble_service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chargeble_service` (
  `serviceID` int unsigned NOT NULL AUTO_INCREMENT,
  `unit` enum('per person','per kg','per item','per request') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ratePerUnit` decimal(10,2) unsigned NOT NULL,
  `serviceType` enum('Spa','Pool','Room Service','Minibar','Laundry','Airport Shuttle') COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`serviceID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chargeble_service`
--

LOCK TABLES `chargeble_service` WRITE;
/*!40000 ALTER TABLE `chargeble_service` DISABLE KEYS */;
INSERT INTO `chargeble_service` VALUES (1,'per person',3000.00,'Spa'),(2,'per request',1500.00,'Room Service'),(3,'per item',800.00,'Laundry'),(4,'per request',1000.00,'Minibar'),(5,'per person',2500.00,'Pool'),(6,'per request',5000.00,'Airport Shuttle');
/*!40000 ALTER TABLE `chargeble_service` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discount`
--

DROP TABLE IF EXISTS `discount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `discount` (
  `discountCode` int unsigned NOT NULL AUTO_INCREMENT,
  `discountName` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `discountCondition` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `validFrom` date NOT NULL,
  `validTo` date NOT NULL,
  `discountValue` decimal(6,2) unsigned NOT NULL,
  PRIMARY KEY (`discountCode`),
  CONSTRAINT `chk_dateValidity` CHECK ((`validTo` > `validFrom`))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discount`
--

LOCK TABLES `discount` WRITE;
/*!40000 ALTER TABLE `discount` DISABLE KEYS */;
INSERT INTO `discount` VALUES (1,'Loyalty Bonus','For returning customers','2025-01-01','2025-12-31',1000.00),(2,'Seasonal Offer','During off-season','2025-06-01','2025-12-31',1500.00);
/*!40000 ALTER TABLE `discount` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guest`
--

DROP TABLE IF EXISTS `guest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guest` (
  `guestID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `firstName` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lastName` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `idNumber` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`guestID`),
  UNIQUE KEY `idNumber` (`idNumber`),
  CONSTRAINT `chk_phone_guest` CHECK ((`phone` like _utf8mb4'+94%'))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guest`
--

LOCK TABLES `guest` WRITE;
/*!40000 ALTER TABLE `guest` DISABLE KEYS */;
INSERT INTO `guest` VALUES (1,'Ruwan','Perera','+94771112233','ruwan@example.com','NIC123'),(2,'Anjali','Fernando','+94772223344','anjali@example.com','NIC124'),(3,'Kavindu','Silva','+94773334455','kavindu@example.com','NIC125'),(4,'Sithmi','De Silva','+94774445566','sithmi@example.com','NIC126'),(5,'Nimal','Jayasinghe','+94775556677','nimal@example.com','NIC127'),(6,'Chamari','Ranasinghe','+94776667788','chamari@example.com','NIC128'),(7,'Kasun','Hettiarachchi','+94777778899','kasun@example.com','NIC129'),(8,'Praveen','Nawarathna','+94773853091','praveenn.23@cse.mrt.ac.lk','200305771088');
/*!40000 ALTER TABLE `guest` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoice`
--

DROP TABLE IF EXISTS `invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice` (
  `invoiceID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `bookingID` bigint unsigned NOT NULL,
  `policyID` int unsigned DEFAULT NULL,
  `discountCode` int unsigned DEFAULT NULL,
  `roomCharges` decimal(15,2) unsigned NOT NULL DEFAULT '0.00',
  `serviceCharges` decimal(15,2) unsigned NOT NULL DEFAULT '0.00',
  `discountAmount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `settledAmount` decimal(15,2) unsigned NOT NULL DEFAULT '0.00',
  `invoiceStatus` enum('Pending','Partially Paid','Paid','Cancelled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Pending',
  `taxAmount` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `latePolicyID` int unsigned DEFAULT NULL,
  `lateAmount` decimal(10,2) unsigned DEFAULT NULL,
  PRIMARY KEY (`invoiceID`),
  UNIQUE KEY `bookingID` (`bookingID`),
  KEY `fk_policyID` (`policyID`),
  KEY `fk_discountCode` (`discountCode`),
  KEY `latePolicyID` (`latePolicyID`),
  KEY `idx_invoice_status` (`invoiceStatus`),
  KEY `idx_invoice_booking` (`bookingID`),
  CONSTRAINT `fk_bookingID_invoice` FOREIGN KEY (`bookingID`) REFERENCES `booking` (`bookingID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_discountCode` FOREIGN KEY (`discountCode`) REFERENCES `discount` (`discountCode`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_policyID` FOREIGN KEY (`policyID`) REFERENCES `tax_policy` (`policyID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `invoice_ibfk_1` FOREIGN KEY (`latePolicyID`) REFERENCES `late_checkout_policy` (`latePolicyID`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice`
--

LOCK TABLES `invoice` WRITE;
/*!40000 ALTER TABLE `invoice` DISABLE KEYS */;
INSERT INTO `invoice` VALUES (1,1,1,1,24000.00,4000.00,1000.00,29000.00,'Paid',2000.00,1,3000.00),(2,2,1,1,27000.00,3000.00,1000.00,11000.00,'Partially Paid',264.00,NULL,3000.00),(3,3,2,NULL,36000.00,2500.00,0.00,38500.00,'Paid',4000.00,NULL,0.00),(4,4,1,2,36000.00,0.00,1500.00,0.00,'Pending',2880.00,NULL,0.00),(5,5,1,NULL,24000.00,1500.00,0.00,25500.00,'Paid',1920.00,NULL,0.00),(6,6,2,1,54000.00,6000.00,1000.00,30000.00,'Partially Paid',4800.00,NULL,0.00),(7,7,1,NULL,75000.00,5000.00,0.00,80000.00,'Paid',6400.00,NULL,0.00),(8,8,NULL,NULL,0.00,0.00,0.00,0.00,'Pending',0.00,NULL,NULL),(9,10,NULL,NULL,0.00,0.00,0.00,0.00,'Pending',0.00,NULL,NULL);
/*!40000 ALTER TABLE `invoice` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`hrgsms_usr`@`127.0.0.1`*/ /*!50003 TRIGGER `trg_before_invoice_update` BEFORE UPDATE ON `invoice` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `late_checkout_policy`
--

DROP TABLE IF EXISTS `late_checkout_policy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `late_checkout_policy` (
  `latePolicyID` int unsigned NOT NULL,
  `amount` decimal(10,2) unsigned DEFAULT NULL,
  PRIMARY KEY (`latePolicyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `late_checkout_policy`
--

LOCK TABLES `late_checkout_policy` WRITE;
/*!40000 ALTER TABLE `late_checkout_policy` DISABLE KEYS */;
INSERT INTO `late_checkout_policy` VALUES (1,3000.00),(2,5000.00);
/*!40000 ALTER TABLE `late_checkout_policy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log`
--

DROP TABLE IF EXISTS `log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log` (
  `logID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `event_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `branchID` bigint unsigned DEFAULT NULL,
  `userID` int unsigned DEFAULT NULL,
  `bookingID` bigint unsigned DEFAULT NULL,
  `logAction` enum('Create','Update','Delete','CheckIn','CheckOut','Payment','Other') COLLATE utf8mb4_unicode_ci NOT NULL,
  `logDescription` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`logID`),
  KEY `fk_branchID_log` (`branchID`),
  KEY `fk_userID_log` (`userID`),
  KEY `fk_bookingID_log` (`bookingID`),
  CONSTRAINT `fk_bookingID_log` FOREIGN KEY (`bookingID`) REFERENCES `booking` (`bookingID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_branchID_log` FOREIGN KEY (`branchID`) REFERENCES `branch` (`branchID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_userID_log` FOREIGN KEY (`userID`) REFERENCES `user_account` (`userID`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log`
--

LOCK TABLES `log` WRITE;
/*!40000 ALTER TABLE `log` DISABLE KEYS */;
INSERT INTO `log` VALUES (1,'2025-10-23 05:23:09',2,NULL,10,'Create','New booking created for guest 3 in room 15 from 2026-10-28 00:00:00 to 2026-10-30 00:00:00'),(2,'2025-10-23 05:23:15',2,NULL,10,'CheckIn','Guest checked in to room 15 for booking 10');
/*!40000 ALTER TABLE `log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `transactionID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `invoiceID` bigint unsigned NOT NULL,
  `transactionDate` date NOT NULL,
  `paymentMethod` enum('Cash','Card','Online','Other') COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(15,2) unsigned NOT NULL,
  PRIMARY KEY (`transactionID`),
  KEY `fk_invoiceID` (`invoiceID`),
  CONSTRAINT `fk_invoiceID` FOREIGN KEY (`invoiceID`) REFERENCES `invoice` (`invoiceID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES (10,1,'2025-10-12','Card',29000.00),(11,2,'2025-10-19','Cash',5000.00),(12,2,'2025-10-20','Card',5000.00),(13,3,'2025-10-18','Online',38500.00),(14,4,'2025-10-22','Cash',0.00),(15,5,'2025-10-07','Card',25500.00),(16,6,'2025-10-21','Online',20000.00),(17,6,'2025-10-22','Cash',10000.00),(18,7,'2025-10-03','Card',80000.00),(19,2,'2025-10-23','Cash',1000.00);
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`hrgsms_usr`@`127.0.0.1`*/ /*!50003 TRIGGER `trg_log_payment_insert` AFTER INSERT ON `payment` FOR EACH ROW BEGIN
    DECLARE v_bookingID BIGINT UNSIGNED;
    DECLARE v_branchID BIGINT UNSIGNED;

    -- Get booking and branch information
    SELECT b.bookingID, b.branchID
    INTO v_bookingID, v_branchID
    FROM Invoice i
    INNER JOIN Booking b ON i.bookingID = b.bookingID
    WHERE i.invoiceID = NEW.invoiceID
    LIMIT 1;

    INSERT INTO log (bookingID, branchID, logAction, logDescription, event_time)
    VALUES (
        v_bookingID,
        v_branchID,
        'Payment',
        CONCAT('Payment of LKR ', NEW.amount, ' received via ', 
               NEW.paymentMethod, ' for invoice ', NEW.invoiceID),
        NOW()
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `room`
--

DROP TABLE IF EXISTS `room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room` (
  `roomID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `branchID` bigint unsigned NOT NULL,
  `typeID` int unsigned NOT NULL,
  `roomNo` int unsigned NOT NULL,
  `roomStatus` enum('Occupied','Available') COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`roomID`),
  UNIQUE KEY `uq_branch_roomNo` (`branchID`,`roomNo`),
  KEY `fk_typeID` (`typeID`),
  CONSTRAINT `fk_branchID` FOREIGN KEY (`branchID`) REFERENCES `branch` (`branchID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_typeID` FOREIGN KEY (`typeID`) REFERENCES `room_type` (`typeID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_roomNo` CHECK ((`roomNo` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room`
--

LOCK TABLES `room` WRITE;
/*!40000 ALTER TABLE `room` DISABLE KEYS */;
INSERT INTO `room` VALUES (1,1,1,101,'Available'),(2,1,1,102,'Available'),(3,1,2,103,'Available'),(4,1,2,104,'Available'),(5,1,2,105,'Available'),(6,1,3,106,'Available'),(7,1,3,107,'Available'),(8,1,3,108,'Available'),(9,1,1,109,'Available'),(10,1,2,110,'Available'),(11,2,1,201,'Available'),(12,2,1,202,'Available'),(13,2,2,203,'Available'),(14,2,2,204,'Available'),(15,2,2,205,'Occupied'),(16,2,3,206,'Available'),(17,2,3,207,'Available'),(18,2,3,208,'Available'),(19,2,1,209,'Available'),(20,2,2,210,'Available'),(21,3,1,301,'Available'),(22,3,1,302,'Available'),(23,3,2,303,'Available'),(24,3,2,304,'Available'),(25,3,2,305,'Available'),(26,3,3,306,'Available'),(27,3,3,307,'Available'),(28,3,3,308,'Available'),(29,3,1,309,'Available'),(30,3,2,310,'Occupied');
/*!40000 ALTER TABLE `room` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `room_type`
--

DROP TABLE IF EXISTS `room_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room_type` (
  `typeID` int unsigned NOT NULL AUTO_INCREMENT,
  `typeName` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `capacity` int NOT NULL,
  `currRate` decimal(10,2) NOT NULL,
  PRIMARY KEY (`typeID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room_type`
--

LOCK TABLES `room_type` WRITE;
/*!40000 ALTER TABLE `room_type` DISABLE KEYS */;
INSERT INTO `room_type` VALUES (1,'Standard',2,12000.00),(2,'Deluxe',3,18000.00),(3,'Suite',4,25000.00),(4,'Standard',2,12000.00),(5,'Deluxe',3,18000.00),(6,'Suite',4,25000.00);
/*!40000 ALTER TABLE `room_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_usage`
--

DROP TABLE IF EXISTS `service_usage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_usage` (
  `usageID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `bookingID` bigint unsigned NOT NULL,
  `serviceID` int unsigned NOT NULL,
  `rate` decimal(10,2) unsigned NOT NULL,
  `quantity` int unsigned NOT NULL DEFAULT '1',
  `usedAt` timestamp NOT NULL,
  PRIMARY KEY (`usageID`),
  KEY `fk_bookingID_service` (`bookingID`),
  KEY `fk_serviceID` (`serviceID`),
  CONSTRAINT `fk_bookingID_service` FOREIGN KEY (`bookingID`) REFERENCES `booking` (`bookingID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_serviceID` FOREIGN KEY (`serviceID`) REFERENCES `chargeble_service` (`serviceID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_usage`
--

LOCK TABLES `service_usage` WRITE;
/*!40000 ALTER TABLE `service_usage` DISABLE KEYS */;
INSERT INTO `service_usage` VALUES (1,1,2,1500.00,2,'2025-10-10 04:30:00'),(2,1,4,1000.00,1,'2025-10-10 05:30:00'),(3,2,1,3000.00,1,'2025-10-19 03:30:00'),(4,3,3,800.00,2,'2025-10-16 08:30:00'),(5,4,2,1500.00,1,'2025-10-21 12:30:00'),(6,5,6,5000.00,1,'2025-10-06 00:30:00'),(7,6,1,3000.00,2,'2025-10-21 04:00:00'),(8,6,3,800.00,3,'2025-10-22 10:30:00'),(9,7,4,1000.00,2,'2025-09-30 05:00:00'),(10,7,2,1500.00,1,'2025-09-30 06:30:00'),(11,2,1,3000.00,1,'2025-10-22 22:37:30');
/*!40000 ALTER TABLE `service_usage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tax_policy`
--

DROP TABLE IF EXISTS `tax_policy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tax_policy` (
  `policyID` int unsigned NOT NULL AUTO_INCREMENT,
  `rate` decimal(5,4) unsigned NOT NULL,
  `appliesTo` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `policyName` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`policyID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tax_policy`
--

LOCK TABLES `tax_policy` WRITE;
/*!40000 ALTER TABLE `tax_policy` DISABLE KEYS */;
INSERT INTO `tax_policy` VALUES (1,0.0800,'All','Standard Tax'),(2,0.1000,'Luxury','Luxury Tax');
/*!40000 ALTER TABLE `tax_policy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_account`
--

DROP TABLE IF EXISTS `user_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_account` (
  `userID` int unsigned NOT NULL AUTO_INCREMENT,
  `branchID` bigint unsigned DEFAULT NULL,
  `username` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userRole` enum('Admin','Manager','Reception','Staff') COLLATE utf8mb4_unicode_ci NOT NULL,
  `salt` varbinary(16) DEFAULT NULL,
  `password_hash` varbinary(255) DEFAULT NULL,
  PRIMARY KEY (`userID`),
  UNIQUE KEY `username` (`username`),
  KEY `fk_branchID_user` (`branchID`),
  CONSTRAINT `fk_branchID_user` FOREIGN KEY (`branchID`) REFERENCES `branch` (`branchID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_account`
--

LOCK TABLES `user_account` WRITE;
/*!40000 ALTER TABLE `user_account` DISABLE KEYS */;
INSERT INTO `user_account` VALUES (1,NULL,'Admin','Admin',_binary '��.\�,\�RP��\�-',_binary '�\��Kp�\\\�-T�-\\��A8\�uI�5�\�ݬ\��R\�'),(2,NULL,'Manager1','Manager',_binary 'ķY�J_G\�\���Qw',_binary '\�����&Y\�\�0Y,�-�k܋�@\�H�?]'),(3,NULL,'Reception','Reception',_binary '��*�����깶\�\�?��',_binary '8\�o���N\�C�*\�\�G�Z=?N{Y\�|t䙻\�2'),(4,NULL,'Staff','Staff',_binary '\�\\�\\tu�\�\\�U\�6>\�',_binary '�����\�U7Hk��\�2�\�zX/3\\\����'),(5,1,'Praveen','Admin',_binary '����p2�h\��\�8dM',_binary '\�.6� ��h�\�Ԙ�\�\�(ְ�<&v�CvF�'),(6,2,'Manager2','Manager',_binary '\�+�<�\�\�U>?��Z',_binary '�[���A~�﹒�k��D\���\�\�d1�+	S'),(7,2,'Maleesha','Admin',_binary '\�VNn��:כ*;2',_binary '�C\�_\0*,\"�l\r\�y_w^F\�j\\6�,5�f��\�9');
/*!40000 ALTER TABLE `user_account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'hrgsms_db'
--

--
-- Dumping routines for database 'hrgsms_db'
--
/*!50003 DROP FUNCTION IF EXISTS `fn_has_role` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`hrgsms_usr`@`127.0.0.1` FUNCTION `fn_has_role`(p_userID BIGINT UNSIGNED, p_role VARCHAR(20)) RETURNS tinyint(1)
    DETERMINISTIC
RETURN EXISTS (
  SELECT 1 FROM User_Account WHERE userID = p_userID AND userRole = p_role
) ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_password_hash` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`hrgsms_usr`@`127.0.0.1` FUNCTION `fn_password_hash`(p_salt VARBINARY(16), p_plain VARCHAR(255)) RETURNS varbinary(32)
    DETERMINISTIC
RETURN UNHEX(SHA2(CONCAT(HEX(p_salt), p_plain), 256)) ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_add_payment` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`hrgsms_usr`@`127.0.0.1` PROCEDURE `sp_add_payment`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_add_service_usage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_checkin` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`hrgsms_usr`@`127.0.0.1` PROCEDURE `sp_checkin`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_checkout` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`hrgsms_usr`@`127.0.0.1` PROCEDURE `sp_checkout`(
  IN p_bookingID BIGINT UNSIGNED
)
BEGIN
  DECLARE v_roomID BIGINT UNSIGNED;

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


  --  Return summary
  SELECT
    'Checkout completed successfully' AS message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_create_booking` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
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
  
  COMMIT;
  
  SELECT v_bookingID AS bookingID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_create_guest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_create_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`hrgsms_usr`@`127.0.0.1` PROCEDURE `sp_create_user`(
  IN p_username VARCHAR(50),
  IN p_plain VARCHAR(255),
  IN p_role VARCHAR(20),
  IN p_branch BIGINT
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

    INSERT INTO User_Account(username, password_hash, salt, userRole, branchID)
    VALUES (p_username, @hash, @salt, p_role, p_branch);

    SELECT LAST_INSERT_ID() AS userID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_customer_preference_trends` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`hrgsms_usr`@`127.0.0.1` PROCEDURE `sp_customer_preference_trends`(
  IN p_branchID BIGINT UNSIGNED,
  IN p_startDate DATE,
  IN p_endDate DATE
)
BEGIN

  -- 1. Most Used Room Type

  WITH room_usage AS (
    SELECT 
      rt.typeName AS room_type,
      COUNT(b.bookingID) AS total_bookings,
      ROW_NUMBER() OVER (ORDER BY COUNT(b.bookingID) DESC) AS rn
    FROM Booking b
    INNER JOIN Room r ON b.roomID = r.roomID
    INNER JOIN Room_Type rt ON r.typeID = rt.typeID
    WHERE b.branchID = p_branchID
      AND DATE(b.checkInDate) BETWEEN p_startDate AND p_endDate
    GROUP BY rt.typeName
  ),

  -- 2. Most Used Service Type
  service_usage AS (
    SELECT 
      cs.serviceType AS service_type,
      SUM(su.quantity) AS total_usage,
      ROW_NUMBER() OVER (ORDER BY SUM(su.quantity) DESC) AS rn
    FROM Service_Usage su
    INNER JOIN Booking b ON su.bookingID = b.bookingID
    INNER JOIN Chargeble_Service cs ON su.serviceID = cs.serviceID
    WHERE b.branchID = p_branchID
      AND DATE(su.usedAt) BETWEEN p_startDate AND p_endDate
    GROUP BY cs.serviceType
  ),

  -- 3. Average Spend Per Customer
  customer_spending AS (
    SELECT 
      g.guestID,
      SUM(i.settledAmount) AS total_spent
    FROM Invoice i
    INNER JOIN Booking b ON i.bookingID = b.bookingID
    INNER JOIN Guest g ON b.guestID = g.guestID
    WHERE b.branchID = p_branchID
      AND DATE(b.checkInDate) BETWEEN p_startDate AND p_endDate
    GROUP BY g.guestID
  )

  SELECT 
    br.location AS branch_name,
    (SELECT room_type FROM room_usage WHERE rn = 1) AS most_used_room_type,
    (SELECT total_bookings FROM room_usage WHERE rn = 1) AS room_bookings,
    (SELECT service_type FROM service_usage WHERE rn = 1) AS most_used_service_type,
    (SELECT total_usage FROM service_usage WHERE rn = 1) AS service_usage_count,
    ROUND(AVG(c.total_spent), 2) AS avg_spend_per_customer
  FROM Branch br
  LEFT JOIN customer_spending c ON br.branchID = p_branchID
  WHERE br.branchID = p_branchID
  GROUP BY br.branchID;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_generate_final_invoice` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
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
    SELECT amount INTO v_lateAmount
    FROM Late_Checkout_Policy
    WHERE latePolicyID = p_latePolicyID;
    SET v_roomCharges = v_roomCharges + v_lateAmount;
  END IF;

  --  Service charges
  SELECT COALESCE(SUM(rate * quantity), 0)
    INTO v_serviceCharges
  FROM Service_Usage
  WHERE bookingID = p_bookingID;

  --  Tax
  IF p_policyID IS NOT NULL THEN
    SELECT (v_roomCharges + v_serviceCharges + v_lateAmount) * rate/10
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
        lateAmount       = v_lateAmount
    WHERE bookingID = p_bookingID;
  ELSE
    INSERT INTO Invoice (
      bookingID, policyID, discountCode,
      roomCharges, serviceCharges, taxAmount, discountAmount, lateAmount
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_available_rooms` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_guest_billing_summary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`hrgsms_usr`@`127.0.0.1` PROCEDURE `sp_get_guest_billing_summary`()
BEGIN
    SELECT 
        i.invoiceID, 
        CONCAT(g.firstName, ' ', g.lastName) AS guestName,
        (i.roomCharges + i.serviceCharges + i.taxAmount + i.lateAmount - i.discountAmount - i.settledAmount) AS unpaid_amount
    FROM Invoice i
    INNER JOIN Booking b ON i.bookingID = b.bookingID
    INNER JOIN Guest g ON g.guestID = b.guestID
    WHERE (i.roomCharges + i.serviceCharges + i.taxAmount + IFNULL(i.lateAmount, 0) - i.discountAmount - i.settledAmount) > 0
    ORDER BY guestName, i.invoiceID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_guest_by_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`hrgsms_usr`@`127.0.0.1` PROCEDURE `sp_get_guest_by_id`(
  IN p_guestID BIGINT UNSIGNED
)
BEGIN
  SELECT guestID, firstName, lastName, phone, email, idNumber
  FROM Guest
  WHERE guestID = p_guestID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_revenue_report` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_room_occupancy_report` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_service_usage_per_room` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_login` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-23 19:38:50

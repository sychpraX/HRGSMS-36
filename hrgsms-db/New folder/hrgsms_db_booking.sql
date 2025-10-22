-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: hrgsms_db
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
INSERT INTO `booking` VALUES (1,1,1,1,80.00,'2025-10-01 00:00:00','2025-10-03 00:00:00',1,'CheckedOut'),(2,2,1,2,120.00,'2025-10-02 00:00:00','2025-10-05 00:00:00',2,'CheckedOut'),(3,3,2,4,85.00,'2025-10-04 00:00:00','2025-10-06 00:00:00',1,'CheckedOut'),(4,4,2,5,130.00,'2025-10-05 00:00:00','2025-10-07 00:00:00',2,'CheckedOut'),(5,5,3,7,90.00,'2025-10-06 00:00:00','2025-10-09 00:00:00',1,'CheckedIn'),(6,1,3,8,140.00,'2025-10-07 00:00:00','2025-10-10 00:00:00',2,'CheckedOut'),(7,2,3,9,270.00,'2025-10-08 00:00:00','2025-10-12 00:00:00',4,'Booked'),(8,3,1,3,250.00,'2025-10-09 00:00:00','2025-10-11 00:00:00',3,'Booked'),(9,1,1,1,8000.00,'2024-11-15 00:00:00','2024-11-16 00:00:00',2,'Booked'),(10,1,2,4,8000.00,'2025-10-20 00:00:00','2025-10-23 00:00:00',2,'CheckedIn');
/*!40000 ALTER TABLE `booking` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-21 15:08:54

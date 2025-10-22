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
-- Table structure for table `service_usage`
--

DROP TABLE IF EXISTS `service_usage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_usage` (
  `usageID` bigint unsigned NOT NULL,
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_usage`
--

LOCK TABLES `service_usage` WRITE;
/*!40000 ALTER TABLE `service_usage` DISABLE KEYS */;
INSERT INTO `service_usage` VALUES (1,1,1,5000.00,1,'2025-10-01 04:30:00'),(2,1,3,1000.00,2,'2025-10-02 06:30:00'),(3,2,2,1500.00,2,'2025-10-03 03:30:00'),(4,3,4,1000.00,3,'2025-10-04 08:30:00'),(5,4,5,500.00,4,'2025-10-05 10:30:00'),(6,5,6,3000.00,1,'2025-10-06 05:30:00'),(7,6,1,5000.00,1,'2025-10-07 04:30:00'),(8,7,3,1000.00,1,'2025-10-08 07:30:00');
/*!40000 ALTER TABLE `service_usage` ENABLE KEYS */;
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

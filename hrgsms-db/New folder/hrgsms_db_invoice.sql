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
  CONSTRAINT `fk_bookingID_invoice` FOREIGN KEY (`bookingID`) REFERENCES `booking` (`bookingID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_discountCode` FOREIGN KEY (`discountCode`) REFERENCES `discount` (`discountCode`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_policyID` FOREIGN KEY (`policyID`) REFERENCES `tax_policy` (`policyID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `invoice_ibfk_1` FOREIGN KEY (`latePolicyID`) REFERENCES `late_checkout_policy` (`latePolicyID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice`
--

LOCK TABLES `invoice` WRITE;
/*!40000 ALTER TABLE `invoice` DISABLE KEYS */;
INSERT INTO `invoice` VALUES (1,1,1,1,3160.00,7000.00,2000.00,28500.00,'Paid',1316.00,1,3000.00),(2,2,NULL,NULL,360.00,3000.00,0.00,2000.00,'Partially Paid',0.00,NULL,0.00),(3,3,1,NULL,17000.00,3000.00,0.00,1000.00,'Partially Paid',2000.00,2,NULL),(4,4,1,NULL,26000.00,3200.00,0.00,29200.00,'Paid',2920.00,NULL,NULL),(5,5,2,1,27000.00,3000.00,2000.00,10000.00,'Partially Paid',1500.00,1,NULL),(6,6,1,1,3420.00,5000.00,2000.00,51700.00,'Paid',1142.00,NULL,3000.00),(7,7,2,NULL,108000.00,2000.00,0.00,0.00,'Pending',5500.00,NULL,NULL),(8,8,1,2,50000.00,0.00,1500.00,0.00,'Pending',51.50,2,NULL),(10,10,1,1,27000.00,0.00,2000.00,20200.00,'Partially Paid',3000.00,NULL,3000.00);
/*!40000 ALTER TABLE `invoice` ENABLE KEYS */;
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

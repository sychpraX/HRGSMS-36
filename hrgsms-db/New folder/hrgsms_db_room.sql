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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room`
--

LOCK TABLES `room` WRITE;
/*!40000 ALTER TABLE `room` DISABLE KEYS */;
INSERT INTO `room` VALUES (1,1,1,101,'Occupied'),(2,1,2,102,'Available'),(3,1,3,103,'Available'),(4,2,1,201,'Occupied'),(5,2,2,202,'Available'),(6,2,3,203,'Available'),(7,3,1,301,'Occupied'),(8,3,2,302,'Available'),(9,3,3,303,'Available'),(10,3,4,304,'Available');
/*!40000 ALTER TABLE `room` ENABLE KEYS */;
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

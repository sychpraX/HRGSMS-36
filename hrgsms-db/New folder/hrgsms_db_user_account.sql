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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_account`
--

LOCK TABLES `user_account` WRITE;
/*!40000 ALTER TABLE `user_account` DISABLE KEYS */;
INSERT INTO `user_account` VALUES (1,NULL,'User1','Reception',_binary '{Ö\‰\Ë\…\È™ÉHgØti\Ë',_binary '2≤4øn\ﬁÜ5W\ŒXëx´ûV_¨ŸÖ\ÔòJxf'),(2,NULL,'manager1','Manager',_binary '‡∏èBN.w&%\\¡zó\Ÿ\Âº',_binary '«∞q\‚r[2≈•øj£é\„\Õ\…¡\"p§J+\0b_∏\Õx'),(3,NULL,'admin1','Admin',_binary '\Zÿád\Ó®´\‡^o¨aB\≈\«',_binary 'êâ\Ã˝\Œr7%€öúÚ@˘\⁄W|yîOàIjñf•p˛'),(4,NULL,'manager2','Manager',_binary '\"\ÊıC\Î√á∏PP+Nò',_binary ']µå¿ıQ˘8>¿\Õ¯®X]IfcsÉûıZXÕö_˜∏ê'),(5,NULL,'reception1','Reception',_binary 'w}©©j\"á\Ÿ\ﬁ˝X≥Iãó',_binary 'J.øΩF[ a\Ôå?úÆvq,éQóòA∫N\›\Ât\…ñ');
/*!40000 ALTER TABLE `user_account` ENABLE KEYS */;
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

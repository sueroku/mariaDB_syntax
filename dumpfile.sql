-- MariaDB dump 10.19-11.3.2-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: board
-- ------------------------------------------------------
-- Server version	11.3.2-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `author`
--

DROP TABLE IF EXISTS `author`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `author` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(225) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(225) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `age` tinyint(4) DEFAULT NULL,
  `profile_image` blob DEFAULT NULL,
  `role` enum('user','admin') NOT NULL DEFAULT 'user',
  `birth` date DEFAULT NULL,
  `created_time` datetime DEFAULT current_timestamp(),
  `post_count` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `author`
--

LOCK TABLES `author` WRITE;
/*!40000 ALTER TABLE `author` DISABLE KEYS */;
INSERT INTO `author` VALUES
(7,'hong6','hong6@naver.com',NULL,NULL,38,NULL,'user',NULL,NULL,3),
(8,'hong8','hong8@naver.com',NULL,NULL,10,NULL,'user',NULL,NULL,0),
(9,'hong9','hong9@naver.com',NULL,NULL,40,NULL,'user',NULL,NULL,2),
(10,'hong10','hong10@naver.com',NULL,NULL,15,NULL,'admin',NULL,NULL,0),
(11,'홍길동','hong11@naver.com',NULL,NULL,28,NULL,'user','1996-11-11',NULL,0),
(12,'홍길둥','hong12@naver.com',NULL,NULL,30,NULL,'user',NULL,'2023-11-11 12:01:00',0),
(13,'홍길당','hong13@naver.com',NULL,NULL,25,NULL,'user',NULL,'2024-05-17 12:30:42',0),
(14,'hong14','hong14@naver.com',NULL,NULL,18,NULL,'user',NULL,'2024-05-17 16:15:15',0),
(16,'kim','hong16@naver.com',NULL,NULL,21,NULL,'user',NULL,'2024-05-20 15:38:40',0);
/*!40000 ALTER TABLE `author` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post`
--

DROP TABLE IF EXISTS `post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `post` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `contents` varchar(3000) DEFAULT NULL,
  `author_id` bigint(20) DEFAULT NULL,
  `price` decimal(10,3) DEFAULT NULL,
  `created_time` datetime DEFAULT current_timestamp(),
  `user_id` char(36) DEFAULT uuid(),
  PRIMARY KEY (`id`),
  KEY `author_id` (`author_id`),
  CONSTRAINT `post_author_fk` FOREIGN KEY (`author_id`) REFERENCES `author` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post`
--

LOCK TABLES `post` WRITE;
/*!40000 ALTER TABLE `post` DISABLE KEYS */;
INSERT INTO `post` VALUES
(6,'hong','hong hello',7,3000.000,'2022-09-30 12:00:00','030aea85-141f-11ef-9a93-8cb0e9d850ab'),
(7,'hong7-1',NULL,7,8900.000,'2022-11-23 13:09:03','030aeacc-141f-11ef-9a93-8cb0e9d850ab'),
(8,'hong',NULL,7,5000.000,'2023-11-11 12:01:00','030aeb16-141f-11ef-9a93-8cb0e9d850ab'),
(9,'hong8-2',NULL,9,6700.000,'2024-05-17 12:30:43','030aeb3f-141f-11ef-9a93-8cb0e9d850ab'),
(10,'hong hello',NULL,9,4300.000,NULL,'030aeb5c-141f-11ef-9a93-8cb0e9d850ab'),
(11,'hong hello2',NULL,NULL,2400.000,'2024-05-17 16:28:45','184ae8cb-141f-11ef-9a93-8cb0e9d850ab');
/*!40000 ALTER TABLE `post` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-05-22 16:27:31

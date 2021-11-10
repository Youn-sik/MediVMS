-- MySQL dump 10.17  Distrib 10.3.25-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: VMS
-- ------------------------------------------------------
-- Server version	10.3.25-MariaDB-0ubuntu0.20.04.1

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
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `authority` varchar(100) NOT NULL,
  `req_auth` varchar(100) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `department` varchar(100) DEFAULT NULL,
  `employee_no` int(11) DEFAULT NULL,
  `surgery_room_auth` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '[]',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` VALUES (1,'admin','12345','0','null','전준희 ','외과',201830128,'[]'),(2,'wjs4222','12345','3',NULL,'전준희 ','외과',201830128,'[1,2,3]'),(3,'jjh4222','12345','2',NULL,'전준희 2','외과2',201830129,'[]'),(4,'low','12345','3',NULL,'전준희 3','외과3',201830130,'[]');
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `browsing_history`
--

DROP TABLE IF EXISTS `browsing_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `browsing_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `record_id` int(11) NOT NULL,
  `created_at` varchar(100) NOT NULL,
  `account_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `browsing_history_FK` (`record_id`),
  KEY `browsing_history_FK_1` (`account_id`),
  CONSTRAINT `browsing_history_FK` FOREIGN KEY (`record_id`) REFERENCES `records` (`id`),
  CONSTRAINT `browsing_history_FK_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `browsing_history`
--

LOCK TABLES `browsing_history` WRITE;
/*!40000 ALTER TABLE `browsing_history` DISABLE KEYS */;
INSERT INTO `browsing_history` VALUES (2,70,'2021-11-02 11:15:51',1),(3,70,'2021-11-02 13:19:59',1),(4,68,'2021-11-02 16:48:45',1),(5,70,'2021-11-02 16:48:47',1),(6,68,'2021-11-02 16:48:49',1),(7,70,'2021-11-09 16:46:18',1),(8,70,'2021-11-09 16:50:50',1),(9,70,'2021-11-09 16:55:52',1),(10,71,'2021-11-09 16:57:24',1),(11,71,'2021-11-09 17:05:00',1),(12,71,'2021-11-09 17:05:11',1),(13,71,'2021-11-09 17:08:24',1),(14,71,'2021-11-09 17:11:03',1),(15,71,'2021-11-09 17:16:28',1),(16,71,'2021-11-09 17:16:43',1),(17,71,'2021-11-09 17:20:04',1),(18,71,'2021-11-09 17:20:23',1),(19,71,'2021-11-09 17:20:26',1),(20,71,'2021-11-09 17:20:51',1),(21,71,'2021-11-09 17:29:47',1),(22,71,'2021-11-09 17:30:43',1),(23,71,'2021-11-09 17:30:52',1),(24,71,'2021-11-09 18:03:30',1),(25,71,'2021-11-09 18:04:02',1);
/*!40000 ALTER TABLE `browsing_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `devices`
--

DROP TABLE IF EXISTS `devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `devices` (
  `device_id` int(11) NOT NULL AUTO_INCREMENT,
  `device_name` varchar(100) NOT NULL,
  `Serial_number` varchar(100) NOT NULL,
  `live_url` varchar(250) NOT NULL,
  `surgery_id` int(11) DEFAULT NULL,
  `grid_layout_id` int(11) DEFAULT NULL,
  `isLive` tinyint(1) NOT NULL DEFAULT 1,
  `device_location` varchar(100) DEFAULT NULL,
  `note` varchar(100) DEFAULT NULL,
  `device_ip` varchar(100) DEFAULT NULL,
  `isLecord` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`device_id`),
  KEY `devices_FK` (`surgery_id`),
  KEY `devices_FK_1` (`grid_layout_id`),
  CONSTRAINT `devices_FK` FOREIGN KEY (`surgery_id`) REFERENCES `surgery` (`surgery_id`),
  CONSTRAINT `devices_FK_1` FOREIGN KEY (`grid_layout_id`) REFERENCES `grid_layouts` (`grid_layout_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devices`
--

LOCK TABLES `devices` WRITE;
/*!40000 ALTER TABLE `devices` DISABLE KEYS */;
INSERT INTO `devices` VALUES (16,'12','2','rtsp://172.16.100.2:9096',1,NULL,1,'2','123',NULL,0),(17,'1','1','http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',2,NULL,0,'1','1',NULL,0),(18,'3','3','http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',3,NULL,0,'3','3',NULL,0),(19,'5','4','http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',1,NULL,1,'4','1',NULL,0),(20,'12','12','http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',1,NULL,1,'1','1',NULL,0),(21,'12','123','http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',1,NULL,1,'12','12',NULL,0),(22,'12','1234','http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4',4,NULL,0,'1','1',NULL,0);
/*!40000 ALTER TABLE `devices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grid_layouts`
--

DROP TABLE IF EXISTS `grid_layouts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `grid_layouts` (
  `grid_layout_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`grid_layout_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grid_layouts`
--

LOCK TABLES `grid_layouts` WRITE;
/*!40000 ALTER TABLE `grid_layouts` DISABLE KEYS */;
INSERT INTO `grid_layouts` VALUES (1,'1');
/*!40000 ALTER TABLE `grid_layouts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `records`
--

DROP TABLE IF EXISTS `records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sergery_name` varchar(100) NOT NULL,
  `department` varchar(100) NOT NULL,
  `doctor` varchar(100) NOT NULL,
  `surgery_desc` varchar(100) NOT NULL,
  `patient_status` varchar(100) NOT NULL,
  `video_link` varchar(255) NOT NULL,
  `date` varchar(100) NOT NULL,
  `patient_name` varchar(100) NOT NULL,
  `expiration` tinyint(1) NOT NULL DEFAULT 0,
  `devices` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `records`
--

LOCK TABLES `records` WRITE;
/*!40000 ALTER TABLE `records` DISABLE KEYS */;
INSERT INTO `records` VALUES (68,'수술실 1-2','2','https://172.16.135.17:3000/stream/stream0.mpd','null','','http://172.16.41.105:3000/stream/undefined_2021-10-14 09:33:05.mp4','2021-08-14 09:33:05','null',1,NULL),(70,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','https://172.16.135.17:3000/stream/stream0.mpd','2021-10-29 16:55:47','임시 정보',0,NULL),(71,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/2_20211109165713.mp4','2021-11-09 16:57:13','임시 정보',0,'4,12,123,2');
/*!40000 ALTER TABLE `records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedule`
--

DROP TABLE IF EXISTS `schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schedule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `start` varchar(100) NOT NULL,
  `end` varchar(100) NOT NULL,
  `note` varchar(255) NOT NULL,
  `color` varchar(100) NOT NULL,
  `emergency` tinyint(1) DEFAULT 0,
  `surgery_id` int(11) DEFAULT NULL,
  `is_record` tinyint(1) DEFAULT 0,
  `is_over` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `schedule_FK` (`surgery_id`),
  CONSTRAINT `schedule_FK` FOREIGN KEY (`surgery_id`) REFERENCES `surgery` (`surgery_id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule`
--

LOCK TABLES `schedule` WRITE;
/*!40000 ALTER TABLE `schedule` DISABLE KEYS */;
INSERT INTO `schedule` VALUES (11,'321','2021-10-26 14:33:00','2021-10-26 14:33:00','321','indigo',0,1,0,0),(14,'ㅅ','2021-10-27','2021-10-27','ㅅㄷㄴㅅ','green',1,1,0,0),(15,'123','2021-10-27 13:41:00','2021-10-27 14:43:00','312313','blue',0,1,0,0),(18,'test','2021-10-27 17:31','2021-10-27 18:32','test','deep-purple',0,2,0,0),(19,'rw','2021-10-28','2021-10-28','test','green',1,2,0,0),(22,'test','2021-10-28 13:39','2021-10-28 13:39','test','green',0,1,0,0),(24,'test','2021-10-28 20:36','2021-10-28 22:37','test','deep-purple',0,1,0,0),(26,'test','2021-10-28','2021-10-28','test','indigo',1,1,0,0),(27,'test','2021-10-29 14:36','2021-10-29 16:36','test','green',0,1,0,1),(28,'test','2021-10-29 14:36','2021-10-29 15:36','test','deep-purple',0,1,0,1),(29,'1','2021-10-29 15:31','2021-10-29 15:31','1','green',0,1,0,1),(30,'2','2021-10-29 15:31','2021-10-29 15:31','2','indigo',0,1,0,0),(32,'긴급1','2021-11-03','2021-11-03','5','indigo',1,1,0,0),(33,'1','2021-11-03','2021-11-03','ㅅㄷㄴㅅ','blue',1,1,0,0),(39,'1','2021-11-04','2021-11-04','1','indigo',1,1,0,0),(40,'ㅅ','2021-11-04','2021-11-04','ㅅ','indigo',1,1,0,0),(41,'ㅅㄷㄴㅅ','2021-11-04','2021-11-04','ㅅ','blue',1,1,0,0),(42,'test','2021-11-09','2021-11-09','test','indigo',1,1,0,1),(43,'test','2021-11-09','2021-11-09','test','cyan',1,1,0,1),(44,'1','2021-11-09','2021-11-09','trs','indigo',1,1,0,1);
/*!40000 ALTER TABLE `schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `surgery`
--

DROP TABLE IF EXISTS `surgery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `surgery` (
  `surgery_id` int(11) NOT NULL AUTO_INCREMENT,
  `surgery_name` varchar(100) NOT NULL,
  `record` tinyint(1) NOT NULL DEFAULT 0,
  `record_time` varchar(100) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`surgery_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `surgery`
--

LOCK TABLES `surgery` WRITE;
/*!40000 ALTER TABLE `surgery` DISABLE KEYS */;
INSERT INTO `surgery` VALUES (1,'수술실 #1',0,NULL,'123'),(2,'수술실 #2',0,NULL,'3212'),(3,'수술실 #3',0,NULL,NULL),(4,'수술실 #4',0,NULL,NULL);
/*!40000 ALTER TABLE `surgery` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `surgery_reserv`
--

DROP TABLE IF EXISTS `surgery_reserv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `surgery_reserv` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `surgery_id` int(11) NOT NULL,
  `patient_name` varchar(100) NOT NULL,
  `doctor_name` varchar(100) NOT NULL,
  `start_time` varchar(100) DEFAULT NULL,
  `end_time` varchar(100) DEFAULT NULL,
  `patient_sex` varchar(100) DEFAULT NULL,
  `patient_status` varchar(100) DEFAULT NULL,
  `patient_age` varchar(100) DEFAULT NULL,
  `status` varchar(100) NOT NULL DEFAULT '2',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=164 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `surgery_reserv`
--

LOCK TABLES `surgery_reserv` WRITE;
/*!40000 ALTER TABLE `surgery_reserv` DISABLE KEYS */;
INSERT INTO `surgery_reserv` VALUES (156,1,'test','test','2021-10-26 00:03:00','2021-10-26 12:12:00','남자','test','21','0'),(157,1,'test','test','2021-10-26 00:00:00','2021-10-26 23:59:00','남자','test','21','0'),(158,1,'1','1','2021-10-26 00:00:00','2021-10-27 00:00:00','남자','1','1','0'),(159,3,'1','1','2021-10-26 00:00:00','2021-10-26 23:59:00','남자','1','1','1'),(160,1,'1','1','2021-10-26 00:00:00','2021-10-27 00:00:00','남자','1','1','0'),(161,1,'1','1','2021-10-26 00:00:00','2021-10-27 00:00:00','남자','1','11','0'),(162,1,'123','123','2021-10-26 00:00:00','2021-10-27 00:00:00','남자','123','123','0'),(163,1,'321','321','2021-10-26 00:00:00','2021-10-26 00:59:00','남자','321','321','0');
/*!40000 ALTER TABLE `surgery_reserv` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-11-10 11:03:18

-- MySQL dump 10.19  Distrib 10.3.32-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: VMS
-- ------------------------------------------------------
-- Server version	10.3.32-MariaDB-0ubuntu0.20.04.1

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
  `dashboard` tinyint(1) NOT NULL DEFAULT 0,
  `surgery` tinyint(1) NOT NULL DEFAULT 0,
  `schedule` tinyint(1) NOT NULL DEFAULT 0,
  `browse` tinyint(1) NOT NULL DEFAULT 0,
  `admin` tinyint(1) NOT NULL DEFAULT 0,
  `setting` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` VALUES (1,'admin','12345','0','0','전준희','외과',1,'',1,1,1,1,1,1),(2,'surgery','12345','0',NULL,'전준희2','외과',2,'[]',0,0,0,1,0,0),(3,'schedule','12345','0',NULL,'전준희3','외과',3,'[]',0,0,0,1,0,0);
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
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
  KEY `devices_FK` (`surgery_id`) USING BTREE,
  KEY `devices_FK_1` (`grid_layout_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devices`
--

LOCK TABLES `devices` WRITE;
/*!40000 ALTER TABLE `devices` DISABLE KEYS */;
INSERT INTO `devices` VALUES (39,'1-1','1','rtsp://172.16.33.201:9096',1,NULL,1,NULL,'1',NULL,0),(42,'1-2','2','rtsp://172.16.33.202:9096',1,NULL,1,NULL,'',NULL,0),(43,'1-3','3','rtsp://172.16.33.203:9096',1,NULL,1,NULL,'',NULL,0),(44,'1-4','4','rtsp://172.16.33.204:9096',1,NULL,1,NULL,'',NULL,0),(45,'2-1','5','rtsp://172.16.33.205:9096',2,NULL,1,NULL,'',NULL,0),(46,'2-2','6','rtsp://172.16.33.206:9096',2,NULL,1,NULL,'',NULL,0),(47,'2-3','7','rtsp://172.16.33.207:9096',2,NULL,1,NULL,'',NULL,0),(48,'2-4','8','rtsp://172.16.33.208:9096',2,NULL,1,NULL,'',NULL,0),(49,'3-1','9','rtsp://172.16.33.209:9096',3,NULL,1,NULL,'9',NULL,0),(50,'3-2','10','rtsp://172.16.33.210:9096',3,NULL,1,NULL,'10',NULL,0),(51,'3-3','11','rtsp://172.16.33.211:9096',3,NULL,1,NULL,'11',NULL,0),(52,'3-4','12','rtsp://172.16.33.212:9096',3,NULL,1,NULL,'12',NULL,0),(53,'4-1','13','rtsp://172.16.33.213:9096',4,NULL,1,NULL,'13',NULL,0),(54,'4-2','14','rtsp://172.16.33.214:9096',4,NULL,1,NULL,'14',NULL,0),(55,'4-3','15','rtsp://172.16.33.215:9096',4,NULL,1,NULL,'15',NULL,0),(56,'4-4','16','rtsp://172.16.33.216:9096',4,NULL,1,NULL,'16',NULL,0),(57,'5-1','17','rtsp://172.16.33.217:9096',5,NULL,1,NULL,'17',NULL,0),(58,'5-2','18','rtsp://172.16.33.218:9096',5,NULL,1,NULL,'18',NULL,0),(59,'5-3','19','rtsp://172.16.33.219:9096',5,NULL,1,NULL,'19',NULL,0),(60,'5-4','20','rtsp://172.16.33.220:9096',5,NULL,1,NULL,'20',NULL,0);
/*!40000 ALTER TABLE `devices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctors`
--

DROP TABLE IF EXISTS `doctors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `doctors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `department` varchar(100) DEFAULT NULL,
  `rank` varchar(100) DEFAULT NULL,
  `employee_id` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctors`
--

LOCK TABLES `doctors` WRITE;
/*!40000 ALTER TABLE `doctors` DISABLE KEYS */;
INSERT INTO `doctors` VALUES (4,'1','1','1','1'),(5,'2','2','2','2'),(6,'3','3','3','3'),(7,'4','4','4','4');
/*!40000 ALTER TABLE `doctors` ENABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grid_layouts`
--

LOCK TABLES `grid_layouts` WRITE;
/*!40000 ALTER TABLE `grid_layouts` DISABLE KEYS */;
/*!40000 ALTER TABLE `grid_layouts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `history`
--

DROP TABLE IF EXISTS `history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `record_id` int(11) NOT NULL,
  `created_at` varchar(100) NOT NULL,
  `account_id` int(11) NOT NULL,
  `type` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `browsing_history_FK` (`record_id`) USING BTREE,
  KEY `browsing_history_FK_1` (`account_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `history`
--

LOCK TABLES `history` WRITE;
/*!40000 ALTER TABLE `history` DISABLE KEYS */;
INSERT INTO `history` VALUES (1,1,'2021-12-08 15:36:54',1,'browse'),(2,9,'2021-12-16 10:04:12',1,'browse'),(3,9,'2021-12-16 10:04:25',1,'browse'),(4,9,'2021-12-16 10:05:40',1,'browse'),(5,9,'2021-12-16 10:29:04',1,'browse'),(6,21,'2022-01-12 16:31:08',1,'browse'),(7,21,'2022-01-12 16:47:19',1,'browse'),(8,21,'2022-01-12 16:47:27',1,'browse'),(9,21,'2022-01-12 17:06:16',1,'browse'),(10,21,'2022-01-12 17:06:21',1,'browse'),(11,21,'2022-01-14 13:23:25',1,'browse'),(12,21,'2022-01-14 17:12:54',1,'browse'),(13,21,'2022-01-17 10:28:11',1,'browse'),(14,21,'2022-01-17 16:25:23',1,'takeout'),(15,21,'2022-01-17 16:25:35',1,'takeout'),(16,21,'2022-01-17 16:25:36',1,'takeout'),(17,36,'2022-01-20 15:05:57',1,'browse'),(18,36,'2022-01-20 15:16:38',1,'browse'),(19,36,'2022-01-20 15:37:44',1,'browse'),(20,36,'2022-01-20 15:44:35',1,'browse'),(21,36,'2022-01-20 15:46:12',1,'browse'),(22,36,'2022-01-20 17:58:02',1,'browse'),(23,36,'2022-01-21 10:18:01',1,'browse'),(24,36,'2022-01-21 10:25:00',1,'browse'),(25,36,'2022-01-21 10:32:15',1,'browse'),(26,36,'2022-01-21 10:52:37',1,'browse'),(27,36,'2022-01-21 10:53:15',1,'browse'),(28,36,'2022-01-21 10:54:05',1,'browse'),(29,36,'2022-01-21 10:54:23',1,'browse'),(30,36,'2022-01-21 10:54:58',1,'browse'),(31,36,'2022-01-21 10:55:26',1,'browse'),(32,36,'2022-01-21 10:55:50',1,'browse'),(33,36,'2022-01-21 11:05:46',1,'browse'),(34,36,'2022-01-21 11:26:06',1,'browse'),(35,36,'2022-01-21 11:26:39',1,'browse'),(36,37,'2022-01-21 11:30:30',1,'takeout'),(37,36,'2022-01-21 11:56:14',1,'browse'),(38,36,'2022-01-21 12:21:14',1,'browse'),(39,36,'2022-01-21 16:43:38',1,'browse'),(40,36,'2022-01-21 16:52:07',1,'browse'),(41,36,'2022-01-21 17:14:33',1,'browse'),(42,36,'2022-01-24 02:40:27',1,'browse'),(43,36,'2022-01-24 10:44:54',1,'browse'),(44,36,'2022-01-24 10:45:17',1,'browse'),(45,36,'2022-01-24 10:46:48',1,'browse'),(46,36,'2022-01-24 10:47:59',1,'browse'),(47,36,'2022-01-24 15:11:59',1,'browse'),(48,36,'2022-01-24 17:44:32',1,'browse'),(49,36,'2022-01-24 17:45:37',1,'browse'),(50,36,'2022-01-24 17:48:45',1,'browse'),(51,36,'2022-01-24 17:48:56',1,'browse'),(52,36,'2022-01-24 17:49:39',1,'browse'),(53,36,'2022-01-24 17:49:41',1,'browse'),(54,36,'2022-01-24 17:50:01',1,'browse'),(55,36,'2022-01-24 18:16:40',1,'browse'),(56,36,'2022-01-24 18:17:33',1,'browse'),(57,36,'2022-01-24 18:17:52',1,'browse'),(58,36,'2022-01-24 18:18:28',1,'browse'),(59,36,'2022-01-24 18:19:21',1,'browse'),(60,36,'2022-01-24 18:21:44',1,'browse'),(61,36,'2022-01-24 18:22:51',1,'browse'),(62,36,'2022-01-24 18:23:21',1,'browse'),(63,36,'2022-01-25 09:23:49',1,'browse'),(64,36,'2022-01-25 09:27:45',1,'browse'),(65,36,'2022-01-25 10:01:47',1,'browse'),(66,36,'2022-01-25 10:16:58',1,'browse'),(67,36,'2022-01-25 10:17:27',1,'browse'),(68,36,'2022-01-25 10:48:50',1,'browse'),(69,36,'2022-01-25 15:12:43',1,'browse'),(70,36,'2022-01-25 15:16:30',1,'browse'),(71,36,'2022-01-25 15:28:22',1,'browse'),(72,36,'2022-01-25 15:33:19',1,'browse'),(73,36,'2022-01-25 15:35:12',1,'browse'),(74,36,'2022-01-25 16:11:50',1,'browse'),(75,36,'2022-01-25 16:20:34',1,'browse'),(76,36,'2022-01-26 22:33:17',1,'browse'),(77,37,'2022-01-26 22:33:42',1,'takeout'),(78,36,'2022-01-26 22:34:00',1,'browse'),(79,36,'2022-01-27 08:40:08',1,'browse'),(80,37,'2022-02-14 10:08:51',1,'browse');
/*!40000 ALTER TABLE `history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `record_access`
--

DROP TABLE IF EXISTS `record_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `record_access` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `record_id` int(11) NOT NULL,
  `status` varchar(100) DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `created_at` varchar(100) DEFAULT NULL,
  `updated_at` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `record_access_FK` (`user_id`) USING BTREE,
  KEY `record_access_FK_1` (`record_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `record_access`
--

LOCK TABLES `record_access` WRITE;
/*!40000 ALTER TABLE `record_access` DISABLE KEYS */;
INSERT INTO `record_access` VALUES (14,1,37,'permitted','test','2022-02-14 10:01:35','2022-02-14 01:08:46');
/*!40000 ALTER TABLE `record_access` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `records`
--

DROP TABLE IF EXISTS `records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `surgery_id` int(11) DEFAULT NULL,
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
  `takeout_link` varchar(255) DEFAULT NULL,
  `split` tinyint(1) DEFAULT 0,
  `end_date` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `records_FK` (`surgery_id`),
  CONSTRAINT `records_FK` FOREIGN KEY (`surgery_id`) REFERENCES `surgery` (`surgery_id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `records`
--

LOCK TABLES `records` WRITE;
/*!40000 ALTER TABLE `records` DISABLE KEYS */;
INSERT INTO `records` VALUES (36,1,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','20220120144822803','2022-01-20 14:48:22','임시 정보',0,'1,2,3,4',NULL,2,'2022-01-21 02:24:40'),(37,1,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','20220121112437272','2022-01-21 11:24:37','임시 정보',0,'1,2,3,4',NULL,0,'2022-01-21 02:24:40');
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
  `patient` varchar(100) DEFAULT NULL,
  `doctor` int(11) DEFAULT NULL,
  `patient_code` varchar(100) DEFAULT NULL,
  `patient_birthday` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `schedule_FK` (`surgery_id`) USING BTREE,
  KEY `doctor_FK` (`doctor`),
  CONSTRAINT `doctor_FK` FOREIGN KEY (`doctor`) REFERENCES `doctors` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule`
--

LOCK TABLES `schedule` WRITE;
/*!40000 ALTER TABLE `schedule` DISABLE KEYS */;
INSERT INTO `schedule` VALUES (38,'Event #0','2022-01-19 07:00:00','2022-01-19 12:30:00','1','blue',0,1,0,1,'1',4,'1','1'),(45,'Event #1','2022-01-20 10:30:00','2022-01-20 14:30:00','1','blue',0,1,0,1,'1',4,'1','1'),(46,'Event #2','2022-01-16 00:45:00','2022-01-16 07:00:00','1','blue',0,1,0,1,'1번',4,'1번','1');
/*!40000 ALTER TABLE `schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `watermark` tinyint(1) NOT NULL DEFAULT 0,
  `face` tinyint(1) NOT NULL DEFAULT 0,
  `human` tinyint(1) NOT NULL DEFAULT 0,
  `voice` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` VALUES (1,1,1,0,1);
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `splited_records`
--

DROP TABLE IF EXISTS `splited_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `splited_records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `video_link` varchar(255) NOT NULL,
  `date` varchar(100) NOT NULL,
  `takeout_link` varchar(255) DEFAULT NULL,
  `record_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `splited_records_FK` (`record_id`),
  CONSTRAINT `splited_records_FK` FOREIGN KEY (`record_id`) REFERENCES `records` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `splited_records`
--

LOCK TABLES `splited_records` WRITE;
/*!40000 ALTER TABLE `splited_records` DISABLE KEYS */;
INSERT INTO `splited_records` VALUES (3,'20220120054826874','2022-01-20 05:48:26',NULL,36);
/*!40000 ALTER TABLE `splited_records` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `surgery`
--

LOCK TABLES `surgery` WRITE;
/*!40000 ALTER TABLE `surgery` DISABLE KEYS */;
INSERT INTO `surgery` VALUES (1,'수술실 #1',0,'2022-01-21 11:24:37',''),(2,'수술실 #2',0,NULL,''),(3,'수술실 #3',0,'2021-12-20 12:35:47',''),(4,'수술실 #4',0,'2021-12-20 12:35:52',''),(5,'수술실 #5',0,NULL,''),(6,'6',0,NULL,'6');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `surgery_reserv`
--

LOCK TABLES `surgery_reserv` WRITE;
/*!40000 ALTER TABLE `surgery_reserv` DISABLE KEYS */;
/*!40000 ALTER TABLE `surgery_reserv` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `takeout_access`
--

DROP TABLE IF EXISTS `takeout_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `takeout_access` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `record_id` int(11) NOT NULL,
  `status` varchar(100) DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `created_at` varchar(100) DEFAULT NULL,
  `updated_at` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `takeout_access_FK` (`user_id`) USING BTREE,
  KEY `takeout_access_FK_1` (`record_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `takeout_access`
--

LOCK TABLES `takeout_access` WRITE;
/*!40000 ALTER TABLE `takeout_access` DISABLE KEYS */;
/*!40000 ALTER TABLE `takeout_access` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-02-14  4:45:34

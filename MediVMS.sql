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
  `history` tinyint(1) NOT NULL DEFAULT 0,
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
INSERT INTO `accounts` VALUES (1,'admin','12345','0','0','전준희','외과',1,'',1,1,1,1,1,1,1),(2,'surgery','12345','0',NULL,'전준희2','외과',2,'[]',0,0,0,1,0,0,0),(3,'schedule','12345','0',NULL,'전준희3','외과',3,'[]',0,0,0,1,0,0,0);
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
  KEY `browsing_history_FK` (`record_id`) USING BTREE,
  KEY `browsing_history_FK_1` (`account_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `browsing_history`
--

LOCK TABLES `browsing_history` WRITE;
/*!40000 ALTER TABLE `browsing_history` DISABLE KEYS */;
INSERT INTO `browsing_history` VALUES (1,1,'2021-12-08 15:36:54',1),(2,9,'2021-12-16 10:04:12',1),(3,9,'2021-12-16 10:04:25',1),(4,9,'2021-12-16 10:05:40',1),(5,9,'2021-12-16 10:29:04',1),(6,21,'2022-01-12 16:31:08',1),(7,21,'2022-01-12 16:47:19',1),(8,21,'2022-01-12 16:47:27',1),(9,21,'2022-01-12 17:06:16',1),(10,21,'2022-01-12 17:06:21',1);
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
-- Table structure for table `record_access`
--

DROP TABLE IF EXISTS `record_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `record_access` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `record_id` int(11) NOT NULL,
  `status` varchar(100) NOT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `created_at` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `record_access_FK` (`user_id`) USING BTREE,
  KEY `record_access_FK_1` (`record_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `record_access`
--

LOCK TABLES `record_access` WRITE;
/*!40000 ALTER TABLE `record_access` DISABLE KEYS */;
INSERT INTO `record_access` VALUES (1,1,1,'permitted','test','2021-12-08 15:36:24'),(2,1,21,'permitted','승인 사유 2','2022-01-12 16:29:07'),(3,1,20,'standby','123','2022-01-12 17:05:02'),(4,1,20,'standby','321','2022-01-12 17:05:30');
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `records`
--

LOCK TABLES `records` WRITE;
/*!40000 ALTER TABLE `records` DISABLE KEYS */;
INSERT INTO `records` VALUES (1,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/1_20211203171822.mp4','2021-12-03 17:18:22','임시 정보',1,'1',NULL),(2,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/3_20211210105107.mp4','2021-12-10 10:51:07','임시 정보',1,'2,3',NULL),(3,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/3_20211210105111.mp4','2021-12-10 10:51:11','임시 정보',1,'2,3',NULL),(4,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211213172420.mp4','2021-12-13 17:24:20','임시 정보',1,'1,2,3,4',NULL),(5,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211213175808.mp4','2021-12-13 17:58:08','임시 정보',1,'1,2,3,4',NULL),(6,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211213180127.mp4','2021-12-13 18:01:27','임시 정보',1,'1,2,3,4',NULL),(7,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211213180720.mp4','2021-12-13 18:07:20','임시 정보',1,'1,2,3,4',NULL),(8,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211213183037.mp4','2021-12-13 18:30:38','임시 정보',1,'1,2,3,4',NULL),(9,'6','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/null_20211215155749.mp4','2021-12-15 15:57:49','임시 정보',0,'',NULL),(10,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','/stream/3_20211217175109/3_20211217175109.mp4','2021-12-17 17:51:09','임시 정보',0,'4,1,2,3',NULL),(11,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','/stream/3_20211217175308/3_20211217175308.mp4','2021-12-17 17:53:08','임시 정보',0,'4,1,2,3',NULL),(12,'수술실 #2','임시 정보','임시 정보','임시 정보','수술 완료','/stream/8_20211217175332/8_20211217175332.mp4','2021-12-17 17:53:32','임시 정보',0,'5,6,7,8',NULL),(13,'수술실 #3','임시 정보','임시 정보','임시 정보','수술 완료','/stream/11_20211217175426/11_20211217175426.mp4','2021-12-17 17:54:26','임시 정보',0,'12,9,10,11',NULL),(14,'수술실 #4','임시 정보','임시 정보','임시 정보','수술 완료','/stream/15_20211217175559/15_20211217175559.mp4','2021-12-17 17:56:00','임시 정보',0,'16,13,14,15',NULL),(15,'수술실 #5','임시 정보','임시 정보','임시 정보','수술 완료','/stream/20_20211217175606/20_20211217175606.mp4','2021-12-17 17:56:06','임시 정보',0,'17,18,19,20',NULL),(16,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','/stream/1_20211220123112/1_20211220123112.mp4','2021-12-20 12:31:12','임시 정보',0,'2,3,4,1',NULL),(17,'수술실 #2','임시 정보','임시 정보','임시 정보','수술 완료','/stream/7_20211220123431/7_20211220123431.mp4','2021-12-20 12:34:31','임시 정보',0,'8,5,6,7',NULL),(18,'수술실 #3','임시 정보','임시 정보','임시 정보','수술 완료','/stream/11_20211220123547/11_20211220123547.mp4','2021-12-20 12:35:47','임시 정보',0,'12,9,10,11',NULL),(19,'수술실 #4','임시 정보','임시 정보','임시 정보','수술 완료','/stream/16_20211220123552/16_20211220123552.mp4','2021-12-20 12:35:53','임시 정보',0,'13,14,15,16',NULL),(20,'수술실 #5','임시 정보','임시 정보','임시 정보','수술 완료','/stream/18_20211220123722/18_20211220123722.mp4','2021-12-20 12:37:22','임시 정보',0,'19,20,17,18',NULL),(21,'수술실 #2','임시 정보','임시 정보','임시 정보','수술 완료','/stream/8_20220112155701/8_20220112155701.mp4','2022-01-12 15:57:01','임시 정보',0,'5,6,7,8',NULL),(22,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','/stream/4_20220112172513/4_20220112172513.mp4','2022-01-12 17:25:13','임시 정보',0,'1,2,3,4',NULL);
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
  `doctor` varchar(100) DEFAULT NULL,
  `patient_code` varchar(100) DEFAULT NULL,
  `patient_birthday` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `schedule_FK` (`surgery_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule`
--

LOCK TABLES `schedule` WRITE;
/*!40000 ALTER TABLE `schedule` DISABLE KEYS */;
INSERT INTO `schedule` VALUES (1,'Event #0','2021-12-03 03:00','2021-12-03 09:45','1','blue',0,1,0,1,'1','1',NULL,NULL),(2,'Event #0','2021-12-08 03:15:00','2021-12-08 08:00:00','1','blue',0,1,0,0,'1','1',NULL,NULL),(3,'Event #2','2021-12-10 07:00:00','2021-12-10 11:00:00','1','blue',0,1,0,1,'1','1',NULL,NULL),(4,'Event #3','2021-12-10 16:00:00','2021-12-10 18:15:00','2','blue',0,1,0,1,'2','2',NULL,NULL),(8,'Event #0','2021-12-13 03:00','2021-12-13 07:00','undefined','blue',0,3,0,0,'','',NULL,NULL),(10,'녹화','2021-12-13 18:30','2021-12-15 18:30','3','deep-purple',0,1,0,1,'1','2',NULL,NULL),(11,'Event #0','2021-12-15 03:30','2021-12-15 11:30','1','blue',0,6,0,1,'1','1',NULL,NULL),(13,'2rec','2021-12-17 17:49','2021-12-17 17:49','2','indigo',0,2,0,1,'2','2',NULL,NULL),(15,'3rec','2021-12-17 17:54','2021-12-17 17:54','3','deep-purple',0,3,0,1,'3','3',NULL,NULL),(16,'4rec','2021-12-17 17:55','2021-12-22 17:55','4','cyan',0,4,0,1,'4','4',NULL,NULL),(18,'1rec','2021-12-20 12:30','2021-12-22 12:30','1','blue',0,1,0,1,'1','1',NULL,NULL),(19,'2rec','2021-12-20 12:34','2021-12-22 12:34','2','indigo',0,2,0,1,'2','2',NULL,NULL),(20,'3rec','2021-12-20 12:35','2021-12-22 12:35','3','deep-purple',0,3,1,0,'3','3',NULL,NULL),(21,'4rec','2021-12-20 12:35','2021-12-22 12:35','4','cyan',0,4,1,0,'4','4',NULL,NULL),(22,'5rec','2021-12-20 12:36','2021-12-22 12:36','5','green',0,5,0,1,'5','5',NULL,NULL),(24,'Event #1','2022-01-12 12:15:00','2022-01-12 18:15:00','1','blue',0,2,0,1,'1','1',NULL,NULL),(25,'Event #1','2022-01-12 03:00:00','2022-01-12 07:15:00','1','blue',0,1,0,1,'1','1',NULL,NULL),(27,'1','2022-01-13 16:14','2022-01-13 16:16','1','blue',0,1,0,0,'1','1','1','1');
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
INSERT INTO `settings` VALUES (1,1,0,0,1);
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
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
INSERT INTO `surgery` VALUES (1,'수술실 #1',0,NULL,''),(2,'수술실 #2',0,NULL,''),(3,'수술실 #3',1,'2021-12-20 12:35:47',''),(4,'수술실 #4',1,'2021-12-20 12:35:52',''),(5,'수술실 #5',0,NULL,''),(6,'6',0,NULL,'6');
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
  PRIMARY KEY (`id`),
  KEY `takeout_access_FK` (`user_id`) USING BTREE,
  KEY `takeout_access_FK_1` (`record_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `takeout_access`
--

LOCK TABLES `takeout_access` WRITE;
/*!40000 ALTER TABLE `takeout_access` DISABLE KEYS */;
INSERT INTO `takeout_access` VALUES (1,1,9,'permitted','ㅅㄷㄴㅅ','2021-12-16 10:03:59'),(2,1,8,'standby','ㅅㄷㄴㅅ','2021-12-16 10:04:16');
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

-- Dump completed on 2022-01-13  8:40:13

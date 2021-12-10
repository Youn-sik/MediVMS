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
  `dashboard` tinyint(1) NOT NULL DEFAULT 0,
  `surgery` tinyint(1) NOT NULL DEFAULT 0,
  `schedule` tinyint(1) NOT NULL DEFAULT 0,
  `browse` tinyint(1) NOT NULL DEFAULT 0,
  `history` tinyint(1) NOT NULL DEFAULT 0,
  `admin` tinyint(1) NOT NULL DEFAULT 0,
  `setting` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` VALUES (1,'admin','12345','0','null','전준희 0','외과',201830128,'[]',1,1,1,1,1,1,1),(2,'surgery','12345','1',NULL,'전준희 ','외과',201830128,'[1,2,3]',0,1,0,0,0,0,0),(3,'schedule','12345','0',NULL,'전준희 2','외과2',201830129,'[]',0,0,1,0,0,0,0),(4,'low','12345','0',NULL,'전준희 3','외과3',201830130,'[]',0,0,0,1,0,0,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `browsing_history`
--

LOCK TABLES `browsing_history` WRITE;
/*!40000 ALTER TABLE `browsing_history` DISABLE KEYS */;
INSERT INTO `browsing_history` VALUES (2,70,'2021-11-02 11:15:51',1),(3,70,'2021-11-02 13:19:59',1),(4,68,'2021-11-02 16:48:45',1),(5,70,'2021-11-02 16:48:47',1),(6,68,'2021-11-02 16:48:49',1),(7,70,'2021-11-09 16:46:18',1),(8,70,'2021-11-09 16:50:50',1),(9,70,'2021-11-09 16:55:52',1),(10,71,'2021-11-09 16:57:24',1),(11,71,'2021-11-09 17:05:00',1),(12,71,'2021-11-09 17:05:11',1),(13,71,'2021-11-09 17:08:24',1),(14,71,'2021-11-09 17:11:03',1),(15,71,'2021-11-09 17:16:28',1),(16,71,'2021-11-09 17:16:43',1),(17,71,'2021-11-09 17:20:04',1),(18,71,'2021-11-09 17:20:23',1),(19,71,'2021-11-09 17:20:26',1),(20,71,'2021-11-09 17:20:51',1),(21,71,'2021-11-09 17:29:47',1),(22,71,'2021-11-09 17:30:43',1),(23,71,'2021-11-09 17:30:52',1),(24,71,'2021-11-09 18:03:30',1),(25,71,'2021-11-09 18:04:02',1),(26,83,'2021-11-16 15:36:52',1),(27,83,'2021-11-16 15:37:35',1),(28,82,'2021-11-16 15:37:36',1),(29,83,'2021-11-16 15:38:46',1),(30,135,'2021-11-29 17:49:36',1),(31,135,'2021-11-29 17:49:55',1);
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
  `schedule` varchar(2500) NOT NULL DEFAULT '["cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel","cancel"] ',
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
INSERT INTO `devices` VALUES (16,'12','2','rtsp://172.16.100.2:9096',1,NULL,1,'2','123',NULL,0,'[\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\",\"all\"]'),(17,'1','1','http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',2,NULL,0,'1','1',NULL,0,'[\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\"] '),(18,'3','3','http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',3,NULL,0,'3','3',NULL,0,'[\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\"] '),(19,'5','4','http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',1,NULL,1,'4','1',NULL,0,'[\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\"] '),(20,'12','12','http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',1,NULL,1,'1','1',NULL,0,'[\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\"] '),(21,'12','123','http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',1,NULL,1,'12','12',NULL,0,'[\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\"] '),(22,'12','1234','http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4',4,NULL,0,'1','1',NULL,0,'[\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\",\"cancel\"] ');
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
  KEY `record_access_FK` (`user_id`),
  KEY `record_access_FK_1` (`record_id`),
  CONSTRAINT `record_access_FK` FOREIGN KEY (`user_id`) REFERENCES `accounts` (`id`),
  CONSTRAINT `record_access_FK_1` FOREIGN KEY (`record_id`) REFERENCES `records` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `record_access`
--

LOCK TABLES `record_access` WRITE;
/*!40000 ALTER TABLE `record_access` DISABLE KEYS */;
INSERT INTO `record_access` VALUES (2,1,132,'denied','test','2021-11-24 13:49:06'),(3,1,131,'standby','test','2021-11-24 13:51:20'),(4,1,128,'standby','test','2021-11-24 13:51:24'),(8,1,132,'standby','ㅅㄷㄴㅅ','2021-11-24 15:04:00'),(9,1,130,'standby','3','2021-11-24 15:04:10'),(10,1,129,'standby','1','2021-11-24 15:05:57'),(11,1,135,'permitted','ㅅㄷㄴㅅ','2021-11-29 10:00:53'),(12,1,142,'denied','fdsa','2021-11-29 17:12:09');
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=162 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `records`
--

LOCK TABLES `records` WRITE;
/*!40000 ALTER TABLE `records` DISABLE KEYS */;
INSERT INTO `records` VALUES (68,'수술실 1-2','2','https://172.16.135.17:3000/stream/stream0.mpd','null','','http://172.16.41.105:3000/stream/undefined_2021-10-14 09:33:05.mp4','2021-08-14 09:33:05','null',1,NULL),(70,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','https://172.16.135.17:3000/stream/stream0.mpd','2021-10-29 16:55:47','임시 정보',1,NULL),(71,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/2_20211109165713.mp4','2021-11-09 16:57:13','임시 정보',0,'4,12,123,2'),(72,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/123_20211116113541.mp4','2021-11-16 11:35:41','임시 정보',0,'2,4,12,123'),(73,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/123_20211116130543.mp4','2021-11-16 13:05:43','임시 정보',0,'2,4,12,123'),(74,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/12_20211116131002.mp4','2021-11-16 13:10:02','임시 정보',0,'123,2,4,12'),(75,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/12_20211116131244.mp4','2021-11-16 13:12:44','임시 정보',0,'123,2,4,12'),(76,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/12_20211116132919.mp4','2021-11-16 13:29:19','임시 정보',0,'123,2,4,12'),(77,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/12_20211116133814.mp4','2021-11-16 13:38:14','임시 정보',0,'123,2,4,12'),(78,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/12_20211116133906.mp4','2021-11-16 13:39:06','임시 정보',0,'123,2,4,12'),(79,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/12_20211116135021.mp4','2021-11-16 13:50:21','임시 정보',0,'123,2,4,12'),(80,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211116135519.mp4','2021-11-16 13:55:19','임시 정보',0,'12,123,2,4'),(81,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211116135528.mp4','2021-11-16 13:55:28','임시 정보',0,'12,123,2,4'),(82,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/12_20211116135732.mp4','2021-11-16 13:57:32','임시 정보',0,'123,2,4,12'),(83,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/12_20211116135753.mp4','2021-11-16 13:57:53','임시 정보',0,'123,2,4,12'),(84,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/2_20211117093217.mp4','2021-11-17 09:32:17','임시 정보',0,'4,12,123,2'),(85,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211117101814.mp4','2021-11-17 10:18:15','임시 정보',0,'12,123,2,4'),(86,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211117102211.mp4','2021-11-17 10:22:11','임시 정보',0,'12,123,2,4'),(87,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/12_20211117142002.mp4','2021-11-17 14:20:02','임시 정보',0,'123,2,4,12'),(88,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211117142300.mp4','2021-11-17 14:23:00','임시 정보',0,'12,123,2,4'),(89,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211117142629.mp4','2021-11-17 14:26:29','임시 정보',0,'12,123,2,4'),(90,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211117142923.mp4','2021-11-17 14:29:23','임시 정보',0,'12,123,2,4'),(91,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/12_20211117143655.mp4','2021-11-17 14:36:55','임시 정보',0,'123,2,4,12'),(92,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/12_20211117143759.mp4','2021-11-17 14:37:59','임시 정보',0,'123,2,4,12'),(93,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/12_20211117160123.mp4','2021-11-17 16:01:23','임시 정보',0,'123,2,4,12'),(94,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/12_20211117160131.mp4','2021-11-17 16:01:31','임시 정보',0,'123,2,4,12'),(95,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/12_20211117170103.mp4','2021-11-17 17:01:03','임시 정보',0,'123,2,4,12'),(96,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211117170735.mp4','2021-11-17 17:07:35','임시 정보',0,'12,123,2,4'),(97,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211117170745.mp4','2021-11-17 17:07:45','임시 정보',0,'12,123,2,4'),(98,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211117171046.mp4','2021-11-17 17:10:46','임시 정보',0,'12,123,2,4'),(99,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211117171052.mp4','2021-11-17 17:10:52','임시 정보',0,'12,123,2,4'),(100,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211117171155.mp4','2021-11-17 17:11:55','임시 정보',0,'12,123,2,4'),(101,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211117171729.mp4','2021-11-17 17:17:30','임시 정보',0,'12,123,2,4'),(102,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/12_20211117171839.mp4','2021-11-17 17:18:39','임시 정보',0,'123,2,4,12'),(103,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/12_20211117171935.mp4','2021-11-17 17:19:35','임시 정보',0,'123,2,4,12'),(104,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/12_20211117172038.mp4','2021-11-17 17:20:38','임시 정보',0,'123,2,4,12'),(105,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/12_20211117172250.mp4','2021-11-17 17:22:50','임시 정보',0,'123,2,4,12'),(106,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211117172359.mp4','2021-11-17 17:23:59','임시 정보',0,'12,123,2,4'),(107,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/12_20211117172502.mp4','2021-11-17 17:25:02','임시 정보',0,'123,2,4,12'),(108,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211117172746.mp4','2021-11-17 17:27:46','임시 정보',0,'12,123,2,4'),(109,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211117172809.mp4','2021-11-17 17:28:09','임시 정보',0,'12,123,2,4'),(110,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/12_20211117172814.mp4','2021-11-17 17:28:14','임시 정보',0,'123,2,4,12'),(111,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211117172839.mp4','2021-11-17 17:28:39','임시 정보',0,'12,123,2,4'),(112,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/12_20211117172901.mp4','2021-11-17 17:29:01','임시 정보',0,'123,2,4,12'),(113,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211117173100.mp4','2021-11-17 17:31:01','임시 정보',0,'12,123,2,4'),(114,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/12_20211117173112.mp4','2021-11-17 17:31:12','임시 정보',0,'123,2,4,12'),(115,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/12_20211117173138.mp4','2021-11-17 17:31:38','임시 정보',0,'123,2,4,12'),(116,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/12_20211117173242.mp4','2021-11-17 17:32:42','임시 정보',0,'123,2,4,12'),(117,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211117173546.mp4','2021-11-17 17:35:46','임시 정보',0,'12,123,2,4'),(118,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211117173808.mp4','2021-11-17 17:38:08','임시 정보',0,'12,123,2,4'),(119,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211117174225.mp4','2021-11-17 17:42:25','임시 정보',0,'12,123,2,4'),(120,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211118103218.mp4','2021-11-18 10:32:18','임시 정보',0,'12,123,2,4'),(121,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/12_20211118103252.mp4','2021-11-18 10:32:52','임시 정보',0,'123,2,4,12'),(122,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/12_20211118103319.mp4','2021-11-18 10:33:19','임시 정보',0,'123,2,4,12'),(123,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211118103637.mp4','2021-11-18 10:36:37','임시 정보',0,'12,123,2,4'),(124,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211122103238.mp4','2021-11-22 10:32:38','임시 정보',0,'12,123,2,4'),(125,'수술실 #1','임시 정보','임시 정보','임시 정보','수술','http://172.16.41.105:3000/stream/4_20211122133852.mp4','2021-11-22 13:38:52','임시 정보',0,'12,123,2,4'),(126,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211122135023.mp4','2021-11-22 13:50:23','임시 정보',0,'12,123,2,4'),(127,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/123_20211122135536.mp4','2021-11-22 13:55:36','임시 정보',0,'2,4,12,123'),(128,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/123_20211122135545.mp4','2021-11-22 13:55:45','임시 정보',0,'2,4,12,123'),(129,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/123_20211122135952.mp4','2021-11-22 13:59:52','임시 정보',0,'2,4,12,123'),(130,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/123_20211122140011.mp4','2021-11-22 14:00:11','임시 정보',0,'2,4,12,123'),(131,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/123_20211122140054.mp4','2021-11-22 14:00:54','임시 정보',0,'2,4,12,123'),(132,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/123_20211122140318.mp4','2021-11-22 14:03:18','임시 정보',0,'2,4,12,123'),(133,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/123_20211126172143.mp4','2021-11-26 17:21:44','임시 정보',0,'2,4,12,123'),(134,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211126172523.mp4','2021-11-26 17:25:23','임시 정보',0,'12,123,2,4'),(135,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/123_20211126172650.mp4','2021-11-26 17:26:50','임시 정보',0,'2,4,12,123'),(136,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/123_20211129154537.mp4','2021-11-29 15:45:37','임시 정보',0,'2,4,12,123'),(137,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/123_20211129154549.mp4','2021-11-29 15:45:49','임시 정보',0,'2,4,12,123'),(138,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211129154800.mp4','2021-11-29 15:48:00','임시 정보',0,'12,123,2,4'),(139,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211129154848.mp4','2021-11-29 15:48:48','임시 정보',0,'12,123,2,4'),(140,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211129154918.mp4','2021-11-29 15:49:18','임시 정보',0,'12,123,2,4'),(141,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/123_20211129161157.mp4','2021-11-29 16:11:57','임시 정보',0,'2,4,12,123'),(142,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/123_20211129163507.mp4','2021-11-29 16:35:07','임시 정보',0,'2,4,12,123'),(143,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/123_20211202134851.mp4','2021-12-02 13:48:51','임시 정보',0,'2,4,12,123'),(144,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/123_20211202141614.mp4','2021-12-02 14:16:14','임시 정보',0,'2,4,12,123'),(145,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211202141738.mp4','2021-12-02 14:17:38','임시 정보',0,'12,123,2,4'),(146,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211202141739.mp4','2021-12-02 14:17:39','임시 정보',0,'12,123,2,4'),(147,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211202141740.mp4','2021-12-02 14:17:40','임시 정보',0,'12,123,2,4'),(148,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211202141745.mp4','2021-12-02 14:17:45','임시 정보',0,'12,123,2,4'),(149,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211202141753.mp4','2021-12-02 14:17:53','임시 정보',0,'12,123,2,4'),(150,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211202141757.mp4','2021-12-02 14:17:57','임시 정보',0,'12,123,2,4'),(151,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211202142948.mp4','2021-12-02 14:29:48','임시 정보',0,'12,123,2,4'),(152,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211202142950.mp4','2021-12-02 14:29:50','임시 정보',0,'12,123,2,4'),(153,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211202143137.mp4','2021-12-02 14:31:38','임시 정보',0,'12,123,2,4'),(154,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/123_20211202143601.mp4','2021-12-02 14:36:01','임시 정보',0,'2,4,12,123'),(155,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211202143858.mp4','2021-12-02 14:38:58','임시 정보',0,'12,123,2,4'),(156,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/4_20211202144113.mp4','2021-12-02 14:41:13','임시 정보',0,'12,123,2,4'),(157,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/2_20211202154311.mp4','2021-12-02 15:43:11','임시 정보',0,'4,12,123,2'),(158,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/2_20211202154335.mp4','2021-12-02 15:43:35','임시 정보',0,'4,12,123,2'),(159,'수술실 #1','임시 정보','임시 정보','임시 정보','수술 완료','http://172.16.41.105:3000/stream/2_20211202154338.mp4','2021-12-02 15:43:38','임시 정보',0,'4,12,123,2'),(160,'12','2','rtsp://172.16.100.2:9096','123','','http://172.16.41.171:3000/stream/172.16.100.2_20211203103618.mp4','2021-12-03 10:36:18','2',0,NULL),(161,'12','2','rtsp://172.16.100.2:9096','123','','http://172.16.41.171:3000/stream/172.16.100.2_20211203150324.mp4','2021-12-03 15:03:25','2',0,NULL);
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
  PRIMARY KEY (`id`),
  KEY `schedule_FK` (`surgery_id`),
  CONSTRAINT `schedule_FK` FOREIGN KEY (`surgery_id`) REFERENCES `surgery` (`surgery_id`)
) ENGINE=InnoDB AUTO_INCREMENT=212 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule`
--

LOCK TABLES `schedule` WRITE;
/*!40000 ALTER TABLE `schedule` DISABLE KEYS */;
INSERT INTO `schedule` VALUES (11,'321','2021-10-26 14:33:00','2021-10-26 14:33:00','321','indigo',0,1,0,0,NULL,NULL),(14,'ㅅ','2021-10-27','2021-10-27','ㅅㄷㄴㅅ','green',1,1,0,0,NULL,NULL),(15,'123','2021-10-27 13:41:00','2021-10-27 14:43:00','312313','blue',0,1,0,0,NULL,NULL),(18,'test','2021-10-27 17:31','2021-10-27 18:32','test','deep-purple',0,2,0,0,NULL,NULL),(19,'rw','2021-10-28','2021-10-28','test','green',1,2,0,0,NULL,NULL),(22,'test','2021-10-28 13:39','2021-10-28 13:39','test','green',0,1,0,0,NULL,NULL),(24,'test','2021-10-28 20:36','2021-10-28 22:37','test','deep-purple',0,1,0,0,NULL,NULL),(26,'test','2021-10-28','2021-10-28','test','indigo',1,1,0,0,NULL,NULL),(27,'test','2021-10-29 14:36','2021-10-29 16:36','test','green',0,1,0,1,NULL,NULL),(28,'test','2021-10-29 14:36','2021-10-29 15:36','test','deep-purple',0,1,0,1,NULL,NULL),(29,'1','2021-10-29 15:31','2021-10-29 15:31','1','green',0,1,0,1,NULL,NULL),(30,'2','2021-10-29 15:31','2021-10-29 15:31','2','indigo',0,1,0,0,NULL,NULL),(88,'12','2021-11-16','2021-11-16','12','blue',1,1,0,0,'12','12'),(153,'2','2021-11-17','2021-11-17','2','blue',1,1,0,1,'2','2'),(155,'3','2021-11-17','2021-11-17','3','deep-purple',1,1,0,1,'3','3'),(156,'4','2021-11-17','2021-11-17','4','orange',1,1,0,1,'4','4'),(163,'1','2021-11-18','2021-11-18','1','deep-purple',1,1,0,1,'1','1'),(164,'2','2021-11-18 09:36','2021-11-18 11:36','2','blue',0,1,0,0,'2','2'),(165,'3','2021-11-18 11:36','2021-11-18 12:36','3','deep-purple',0,1,0,1,'3','3'),(167,'4','2021-11-18 09:37','2021-11-18 11:37','4','blue',0,1,0,0,'4','4'),(174,'1','2021-11-22 11:55','2021-11-22 14:55','1','blue',0,1,0,1,'1','1'),(175,'2','2021-11-22 10:59','2021-11-22 16:59','2','indigo',0,1,0,1,'2','2'),(178,'3','2021-11-22','2021-11-22','3','indigo',1,1,0,1,'3','3'),(179,'4','2021-11-22','2021-11-22','4','cyan',1,1,0,1,'4','4'),(180,'1','2021-11-26','2021-11-26','1','blue',1,1,0,1,'1','11'),(181,'11','2021-11-26','2021-11-26','1','blue',1,1,0,1,'1','1'),(182,'2','2021-11-26','2021-11-26','2','cyan',1,1,0,1,'2','2'),(198,'일반','2021-11-29 15:33','2021-11-29 17:33','일반','blue',0,1,0,1,'일반','일반'),(199,'일반2','2021-11-29 15:35','2021-11-29 17:35','일반2','deep-purple',0,1,0,0,'일반2','일반2'),(208,'Event #0','2021-12-02 02:00','2021-12-02 04:30','0','blue',0,2,0,1,'0','0'),(209,'Event #1','2021-12-02 12:45:00','2021-12-02 14:45:00','1','blue',0,1,0,1,'1','1'),(211,'1','2021-12-03 10:24','2021-12-03 10:24','1','blue',0,1,0,0,'1','1');
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
INSERT INTO `surgery_reserv` VALUES (156,1,'test','test','2021-10-26 00:03:00','2021-10-26 12:12:00','남자','test','21','0'),(157,1,'test','test','2021-10-26 00:00:00','2021-10-26 23:59:00','남자','test','21','0'),(158,1,'1','1','2021-10-26 00:00:00','2021-10-27 00:00:00','남자','1','1','0'),(159,3,'1','1','2021-10-26 00:00:00','2021-10-26 23:59:00','남자','1','1','0'),(160,1,'1','1','2021-10-26 00:00:00','2021-10-27 00:00:00','남자','1','1','0'),(161,1,'1','1','2021-10-26 00:00:00','2021-10-27 00:00:00','남자','1','11','0'),(162,1,'123','123','2021-10-26 00:00:00','2021-10-27 00:00:00','남자','123','123','0'),(163,1,'321','321','2021-10-26 00:00:00','2021-10-26 00:59:00','남자','321','321','0');
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
  KEY `takeout_access_FK` (`user_id`),
  KEY `takeout_access_FK_1` (`record_id`),
  CONSTRAINT `takeout_access_FK` FOREIGN KEY (`user_id`) REFERENCES `accounts` (`id`),
  CONSTRAINT `takeout_access_FK_1` FOREIGN KEY (`record_id`) REFERENCES `records` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `takeout_access`
--

LOCK TABLES `takeout_access` WRITE;
/*!40000 ALTER TABLE `takeout_access` DISABLE KEYS */;
INSERT INTO `takeout_access` VALUES (1,1,132,'permitted','ㅅㄷㄴㅅ','2021-11-24 15:03:55'),(2,1,130,'standby','3','2021-11-24 15:04:17'),(3,1,131,'standby','1','2021-11-24 15:05:53');
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

-- Dump completed on 2021-12-10  9:31:14

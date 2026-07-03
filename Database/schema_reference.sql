-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: letterboxd_db
-- ------------------------------------------------------
-- Server version	8.0.46

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
-- Table structure for table `activity_log`
--

DROP TABLE IF EXISTS `activity_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_log` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `action_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action_details` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  KEY `fk_activity_log_user` (`user_id`),
  KEY `idx_activity_log_created_at` (`created_at`),
  CONSTRAINT `fk_activity_log_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_log`
--

LOCK TABLES `activity_log` WRITE;
/*!40000 ALTER TABLE `activity_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `activity_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `actor`
--

DROP TABLE IF EXISTS `actor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `actor` (
  `actor_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `birth_date` date DEFAULT NULL,
  `bio` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`actor_id`),
  KEY `idx_actor_full_name` (`full_name`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actor`
--

LOCK TABLES `actor` WRITE;
/*!40000 ALTER TABLE `actor` DISABLE KEYS */;
INSERT INTO `actor` VALUES (1,'Leonardo DiCaprio','1974-11-11',NULL),(2,'Cillian Murphy','1976-05-25',NULL),(3,'Zendaya','1996-09-01',NULL),(4,'Tom Hanks','1956-07-09',NULL),(5,'Saoirse Ronan','1994-04-12',NULL),(6,'Ryan Gosling','1980-11-12',NULL),(7,'Emma Stone','1988-11-06',NULL),(8,'Timothée Chalamet','1995-12-27',NULL),(9,'Florence Pugh','1996-01-03',NULL),(10,'Song Kang-ho','1967-01-17',NULL);
/*!40000 ALTER TABLE `actor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collection_movie`
--

DROP TABLE IF EXISTS `collection_movie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `collection_movie` (
  `collection_id` int NOT NULL,
  `movie_id` int NOT NULL,
  PRIMARY KEY (`collection_id`,`movie_id`),
  KEY `fk_collection_movie_movie` (`movie_id`),
  CONSTRAINT `fk_collection_movie_collection` FOREIGN KEY (`collection_id`) REFERENCES `movie_collection` (`collection_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_collection_movie_movie` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`movie_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collection_movie`
--

LOCK TABLES `collection_movie` WRITE;
/*!40000 ALTER TABLE `collection_movie` DISABLE KEYS */;
/*!40000 ALTER TABLE `collection_movie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `country`
--

DROP TABLE IF EXISTS `country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `country` (
  `country_id` int NOT NULL AUTO_INCREMENT,
  `country_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`country_id`),
  UNIQUE KEY `uq_country_name` (`country_name`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `country`
--

LOCK TABLES `country` WRITE;
/*!40000 ALTER TABLE `country` DISABLE KEYS */;
INSERT INTO `country` VALUES (10,'Canada'),(3,'France'),(7,'Germany'),(6,'India'),(8,'Italy'),(4,'Japan'),(5,'South Korea'),(9,'Spain'),(2,'United Kingdom'),(1,'United States');
/*!40000 ALTER TABLE `country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `diary_entry`
--

DROP TABLE IF EXISTS `diary_entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `diary_entry` (
  `diary_entry_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `movie_id` int NOT NULL,
  `watched_date` date NOT NULL DEFAULT (curdate()),
  `is_rewatch` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`diary_entry_id`),
  KEY `fk_diary_entry_movie` (`movie_id`),
  KEY `idx_diary_entry_user_movie` (`user_id`,`movie_id`),
  CONSTRAINT `fk_diary_entry_movie` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`movie_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_diary_entry_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=138 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `diary_entry`
--

LOCK TABLES `diary_entry` WRITE;
/*!40000 ALTER TABLE `diary_entry` DISABLE KEYS */;
INSERT INTO `diary_entry` VALUES (3,6,17,'2024-08-09',0,'2026-07-03 10:24:35'),(4,6,18,'2026-04-15',0,'2026-07-03 10:24:35'),(5,6,13,'2026-03-24',0,'2026-07-03 10:24:35'),(6,16,12,'2025-06-25',0,'2026-07-03 10:24:35'),(7,14,26,'2025-04-26',0,'2026-07-03 10:24:35'),(8,4,11,'2025-05-17',0,'2026-07-03 10:24:35'),(9,13,14,'2024-09-12',0,'2026-07-03 10:24:35'),(10,9,8,'2025-06-26',0,'2026-07-03 10:24:35'),(11,4,8,'2026-05-11',0,'2026-07-03 10:24:35'),(12,15,29,'2024-11-12',0,'2026-07-03 10:24:35'),(13,4,21,'2024-12-27',0,'2026-07-03 10:24:35'),(14,9,27,'2026-02-25',0,'2026-07-03 10:24:35'),(15,18,15,'2026-03-28',0,'2026-07-03 10:24:35'),(16,19,27,'2024-11-07',0,'2026-07-03 10:24:35'),(17,13,24,'2026-06-09',0,'2026-07-03 10:24:35'),(18,5,26,'2024-08-16',0,'2026-07-03 10:24:35'),(19,15,22,'2025-11-27',0,'2026-07-03 10:24:35'),(20,14,7,'2026-01-14',0,'2026-07-03 10:24:35'),(21,10,23,'2025-02-20',0,'2026-07-03 10:24:35'),(22,17,29,'2024-12-24',0,'2026-07-03 10:24:35'),(23,12,27,'2024-12-25',0,'2026-07-03 10:24:35'),(24,10,4,'2024-08-22',0,'2026-07-03 10:24:35'),(25,18,23,'2025-07-29',0,'2026-07-03 10:24:35'),(26,19,15,'2025-09-25',0,'2026-07-03 10:24:35'),(27,13,8,'2026-03-19',0,'2026-07-03 10:24:35'),(28,2,24,'2025-02-28',0,'2026-07-03 10:24:35'),(29,19,23,'2026-05-25',0,'2026-07-03 10:24:35'),(30,16,7,'2025-04-15',0,'2026-07-03 10:24:35'),(31,10,18,'2024-07-29',0,'2026-07-03 10:24:35'),(32,6,27,'2025-11-09',0,'2026-07-03 10:24:35'),(33,18,12,'2026-04-22',0,'2026-07-03 10:24:35'),(34,2,9,'2025-04-30',0,'2026-07-03 10:24:35'),(35,14,27,'2025-11-02',0,'2026-07-03 10:24:35'),(36,7,20,'2025-01-11',0,'2026-07-03 10:24:35'),(37,12,3,'2024-12-07',0,'2026-07-03 10:24:35'),(38,2,27,'2024-09-24',0,'2026-07-03 10:24:35'),(39,3,25,'2026-01-06',0,'2026-07-03 10:24:35'),(40,19,3,'2024-10-10',0,'2026-07-03 10:24:35'),(41,5,24,'2025-11-19',0,'2026-07-03 10:24:35'),(42,3,16,'2024-09-20',0,'2026-07-03 10:24:35'),(43,12,23,'2025-12-24',0,'2026-07-03 10:24:35'),(44,13,9,'2025-01-11',0,'2026-07-03 10:24:35'),(45,8,7,'2025-05-02',0,'2026-07-03 10:24:35'),(46,8,6,'2025-11-21',0,'2026-07-03 10:24:35'),(47,17,16,'2025-08-04',0,'2026-07-03 10:24:35'),(48,15,10,'2026-04-07',0,'2026-07-03 10:24:35'),(49,9,22,'2025-11-05',0,'2026-07-03 10:24:35'),(50,6,20,'2025-01-27',0,'2026-07-03 10:24:35'),(51,14,6,'2025-03-26',0,'2026-07-03 10:24:35'),(52,11,8,'2025-11-08',0,'2026-07-03 10:24:35'),(53,19,14,'2025-12-07',0,'2026-07-03 10:24:35'),(54,12,18,'2025-07-11',0,'2026-07-03 10:24:35'),(55,18,16,'2026-03-14',0,'2026-07-03 10:24:35'),(56,16,28,'2026-01-20',0,'2026-07-03 10:24:35'),(57,7,4,'2026-06-08',0,'2026-07-03 10:24:35'),(58,3,17,'2026-02-22',0,'2026-07-03 10:24:35'),(59,12,14,'2025-01-27',0,'2026-07-03 10:24:35'),(60,11,16,'2024-10-29',0,'2026-07-03 10:24:35'),(61,18,18,'2026-03-21',0,'2026-07-03 10:24:35'),(62,18,30,'2025-12-15',0,'2026-07-03 10:24:35'),(63,2,13,'2025-06-26',0,'2026-07-03 10:24:35'),(64,17,6,'2025-01-25',0,'2026-07-03 10:24:35'),(65,16,29,'2026-06-20',0,'2026-07-03 10:24:35'),(66,14,24,'2025-09-16',0,'2026-07-03 10:24:35'),(67,17,30,'2025-04-18',0,'2026-07-03 10:24:35'),(68,14,25,'2025-10-29',0,'2026-07-03 10:24:35'),(69,18,25,'2026-04-11',0,'2026-07-03 10:24:35'),(70,9,5,'2024-10-29',0,'2026-07-03 10:24:35'),(71,19,20,'2025-05-09',0,'2026-07-03 10:24:35'),(72,18,11,'2026-01-24',0,'2026-07-03 10:24:35'),(73,11,12,'2026-01-05',0,'2026-07-03 10:24:35'),(74,4,30,'2025-08-24',0,'2026-07-03 10:24:35'),(75,8,20,'2025-01-17',0,'2026-07-03 10:24:35'),(76,13,28,'2026-01-05',0,'2026-07-03 10:24:35'),(77,4,13,'2026-03-23',0,'2026-07-03 10:24:35'),(78,17,18,'2024-12-14',0,'2026-07-03 10:24:35'),(79,11,13,'2025-11-24',0,'2026-07-03 10:24:35'),(80,3,13,'2025-02-17',0,'2026-07-03 10:24:35'),(130,4,11,'2025-12-03',1,'2026-07-03 10:24:41'),(131,17,18,'2025-07-02',1,'2026-07-03 10:24:41'),(132,6,13,'2026-10-10',1,'2026-07-03 10:24:41'),(133,9,22,'2026-05-24',1,'2026-07-03 10:24:41'),(134,6,20,'2025-08-15',1,'2026-07-03 10:24:41'),(135,15,10,'2026-10-24',1,'2026-07-03 10:24:41');
/*!40000 ALTER TABLE `diary_entry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `diary_entry_tag`
--

DROP TABLE IF EXISTS `diary_entry_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `diary_entry_tag` (
  `diary_entry_id` int NOT NULL,
  `tag_id` int NOT NULL,
  PRIMARY KEY (`diary_entry_id`,`tag_id`),
  KEY `fk_diary_entry_tag_tag` (`tag_id`),
  CONSTRAINT `fk_diary_entry_tag_entry` FOREIGN KEY (`diary_entry_id`) REFERENCES `diary_entry` (`diary_entry_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_diary_entry_tag_tag` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`tag_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `diary_entry_tag`
--

LOCK TABLES `diary_entry_tag` WRITE;
/*!40000 ALTER TABLE `diary_entry_tag` DISABLE KEYS */;
/*!40000 ALTER TABLE `diary_entry_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `director`
--

DROP TABLE IF EXISTS `director`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `director` (
  `director_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `birth_date` date DEFAULT NULL,
  `bio` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`director_id`),
  KEY `idx_director_full_name` (`full_name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `director`
--

LOCK TABLES `director` WRITE;
/*!40000 ALTER TABLE `director` DISABLE KEYS */;
INSERT INTO `director` VALUES (1,'Christopher Nolan','1970-07-30',NULL),(2,'Bong Joon-ho','1969-09-14',NULL),(3,'Greta Gerwig','1983-08-04',NULL),(4,'Denis Villeneuve','1967-10-03',NULL),(5,'Quentin Tarantino','1963-03-27',NULL),(6,'Hayao Miyazaki','1941-01-05',NULL),(7,'Wes Anderson','1969-05-01',NULL);
/*!40000 ALTER TABLE `director` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorite_genre`
--

DROP TABLE IF EXISTS `favorite_genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favorite_genre` (
  `user_id` int NOT NULL,
  `genre_id` int NOT NULL,
  PRIMARY KEY (`user_id`,`genre_id`),
  KEY `fk_favorite_genre_genre` (`genre_id`),
  CONSTRAINT `fk_favorite_genre_genre` FOREIGN KEY (`genre_id`) REFERENCES `genre` (`genre_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_favorite_genre_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorite_genre`
--

LOCK TABLES `favorite_genre` WRITE;
/*!40000 ALTER TABLE `favorite_genre` DISABLE KEYS */;
INSERT INTO `favorite_genre` VALUES (4,1),(4,2),(16,3),(14,4),(3,5),(7,6),(2,7),(6,7),(7,7),(14,7),(16,8),(3,10),(6,11),(2,12),(9,12),(9,13);
/*!40000 ALTER TABLE `favorite_genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `followers`
--

DROP TABLE IF EXISTS `followers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `followers` (
  `follower_id` int NOT NULL,
  `followed_id` int NOT NULL,
  `followed_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`follower_id`,`followed_id`),
  KEY `fk_followers_followed` (`followed_id`),
  CONSTRAINT `fk_followers_followed` FOREIGN KEY (`followed_id`) REFERENCES `user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_followers_follower` FOREIGN KEY (`follower_id`) REFERENCES `user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_followers_no_self_follow` CHECK ((`follower_id` <> `followed_id`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `followers`
--

LOCK TABLES `followers` WRITE;
/*!40000 ALTER TABLE `followers` DISABLE KEYS */;
INSERT INTO `followers` VALUES (2,3,'2026-07-03 10:31:19'),(2,6,'2026-07-03 10:31:19'),(2,9,'2026-07-03 10:31:19'),(3,2,'2026-07-03 10:31:19'),(4,2,'2026-07-03 10:31:19'),(5,2,'2026-07-03 10:31:19'),(6,2,'2026-07-03 10:31:19'),(6,4,'2026-07-03 10:31:19'),(7,2,'2026-07-03 10:31:19'),(7,6,'2026-07-03 10:31:19'),(8,2,'2026-07-03 10:31:19'),(8,5,'2026-07-03 10:31:19'),(9,2,'2026-07-03 10:31:19'),(9,6,'2026-07-03 10:31:19'),(10,2,'2026-07-03 10:31:19'),(13,7,'2026-07-03 10:31:19'),(14,6,'2026-07-03 10:31:19'),(14,11,'2026-07-03 10:31:19'),(15,6,'2026-07-03 10:31:19'),(15,12,'2026-07-03 10:31:19'),(16,6,'2026-07-03 10:31:19'),(16,9,'2026-07-03 10:31:19'),(17,9,'2026-07-03 10:31:19'),(17,13,'2026-07-03 10:31:19'),(18,8,'2026-07-03 10:31:19'),(18,14,'2026-07-03 10:31:19'),(19,10,'2026-07-03 10:31:19'),(19,16,'2026-07-03 10:31:19');
/*!40000 ALTER TABLE `followers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genre`
--

DROP TABLE IF EXISTS `genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genre` (
  `genre_id` int NOT NULL AUTO_INCREMENT,
  `genre_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`genre_id`),
  UNIQUE KEY `uq_genre_name` (`genre_name`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genre`
--

LOCK TABLES `genre` WRITE;
/*!40000 ALTER TABLE `genre` DISABLE KEYS */;
INSERT INTO `genre` VALUES (1,'Action'),(2,'Adventure'),(3,'Animation'),(4,'Comedy'),(5,'Crime'),(6,'Documentary'),(7,'Drama'),(8,'Fantasy'),(9,'Horror'),(10,'Mystery'),(11,'Romance'),(12,'Science Fiction'),(13,'Thriller'),(14,'War'),(15,'Western');
/*!40000 ALTER TABLE `genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `language`
--

DROP TABLE IF EXISTS `language`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `language` (
  `language_id` int NOT NULL AUTO_INCREMENT,
  `language_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`language_id`),
  UNIQUE KEY `uq_language_name` (`language_name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `language`
--

LOCK TABLES `language` WRITE;
/*!40000 ALTER TABLE `language` DISABLE KEYS */;
INSERT INTO `language` VALUES (1,'English'),(2,'French'),(6,'German'),(5,'Hindi'),(7,'Italian'),(3,'Japanese'),(4,'Korean'),(8,'Spanish');
/*!40000 ALTER TABLE `language` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `list_movie`
--

DROP TABLE IF EXISTS `list_movie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `list_movie` (
  `list_id` int NOT NULL,
  `movie_id` int NOT NULL,
  `position` smallint unsigned DEFAULT NULL,
  `added_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`list_id`,`movie_id`),
  KEY `fk_list_movie_movie` (`movie_id`),
  CONSTRAINT `fk_list_movie_list` FOREIGN KEY (`list_id`) REFERENCES `movie_list` (`list_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_list_movie_movie` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`movie_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `list_movie`
--

LOCK TABLES `list_movie` WRITE;
/*!40000 ALTER TABLE `list_movie` DISABLE KEYS */;
INSERT INTO `list_movie` VALUES (1,3,4,'2026-07-03 10:26:15'),(1,7,1,'2026-07-03 10:26:15'),(1,8,2,'2026-07-03 10:26:15'),(1,18,3,'2026-07-03 10:26:15'),(2,12,1,'2026-07-03 10:26:15'),(2,14,2,'2026-07-03 10:26:15'),(3,19,1,'2026-07-03 10:26:15'),(3,25,3,'2026-07-03 10:26:15'),(3,26,2,'2026-07-03 10:26:15'),(4,7,2,'2026-07-03 10:26:15'),(4,18,1,'2026-07-03 10:26:15'),(5,5,1,'2026-07-03 10:26:15'),(5,24,3,'2026-07-03 10:26:15'),(5,25,2,'2026-07-03 10:26:15');
/*!40000 ALTER TABLE `list_movie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movie`
--

DROP TABLE IF EXISTS `movie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movie` (
  `movie_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `release_year` smallint unsigned NOT NULL,
  `runtime_minutes` smallint unsigned DEFAULT NULL,
  `synopsis` text COLLATE utf8mb4_unicode_ci,
  `poster_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country_id` int NOT NULL,
  `language_id` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`movie_id`),
  KEY `fk_movie_country` (`country_id`),
  KEY `fk_movie_language` (`language_id`),
  KEY `idx_movie_title` (`title`),
  KEY `idx_movie_release_year` (`release_year`),
  CONSTRAINT `fk_movie_country` FOREIGN KEY (`country_id`) REFERENCES `country` (`country_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_movie_language` FOREIGN KEY (`language_id`) REFERENCES `language` (`language_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_movie_release_year` CHECK ((`release_year` >= 1888)),
  CONSTRAINT `chk_movie_runtime` CHECK (((`runtime_minutes` is null) or (`runtime_minutes` > 0)))
) ENGINE=InnoDB AUTO_INCREMENT=8229 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movie`
--

LOCK TABLES `movie` WRITE;
/*!40000 ALTER TABLE `movie` DISABLE KEYS */;
INSERT INTO `movie` VALUES (3,'Oppenheimer',2023,180,NULL,NULL,1,1,'2026-07-03 10:13:34'),(4,'Barbie',2023,114,NULL,NULL,1,1,'2026-07-03 10:13:34'),(5,'Parasite',2019,132,NULL,NULL,5,4,'2026-07-03 10:13:34'),(6,'La La Land',2016,128,NULL,NULL,1,1,'2026-07-03 10:13:34'),(7,'Dune',2021,155,NULL,NULL,1,1,'2026-07-03 10:13:34'),(8,'Dune: Part Two',2024,166,NULL,NULL,1,1,'2026-07-03 10:13:34'),(9,'Once Upon a Time in Hollywood',2019,161,NULL,NULL,1,1,'2026-07-03 10:13:34'),(10,'Spirited Away',2001,125,NULL,NULL,4,3,'2026-07-03 10:13:34'),(11,'The Grand Budapest Hotel',2014,99,NULL,NULL,7,1,'2026-07-03 10:13:34'),(12,'Midsommar',2019,148,NULL,NULL,1,1,'2026-07-03 10:13:34'),(13,'Little Women',2019,135,NULL,NULL,1,1,'2026-07-03 10:13:34'),(14,'Lady Bird',2017,94,NULL,NULL,1,1,'2026-07-03 10:13:34'),(15,'Inception',2010,148,NULL,NULL,1,1,'2026-07-03 10:13:34'),(16,'Interstellar',2014,169,NULL,NULL,1,1,'2026-07-03 10:13:34'),(17,'The Dark Knight',2008,152,NULL,NULL,1,1,'2026-07-03 10:13:34'),(18,'Blade Runner 2049',2017,164,NULL,NULL,1,1,'2026-07-03 10:13:34'),(19,'Arrival',2016,116,NULL,NULL,1,1,'2026-07-03 10:13:34'),(20,'Pulp Fiction',1994,154,NULL,NULL,1,1,'2026-07-03 10:13:34'),(21,'Killers of the Flower Moon',2023,206,NULL,NULL,1,1,'2026-07-03 10:13:34'),(22,'The Wolf of Wall Street',2013,180,NULL,NULL,1,1,'2026-07-03 10:13:34'),(23,'Poor Things',2023,141,NULL,NULL,2,1,'2026-07-03 10:13:34'),(24,'Amélie',2001,122,NULL,NULL,3,2,'2026-07-03 10:13:34'),(25,'Portrait of a Lady on Fire',2019,122,NULL,NULL,3,2,'2026-07-03 10:13:34'),(26,'Memories of Murder',2003,131,NULL,NULL,5,4,'2026-07-03 10:13:34'),(27,'My Neighbor Totoro',1988,86,NULL,NULL,4,3,'2026-07-03 10:13:34'),(28,'Princess Mononoke',1997,134,NULL,NULL,4,3,'2026-07-03 10:13:34'),(29,'The French Dispatch',2021,108,NULL,NULL,1,1,'2026-07-03 10:13:34'),(30,'Moonrise Kingdom',2012,94,NULL,NULL,1,1,'2026-07-03 10:13:34');
/*!40000 ALTER TABLE `movie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movie_cast`
--

DROP TABLE IF EXISTS `movie_cast`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movie_cast` (
  `movie_id` int NOT NULL,
  `actor_id` int NOT NULL,
  `character_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `billing_order` smallint unsigned DEFAULT NULL,
  PRIMARY KEY (`movie_id`,`actor_id`,`character_name`),
  KEY `fk_movie_cast_actor` (`actor_id`),
  CONSTRAINT `fk_movie_cast_actor` FOREIGN KEY (`actor_id`) REFERENCES `actor` (`actor_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_movie_cast_movie` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`movie_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movie_cast`
--

LOCK TABLES `movie_cast` WRITE;
/*!40000 ALTER TABLE `movie_cast` DISABLE KEYS */;
INSERT INTO `movie_cast` VALUES (3,2,'J. Robert Oppenheimer',1),(5,10,'Kim Ki-taek',1),(6,6,'Sebastian Wilder',1),(6,7,'Mia Dolan',2),(7,3,'Chani',2),(7,8,'Paul Atreides',1),(8,3,'Chani',2),(8,8,'Paul Atreides',1),(9,1,'Rick Dalton',1),(12,9,'Dani Ardor',1),(13,5,'Jo March',1),(13,8,'Laurie',2),(13,9,'Amy March',3),(14,5,'Christine \"Lady Bird\" McPherson',1),(15,1,'Dom Cobb',1),(21,1,'Ernest Burkhart',1),(22,1,'Jordan Belfort',1),(23,7,'Bella Baxter',1),(26,10,'Detective Park Doo-man',1);
/*!40000 ALTER TABLE `movie_cast` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movie_collection`
--

DROP TABLE IF EXISTS `movie_collection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movie_collection` (
  `collection_id` int NOT NULL AUTO_INCREMENT,
  `collection_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`collection_id`),
  UNIQUE KEY `uq_movie_collection_name` (`collection_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movie_collection`
--

LOCK TABLES `movie_collection` WRITE;
/*!40000 ALTER TABLE `movie_collection` DISABLE KEYS */;
/*!40000 ALTER TABLE `movie_collection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movie_crew`
--

DROP TABLE IF EXISTS `movie_crew`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movie_crew` (
  `movie_id` int NOT NULL,
  `director_id` int NOT NULL,
  `job_title` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`movie_id`,`director_id`,`job_title`),
  KEY `fk_movie_crew_director` (`director_id`),
  CONSTRAINT `fk_movie_crew_director` FOREIGN KEY (`director_id`) REFERENCES `director` (`director_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_movie_crew_movie` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`movie_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movie_crew`
--

LOCK TABLES `movie_crew` WRITE;
/*!40000 ALTER TABLE `movie_crew` DISABLE KEYS */;
INSERT INTO `movie_crew` VALUES (3,1,'Director'),(15,1,'Director'),(16,1,'Director'),(17,1,'Director'),(5,2,'Director'),(26,2,'Director'),(4,3,'Director'),(13,3,'Director'),(14,3,'Director'),(7,4,'Director'),(8,4,'Director'),(18,4,'Director'),(19,4,'Director'),(9,5,'Director'),(20,5,'Director'),(10,6,'Director'),(27,6,'Director'),(28,6,'Director'),(11,7,'Director'),(29,7,'Director'),(30,7,'Director');
/*!40000 ALTER TABLE `movie_crew` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movie_genre`
--

DROP TABLE IF EXISTS `movie_genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movie_genre` (
  `movie_id` int NOT NULL,
  `genre_id` int NOT NULL,
  PRIMARY KEY (`movie_id`,`genre_id`),
  KEY `fk_movie_genre_genre` (`genre_id`),
  CONSTRAINT `fk_movie_genre_genre` FOREIGN KEY (`genre_id`) REFERENCES `genre` (`genre_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_movie_genre_movie` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`movie_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movie_genre`
--

LOCK TABLES `movie_genre` WRITE;
/*!40000 ALTER TABLE `movie_genre` DISABLE KEYS */;
INSERT INTO `movie_genre` VALUES (15,1),(17,1),(7,2),(8,2),(10,2),(16,2),(28,2),(10,3),(27,3),(28,3),(4,4),(5,4),(9,4),(11,4),(14,4),(22,4),(23,4),(24,4),(29,4),(30,4),(17,5),(20,5),(21,5),(22,5),(26,5),(3,7),(5,7),(6,7),(9,7),(11,7),(13,7),(14,7),(16,7),(19,7),(20,7),(21,7),(22,7),(25,7),(26,7),(29,7),(4,8),(10,8),(23,8),(27,8),(28,8),(12,9),(12,10),(19,10),(26,10),(6,11),(13,11),(24,11),(25,11),(30,11),(7,12),(8,12),(15,12),(16,12),(18,12),(19,12),(23,12),(3,13),(5,13),(15,13),(17,13),(18,13),(3,14),(21,15);
/*!40000 ALTER TABLE `movie_genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movie_list`
--

DROP TABLE IF EXISTS `movie_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movie_list` (
  `list_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `list_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `visibility` enum('public','private') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'public',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`list_id`),
  UNIQUE KEY `uq_movie_list_user_name` (`user_id`,`list_name`),
  CONSTRAINT `fk_movie_list_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movie_list`
--

LOCK TABLES `movie_list` WRITE;
/*!40000 ALTER TABLE `movie_list` DISABLE KEYS */;
INSERT INTO `movie_list` VALUES (1,2,'Best Cinematography of the 2020s','Films where every frame is a painting.','public','2026-07-03 10:26:06'),(2,6,'A24 Essentials','My personal ranking of the studio\'s best output.','public','2026-07-03 10:26:06'),(3,7,'Slow Burns Worth the Patience',NULL,'public','2026-07-03 10:26:06'),(4,9,'Deakins-Tier Visuals','Cinematography nerd picks.','private','2026-07-03 10:26:06'),(5,14,'Festival Favorites',NULL,'public','2026-07-03 10:26:06');
/*!40000 ALTER TABLE `movie_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movie_studio`
--

DROP TABLE IF EXISTS `movie_studio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movie_studio` (
  `movie_id` int NOT NULL,
  `studio_id` int NOT NULL,
  PRIMARY KEY (`movie_id`,`studio_id`),
  KEY `fk_movie_studio_studio` (`studio_id`),
  CONSTRAINT `fk_movie_studio_movie` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`movie_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_movie_studio_studio` FOREIGN KEY (`studio_id`) REFERENCES `studio` (`studio_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movie_studio`
--

LOCK TABLES `movie_studio` WRITE;
/*!40000 ALTER TABLE `movie_studio` DISABLE KEYS */;
INSERT INTO `movie_studio` VALUES (4,1),(7,1),(8,1),(17,1),(10,2),(27,2),(28,2),(12,3),(14,3),(5,4),(25,4);
/*!40000 ALTER TABLE `movie_studio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification` (
  `notification_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `notification_type` enum('new_follower','new_comment','new_like','watchlist_alert','system') COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`notification_id`),
  KEY `idx_notification_user_read` (`user_id`,`is_read`),
  CONSTRAINT `fk_notification_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification`
--

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rating`
--

DROP TABLE IF EXISTS `rating`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rating` (
  `rating_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `movie_id` int NOT NULL,
  `rating_value` decimal(2,1) NOT NULL,
  `rated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`rating_id`),
  UNIQUE KEY `uq_rating_user_movie` (`user_id`,`movie_id`),
  KEY `fk_rating_movie` (`movie_id`),
  CONSTRAINT `fk_rating_movie` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`movie_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_rating_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_rating_half_step` CHECK (((`rating_value` * 2) = floor((`rating_value` * 2)))),
  CONSTRAINT `chk_rating_range` CHECK ((`rating_value` between 0.5 and 5.0))
) ENGINE=InnoDB AUTO_INCREMENT=134 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rating`
--

LOCK TABLES `rating` WRITE;
/*!40000 ALTER TABLE `rating` DISABLE KEYS */;
INSERT INTO `rating` VALUES (1,8,11,1.0,'2026-07-03 10:25:42'),(2,6,11,0.5,'2026-07-03 10:25:42'),(3,16,28,1.0,'2026-07-03 10:25:42'),(4,14,7,5.0,'2026-07-03 10:25:42'),(5,4,18,5.0,'2026-07-03 10:25:42'),(6,15,11,2.5,'2026-07-03 10:25:42'),(7,2,18,5.0,'2026-07-03 10:25:42'),(8,6,19,4.0,'2026-07-03 10:25:42'),(9,9,18,5.0,'2026-07-03 10:25:42'),(10,6,26,2.5,'2026-07-03 10:25:42'),(11,10,28,3.0,'2026-07-03 10:25:42'),(12,13,30,0.5,'2026-07-03 10:25:42'),(13,5,9,4.5,'2026-07-03 10:25:42'),(14,12,14,3.0,'2026-07-03 10:25:42'),(15,5,26,4.0,'2026-07-03 10:25:42'),(16,4,24,2.5,'2026-07-03 10:25:42'),(17,17,25,0.5,'2026-07-03 10:25:42'),(18,4,11,3.5,'2026-07-03 10:25:42'),(19,19,29,4.0,'2026-07-03 10:25:42'),(20,3,7,5.0,'2026-07-03 10:25:42'),(21,8,24,5.0,'2026-07-03 10:25:42'),(22,15,27,4.0,'2026-07-03 10:25:42'),(23,4,12,1.5,'2026-07-03 10:25:42'),(24,14,25,3.0,'2026-07-03 10:25:42'),(25,15,17,2.5,'2026-07-03 10:25:42'),(26,18,13,2.0,'2026-07-03 10:25:42'),(27,10,17,0.5,'2026-07-03 10:25:42'),(28,5,22,0.5,'2026-07-03 10:25:42'),(29,6,5,3.0,'2026-07-03 10:25:42'),(30,17,13,3.0,'2026-07-03 10:25:42'),(31,7,25,2.5,'2026-07-03 10:25:42'),(32,16,30,4.5,'2026-07-03 10:25:42'),(33,5,29,3.5,'2026-07-03 10:25:42'),(34,18,25,1.5,'2026-07-03 10:25:42'),(35,17,22,1.5,'2026-07-03 10:25:42'),(36,11,24,1.5,'2026-07-03 10:25:42'),(37,17,18,0.5,'2026-07-03 10:25:42'),(38,12,6,0.5,'2026-07-03 10:25:42'),(39,5,5,5.0,'2026-07-03 10:25:42'),(40,9,9,5.0,'2026-07-03 10:25:42'),(41,9,29,2.0,'2026-07-03 10:25:42'),(42,9,22,3.5,'2026-07-03 10:25:42'),(43,14,5,4.5,'2026-07-03 10:25:42'),(44,11,21,1.0,'2026-07-03 10:25:42'),(45,5,15,5.0,'2026-07-03 10:25:42'),(46,16,5,4.5,'2026-07-03 10:25:42'),(47,8,26,3.0,'2026-07-03 10:25:42'),(48,18,15,3.0,'2026-07-03 10:25:42'),(49,16,12,2.0,'2026-07-03 10:25:42'),(50,6,25,4.5,'2026-07-03 10:25:42'),(51,15,15,4.0,'2026-07-03 10:25:42'),(52,14,9,3.5,'2026-07-03 10:25:42'),(53,4,27,4.5,'2026-07-03 10:25:42'),(54,9,20,1.0,'2026-07-03 10:25:42'),(55,18,30,2.5,'2026-07-03 10:25:42'),(56,5,16,2.5,'2026-07-03 10:25:42'),(57,2,16,5.0,'2026-07-03 10:25:42'),(58,12,22,4.0,'2026-07-03 10:25:42'),(59,2,26,4.0,'2026-07-03 10:25:42'),(60,10,16,3.0,'2026-07-03 10:25:42'),(61,12,10,4.0,'2026-07-03 10:25:42'),(62,6,7,2.5,'2026-07-03 10:25:42'),(63,10,18,3.0,'2026-07-03 10:25:42'),(64,13,21,2.5,'2026-07-03 10:25:42'),(65,5,4,3.0,'2026-07-03 10:25:42'),(66,16,13,3.5,'2026-07-03 10:25:42'),(67,11,16,5.0,'2026-07-03 10:25:42'),(68,12,12,4.5,'2026-07-03 10:25:42'),(69,6,17,1.5,'2026-07-03 10:25:42'),(70,6,13,2.5,'2026-07-03 10:25:42'),(71,17,11,2.5,'2026-07-03 10:25:42'),(72,9,17,2.5,'2026-07-03 10:25:42'),(73,14,27,2.5,'2026-07-03 10:25:42'),(74,5,18,3.5,'2026-07-03 10:25:42'),(75,5,30,3.5,'2026-07-03 10:25:42'),(76,15,16,3.0,'2026-07-03 10:25:42'),(77,17,10,0.5,'2026-07-03 10:25:42'),(78,7,23,0.5,'2026-07-03 10:25:42'),(79,8,8,3.5,'2026-07-03 10:25:42'),(80,19,3,1.0,'2026-07-03 10:25:42'),(81,3,30,1.5,'2026-07-03 10:25:42'),(82,8,12,1.0,'2026-07-03 10:25:42');
/*!40000 ALTER TABLE `rating` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `report`
--

DROP TABLE IF EXISTS `report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `report` (
  `report_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `reported_review_id` int DEFAULT NULL,
  `reported_comment_id` int DEFAULT NULL,
  `reason` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('pending','reviewed','dismissed','action_taken') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`report_id`),
  KEY `fk_report_user` (`user_id`),
  KEY `fk_report_review` (`reported_review_id`),
  KEY `fk_report_comment` (`reported_comment_id`),
  CONSTRAINT `fk_report_comment` FOREIGN KEY (`reported_comment_id`) REFERENCES `review_comment` (`comment_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_report_review` FOREIGN KEY (`reported_review_id`) REFERENCES `review` (`review_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_report_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report`
--

LOCK TABLES `report` WRITE;
/*!40000 ALTER TABLE `report` DISABLE KEYS */;
/*!40000 ALTER TABLE `report` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_report_one_target` BEFORE INSERT ON `report` FOR EACH ROW BEGIN
    IF NOT (
        (NEW.reported_review_id IS NOT NULL AND NEW.reported_comment_id IS NULL)
        OR
        (NEW.reported_review_id IS NULL AND NEW.reported_comment_id IS NOT NULL)
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Report must target exactly one: review OR comment';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_report_one_target_update` BEFORE UPDATE ON `report` FOR EACH ROW BEGIN
    IF NOT (
        (NEW.reported_review_id IS NOT NULL AND NEW.reported_comment_id IS NULL)
        OR
        (NEW.reported_review_id IS NULL AND NEW.reported_comment_id IS NOT NULL)
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Report must target exactly one: review OR comment';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review` (
  `review_id` int NOT NULL AUTO_INCREMENT,
  `diary_entry_id` int NOT NULL,
  `review_text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `contains_spoilers` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`review_id`),
  UNIQUE KEY `uq_review_diary_entry` (`diary_entry_id`),
  CONSTRAINT `fk_review_diary_entry` FOREIGN KEY (`diary_entry_id`) REFERENCES `diary_entry` (`diary_entry_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review`
--

LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
INSERT INTO `review` VALUES (2,46,'The visuals carried it more than the story did honestly.',1,'2026-07-03 10:25:51','2026-07-03 11:51:05'),(3,41,'A masterclass in editing and sound design, incredible craft.',0,'2026-07-03 10:25:51','2026-07-03 10:25:51'),(4,76,'Rewatched this and it hit even harder the second time.',1,'2026-07-03 10:25:51','2026-07-03 10:25:51'),(5,37,'Solid but a bit overhyped, the pacing dragged in the middle act.',0,'2026-07-03 10:25:51','2026-07-03 10:25:51'),(6,69,'Rewatched this and it hit even harder the second time.',1,'2026-07-03 10:25:51','2026-07-03 10:25:51'),(7,71,'Genuinely stunning from start to finish, one of the best I have seen this year.',0,'2026-07-03 10:25:51','2026-07-03 10:25:51'),(8,24,'Rewatched this and it hit even harder the second time.',1,'2026-07-03 10:25:51','2026-07-03 10:25:51'),(9,62,'Rewatched this and it hit even harder the second time.',0,'2026-07-03 10:25:51','2026-07-03 10:25:51'),(10,39,'Genuinely stunning from start to finish, one of the best I have seen this year.',0,'2026-07-03 10:25:51','2026-07-03 10:25:51'),(11,23,'The visuals carried it more than the story did honestly.',0,'2026-07-03 10:25:51','2026-07-03 10:25:51'),(12,34,'Not for me, but I can see why others love it.',0,'2026-07-03 10:25:51','2026-07-03 10:25:51'),(13,38,'Solid but a bit overhyped, the pacing dragged in the middle act.',0,'2026-07-03 10:25:51','2026-07-03 10:25:51'),(14,72,'The visuals carried it more than the story did honestly.',0,'2026-07-03 10:25:51','2026-07-03 10:25:51'),(15,132,'Not for me, but I can see why others love it.',0,'2026-07-03 10:25:51','2026-07-03 10:25:51'),(16,131,'Solid but a bit overhyped, the pacing dragged in the middle act.',0,'2026-07-03 10:25:51','2026-07-03 10:25:51'),(17,7,'Solid but a bit overhyped, the pacing dragged in the middle act.',1,'2026-07-03 10:25:51','2026-07-03 10:25:51'),(18,12,'Rewatched this and it hit even harder the second time.',0,'2026-07-03 10:25:51','2026-07-03 10:25:51'),(19,19,'Solid but a bit overhyped, the pacing dragged in the middle act.',0,'2026-07-03 10:25:51','2026-07-03 10:25:51');
/*!40000 ALTER TABLE `review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_comment`
--

DROP TABLE IF EXISTS `review_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review_comment` (
  `comment_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `review_id` int NOT NULL,
  `comment_text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`comment_id`),
  KEY `fk_review_comment_user` (`user_id`),
  KEY `fk_review_comment_review` (`review_id`),
  CONSTRAINT `fk_review_comment_review` FOREIGN KEY (`review_id`) REFERENCES `review` (`review_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_review_comment_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_comment`
--

LOCK TABLES `review_comment` WRITE;
/*!40000 ALTER TABLE `review_comment` DISABLE KEYS */;
INSERT INTO `review_comment` VALUES (2,11,4,'Interesting take, I saw it differently though.','2026-07-03 10:31:32'),(3,7,14,'Completely agree with this take.','2026-07-03 10:31:32'),(4,12,12,'Well written, thanks for the spoiler warning.','2026-07-03 10:31:32'),(5,6,12,'Completely agree with this take.','2026-07-03 10:31:32'),(6,14,4,'Well written, thanks for the spoiler warning.','2026-07-03 10:31:32'),(7,11,15,'Interesting take, I saw it differently though.','2026-07-03 10:31:32'),(8,12,13,'Well written, thanks for the spoiler warning.','2026-07-03 10:31:32'),(9,10,3,'This convinced me to finally watch it.','2026-07-03 10:31:32'),(10,9,19,'Interesting take, I saw it differently though.','2026-07-03 10:31:32'),(11,19,4,'Interesting take, I saw it differently though.','2026-07-03 10:31:32'),(12,14,3,'This convinced me to finally watch it.','2026-07-03 10:31:32'),(13,6,6,'Rewatching this weekend because of your review.','2026-07-03 10:31:32'),(14,19,16,'Interesting take, I saw it differently though.','2026-07-03 10:31:32'),(15,8,7,'This convinced me to finally watch it.','2026-07-03 10:31:32'),(16,5,18,'Interesting take, I saw it differently though.','2026-07-03 10:31:32'),(17,18,8,'Rewatching this weekend because of your review.','2026-07-03 10:31:32'),(18,5,13,'Completely agree with this take.','2026-07-03 10:31:32'),(19,3,8,'Completely agree with this take.','2026-07-03 10:31:32'),(20,13,5,'Rewatching this weekend because of your review.','2026-07-03 10:31:32'),(21,7,16,'Well written, thanks for the spoiler warning.','2026-07-03 10:31:32'),(22,7,15,'Completely agree with this take.','2026-07-03 10:31:32'),(23,19,6,'This convinced me to finally watch it.','2026-07-03 10:31:32'),(33,15,15,'Completely agree with this take.','2026-07-03 10:31:32'),(34,10,6,'Rewatching this weekend because of your review.','2026-07-03 10:31:32'),(35,9,14,'Completely agree with this take.','2026-07-03 10:31:32'),(36,3,4,'Rewatching this weekend because of your review.','2026-07-03 10:31:32'),(37,18,15,'Completely agree with this take.','2026-07-03 10:31:32'),(38,13,10,'Well written, thanks for the spoiler warning.','2026-07-03 10:31:32'),(39,11,12,'Completely agree with this take.','2026-07-03 10:31:32'),(40,6,19,'This convinced me to finally watch it.','2026-07-03 10:31:32'),(41,16,18,'Completely agree with this take.','2026-07-03 10:31:32'),(42,9,11,'Well written, thanks for the spoiler warning.','2026-07-03 10:31:32'),(43,8,2,'Interesting take, I saw it differently though.','2026-07-03 10:31:32'),(44,8,14,'Rewatching this weekend because of your review.','2026-07-03 10:31:32'),(45,2,7,'Rewatching this weekend because of your review.','2026-07-03 10:31:32'),(46,11,17,'This convinced me to finally watch it.','2026-07-03 10:31:32'),(47,2,6,'Well written, thanks for the spoiler warning.','2026-07-03 10:31:32'),(48,11,2,'Well written, thanks for the spoiler warning.','2026-07-03 10:31:32'),(49,16,17,'Rewatching this weekend because of your review.','2026-07-03 10:31:32'),(50,17,15,'Interesting take, I saw it differently though.','2026-07-03 10:31:32'),(51,17,2,'Rewatching this weekend because of your review.','2026-07-03 10:31:32'),(52,7,6,'Rewatching this weekend because of your review.','2026-07-03 10:31:32'),(53,16,11,'Well written, thanks for the spoiler warning.','2026-07-03 10:31:32'),(54,3,14,'Interesting take, I saw it differently though.','2026-07-03 10:31:32');
/*!40000 ALTER TABLE `review_comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_like`
--

DROP TABLE IF EXISTS `review_like`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review_like` (
  `user_id` int NOT NULL,
  `review_id` int NOT NULL,
  `liked_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`review_id`),
  KEY `fk_review_like_review` (`review_id`),
  CONSTRAINT `fk_review_like_review` FOREIGN KEY (`review_id`) REFERENCES `review` (`review_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_review_like_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_like`
--

LOCK TABLES `review_like` WRITE;
/*!40000 ALTER TABLE `review_like` DISABLE KEYS */;
INSERT INTO `review_like` VALUES (2,17,'2026-07-03 10:31:26'),(3,2,'2026-07-03 10:31:26'),(3,3,'2026-07-03 10:31:26'),(4,17,'2026-07-03 10:31:26'),(5,12,'2026-07-03 10:31:26'),(5,17,'2026-07-03 10:31:26'),(6,2,'2026-07-03 10:31:26'),(6,7,'2026-07-03 10:31:26'),(6,8,'2026-07-03 10:31:26'),(6,9,'2026-07-03 10:31:26'),(6,18,'2026-07-03 10:31:26'),(7,8,'2026-07-03 10:31:26'),(7,16,'2026-07-03 10:31:26'),(7,18,'2026-07-03 10:31:26'),(8,2,'2026-07-03 10:31:26'),(8,5,'2026-07-03 10:31:26'),(8,7,'2026-07-03 10:31:26'),(8,10,'2026-07-03 10:31:26'),(8,13,'2026-07-03 10:31:26'),(8,19,'2026-07-03 10:31:26'),(9,7,'2026-07-03 10:31:26'),(9,9,'2026-07-03 10:31:26'),(11,7,'2026-07-03 10:31:26'),(12,6,'2026-07-03 10:31:26'),(12,17,'2026-07-03 10:31:26'),(13,4,'2026-07-03 10:31:26'),(13,8,'2026-07-03 10:31:26'),(13,15,'2026-07-03 10:31:26'),(14,11,'2026-07-03 10:31:26'),(14,15,'2026-07-03 10:31:26'),(15,11,'2026-07-03 10:31:26'),(15,14,'2026-07-03 10:31:26'),(16,7,'2026-07-03 10:31:26'),(16,19,'2026-07-03 10:31:26'),(17,14,'2026-07-03 10:31:26'),(18,4,'2026-07-03 10:31:26'),(18,12,'2026-07-03 10:31:26'),(18,18,'2026-07-03 10:31:26'),(19,9,'2026-07-03 10:31:26'),(19,11,'2026-07-03 10:31:26');
/*!40000 ALTER TABLE `review_like` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_prevent_self_review_like` BEFORE INSERT ON `review_like` FOR EACH ROW BEGIN
    DECLARE v_author_id INT;

    SELECT de.user_id INTO v_author_id
    FROM review rv
    JOIN diary_entry de ON de.diary_entry_id = rv.diary_entry_id
    WHERE rv.review_id = NEW.review_id;

    IF NEW.user_id = v_author_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Users cannot like their own review';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_prevent_self_review_like_update` BEFORE UPDATE ON `review_like` FOR EACH ROW BEGIN
    DECLARE v_author_id INT;

    SELECT de.user_id INTO v_author_id
    FROM review rv
    JOIN diary_entry de ON de.diary_entry_id = rv.diary_entry_id
    WHERE rv.review_id = NEW.review_id;

    IF NEW.user_id = v_author_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Users cannot like their own review';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `studio`
--

DROP TABLE IF EXISTS `studio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `studio` (
  `studio_id` int NOT NULL AUTO_INCREMENT,
  `studio_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `founded_year` smallint DEFAULT NULL,
  `country_id` int DEFAULT NULL,
  PRIMARY KEY (`studio_id`),
  UNIQUE KEY `uq_studio_name` (`studio_name`),
  KEY `fk_studio_country` (`country_id`),
  CONSTRAINT `fk_studio_country` FOREIGN KEY (`country_id`) REFERENCES `country` (`country_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_studio_founded_year` CHECK ((`founded_year` >= 1888))
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `studio`
--

LOCK TABLES `studio` WRITE;
/*!40000 ALTER TABLE `studio` DISABLE KEYS */;
INSERT INTO `studio` VALUES (1,'Warner Bros. Pictures',1923,1),(2,'Studio Ghibli',1985,4),(3,'A24',2012,1),(4,'Neon',2017,1),(5,'Focus Features',2002,1);
/*!40000 ALTER TABLE `studio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tag`
--

DROP TABLE IF EXISTS `tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tag` (
  `tag_id` int NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`tag_id`),
  UNIQUE KEY `uq_tag_name` (`tag_name`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tag`
--

LOCK TABLES `tag` WRITE;
/*!40000 ALTER TABLE `tag` DISABLE KEYS */;
INSERT INTO `tag` VALUES (4,'cinematography'),(8,'comfort watch'),(2,'cried'),(12,'date night'),(11,'first watch'),(3,'masterpiece'),(6,'overrated'),(9,'plot twist'),(1,'rewatch'),(5,'slow burn'),(10,'soundtrack'),(7,'underrated');
/*!40000 ALTER TABLE `tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `bio` text COLLATE utf8mb4_unicode_ci,
  `avatar_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `join_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uq_user_username` (`username`),
  UNIQUE KEY `uq_user_email` (`email`),
  CONSTRAINT `chk_user_email_format` CHECK (regexp_like(`email`,_utf8mb4'^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$')),
  CONSTRAINT `chk_user_username_length` CHECK ((char_length(`username`) >= 3))
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (2,'cinephile_raj','raj.cinema@example.com','hashed_placeholder_pw','Always chasing the next great long take.',NULL,'2026-07-03 10:13:21'),(3,'film_noir_fan','noirfan@example.com','hashed_placeholder_pw','Shadows, cigarettes, and moral ambiguity.',NULL,'2026-07-03 10:13:21'),(4,'popcorn_prophet','prophet.popcorn@example.com','hashed_placeholder_pw','Blockbusters deserve respect too.',NULL,'2026-07-03 10:13:21'),(5,'reeltalk_sam','sam.reeltalk@example.com','hashed_placeholder_pw',NULL,NULL,'2026-07-03 10:13:21'),(6,'arthouse_ana','ana.arthouse@example.com','hashed_placeholder_pw','A24 completionist.',NULL,'2026-07-03 10:13:21'),(7,'criterion_kid','criterionkid@example.com','hashed_placeholder_pw','Collecting spine numbers since 2019.',NULL,'2026-07-03 10:13:21'),(8,'movie_maven_22','maven22@example.com','hashed_placeholder_pw',NULL,NULL,'2026-07-03 10:13:21'),(9,'deepfocus_dana','dana.deepfocus@example.com','hashed_placeholder_pw','Cinematography nerd, Deakins stan.',NULL,'2026-07-03 10:13:21'),(10,'tracking_shot','trackingshot@example.com','hashed_placeholder_pw',NULL,NULL,'2026-07-03 10:13:21'),(11,'celluloid_dreams','celluloid.dreams@example.com','hashed_placeholder_pw','Film school dropout, still watching.',NULL,'2026-07-03 10:13:21'),(12,'midnight_marquee','midnight.marquee@example.com','hashed_placeholder_pw','Midnight screenings only.',NULL,'2026-07-03 10:13:21'),(13,'script_doctor','scriptdoctor@example.com','hashed_placeholder_pw',NULL,NULL,'2026-07-03 10:13:21'),(14,'indie_insider','indie.insider@example.com','hashed_placeholder_pw','Sundance every January.',NULL,'2026-07-03 10:13:21'),(15,'festivalgoer','festivalgoer@example.com','hashed_placeholder_pw',NULL,NULL,'2026-07-03 10:13:21'),(16,'frame_by_frame','framebyframe@example.com','hashed_placeholder_pw','Pausing movies to admire composition.',NULL,'2026-07-03 10:13:21'),(17,'double_feature','doublefeature@example.com','hashed_placeholder_pw',NULL,NULL,'2026-07-03 10:13:21'),(18,'lens_flare_lee','lee.lensflare@example.com','hashed_placeholder_pw','JJ Abrams forgiven, mostly.',NULL,'2026-07-03 10:13:21'),(19,'montage_mind','montage.mind@example.com','hashed_placeholder_pw','Editing is directing.',NULL,'2026-07-03 10:13:21');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_movie_ratings_summary`
--

DROP TABLE IF EXISTS `vw_movie_ratings_summary`;
/*!50001 DROP VIEW IF EXISTS `vw_movie_ratings_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_movie_ratings_summary` AS SELECT 
 1 AS `movie_id`,
 1 AS `title`,
 1 AS `release_year`,
 1 AS `avg_rating`,
 1 AS `num_ratings`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_user_activity_summary`
--

DROP TABLE IF EXISTS `vw_user_activity_summary`;
/*!50001 DROP VIEW IF EXISTS `vw_user_activity_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_user_activity_summary` AS SELECT 
 1 AS `user_id`,
 1 AS `username`,
 1 AS `num_diary_entries`,
 1 AS `num_ratings`,
 1 AS `num_reviews`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `watchlist`
--

DROP TABLE IF EXISTS `watchlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `watchlist` (
  `user_id` int NOT NULL,
  `movie_id` int NOT NULL,
  `date_added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`movie_id`),
  KEY `fk_watchlist_movie` (`movie_id`),
  CONSTRAINT `fk_watchlist_movie` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`movie_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_watchlist_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `watchlist`
--

LOCK TABLES `watchlist` WRITE;
/*!40000 ALTER TABLE `watchlist` DISABLE KEYS */;
INSERT INTO `watchlist` VALUES (2,6,'2026-07-03 10:25:59'),(2,21,'2026-07-03 10:25:59'),(2,29,'2026-07-03 10:25:59'),(3,4,'2026-07-03 10:25:59'),(3,6,'2026-07-03 10:25:59'),(4,10,'2026-07-03 10:25:59'),(4,17,'2026-07-03 10:25:59'),(5,4,'2026-07-03 10:25:59'),(5,5,'2026-07-03 10:25:59'),(5,10,'2026-07-03 10:25:59'),(6,16,'2026-07-03 10:25:59'),(6,26,'2026-07-03 10:25:59'),(6,30,'2026-07-03 10:25:59'),(7,14,'2026-07-03 10:25:59'),(7,15,'2026-07-03 10:25:59'),(7,30,'2026-07-03 10:25:59'),(8,4,'2026-07-03 10:25:59'),(8,10,'2026-07-03 10:25:59'),(8,12,'2026-07-03 10:25:59'),(8,21,'2026-07-03 10:25:59'),(9,4,'2026-07-03 10:25:59'),(9,19,'2026-07-03 10:25:59'),(9,28,'2026-07-03 10:25:59'),(10,11,'2026-07-03 10:25:59'),(10,13,'2026-07-03 10:25:59'),(11,6,'2026-07-03 10:25:59'),(14,21,'2026-07-03 10:25:59'),(14,22,'2026-07-03 10:25:59'),(14,29,'2026-07-03 10:25:59'),(17,3,'2026-07-03 10:25:59'),(17,13,'2026-07-03 10:25:59'),(17,17,'2026-07-03 10:25:59'),(17,28,'2026-07-03 10:25:59'),(19,7,'2026-07-03 10:25:59'),(19,19,'2026-07-03 10:25:59');
/*!40000 ALTER TABLE `watchlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'letterboxd_db'
--
/*!50003 DROP FUNCTION IF EXISTS `fn_get_movie_avg_rating` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_get_movie_avg_rating`(p_movie_id INT) RETURNS decimal(3,2)
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE v_avg_rating DECIMAL(3,2);
    
    SELECT ROUND(AVG(rating_value), 2) INTO v_avg_rating
    FROM rating
    WHERE movie_id = p_movie_id;
    
    RETURN v_avg_rating;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_user_rating_count` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_user_rating_count`(p_user_id INT) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE v_count INT;
    
    SELECT COUNT(*) INTO v_count
    FROM rating
    WHERE user_id = p_user_id;
    
    RETURN v_count;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_add_rating` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_add_rating`(
    IN p_user_id INT,
    IN p_movie_id INT,
    IN p_rating_value DECIMAL(3,1)
)
BEGIN
    INSERT INTO rating (user_id, movie_id, rating_value)
    VALUES (p_user_id, p_movie_id, p_rating_value)
    ON DUPLICATE KEY UPDATE
        rating.rating_value = p_rating_value;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_user_stats` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_user_stats`(
    IN p_user_id INT,
    OUT p_num_ratings INT,
    OUT p_avg_rating_given DECIMAL(3,2),
    OUT p_num_diary_entries INT
)
BEGIN
    SELECT COUNT(*), ROUND(AVG(rating_value), 2)
    INTO p_num_ratings, p_avg_rating_given
    FROM rating
    WHERE user_id = p_user_id;

    SELECT COUNT(*)
    INTO p_num_diary_entries
    FROM diary_entry
    WHERE user_id = p_user_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `vw_movie_ratings_summary`
--

/*!50001 DROP VIEW IF EXISTS `vw_movie_ratings_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_movie_ratings_summary` AS select `m`.`movie_id` AS `movie_id`,`m`.`title` AS `title`,`m`.`release_year` AS `release_year`,round(avg(`r`.`rating_value`),2) AS `avg_rating`,count(`r`.`rating_id`) AS `num_ratings` from (`movie` `m` join `rating` `r` on((`r`.`movie_id` = `m`.`movie_id`))) group by `m`.`movie_id`,`m`.`title`,`m`.`release_year` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_user_activity_summary`
--

/*!50001 DROP VIEW IF EXISTS `vw_user_activity_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_user_activity_summary` AS select `u`.`user_id` AS `user_id`,`u`.`username` AS `username`,(select count(0) from `diary_entry` `de` where (`de`.`user_id` = `u`.`user_id`)) AS `num_diary_entries`,(select count(0) from `rating` `r` where (`r`.`user_id` = `u`.`user_id`)) AS `num_ratings`,(select count(0) from (`review` `rv` join `diary_entry` `de2` on((`de2`.`diary_entry_id` = `rv`.`diary_entry_id`))) where (`de2`.`user_id` = `u`.`user_id`)) AS `num_reviews` from `user` `u` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-03 14:01:03

-- ERD-only companion file for dbdiagram.io import
-- Tables + PK/FK structure only (CHECK constraints, non-FK indexes
-- omitted - irrelevant to entity-relationship visualization).
-- Source of truth for the real schema remains schema_reference.sql.

-- GROUP 1: LOOKUP TABLES
CREATE TABLE `country` (
  `country_id` int NOT NULL AUTO_INCREMENT,
  `country_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`country_id`),
  UNIQUE KEY `uq_country_name` (`country_name`)
);

CREATE TABLE `language` (
  `language_id` int NOT NULL AUTO_INCREMENT,
  `language_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`language_id`),
  UNIQUE KEY `uq_language_name` (`language_name`)
);

CREATE TABLE `genre` (
  `genre_id` int NOT NULL AUTO_INCREMENT,
  `genre_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`genre_id`),
  UNIQUE KEY `uq_genre_name` (`genre_name`)
);

CREATE TABLE `tag` (
  `tag_id` int NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`tag_id`),
  UNIQUE KEY `uq_tag_name` (`tag_name`)
);

CREATE TABLE `actor` (
  `actor_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `birth_date` date DEFAULT NULL,
  `bio` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`actor_id`)
);

CREATE TABLE `director` (
  `director_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `birth_date` date DEFAULT NULL,
  `bio` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`director_id`)
);

CREATE TABLE `studio` (
  `studio_id` int NOT NULL AUTO_INCREMENT,
  `studio_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `founded_year` smallint DEFAULT NULL,
  `country_id` int DEFAULT NULL,
  PRIMARY KEY (`studio_id`),
  UNIQUE KEY `uq_studio_name` (`studio_name`),
  CONSTRAINT `fk_studio_country` FOREIGN KEY (`country_id`) REFERENCES `country` (`country_id`) ON DELETE SET NULL ON UPDATE CASCADE
);

-- GROUP 2: CORE ENTITIES
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
  UNIQUE KEY `uq_user_email` (`email`)
);

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
  CONSTRAINT `fk_movie_country` FOREIGN KEY (`country_id`) REFERENCES `country` (`country_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_movie_language` FOREIGN KEY (`language_id`) REFERENCES `language` (`language_id`) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- GROUP 3: BRIDGE / METADATA TABLES
CREATE TABLE `movie_genre` (
  `movie_id` int NOT NULL,
  `genre_id` int NOT NULL,
  PRIMARY KEY (`movie_id`,`genre_id`),
  CONSTRAINT `fk_movie_genre_genre` FOREIGN KEY (`genre_id`) REFERENCES `genre` (`genre_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_movie_genre_movie` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`movie_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `movie_cast` (
  `movie_id` int NOT NULL,
  `actor_id` int NOT NULL,
  `character_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `billing_order` smallint unsigned DEFAULT NULL,
  PRIMARY KEY (`movie_id`,`actor_id`,`character_name`),
  CONSTRAINT `fk_movie_cast_actor` FOREIGN KEY (`actor_id`) REFERENCES `actor` (`actor_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_movie_cast_movie` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`movie_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `movie_crew` (
  `movie_id` int NOT NULL,
  `director_id` int NOT NULL,
  `job_title` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`movie_id`,`director_id`,`job_title`),
  CONSTRAINT `fk_movie_crew_director` FOREIGN KEY (`director_id`) REFERENCES `director` (`director_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_movie_crew_movie` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`movie_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `movie_studio` (
  `movie_id` int NOT NULL,
  `studio_id` int NOT NULL,
  PRIMARY KEY (`movie_id`,`studio_id`),
  CONSTRAINT `fk_movie_studio_movie` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`movie_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_movie_studio_studio` FOREIGN KEY (`studio_id`) REFERENCES `studio` (`studio_id`) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- GROUP 4: USER-GENERATED CONTENT
CREATE TABLE `diary_entry` (
  `diary_entry_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `movie_id` int NOT NULL,
  `watched_date` date NOT NULL DEFAULT (curdate()),
  `is_rewatch` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`diary_entry_id`),
  CONSTRAINT `fk_diary_entry_movie` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`movie_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_diary_entry_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

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
);

CREATE TABLE `rating` (
  `rating_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `movie_id` int NOT NULL,
  `rating_value` decimal(2,1) NOT NULL,
  `rated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`rating_id`),
  UNIQUE KEY `uq_rating_user_movie` (`user_id`,`movie_id`),
  CONSTRAINT `fk_rating_movie` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`movie_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_rating_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

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
);

CREATE TABLE `watchlist` (
  `user_id` int NOT NULL,
  `movie_id` int NOT NULL,
  `date_added` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`movie_id`),
  CONSTRAINT `fk_watchlist_movie` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`movie_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_watchlist_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

-- GROUP 5: SOCIAL FEATURES
CREATE TABLE `review_like` (
  `user_id` int NOT NULL,
  `review_id` int NOT NULL,
  `liked_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`review_id`),
  CONSTRAINT `fk_review_like_review` FOREIGN KEY (`review_id`) REFERENCES `review` (`review_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_review_like_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `review_comment` (
  `comment_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `review_id` int NOT NULL,
  `comment_text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`comment_id`),
  CONSTRAINT `fk_review_comment_review` FOREIGN KEY (`review_id`) REFERENCES `review` (`review_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_review_comment_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `followers` (
  `follower_id` int NOT NULL,
  `followed_id` int NOT NULL,
  `followed_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`follower_id`,`followed_id`),
  CONSTRAINT `fk_followers_followed` FOREIGN KEY (`followed_id`) REFERENCES `user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_followers_follower` FOREIGN KEY (`follower_id`) REFERENCES `user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE TABLE `favorite_genre` (
  `user_id` int NOT NULL,
  `genre_id` int NOT NULL,
  PRIMARY KEY (`user_id`,`genre_id`),
  CONSTRAINT `fk_favorite_genre_genre` FOREIGN KEY (`genre_id`) REFERENCES `genre` (`genre_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_favorite_genre_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

-- GROUP 6: SYSTEM TABLES
CREATE TABLE `notification` (
  `notification_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `notification_type` enum('new_follower','new_comment','new_like','watchlist_alert','system') COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`notification_id`),
  CONSTRAINT `fk_notification_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `activity_log` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `action_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action_details` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  CONSTRAINT `fk_activity_log_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `report` (
  `report_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `reported_review_id` int DEFAULT NULL,
  `reported_comment_id` int DEFAULT NULL,
  `reason` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('pending','reviewed','dismissed','action_taken') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`report_id`),
  CONSTRAINT `fk_report_comment` FOREIGN KEY (`reported_comment_id`) REFERENCES `review_comment` (`comment_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_report_review` FOREIGN KEY (`reported_review_id`) REFERENCES `review` (`review_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_report_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

-- GROUP 7: REMAINING BRIDGE TABLES
CREATE TABLE `movie_collection` (
  `collection_id` int NOT NULL AUTO_INCREMENT,
  `collection_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`collection_id`),
  UNIQUE KEY `uq_movie_collection_name` (`collection_name`)
);

CREATE TABLE `collection_movie` (
  `collection_id` int NOT NULL,
  `movie_id` int NOT NULL,
  PRIMARY KEY (`collection_id`,`movie_id`),
  CONSTRAINT `fk_collection_movie_collection` FOREIGN KEY (`collection_id`) REFERENCES `movie_collection` (`collection_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_collection_movie_movie` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`movie_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `list_movie` (
  `list_id` int NOT NULL,
  `movie_id` int NOT NULL,
  `position` smallint unsigned DEFAULT NULL,
  `added_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`list_id`,`movie_id`),
  CONSTRAINT `fk_list_movie_list` FOREIGN KEY (`list_id`) REFERENCES `movie_list` (`list_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_list_movie_movie` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`movie_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `diary_entry_tag` (
  `diary_entry_id` int NOT NULL,
  `tag_id` int NOT NULL,
  PRIMARY KEY (`diary_entry_id`,`tag_id`),
  CONSTRAINT `fk_diary_entry_tag_entry` FOREIGN KEY (`diary_entry_id`) REFERENCES `diary_entry` (`diary_entry_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_diary_entry_tag_tag` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`tag_id`) ON DELETE RESTRICT ON UPDATE CASCADE
);

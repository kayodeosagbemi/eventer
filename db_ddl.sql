create database event_db;

-- apen_event.event definition

CREATE TABLE `event` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique ID of an event. PK of this table',
  `name` varchar(200) NOT NULL COMMENT 'The name of the event.',
  `year` year(4) DEFAULT NULL COMMENT 'The year of this event.',
  `description` text DEFAULT NULL,
  `created_date` datetime DEFAULT current_timestamp(),
  `status` bit(1) DEFAULT b'1' COMMENT '1 means this event is not deleted and 0 means deleted.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `event_UN` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- apen_event.`day` definition

CREATE TABLE `day` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `display_name` varchar(100) COLLATE utf8_swedish_ci NOT NULL COMMENT 'This is what is displayed when rendering this day record on a view',
  `calendar_date` date NOT NULL COMMENT 'The actual date',
  `status` bit(1) NOT NULL DEFAULT b'1' COMMENT '1 means active and 0 means inactive or deleted',
  `record_creation_date` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'The date and time this record was created.',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci;


-- apen_event.delegate definition

CREATE TABLE `delegate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lastname` varchar(100) DEFAULT NULL,
  `firstname` varchar(100) DEFAULT NULL,
  `sex` char(1) NOT NULL,
  `email` varchar(200) DEFAULT NULL,
  `phone` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='The information about the delegate';


-- apen_event.event_day definition

CREATE TABLE `event_day` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) DEFAULT NULL COMMENT 'The ID of the event this day belongs to.',
  `day_id` int(11) DEFAULT NULL COMMENT 'The day this event belongs to.',
  `created_date` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `event_day_FK` (`event_id`),
  KEY `event_day_FK_1` (`day_id`),
  CONSTRAINT `event_day_FK` FOREIGN KEY (`event_id`) REFERENCES `event` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `event_day_FK_1` FOREIGN KEY (`day_id`) REFERENCES `day` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- apen_event.breakout definition

CREATE TABLE `breakout` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) NOT NULL,
  `day_id` int(11) DEFAULT NULL,
  `name` varchar(200) NOT NULL,
  `created_date` datetime DEFAULT current_timestamp(),
  `created_by` varchar(100) DEFAULT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1' COMMENT '1 is active and 0 is inactive',
  PRIMARY KEY (`id`),
  KEY `breakout_FK` (`event_id`),
  KEY `breakout_FK_1` (`day_id`),
  CONSTRAINT `breakout_FK` FOREIGN KEY (`event_id`) REFERENCES `event` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `breakout_FK_1` FOREIGN KEY (`day_id`) REFERENCES `day` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Represents a breakout in an event which is like a mini-meeting taking place on that same day along with other mini meetings.';


-- apen_event.`session` definition

CREATE TABLE `session` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(300) NOT NULL,
  `breakout_id` int(11) DEFAULT NULL COMMENT 'The breakout that this session belongs to.',
  `presenter` varchar(100) DEFAULT NULL COMMENT 'The name of the person who is presenting or anchoring this session.',
  PRIMARY KEY (`id`),
  KEY `session_FK` (`breakout_id`),
  CONSTRAINT `session_FK` FOREIGN KEY (`breakout_id`) REFERENCES `breakout` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='The sessions or topics under each breakout.';

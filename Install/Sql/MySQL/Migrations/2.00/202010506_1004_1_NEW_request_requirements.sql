-- UP

CREATE TABLE IF NOT EXISTS `request` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
  `modified_on` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
  `created_by_user_oid` binary(16) DEFAULT NULL,
  `modified_by_user_oid` binary(16) DEFAULT NULL,
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `date_received` date NOT NULL,
  `date_submitted` date DEFAULT NULL,
  `summary` varchar(200) DEFAULT NULL,
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci,
  `client_id` int DEFAULT NULL,
  `file_location` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `Name unique` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `request_requirement` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
  `modified_on` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
  `created_by_user_oid` binary(16) DEFAULT NULL,
  `modified_by_user_oid` binary(16) DEFAULT NULL,
  `request_id` int NOT NULL,
  `no` int DEFAULT NULL,
  `section` varchar(100) NOT NULL DEFAULT '',
  `subsection` varchar(100) NOT NULL DEFAULT '',
  `requirement_text` text CHARACTER SET utf8 COLLATE utf8_general_ci,
  `priority` int DEFAULT NULL,
  `phase` int DEFAULT NULL,
  `est_design_d` decimal(8,2) DEFAULT NULL,
  `est_build_d` decimal(8,2) DEFAULT NULL,
  `est_test_d` decimal(8,2) DEFAULT NULL,
  `est_group` varchar(20) DEFAULT NULL,
  `billing` int DEFAULT NULL,
  `answer_status` int DEFAULT NULL,
  `comment` text,
  `topic_id` int DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `request` (`request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- DOWN

DROP TABLE IF EXISTS request;

DROP TABLE IF EXISTS request_requirement;
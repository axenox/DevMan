-- UP

DROP TABLE IF EXISTS `release_applications`;
CREATE TABLE `release_applications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT current_timestamp(),
  `modified_on` datetime NOT NULL DEFAULT current_timestamp(),
  `created_by_user_oid` binary(16) NOT NULL,
  `modified_by_user_oid` binary(16) NOT NULL,
  `release_id` int(11) NOT NULL,
  `application_id` int(11) NOT NULL,
  `description` text DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `application_id` (`application_id`),
  KEY `release_id` (`release_id`),
  CONSTRAINT `release_applications_ibfk_2` FOREIGN KEY (`application_id`) REFERENCES `application` (`id`),
  CONSTRAINT `release_applications_ibfk_3` FOREIGN KEY (`release_id`) REFERENCES `release` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;


DROP TABLE IF EXISTS `release_deployments`;
CREATE TABLE `release_deployments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT current_timestamp(),
  `modified_on` datetime NOT NULL DEFAULT current_timestamp(),
  `created_by_user_oid` binary(16) NOT NULL,
  `modified_by_user_oid` binary(16) NOT NULL,
  `release_id` int(11) NOT NULL,
  `installation_id` int(11) NOT NULL,
  `type` varchar(2) NOT NULL,
  `deployed_on` datetime NOT NULL,
  `description` text DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `installation_id` (`installation_id`),
  KEY `release_id` (`release_id`),
  CONSTRAINT `release_deployments_ibfk_1` FOREIGN KEY (`installation_id`) REFERENCES `installation` (`id`),
  CONSTRAINT `release_deployments_ibfk_2` FOREIGN KEY (`release_id`) REFERENCES `release` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;

-- DOWN

-- Do not delete tables!!!
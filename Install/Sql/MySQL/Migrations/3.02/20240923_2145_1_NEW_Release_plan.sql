-- UP

CREATE TABLE `release` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT current_timestamp(),
  `modified_on` datetime NOT NULL DEFAULT current_timestamp(),
  `created_by_user_oid` binary(16) NOT NULL,
  `modified_by_user_oid` binary(16) NOT NULL,
  `name` varchar(100) NOT NULL,
  `client_id` int(11) NOT NULL,
  `date_planned` date DEFAULT NULL,
  `date_staging` date DEFAULT NULL,
  `date_released` date DEFAULT NULL,
  `date_eol` date DEFAULT NULL,
  `description` text DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `client_id` (`client_id`),
  CONSTRAINT `release_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;


CREATE TABLE `release_includes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT current_timestamp(),
  `modified_on` datetime NOT NULL DEFAULT current_timestamp(),
  `created_by_user_oid` binary(16) NOT NULL,
  `modified_by_user_oid` binary(16) NOT NULL,
  `release_id` int(11) NOT NULL,
  `release_included_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `release_included_id` (`release_included_id`),
  KEY `release_id` (`release_id`),
  CONSTRAINT `release_includes_ibfk_2` FOREIGN KEY (`release_included_id`) REFERENCES `release` (`id`),
  CONSTRAINT `release_includes_ibfk_3` FOREIGN KEY (`release_id`) REFERENCES `release` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci ROW_FORMAT=DYNAMIC;


ALTER TABLE `ticket`
ADD `release_id` int(11) NULL,
ADD FOREIGN KEY `FK_ticket_release` (`release_id`) REFERENCES `release` (`id`);

ALTER TABLE `sprint`
ADD `release_id` int(11) NULL,
ADD FOREIGN KEY `FK_sprint_release` (`release_id`) REFERENCES `release` (`id`);

-- DOWN

ALTER TABLE `ticket`
DROP FOREIGN KEY `FK_ticket_release`
DROP `release_id` int(11) NULL;

ALTER TABLE `sprint`,
DROP FOREIGN KEY `FK_sprint_release`
DROP `release_id` int(11) NULL;
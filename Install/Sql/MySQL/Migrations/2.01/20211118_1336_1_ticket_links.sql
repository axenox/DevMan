-- UP

CREATE TABLE IF NOT EXISTS `external_system` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by_user_oid` binary(16) NOT NULL,
  `modified_by_user_oid` binary(16) NOT NULL,
  `name` varchar(50) NOT NULL,
  `client_id` int DEFAULT NULL,
  `project_id` int DEFAULT NULL,
  `url` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `ticket_url_pattern` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `external_ticket_link` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by_user_oid` binary(16) NOT NULL,
  `modified_by_user_oid` binary(16) NOT NULL,
  `external_system_id` int NOT NULL,
  `ticket_id` int NOT NULL,
  `external_ticket_id` varchar(400) DEFAULT '',
  `custom_url` varchar(400) DEFAULT '',
  `comment` varchar(400) DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- DOWN

DROP TABLE IF EXISTS `external_ticket_link`;
DROP TABLE IF EXISTS `external_system`;


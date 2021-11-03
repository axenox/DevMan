-- UP

CREATE TABLE IF NOT EXISTS `ticket_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT NOW(),
  `modified_on` datetime NOT NULL DEFAULT NOW(),
  `created_by_user_oid` binary(16) DEFAULT NULL,
  `modified_by_user_oid` binary(16) DEFAULT NULL,
  `ticket_id` int NOT NULL,
  `resource_id` int NOT NULL,
  `comment` longtext NOT NULL,
  `state` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `Ticket and time` (`ticket_id`,`created_on`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
	


-- DOWN

DROP TABLE IF EXISTS `ticket_log`;

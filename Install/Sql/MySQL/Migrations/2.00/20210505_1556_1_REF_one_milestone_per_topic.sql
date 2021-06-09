-- UP

DROP TABLE `milestone_topics`;

ALTER TABLE `topic`
	ADD COLUMN `milestone_id` INT(10) NULL DEFAULT NULL AFTER `assigned_to`;

-- DOWN

CREATE TABLE IF NOT EXISTS `milestone_topics` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
  `modified_on` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
  `created_by_user_oid` binary(16) DEFAULT NULL,
  `modified_by_user_oid` binary(16) DEFAULT NULL,
  `milestone_id` int NOT NULL DEFAULT '0',
  `topic_id` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `Milestone unique per project` (`topic_id`,`milestone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

ALTER TABLE `topic`
	DROP COLUMN `milestone_id`;
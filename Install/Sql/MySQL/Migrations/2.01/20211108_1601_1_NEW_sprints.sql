-- UP

CREATE TABLE IF NOT EXISTS `sprint` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by_user_oid` binary(16) NOT NULL,
  `modified_by_user_oid` binary(16) NOT NULL,
  `name` varchar(100) NOT NULL,
  `start_on` date NOT NULL,
  `end_on` date NOT NULL,
  `description` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2539 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

ALTER TABLE `ticket`
	ADD COLUMN `sprint_id` INT NULL AFTER `milestone_id`,
	ADD COLUMN `sprint_pos` INT NULL AFTER `sprint_id`;

-- DOWN

DROP TABLE IF EXISTS `sprint`;

ALTER TABLE `ticket`
	DROP COLUMN `sprint_id`,
	DROP COLUMN `sprint_pos`;


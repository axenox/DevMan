-- UP

CREATE TABLE IF NOT EXISTS `feature_tickets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by_user_oid` binary(16) NOT NULL,
  `modified_by_user_oid` binary(16) NOT NULL,
  `ticket_id` int NOT NULL,
  `feature_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `Unique ticket per feature` (`ticket_id`,`feature_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

ALTER TABLE `test_scenario`
	ADD COLUMN `application_id` INT NULL AFTER `description`;
	
ALTER TABLE `test_case`
	CHANGE COLUMN `description` `description` TEXT NULL COLLATE 'utf8_general_ci' AFTER `name`;

-- DOWN

DROP TABLE IF EXISTS `feature_tickets`;

ALTER TABLE `test_scenario`
	DROP COLUMN `application_id`;
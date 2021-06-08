-- UP

CREATE TABLE IF NOT EXISTS `installation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by_user_oid` binary(16) DEFAULT NULL,
  `modified_by_user_oid` binary(16) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `url` varchar(100) NOT NULL,
  `description` text,
  `client_id` int NOT NULL,
  `current_workbench_version` varchar(30) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

ALTER TABLE `test_log`
	CHANGE COLUMN `tested_installation` `tested_installation_id` INT(10) NOT NULL AFTER `test_case_id`,
	CHANGE COLUMN `tested_version` `tested_workbench_version` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci' AFTER `tested_installation_i`;


-- DOWN

DROP TABLE IF EXISTS `installation`;
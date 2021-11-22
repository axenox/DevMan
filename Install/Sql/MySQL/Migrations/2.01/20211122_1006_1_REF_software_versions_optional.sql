-- UP

ALTER TABLE `server_software_log`
	CHANGE COLUMN `version` `version` VARCHAR(50) NOT NULL DEFAULT '' COLLATE 'utf8_general_ci' AFTER `software_id`;

ALTER TABLE `software`
	CHANGE COLUMN `latest_version` `latest_version` VARCHAR(50) NOT NULL DEFAULT '' COLLATE 'utf8_general_ci' AFTER `name`,
	CHANGE COLUMN `least_version` `least_version` VARCHAR(50) NOT NULL DEFAULT '' COLLATE 'utf8_general_ci' AFTER `latest_version`;

-- DOWN

ALTER TABLE `server_software_log`
	CHANGE COLUMN `version` `version` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci' AFTER `software_id`;

ALTER TABLE `software`
	CHANGE COLUMN `latest_version` `latest_version` VARCHAR(50) NULL COLLATE 'utf8_general_ci' AFTER `name`,
	CHANGE COLUMN `least_version` `least_version` VARCHAR(50) NULL COLLATE 'utf8_general_ci' AFTER `latest_version`;


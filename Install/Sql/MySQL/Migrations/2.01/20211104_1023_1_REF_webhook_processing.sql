-- UP

ALTER TABLE webhook_log
	ADD COLUMN `created_on` datetime NOT NULL DEFAULT NOW() AFTER `id`,
	ADD COLUMN `modified_on` datetime NOT NULL DEFAULT NOW() AFTER `created_on`,
	ADD COLUMN `created_by_user_oid` binary(16) DEFAULT NULL AFTER `modified_on`,
	ADD COLUMN `modified_by_user_oid` binary(16) DEFAULT NULL AFTER `created_by_user_oid`,
	CHANGE COLUMN `receive_datetime` `received_on` DATETIME NOT NULL,
	ADD COLUMN `ignored` TINYINT NOT NULL DEFAULT '0' AFTER `processed`,
	ADD COLUMN `failed` TINYINT NOT NULL DEFAULT '0' AFTER `ignored`,
	ADD COLUMN `failed_message` VARCHAR(250) NULL AFTER `failed`,
	ADD COLUMN `failed_log_id` VARCHAR(10) NULL AFTER `failed_message`,
	ADD COLUMN `repo_url` VARCHAR(250) NULL AFTER `message`;

UPDATE webhook_log SET `created_on` = `receive_datetime`,  `modified_on` = `receive_datetime`;

-- DOWN

ALTER TABLE webhook_log
	DROP COLUMN `created_on` datetime,
	DROP COLUMN `modified_on` datetime,
	DROP COLUMN `created_by_user_oid`,
	DROP COLUMN `modified_by_user_oid`,
	CHANGE COLUMN `received_on` `receive_datetime` DATETIME NOT NULL,
	DROP COLUMN `ignored`,
	DROP COLUMN `failed`,
	DROP COLUMN `failed_message`,
	DROP COLUMN `failed_log_id`,
	DROP COLUMN `repo_url`;

UPDATE webhook_log SET `created_on` = `receive_datetime`,  `modified_on` = `receive_datetime`;
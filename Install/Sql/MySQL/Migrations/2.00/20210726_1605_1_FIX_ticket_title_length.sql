-- UP

ALTER TABLE `ticket`
	CHANGE COLUMN `title` `title` VARCHAR(250) NOT NULL COLLATE 'utf8_general_ci' AFTER `modified_by_user_oid`;

-- DOWN

ALTER TABLE `ticket`
	CHANGE COLUMN `title` `title` VARCHAR(128) NOT NULL COLLATE 'utf8_general_ci' AFTER `modified_by_user_oid`;
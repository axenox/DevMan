-- UP

ALTER TABLE `webhook_log`
	ADD COLUMN `result` TEXT NULL AFTER `repo_url`;
	
ALTER TABLE `vcs_update_files`
	ADD COLUMN `deleted_flag` TINYINT NOT NULL DEFAULT '0' AFTER `application_file_id`;


-- DOWN

ALTER TABLE `webhook_log`
	DROP COLUMN `result`;
	
ALTER TABLE `vcs_update_files`
	DROP COLUMN `deleted_flag`;


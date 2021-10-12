-- UP

ALTER TABLE `feature`
	ADD COLUMN `connected_files` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8_general_ci' AFTER `test_setup`;
	
-- DOWN

ALTER TABLE `feature`
	DROP COLUMN `connected_files`
-- UP

ALTER TABLE `test_case`
	ADD COLUMN `priority` TINYINT NULL DEFAULT NULL AFTER `effort_planned`;
	
ALTER TABLE `feature`
	ADD COLUMN `priority` TINYINT NULL DEFAULT NULL AFTER `parent_feature_id`;
	
ALTER TABLE `installation`
	ADD COLUMN `current_build_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER `current_workbench_version`;
	
ALTER TABLE `test_log`
	ADD COLUMN `tested_build_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER `tested_workbench_version`;

-- DOWN

ALTER TABLE `test_case`
	DROP COLUMN `priority`;
	
ALTER TABLE `feature`
	DROP COLUMN `priority`;
	
ALTER TABLE `installation`
	DROP COLUMN `current_build_time`;
	
ALTER TABLE `test_log`
	DROP COLUMN `tested_build_time`;
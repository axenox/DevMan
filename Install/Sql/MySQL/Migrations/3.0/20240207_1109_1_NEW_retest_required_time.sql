-- UP

ALTER TABLE `test_case`
	ADD COLUMN `retest_required_time` datetime NULL AFTER `priority`;
	
-- DOWN

ALTER TABLE `test_case`
	DROP COLUMN `retest_required_time`;
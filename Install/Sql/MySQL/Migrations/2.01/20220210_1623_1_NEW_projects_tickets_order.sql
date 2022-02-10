-- UP

ALTER TABLE `project_tickets`
	ADD COLUMN `position` INT NOT NULL DEFAULT '0' AFTER `comment`;
	
ALTER TABLE `test_case_coverage`
	ADD COLUMN `comment` VARCHAR(300) NOT NULL DEFAULT '' AFTER `covers_test_case_id`;

-- DOWN

ALTER TABLE `project_tickets`
	DROP COLUMN `position`;

ALTER TABLE `test_case_coverage`
	DROP COLUMN `comment`;
	
-- UP

ALTER TABLE `test_scenario_cases` 
	CHANGE `test_case_id` `test_case_id` INT(11) NULL;
ALTER TABLE `test_scenario_cases` 
	ADD `sequence` INT NOT NULL AFTER `test_scenario_id`, 
	ADD `summary` VARCHAR(250) NOT NULL AFTER `sequence`;
ALTER TABLE `test_scenario` 
	ADD `setup` TEXT NULL AFTER `application_id`;

-- DOWN

ALTER TABLE `test_scenario_cases` 
	CHANGE `test_case_id` `test_case_id` INT(11) NOT NULL;
ALTER TABLE `test_scenario_cases` 
	DROP `sequence`,
	DROP `summary`;
ALTER TABLE `test_scenario` 
	DROP `setup`;
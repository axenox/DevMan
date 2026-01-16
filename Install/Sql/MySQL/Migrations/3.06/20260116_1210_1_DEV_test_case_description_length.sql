-- UP 

ALTER TABLE `test_case`
CHANGE `description` `description` longtext COLLATE 'utf8mb3_general_ci' NULL AFTER `name`;

ALTER TABLE `test_log`
CHANGE `test_description` `test_description` longtext COLLATE 'utf8mb3_general_ci' NULL AFTER `comment`;

-- DOWN


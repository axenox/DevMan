-- UP

ALTER TABLE `test_case`
ADD `login_data` text COLLATE 'utf8mb3_general_ci' NULL;

-- DOWN

ALTER TABLE `test_case`
DROP COLUMN `login_data`;
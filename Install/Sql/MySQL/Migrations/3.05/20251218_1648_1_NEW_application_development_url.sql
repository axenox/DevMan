-- UP 

ALTER TABLE `application`
ADD `development_url` varchar(255) COLLATE 'utf8mb3_general_ci' NULL;

-- DOWN

ALTER TABLE `application`
DROP COLUMN `development_url` 
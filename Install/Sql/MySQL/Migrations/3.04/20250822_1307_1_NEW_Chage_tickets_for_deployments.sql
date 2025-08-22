-- UP

ALTER TABLE `release_deployments`
ADD `change_ticket` varchar(50) COLLATE 'utf8mb3_general_ci' NULL;

-- DOWN

ALTER TABLE `release_deployments`
DROP COLUMN `change_ticket`;
-- UP

ALTER TABLE `project_tickets`
	ADD COLUMN `priority` TINYINT NOT NULL DEFAULT 0 AFTER `priority_id`;
	
UPDATE project_tickets SET priority = (SELECT p.`value` FROM priority p WHERE p.id = priority_id);

ALTER TABLE `project_tickets`
	CHANGE COLUMN `priority` `priority` TINYINT(3) NOT NULL AFTER `priority_id`;
	
ALTER TABLE `project_tickets`
	DROP COLUMN `priority_id`;
	
ALTER TABLE `test_plan_cases`
	CHANGE COLUMN `priority_id` `priority` TINYINT NOT NULL DEFAULT 1 AFTER `modified_by_user_oid`;
	
DROP TABLE `priority`;

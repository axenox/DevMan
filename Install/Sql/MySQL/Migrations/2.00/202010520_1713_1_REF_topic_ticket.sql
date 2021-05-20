-- UP

ALTER TABLE `topic`
	CHANGE COLUMN `topic_type_id` `ticket_type_id` INT(10) NOT NULL AFTER `description`,
	CHANGE COLUMN `parent_topic_id` `parent_ticket_id` INT(10) NULL DEFAULT NULL AFTER `ticket_type_id`,
	DROP INDEX `Parent`,
	ADD INDEX `Parent` (`parent_ticket_id`) USING BTREE;
RENAME TABLE `topic` TO `ticket`;

ALTER TABLE `topic_tags`
	CHANGE COLUMN `topic_id` `ticket_id` INT(10) NOT NULL AFTER `tag_id`,
	DROP INDEX `Tag unique per topic`,
	ADD UNIQUE INDEX `Tag unique per ticket` (`tag_id`, `ticket_id`) USING BTREE;
RENAME TABLE `topic_tags` TO `ticket_tags`;

RENAME TABLE `topic_type` TO `ticket_type`;

ALTER TABLE `project_topics`
	CHANGE COLUMN `topic_id` `ticket_id` INT(10) NOT NULL AFTER `project_id`,
	DROP INDEX `Topic unique per project`,
	ADD UNIQUE INDEX `Ticket unique per project` (`project_id`, `ticket_id`) USING BTREE,
	DROP INDEX `Topic priority`,
	ADD INDEX `Ticket priority` (`ticket_id`, `priority_id`) USING BTREE;
RENAME TABLE `project_topics` TO `project_tickets`;

ALTER TABLE `approval`
	CHANGE COLUMN `topic_id` `ticket_id` INT(10) NULL DEFAULT NULL AFTER `project_id`,
	DROP INDEX `Topic`,
	ADD INDEX `Ticket` (`ticket_id`) USING BTREE;
	
ALTER TABLE `request_requirement`
	CHANGE COLUMN `topic_id` `ticket_id` INT(10) NULL DEFAULT NULL AFTER `comment`;

-- DOWN

ALTER TABLE `ticket`
	CHANGE COLUMN `ticket_type_id` `topic_type_id` INT(10) NOT NULL AFTER `description`,
	CHANGE COLUMN `parent_ticket_id` `parent_topic_id` INT(10) NULL DEFAULT NULL AFTER `topic_type_id`,
	DROP INDEX `Parent`,
	ADD INDEX `Parent` (`parent_topic_id`) USING BTREE;
RENAME TABLE `ticket` TO `topic`;

ALTER TABLE `ticket_tags`
	CHANGE COLUMN `ticket_id` `topic_id` INT(10) NOT NULL AFTER `tag_id`,
	DROP INDEX `Tag unique per ticket`,
	ADD UNIQUE INDEX `Tag unique per topic` (`tag_id`, `topic_id`) USING BTREE;
RENAME TABLE `ticket_tags` TO `topic_tags`;

RENAME TABLE `ticket_type` TO `topic_type`;

ALTER TABLE `project_tickets`
	CHANGE COLUMN `ticket_id` `topic_id` INT(10) NOT NULL AFTER `project_id`,
	DROP INDEX `Ticket unique per project`,
	ADD UNIQUE INDEX `Topic unique per project` (`project_id`, `topic_id`) USING BTREE,
	DROP INDEX `Ticket priority`,
	ADD INDEX `Topic priority` (`topic_id`, `priority_id`) USING BTREE;
RENAME TABLE `project_tickets` TO `project_topics`;

ALTER TABLE `approval`
	CHANGE COLUMN `ticket_id` `topic_id` INT(10) NULL DEFAULT NULL AFTER `project_id`,
	DROP INDEX `Ticket`,
	ADD INDEX `Topic` (`topic_id`) USING BTREE;
	
ALTER TABLE `request_requirement`
	CHANGE COLUMN `ticket_id` `topic_id` INT(10) NULL DEFAULT NULL AFTER `comment`;

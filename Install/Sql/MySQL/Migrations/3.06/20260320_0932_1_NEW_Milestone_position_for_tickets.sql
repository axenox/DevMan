/*
 * Add missing milestone assignment fields to ticket.
 *
 * This migration creates ticket.milestone_id and ticket.milestone_at_pos
 * for installations that do not yet have these columns.
 *
 * The migration also creates an index and foreign key for milestone_id.
 *
 * @author OpenAI
 */
-- UP
ALTER TABLE `ticket`
    ADD COLUMN `milestone_id` int(10) NULL
        AFTER `assigned_at_pos`,
    ADD INDEX `IDX_ticket_milestone_id` (`milestone_id`),
    ADD CONSTRAINT `FK_ticket_milestone_id`
        FOREIGN KEY (`milestone_id`) REFERENCES `milestone` (`id`);

ALTER TABLE `ticket`
    ADD COLUMN `milestone_at_pos` int(11) NULL
        AFTER `milestone_id`;

-- DOWN
ALTER TABLE `ticket`
    DROP FOREIGN KEY `FK_ticket_milestone_id`,
    DROP INDEX `IDX_ticket_milestone_id`;
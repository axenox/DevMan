/*
 * Add comments for tickets.
 *
 * The table is retained on DOWN to avoid deleting comment history.
 *
 * @author OpenAI
 */
-- UP
CREATE TABLE IF NOT EXISTS `ticket_comment` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `created_on` datetime NOT NULL,
    `modified_on` datetime NOT NULL,
    `created_by_user_oid` binary(16) NOT NULL,
    `modified_by_user_oid` binary(16) NOT NULL,
    `ticket_id` int(11) NOT NULL,
    `comment` text NOT NULL,
    `comment_type` int(11) NOT NULL,
    `action_required` int(11) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `IDX_ticket_comment_ticket` (`ticket_id`),
    CONSTRAINT `FK_ticket_comment_ticket`
        FOREIGN KEY (`ticket_id`) REFERENCES `ticket` (`id`)
) ENGINE=InnoDB;

-- DOWN
-- Preserve the table because it may contain comment history.

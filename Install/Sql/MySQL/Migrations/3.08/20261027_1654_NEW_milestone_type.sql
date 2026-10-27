/*
 * Add the milestone type table required by milestones.
 *
 * The table is retained on DOWN to avoid deleting milestone type data.
 *
 * @author OpenAI
 */
-- UP
CREATE TABLE IF NOT EXISTS `milestone_type` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `created_on` datetime DEFAULT '1970-01-01 00:00:00',
    `modified_on` datetime DEFAULT '1970-01-01 00:00:00',
    `created_by_user_oid` binary(16) DEFAULT NULL,
    `modified_by_user_oid` binary(16) DEFAULT NULL,
    `name` varchar(50) NOT NULL,
    `color` varchar(7) NOT NULL,
    `description` varchar(100) NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `UQ_milestone_type_name` (`name`)
) ENGINE=InnoDB;

-- DOWN
-- Preserve the table because it may contain user-maintained master data.

/*
 * Add issues raised for test cases.
 *
 * The table is retained on DOWN to avoid deleting issue data.
 *
 * @author OpenAI
 */
-- UP
CREATE TABLE IF NOT EXISTS `test_case_issue` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `created_on` datetime NOT NULL,
    `modified_on` datetime NOT NULL,
    `created_by_user_oid` binary(16) NOT NULL,
    `modified_by_user_oid` binary(16) NOT NULL,
    `test_case_id` int(11) NOT NULL,
    `title` varchar(250) NOT NULL,
    `description` longtext NOT NULL,
    `type` int(11) NOT NULL DEFAULT 1,
    `state` int(11) NOT NULL DEFAULT 10,
    `severity` int(11) DEFAULT NULL,
    `priority` int(11) DEFAULT NULL,
    `assigned_to` varchar(50) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `IDX_test_case_issue_test_case` (`test_case_id`),
    CONSTRAINT `FK_test_case_issue_test_case`
        FOREIGN KEY (`test_case_id`) REFERENCES `test_case` (`id`)
) ENGINE=InnoDB;

-- DOWN
-- Preserve the table because it may contain issue history.

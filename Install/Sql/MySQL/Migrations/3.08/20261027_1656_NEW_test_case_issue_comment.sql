/*
 * Add comments for test case issues.
 *
 * The table is retained on DOWN to avoid deleting comment history.
 *
 * @author OpenAI
 */
-- UP
CREATE TABLE IF NOT EXISTS `test_case_issue_comment` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `created_on` datetime NOT NULL,
    `modified_on` datetime NOT NULL,
    `created_by_user_oid` binary(16) NOT NULL,
    `modified_by_user_oid` binary(16) NOT NULL,
    `test_case_issue_id` int(11) NOT NULL,
    `comment` longtext NOT NULL,
    `comment_type` int(11) NOT NULL,
    `action_required` int(11) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `IDX_test_case_issue_comment_issue` (`test_case_issue_id`),
    CONSTRAINT `FK_test_case_issue_comment_issue`
        FOREIGN KEY (`test_case_issue_id`) REFERENCES `test_case_issue` (`id`)
) ENGINE=InnoDB;

-- DOWN
-- Preserve the table because it may contain comment history.

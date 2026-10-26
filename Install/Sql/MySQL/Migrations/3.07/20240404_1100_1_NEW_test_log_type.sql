/*
 * Add test log types required by the model and master data.
 *
 * Preserve existing tables and columns on retries and during DOWN.
 *
 * @author GitHub Copilot
 */
-- UP
CREATE TABLE IF NOT EXISTS `test_log_type` (
    `id` int NOT NULL AUTO_INCREMENT,
    `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `modified_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `created_by_user_oid` binary(16) NOT NULL,
    `modified_by_user_oid` binary(16) NOT NULL,
    `name` varchar(100) NOT NULL,
    `explanation` varchar(500) DEFAULT NULL,
    PRIMARY KEY (`id`)
);

CALL execute_sql_on_missing_column(
    'test_log',
    'test_log_type_id',
    'ALTER TABLE `test_log` ADD COLUMN `test_log_type_id` int DEFAULT NULL'
);

-- DOWN
-- Preserve test log types and assignments to avoid deleting existing data.
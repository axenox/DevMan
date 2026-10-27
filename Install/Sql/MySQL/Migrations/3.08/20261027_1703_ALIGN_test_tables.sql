/*
 * Align test-related columns with the current DevMan database.
 *
 * Added classification data is retained on DOWN.
 *
 * @author OpenAI
 */
-- UP
CALL execute_sql_on_missing_column(
    'test_case',
    'archived_flag',
    'ALTER TABLE `test_case` ADD COLUMN `archived_flag` tinyint NOT NULL DEFAULT 0'
);
ALTER TABLE `test_log`
    MODIFY `test_log_type_id` int NOT NULL;
ALTER TABLE `test_log_type`
    MODIFY `created_on` datetime NOT NULL,
    MODIFY `modified_on` datetime NOT NULL;
ALTER TABLE `test_scenario_cases`
    MODIFY `summary` varchar(250) DEFAULT NULL;

-- DOWN
ALTER TABLE `test_log`
    MODIFY `test_log_type_id` int DEFAULT NULL;
ALTER TABLE `test_log_type`
    MODIFY `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    MODIFY `modified_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE `test_scenario_cases`
    MODIFY `summary` varchar(250) NOT NULL;
-- Keep archived_flag because removing it could lose classifications.

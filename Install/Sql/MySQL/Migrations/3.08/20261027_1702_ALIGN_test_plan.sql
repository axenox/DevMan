/*
 * Add sprint and state fields to test plans.
 *
 * Existing columns and constraints are preserved on repeated installation.
 *
 * @author OpenAI
 */
-- UP
CALL execute_sql_on_missing_column('test_plan', 'sprint_id',
    'ALTER TABLE `test_plan` ADD COLUMN `sprint_id` int NULL');
CALL execute_sql_on_missing_column('test_plan', 'state',
    'ALTER TABLE `test_plan` ADD COLUMN `state` int NOT NULL DEFAULT 10');
SET @devman_test_plan_sprint_sql = (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE `test_plan` ADD CONSTRAINT `FK_test_plan_sprint` FOREIGN KEY (`sprint_id`) REFERENCES `sprint` (`id`)',
        'SELECT 1')
    FROM information_schema.key_column_usage AS k
    WHERE k.constraint_schema = DATABASE() AND k.table_name = 'test_plan'
      AND k.column_name = 'sprint_id'
      AND k.referenced_table_name = 'sprint');
PREPARE devman_test_plan_sprint_stmt FROM @devman_test_plan_sprint_sql;
EXECUTE devman_test_plan_sprint_stmt;
DEALLOCATE PREPARE devman_test_plan_sprint_stmt;

-- DOWN
-- Keep test plan fields because they may contain business data.

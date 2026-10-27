/*
 * Add ticket severity and test case relation from the current database.
 *
 * Existing columns and constraints are preserved on repeated installation.
 *
 * @author OpenAI
 */
-- UP
CALL execute_sql_on_missing_column('ticket', 'severity',
    'ALTER TABLE `ticket` ADD COLUMN `severity` int NULL');
CALL execute_sql_on_missing_column('ticket', 'test_case_id',
    'ALTER TABLE `ticket` ADD COLUMN `test_case_id` int NULL');
SET @devman_ticket_test_case_sql = (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE `ticket` ADD CONSTRAINT `FK_ticket_test_case` FOREIGN KEY (`test_case_id`) REFERENCES `test_case` (`id`)',
        'SELECT 1')
    FROM information_schema.key_column_usage AS k
    WHERE k.constraint_schema = DATABASE() AND k.table_name = 'ticket'
      AND k.column_name = 'test_case_id'
      AND k.referenced_table_name = 'test_case');
PREPARE devman_ticket_test_case_stmt FROM @devman_ticket_test_case_sql;
EXECUTE devman_ticket_test_case_stmt;
DEALLOCATE PREPARE devman_ticket_test_case_stmt;

-- DOWN
-- Keep ticket fields because they may contain business data.

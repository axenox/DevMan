/*
 * Remove redundant relations and indexes absent from the current model.
 *
 * Composite indexes continue to support release application lookups.
 *
 * @author OpenAI
 */
-- UP
SET @devman_external_test_fk_sql = (
    SELECT IF(COUNT(*) = 0, 'SELECT 1',
        CONCAT('ALTER TABLE `external_test_link` DROP FOREIGN KEY `',
            MAX(k.constraint_name), '`'))
    FROM information_schema.key_column_usage AS k
    WHERE k.constraint_schema = DATABASE()
      AND k.table_name = 'external_test_link'
      AND k.column_name = 'test_plan_id'
      AND k.referenced_table_name = 'test_plan');
PREPARE devman_external_test_fk_stmt FROM @devman_external_test_fk_sql;
EXECUTE devman_external_test_fk_stmt;
DEALLOCATE PREPARE devman_external_test_fk_stmt;
SET @devman_external_test_index_sql = (
    SELECT IF(COUNT(*) = 0, 'SELECT 1',
        CONCAT('ALTER TABLE `external_test_link` DROP INDEX `',
            MAX(s.index_name), '`'))
    FROM information_schema.statistics AS s
    WHERE s.table_schema = DATABASE()
      AND s.table_name = 'external_test_link'
      AND s.index_name <> 'PRIMARY'
      AND s.index_name IN (
          SELECT x.index_name FROM information_schema.statistics AS x
          WHERE x.table_schema = DATABASE()
            AND x.table_name = 'external_test_link'
          GROUP BY x.index_name
          HAVING GROUP_CONCAT(x.column_name ORDER BY x.seq_in_index)
              = 'test_plan_id'));
PREPARE devman_external_test_index_stmt
    FROM @devman_external_test_index_sql;
EXECUTE devman_external_test_index_stmt;
DEALLOCATE PREPARE devman_external_test_index_stmt;
SET @devman_release_app_index_sql = (
    SELECT IF(COUNT(*) = 0, 'SELECT 1',
        CONCAT('ALTER TABLE `release_applications` DROP INDEX `',
            MAX(s.index_name), '`'))
    FROM information_schema.statistics AS s
    WHERE s.table_schema = DATABASE()
      AND s.table_name = 'release_applications'
      AND s.index_name <> 'PRIMARY'
      AND s.index_name IN (
          SELECT x.index_name FROM information_schema.statistics AS x
          WHERE x.table_schema = DATABASE()
            AND x.table_name = 'release_applications'
          GROUP BY x.index_name
          HAVING GROUP_CONCAT(x.column_name ORDER BY x.seq_in_index)
              = 'release_id'));
PREPARE devman_release_app_index_stmt FROM @devman_release_app_index_sql;
EXECUTE devman_release_app_index_stmt;
DEALLOCATE PREPARE devman_release_app_index_stmt;

-- DOWN
-- Redundant objects are not recreated automatically.

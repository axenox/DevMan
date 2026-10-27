/*
 * Add milestone fields and relations present in the current database.
 *
 * Existing columns and constraints are preserved on repeated installation.
 *
 * @author OpenAI
 */
-- UP
CALL execute_sql_on_missing_column('milestone', 'release_id',
    'ALTER TABLE `milestone` ADD COLUMN `release_id` int NULL');
CALL execute_sql_on_missing_column('milestone', 'milestone_type_id',
    'ALTER TABLE `milestone` ADD COLUMN `milestone_type_id` int NULL');
CALL execute_sql_on_missing_column('milestone', 'status',
    'ALTER TABLE `milestone` ADD COLUMN `status` varchar(50) NULL');
CALL execute_sql_on_missing_column('milestone', 'date_to',
    'ALTER TABLE `milestone` ADD COLUMN `date_to` date NULL');
CALL execute_sql_on_missing_column('milestone', 'installation_id',
    'ALTER TABLE `milestone` ADD COLUMN `installation_id` int NULL');
SET @devman_milestone_release_sql = (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE `milestone` ADD CONSTRAINT `FK_milestone_release` FOREIGN KEY (`release_id`) REFERENCES `release` (`id`)',
        'SELECT 1')
    FROM information_schema.key_column_usage AS k
    WHERE k.constraint_schema = DATABASE() AND k.table_name = 'milestone'
      AND k.column_name = 'release_id' AND k.referenced_table_name = 'release');
PREPARE devman_milestone_release_stmt FROM @devman_milestone_release_sql;
EXECUTE devman_milestone_release_stmt;
DEALLOCATE PREPARE devman_milestone_release_stmt;
SET @devman_milestone_type_sql = (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE `milestone` ADD CONSTRAINT `FK_milestone_type` FOREIGN KEY (`milestone_type_id`) REFERENCES `milestone_type` (`id`)',
        'SELECT 1')
    FROM information_schema.key_column_usage AS k
    WHERE k.constraint_schema = DATABASE() AND k.table_name = 'milestone'
      AND k.column_name = 'milestone_type_id'
      AND k.referenced_table_name = 'milestone_type');
PREPARE devman_milestone_type_stmt FROM @devman_milestone_type_sql;
EXECUTE devman_milestone_type_stmt;
DEALLOCATE PREPARE devman_milestone_type_stmt;
SET @devman_milestone_installation_sql = (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE `milestone` ADD CONSTRAINT `FK_milestone_installation` FOREIGN KEY (`installation_id`) REFERENCES `installation` (`id`)',
        'SELECT 1')
    FROM information_schema.key_column_usage AS k
    WHERE k.constraint_schema = DATABASE() AND k.table_name = 'milestone'
      AND k.column_name = 'installation_id'
      AND k.referenced_table_name = 'installation');
PREPARE devman_milestone_installation_stmt
    FROM @devman_milestone_installation_sql;
EXECUTE devman_milestone_installation_stmt;
DEALLOCATE PREPARE devman_milestone_installation_stmt;

-- DOWN
-- Keep milestone fields because they may contain business data.

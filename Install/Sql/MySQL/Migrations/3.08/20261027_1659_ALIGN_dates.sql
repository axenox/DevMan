/*
 * Align the calendar table with the current DevMan database.
 *
 * Existing identifiers and calendar rows are preserved.
 *
 * @author OpenAI
 */
-- UP
ALTER TABLE `dates`
    MODIFY `year_no` int NOT NULL,
    MODIFY `quarter_no` int NOT NULL,
    MODIFY `month_no` int NOT NULL,
    MODIFY `week_no` int NOT NULL,
    MODIFY `day_no` int NOT NULL,
    MODIFY `weekday_no` int NOT NULL,
    MODIFY `weekend_flag` tinyint DEFAULT 0,
    MODIFY `id` int NOT NULL;
SET @devman_dates_ymd_sql = (
    SELECT IF(COUNT(*) = 0,
        'ALTER TABLE `dates` ADD UNIQUE KEY `UQ_dates_ymd` (`year_no`, `month_no`, `day_no`)',
        'SELECT 1')
    FROM information_schema.statistics AS s
    WHERE s.table_schema = DATABASE() AND s.table_name = 'dates'
      AND s.non_unique = 0 AND s.index_name IN (
          SELECT x.index_name FROM information_schema.statistics AS x
          WHERE x.table_schema = DATABASE() AND x.table_name = 'dates'
          GROUP BY x.index_name
          HAVING GROUP_CONCAT(x.column_name ORDER BY x.seq_in_index)
              = 'year_no,month_no,day_no'));
PREPARE devman_dates_ymd_stmt FROM @devman_dates_ymd_sql;
EXECUTE devman_dates_ymd_stmt;
DEALLOCATE PREPARE devman_dates_ymd_stmt;

-- DOWN
-- Keep the wider numeric types and identifiers to avoid truncating data.

/*
 * Add the calendar required by daily test statistics and sprint charts.
 *
 * Populate 2000-2099, including days without tests. Weekdays start on Monday
 * and week numbers follow ISO 8601. Existing calendar rows are preserved.
 * DOWN preserves the calendar to avoid deleting existing data.
 *
 * @author GitHub Copilot
 */
-- UP
CREATE TABLE IF NOT EXISTS `dates` (
    `id` int NOT NULL AUTO_INCREMENT,
    `date` date NOT NULL,
    `year_no` smallint NOT NULL,
    `quarter_no` tinyint NOT NULL,
    `month_no` tinyint NOT NULL,
    `week_no` tinyint NOT NULL,
    `day_no` tinyint NOT NULL,
    `weekday_no` tinyint NOT NULL,
    `weekend_flag` tinyint NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `UQ_dates_date` (`date`)
);

-- Fill missing calendar days without changing existing identifiers or values.
INSERT INTO `dates` (
    `date`, `year_no`, `quarter_no`, `month_no`, `week_no`,
    `day_no`, `weekday_no`, `weekend_flag`
)
SELECT
    calendar.`date`,
    YEAR(calendar.`date`),
    QUARTER(calendar.`date`),
    MONTH(calendar.`date`),
    WEEK(calendar.`date`, 3),
    DAYOFMONTH(calendar.`date`),
    WEEKDAY(calendar.`date`) + 1,
    IF(WEEKDAY(calendar.`date`) >= 5, 1, 0)
FROM (
    SELECT DATE_ADD('2000-01-01', INTERVAL (
        units.n + 10 * tens.n + 100 * hundreds.n
        + 1000 * thousands.n + 10000 * ten_thousands.n
    ) DAY) AS `date`
    FROM (
        SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2
        UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
        UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8
        UNION ALL SELECT 9
    ) units
    CROSS JOIN (
        SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2
        UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
        UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8
        UNION ALL SELECT 9
    ) tens
    CROSS JOIN (
        SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2
        UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
        UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8
        UNION ALL SELECT 9
    ) hundreds
    CROSS JOIN (
        SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2
        UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
        UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8
        UNION ALL SELECT 9
    ) thousands
    CROSS JOIN (
        SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2
        UNION ALL SELECT 3
    ) ten_thousands
) calendar
LEFT JOIN `dates` existing ON existing.`date` = calendar.`date`
WHERE calendar.`date` < '2100-01-01' AND existing.`id` IS NULL
ORDER BY calendar.`date`;

-- DOWN
-- Preserve calendar rows and identifiers used by statistics and relations.
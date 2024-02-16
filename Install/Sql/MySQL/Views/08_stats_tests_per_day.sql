CREATE OR REPLACE VIEW stats_tests_per_day AS

SELECT
    d.id AS dates_id,
    d.date,
    s.id AS sprint_id,
    (SELECT 
        COUNT(1)
        FROM test_case tcc
        WHERE DATE(tcc.created_on) = d.date
    ) AS test_cases_created,
    (SELECT 
        COUNT(1)
        FROM test_log tle
        WHERE DATE(tle.tested_on) = d.date
    ) AS tests_done,
    (SELECT 
        COUNT(DISTINCT tlc.test_case_id)
        FROM test_log tlc
        WHERE DATE(tlc.tested_on) = d.date
    ) AS test_cases_done
FROM dates d
    LEFT JOIN sprint s ON d.date >= s.start_on AND d.date <= s.end_on
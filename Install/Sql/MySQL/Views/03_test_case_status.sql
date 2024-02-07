CREATE OR REPLACE VIEW test_case_status AS

SELECT
	tmp.*,
	CASE
		WHEN tmp.retest_required_time IS NOT NULL AND tmp.last_test_time < tmp.retest_required_time THEN 'TODO'
		WHEN tlc2.test_ok_flag != 0 AND NOT(tmp.last_test_time IS NOT NULL AND (tmp.last_change_time IS NULL OR tmp.last_change_time < tlc2.tested_build_time)) THEN 'TODO'
		WHEN tlc2.test_ok_flag = 1 AND tlc2.tested_directly = 1 THEN 'PASS'
		WHEN tlc2.test_ok_flag = 1 AND tlc2.tested_directly = 0 THEN 'COVERED'
		WHEN tlc2.test_ok_flag = 0 AND tlc2.tested_directly = 1 THEN 'FAIL'
		WHEN tlc2.test_ok_flag = 0 AND tlc2.tested_directly = 0 THEN 'FAIL_COVER'
		ELSE 'TODO'
	END AS test_status,
	tlc2.test_log_id AS last_test_log_id,
	tlc2.tested_by_resource_id AS last_test_by_resource_id,
	tlc2.tested_directly
FROM (
		SELECT 
			tc.id AS test_case_id,
			tc.retest_required_time,
			(f.priority * IFNULL(tc.priority, 1)) AS priority_weighted,
			(SELECT MAX(fc.active_since) FROM feature_update fc WHERE fc.feature_id = tc.feature_id) AS last_change_time,
			(SELECT MAX(tlc.tested_on) FROM test_log_coverage tlc WHERE tlc.test_case_id = tc.id) AS last_test_time
		FROM
			test_case tc
			INNER JOIN feature f ON tc.feature_id = f.id
	) tmp
	LEFT JOIN test_log_coverage tlc2 ON tlc2.test_case_id = tmp.test_case_id AND tlc2.tested_on = tmp.last_test_time;
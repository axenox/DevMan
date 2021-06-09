CREATE OR REPLACE VIEW test_case_status AS

SELECT
	tmp.*,
	CASE
		WHEN tmp.last_test_time IS NOT NULL AND (tmp.last_change_time IS NULL OR tmp.last_change_time < tmp.last_test_time) AND  tlc2.test_ok_flag = 1 THEN 'PASS'
		WHEN tmp.last_test_time IS NOT NULL AND (tmp.last_change_time IS NULL OR tmp.last_change_time < tmp.last_test_time) AND tlc2.test_ok_flag = 0 THEN 'FAIL'
		ELSE 'TODO'
	END AS test_status,
	tlc2.test_log_id AS last_test_log_id,
	tlc2.tested_by_resource_id AS last_test_by_resource_id,
	tlc2.tested_directly,
	tlc2.test_ok_flag
FROM (
		SELECT 
			tc.id AS test_case_id,
			(SELECT MAX(fc.active_since) FROM feature_change fc WHERE fc.feature_id = tc.feature_id) AS last_change_time,
			(SELECT MAX(tlc.tested_on) FROM test_log_coverage tlc WHERE tlc.test_case_id = tc.id) AS last_test_time
		FROM
			test_case tc
			INNER JOIN feature f ON tc.feature_id = f.id
	) tmp
	LEFT JOIN test_log_coverage tlc2 ON tlc2.test_case_id = tmp.test_case_id AND tlc2.tested_on = tmp.last_test_time;
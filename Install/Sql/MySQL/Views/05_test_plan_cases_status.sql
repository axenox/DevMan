CREATE OR REPLACE VIEW test_plan_cases_status AS

SELECT
	tmp.*,
	CASE
		WHEN tmp.last_test_time IS NOT NULL AND (tmp.last_change_time IS NULL OR tmp.last_change_time < tl2.tested_build_time) AND tl2.test_ok_flag = 1 THEN 'PASS'
		WHEN tmp.last_test_time IS NOT NULL AND (tmp.last_change_time IS NULL OR tmp.last_change_time < tl2.tested_build_time) AND tl2.test_ok_flag = 0 THEN 'FAIL'
		ELSE 'TODO'
	END AS test_status,
	tl2.id AS last_test_log_id,
	tl2.tested_by_resource_id AS last_test_by_resource_id,
	tl2.test_ok_flag
FROM (
		SELECT 
			tpc.id AS test_plan_cases_id,
			tpc.test_plan_id,
			tc.id AS test_case_id,
			(SELECT MAX(fc.active_since) FROM feature_update fc WHERE fc.feature_id = tc.feature_id) AS last_change_time,
			(SELECT MAX(tl.tested_on) FROM test_log tl WHERE tl.test_case_id = tc.id) AS last_test_time
		FROM
			test_plan_cases tpc
			INNER JOIN test_case tc ON tc.id = tpc.id
			INNER JOIN feature f ON tc.feature_id = f.id
	) tmp
	LEFT JOIN test_log tl2 ON tl2.test_case_id = tmp.test_case_id AND tl2.tested_on = tmp.last_test_time
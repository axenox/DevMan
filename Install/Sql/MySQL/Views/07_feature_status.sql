CREATE OR REPLACE VIEW feature_status AS
SELECT
	tmp.*,
	CASE
		WHEN tmp.cases_ok IS NULL AND cases_total = 0 THEN NULL
		WHEN tmp.cases_ok IS NULL THEN 0
		ELSE tmp.cases_ok/tmp.cases_total*100
	END AS  cases_ok_percentage
	FROM (
		SELECT 
			f.id AS feature_id,
			SUM(tcs.test_ok_flag) AS cases_ok,
			SUM(IF(tcs.test_status != 'TODO' AND tcs.test_ok_flag = 0, 1, 0)) AS cases_failed,
			SUM(IF(tcs.test_status != 'TODO', 1, 0)) AS cases_tested,
			SUM(IF(tcs.test_status = 'TODO', 1, 0)) AS cases_todo,
			COUNT(tcs.test_case_id) AS cases_total
		FROM feature f
			LEFT JOIN (
				test_case_status tcs
				INNER JOIN test_case tc ON tc.id = tcs.test_case_id
			) ON tc.feature_id = f.id 
		GROUP BY f.id) tmp
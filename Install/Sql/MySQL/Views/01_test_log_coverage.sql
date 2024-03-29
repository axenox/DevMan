CREATE OR REPLACE VIEW test_log_coverage AS

SELECT 
	tl.tested_on,
	tl.test_ok_flag,
	tl.tested_by_resource_id,
	tl.tested_workbench_version,
	tl.tested_build_time,
	tl.id AS test_log_id,
	tl.test_case_id AS tested_test_case_id,
	tl.test_case_id AS test_case_id,
	1 AS tested_directly
FROM
	test_log tl

UNION ALL

SELECT 
	tl.tested_on,
	tl.test_ok_flag,
	tl.tested_by_resource_id,
	tl.tested_workbench_version,
	tl.tested_build_time,
	tl.id AS test_log_id,
	tl.test_case_id AS tested_test_case_id,
	tcc.covers_test_case_id AS test_case_id,
	0 AS tested_directly
FROM
	test_log tl
	INNER JOIN test_case_coverage tcc ON tl.test_case_id = tcc.test_case_id;
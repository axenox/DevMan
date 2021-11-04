CREATE OR REPLACE VIEW feature_test_cases AS

SELECT 
		tc.feature_id,
		tc.id AS test_case_id,
		1 AS direct_flag
	FROM test_case tc 
		
UNION ALL

SELECT DISTINCT
	tcctc.feature_id,
	tcc.test_case_id,
	0 AS direct_flag
	FROM test_case_coverage tcc
		INNER JOIN test_case tcctc ON tcc.covers_test_case_id = tcctc.id;
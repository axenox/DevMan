-- UP

RENAME TABLE `test_case_covers` TO `test_case_coverage`;

DROP VIEW IF EXISTS test_case_covers;

-- DOWN

DROP VIEW IF EXISTS test_case_coverage;

RENAME TABLE `test_case_coverage` TO `test_case_covers`;
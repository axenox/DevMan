-- UP

DROP VIEW IF EXISTS test_case_covers;

RENAME TABLE `test_case_covers` TO `test_case_coverage`;

-- DOWN

DROP VIEW IF EXISTS test_case_coverage;

RENAME TABLE `test_case_coverage` TO `test_case_covers`;
-- UP

ALTER TABLE `external_test_link`
CHANGE `test_plan_id` `test_plan_id` int(11) NULL AFTER `external_system_id`;
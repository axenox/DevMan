-- UP 

ALTER TABLE `test_plan_cases`
ADD `assigned_to_resource_id` int(11) NULL,
ADD FOREIGN KEY (`assigned_to_resource_id`) REFERENCES `resource` (`id`);

-- DOWN
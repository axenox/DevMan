-- UP 

ALTER TABLE `test_plan`
ADD `release_id` int(11) NULL,
ADD FOREIGN KEY (`release_id`) REFERENCES `release` (`id`);

-- DOWN
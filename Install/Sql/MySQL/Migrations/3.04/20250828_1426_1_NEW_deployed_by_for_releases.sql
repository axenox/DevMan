-- UP 

ALTER TABLE `release_deployments`
ADD `deployed_by_resource_id` int(11) NOT NULL AFTER `deployed_on`,
ADD FOREIGN KEY (`deployed_by_resource_id`) REFERENCES `resource` (`id`);

-- DOWN
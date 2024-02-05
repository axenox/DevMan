-- UP
	
DROP TABLE IF EXISTS `project_report`;
	
-- DOWN

CREATE TABLE IF NOT EXISTS `project_report` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by_user_oid` binary(16) NOT NULL,
  `modified_by_user_oid` binary(16) NOT NULL,
  `project_id` int NOT NULL,
  `date` date NOT NULL,
  `summary` varchar(200) NOT NULL,
  `outlook` varchar(200) NOT NULL,
  `details` text,
  `streetlight` varchar(10) NOT NULL,
  `trubulence` tinyint NOT NULL,
  `workload` tinyint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `project_id` (`project_id`),
  CONSTRAINT `project_report_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

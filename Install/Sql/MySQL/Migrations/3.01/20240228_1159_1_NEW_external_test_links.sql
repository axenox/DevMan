-- UP

CREATE TABLE IF NOT EXISTS `external_test_link` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT current_timestamp(),
  `modified_on` datetime NOT NULL DEFAULT current_timestamp(),
  `created_by_user_oid` binary(16) NOT NULL,
  `modified_by_user_oid` binary(16) NOT NULL,
  `external_system_id` int(11) NOT NULL,
  `test_plan_id` int(11) NOT NULL,
  `test_case_id` int(11) DEFAULT NULL,
  `external_ticket_id` varchar(400) NOT NULL DEFAULT '',
  `custom_url` varchar(400) DEFAULT '',
  `comment` varchar(400) DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `test_case_id` (`test_case_id`),
  KEY `test_plan_id` (`test_plan_id`),
  CONSTRAINT `external_test_link_ibfk_1` FOREIGN KEY (`test_case_id`) REFERENCES `test_case` (`id`),
  CONSTRAINT `external_test_link_ibfk_2` FOREIGN KEY (`test_plan_id`) REFERENCES `test_plan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- DOWN

-- Don't remove the table automatically in case there is data
-- UP

CREATE TABLE IF NOT EXISTS `test_case_files` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by_user_oid` binary(16) NOT NULL,
  `modified_by_user_oid` binary(16) NOT NULL,
  `schema` varchar(200) NOT NULL,
  `test_case_id` int DEFAULT NULL,
  `file` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `option` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `autocreated_flag` tinyint NOT NULL DEFAULT '0',
  `not_found_flag` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `unique` (`file`,`option`,`test_case_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- DOWN

DROP TABLE IF EXISTS `test_case_files`;
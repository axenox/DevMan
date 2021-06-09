-- UP

ALTER TABLE `application`
	CHANGE COLUMN `latest_version` `latest_version` VARCHAR(20) NOT NULL DEFAULT '' COLLATE 'utf8_general_ci' AFTER `description`;

CREATE TABLE IF NOT EXISTS `feature_change` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by_user_oid` binary(16) NOT NULL,
  `modified_by_user_oid` binary(16) NOT NULL,
  `feature_id` int NOT NULL,
  `summary` varchar(100) NOT NULL,
  `active_since` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `app_version` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `change_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `unique` (`feature_id`,`change_id`),
  KEY `feature, active` (`feature_id`,`active_since`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- DOWN

ALTER TABLE `application`
	DROP COLUMN `latest_version`;
	
DROP TABLE IF EXISTS `feature_change`;
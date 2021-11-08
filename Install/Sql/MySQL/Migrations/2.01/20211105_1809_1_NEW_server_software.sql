-- UP

CREATE TABLE IF NOT EXISTS `server` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by_user_oid` binary(16) NOT NULL,
  `modified_by_user_oid` binary(16) NOT NULL,
  `client_id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `url` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `Unique name per client` (`client_id`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `server_software_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by_user_oid` binary(16) NOT NULL,
  `modified_by_user_oid` binary(16) NOT NULL,
  `server_id` int NOT NULL,
  `software_id` int NOT NULL,
  `version` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `update_interval_months` int DEFAULT NULL,
  `installed_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `uninstalled_on` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `Unique software per server and installation time` (`server_id`,`software_id`,`installed_on`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `software` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by_user_oid` binary(16) NOT NULL,
  `modified_by_user_oid` binary(16) NOT NULL,
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `latest_version` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `least_version` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

INSERT INTO `server` (id, created_on, created_by_user_oid, modified_on, modified_by_user_oid, `name`, url, client_id)
SELECT id, created_on, created_by_user_oid, modified_on, modified_by_user_oid, `name`, url, client_id FROM `installation`;

ALTER TABLE `installation`
	ADD COLUMN `server_id` INT(10) NOT NULL AFTER `client_id`;

UPDATE `installation` SET server_id = id;

ALTER TABLE `installation`
	DROP COLUMN `client_id`;

-- DOWN

ALTER TABLE `installation`
	ADD COLUMN `client_id` INT(10) NOT NULL AFTER `server_id`;

UPDATE `installation` SET client_id = (SELECT s.client_id FROM server s WHERE s.id = server_id);

ALTER TABLE `installation`
	DROP COLUMN `server_id`;
	
DROP TABLE IF EXISTS `server`;
DROP TABLE IF EXISTS `server_software_log`;
DROP TABLE IF EXISTS `software`;


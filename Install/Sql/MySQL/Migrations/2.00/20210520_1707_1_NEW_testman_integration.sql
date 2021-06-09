-- UP

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `application`
--

CREATE TABLE IF NOT EXISTS `application` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by_user_oid` binary(16) NOT NULL,
  `modified_by_user_oid` binary(16) NOT NULL,
  `name` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `app_alias` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `client_id` int NOT NULL,
  `package_url` varchar(200) DEFAULT NULL,
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `application_features`
--

CREATE TABLE IF NOT EXISTS `application_features` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by_user_oid` binary(16) NOT NULL,
  `modified_by_user_oid` binary(16) NOT NULL,
  `application_id` int NOT NULL,
  `feature_id` int NOT NULL,
  `description` varchar(400) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `unique_feature_per_app` (`application_id`,`feature_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `application_test_scenarios`
--

CREATE TABLE IF NOT EXISTS `application_test_scenarios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by_user_oid` binary(16) NOT NULL,
  `modified_by_user_oid` binary(16) NOT NULL,
  `application_id` int NOT NULL,
  `client_id` int NOT NULL,
  `priority` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_scenario_per_app` (`client_id`,`application_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `feature`
--

CREATE TABLE IF NOT EXISTS `feature` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by_user_oid` binary(16) NOT NULL,
  `modified_by_user_oid` binary(16) NOT NULL,
  `name` varchar(128) NOT NULL,
  `module_id` int NOT NULL,
  `parent_feature_id` int DEFAULT NULL,
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci,
  `test_setup` longtext,
  PRIMARY KEY (`id`),
  KEY `module` (`module_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `module`
--

CREATE TABLE IF NOT EXISTS `module` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by_user_oid` binary(16) NOT NULL,
  `modified_by_user_oid` binary(16) NOT NULL,
  `name` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `application_id` int NOT NULL,
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci,
  `test_setup` longtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `test_case`
--

CREATE TABLE IF NOT EXISTS `test_case` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by_user_oid` binary(16) NOT NULL,
  `modified_by_user_oid` binary(16) NOT NULL,
  `name` varchar(128) NOT NULL,
  `description` text NOT NULL,
  `feature_id` int NOT NULL,
  `effort_planned` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `feature_id` (`feature_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `test_log`
--

CREATE TABLE IF NOT EXISTS `test_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by_user_oid` binary(16) NOT NULL,
  `modified_by_user_oid` binary(16) NOT NULL,
  `test_case_id` int NOT NULL,
  `tested_installation` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `tested_version` varchar(40) DEFAULT NULL,
  `tested_on` datetime NOT NULL,
  `tested_by_resource_id` int NOT NULL,
  `comment` text,
  `test_description` text,
  `topic_id` int DEFAULT NULL,
  `effort` time DEFAULT NULL,
  `test_ok_flag` tinyint(1) NOT NULL DEFAULT '0',
  `test_plan_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `test_case_ok_flag` (`test_case_id`,`test_ok_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `test_plan`
--

CREATE TABLE IF NOT EXISTS `test_plan` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by_user_oid` binary(16) NOT NULL,
  `modified_by_user_oid` binary(16) NOT NULL,
  `name` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci,
  `milestone_id` int DEFAULT NULL,
  `closed_flag` tinyint(1) NOT NULL DEFAULT '0',
  `resource_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `test_plan_cases`
--

CREATE TABLE IF NOT EXISTS `test_plan_cases` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by_user_oid` binary(16) NOT NULL,
  `modified_by_user_oid` binary(16) NOT NULL,
  `priority_id` int NOT NULL,
  `test_plan_id` int NOT NULL,
  `test_case_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `case_unique_per_plan` (`test_plan_id`,`test_case_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `test_scenario`
--

CREATE TABLE IF NOT EXISTS `test_scenario` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by_user_oid` binary(16) NOT NULL,
  `modified_by_user_oid` binary(16) NOT NULL,
  `name` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `test_type_id` int NOT NULL,
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci,
  PRIMARY KEY (`id`),
  KEY `test_type_id` (`test_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `test_scenario_cases`
--

CREATE TABLE IF NOT EXISTS `test_scenario_cases` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by_user_oid` binary(16) NOT NULL,
  `modified_by_user_oid` binary(16) NOT NULL,
  `test_scenario_id` int NOT NULL,
  `test_case_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `case_unique_per_scenario` (`test_scenario_id`,`test_case_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `test_type`
--

CREATE TABLE IF NOT EXISTS `test_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `created_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_on` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by_user_oid` binary(16) NOT NULL,
  `modified_by_user_oid` binary(16) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- DOWN


DROP TABLE IF EXISTS `application`;
DROP TABLE IF EXISTS `application_features`;
DROP TABLE IF EXISTS `application_test_scenarios`;
DROP TABLE IF EXISTS `feature`;
DROP TABLE IF EXISTS `module`;
DROP TABLE IF EXISTS `test_case`;
DROP TABLE IF EXISTS `test_log`;
DROP TABLE IF EXISTS `test_plan`;
DROP TABLE IF EXISTS `test_plan_cases`;
DROP TABLE IF EXISTS `test_scenario`;
DROP TABLE IF EXISTS `test_scenario_cases`;
DROP TABLE IF EXISTS `test_type`;

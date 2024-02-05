-- UP

ALTER TABLE `installation`
	ADD COLUMN `client_id` INT NOT NULL;
ALTER TABLE `installation`
	ADD COLUMN `deployer_host_alias` VARCHAR(100) NULL DEFAULT NULL;
	
UPDATE installation SET client_id = (SELECT client_id FROM server s WHERE s.id = server_id);
	
ALTER TABLE `installation`
	DROP COLUMN `server_id`;
	
DROP VIEW IF EXISTS `server_software`;
DROP TABLE IF EXISTS `server`;
DROP TABLE IF EXISTS `software`;
DROP TABLE IF EXISTS `server_software_log`;
	
-- DOWN
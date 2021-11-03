-- UP

ALTER TABLE `ticket`
	ADD COLUMN `assigned_at_pos` INT(10) NULL DEFAULT NULL AFTER `assigned_to`;

ALTER TABLE `client`
	ADD COLUMN `importance` INT NOT NULL DEFAULT '0' AFTER `description`;

-- DOWN

ALTER TABLE `ticket`
	DROP COLUMN `assigned_at_pos`;
	
ALTER TABLE `client`
	DROP COLUMN `importance`;



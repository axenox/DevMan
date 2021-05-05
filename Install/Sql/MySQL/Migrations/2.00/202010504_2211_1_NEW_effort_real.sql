-- UP

ALTER TABLE `milestone`
	ADD COLUMN `effort_real_h` DECIMAL(5,1) NULL DEFAULT NULL AFTER `effort_rem_estimated_h`;
	
ALTER TABLE `topic`
	ADD COLUMN `effort_real_h` DECIMAL(5,1) NULL DEFAULT NULL AFTER `effort_rem_estimated_h`;

-- DOWN

ALTER TABLE `milestone`
	DROP COLUMN `effort_real_h`;

ALTER TABLE `topic`
	DROP COLUMN `effort_real_h`;
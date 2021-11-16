-- UP

ALTER TABLE `sprint`
	ADD COLUMN `closed_flag` TINYINT NOT NULL DEFAULT 0 AFTER `description`;


-- DOWN

ALTER TABLE `sprint`
	DROP COLUMN `closed_flag`;



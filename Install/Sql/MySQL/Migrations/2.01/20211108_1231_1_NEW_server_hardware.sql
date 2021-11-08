-- UP

ALTER TABLE `server`
	ADD COLUMN `public` TINYINT NOT NULL DEFAULT '0' AFTER `url`,
	ADD COLUMN `cpu` VARCHAR(100) NULL AFTER `public`,
	ADD COLUMN `ram_gb` INT NULL AFTER `cpu`,
	ADD COLUMN `storage_gb` INT NULL AFTER `ram_gb`;


-- DOWN

ALTER TABLE `server`
	DROP COLUMN `public`,
	DROP COLUMN `cpu`,
	DROP COLUMN `ram_gb`,
	DROP COLUMN `storage_gb`;


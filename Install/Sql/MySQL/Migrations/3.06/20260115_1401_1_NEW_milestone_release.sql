-- UP 

ALTER TABLE `release`
ADD `release_notes` text COLLATE 'utf8mb3_general_ci' NULL;

ALTER TABLE `milestone`
ADD `show_in_calendar` tinyint NOT NULL DEFAULT '1';

-- DOWN


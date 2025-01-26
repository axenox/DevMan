-- UP

ALTER TABLE `ticket`
CHANGE `description` `description` longtext NULL;

-- DOWN

ALTER TABLE `ticket`
CHANGE `description` `description` text NULL;
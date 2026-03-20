-- UP

ALTER TABLE `ticket`
ADD `milestone_at_pos` int NULL AFTER `milestone_id`;

-- DOWN

-- DO NOT drop columns to avoid data loss.
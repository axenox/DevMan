/*
 * Add ticket ordering within a milestone.
 *
 * milestone_id already exists from the earlier topic migrations.
 * Add milestone_at_pos only if missing so installation retries are safe.
 *
 * DOWN preserves the column to avoid losing existing ticket positions.
 *
 * @author OpenAI
 */
-- UP
CALL execute_sql_on_missing_column(
    'ticket',
    'milestone_at_pos',
    'ALTER TABLE `ticket` ADD COLUMN `milestone_at_pos` int(11) NULL AFTER `milestone_id`'
);

-- DOWN
-- DO NOT drop columns to avoid data loss.
/*
 * Add the incident flag required by the ticket type model and master data.
 *
 * Existing installations may already have this column from manual changes.
 * DOWN preserves the column to avoid losing ticket type classifications.
 *
 * @author GitHub Copilot
 */
-- UP
CALL execute_sql_on_missing_column(
    'ticket_type',
    'incident_flag',
    'ALTER TABLE `ticket_type` ADD COLUMN `incident_flag` TINYINT NOT NULL DEFAULT 0 AFTER `bug_flag`'
);

-- DOWN
-- DO NOT drop the column to avoid losing existing incident classifications.
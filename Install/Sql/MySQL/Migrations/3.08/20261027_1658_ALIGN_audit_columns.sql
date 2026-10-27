/*
 * Align legacy audit columns with the current DevMan database.
 *
 * This keeps nullable user identifiers and deterministic epoch defaults used
 * by the current model. DOWN keeps the definitions to prevent data loss.
 *
 * @author OpenAI
 */
-- UP
ALTER TABLE `approval`
    MODIFY `created_on` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    MODIFY `modified_on` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    MODIFY `created_by_user_oid` binary(16) DEFAULT NULL,
    MODIFY `modified_by_user_oid` binary(16) DEFAULT NULL;
ALTER TABLE `client`
    MODIFY `created_on` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    MODIFY `modified_on` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    MODIFY `created_by_user_oid` binary(16) DEFAULT NULL,
    MODIFY `modified_by_user_oid` binary(16) DEFAULT NULL;
ALTER TABLE `milestone`
    MODIFY `created_on` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    MODIFY `modified_on` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    MODIFY `created_by_user_oid` binary(16) DEFAULT NULL,
    MODIFY `modified_by_user_oid` binary(16) DEFAULT NULL;
ALTER TABLE `project`
    MODIFY `created_on` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    MODIFY `modified_on` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    MODIFY `created_by_user_oid` binary(16) DEFAULT NULL,
    MODIFY `modified_by_user_oid` binary(16) DEFAULT NULL;
ALTER TABLE `project_tickets`
    MODIFY `created_on` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    MODIFY `modified_on` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    MODIFY `created_by_user_oid` binary(16) DEFAULT NULL,
    MODIFY `modified_by_user_oid` binary(16) DEFAULT NULL;
ALTER TABLE `resource`
    MODIFY `created_on` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    MODIFY `modified_on` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    MODIFY `created_by_user_oid` binary(16) DEFAULT NULL,
    MODIFY `modified_by_user_oid` binary(16) DEFAULT NULL;
ALTER TABLE `ticket`
    MODIFY `created_on` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    MODIFY `modified_on` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    MODIFY `created_by_user_oid` binary(16) DEFAULT NULL,
    MODIFY `modified_by_user_oid` binary(16) DEFAULT NULL;
ALTER TABLE `ticket_type`
    MODIFY `created_on` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    MODIFY `modified_on` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    MODIFY `created_by_user_oid` binary(16) DEFAULT NULL,
    MODIFY `modified_by_user_oid` binary(16) DEFAULT NULL;
ALTER TABLE `flag`
    MODIFY `created_on` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    MODIFY `modified_on` datetime NOT NULL DEFAULT '1970-01-01 00:00:00';
ALTER TABLE `test_case_flags`
    MODIFY `created_on` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    MODIFY `modified_on` datetime NOT NULL DEFAULT '1970-01-01 00:00:00';

-- DOWN
-- Nullable identifiers cannot safely become NOT NULL after new rows exist.
-- Keep the aligned definitions to preserve data.

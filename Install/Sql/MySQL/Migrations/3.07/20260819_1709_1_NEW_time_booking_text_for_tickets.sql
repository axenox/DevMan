/*
 * Added column for explicit time booking subject for project management systems
 *
 * @author Andrej Kabachnik
 */
-- UP
ALTER TABLE `ticket`
ADD `time_booking_text` varchar(100) NULL;

-- DOWN
-- Do not drop columns!
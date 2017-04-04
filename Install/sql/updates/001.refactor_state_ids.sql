ALTER TABLE `dwm_topic` ADD `state` INT NOT NULL AFTER `state_uid`;
UPDATE dwm_topic t SET t.state = (SELECT s.code FROM dwm_state s WHERE s.uid = t.state_uid);
ALTER TABLE `dwm_topic` DROP `state_uid`;
DROP TABLE `dwm_state`;

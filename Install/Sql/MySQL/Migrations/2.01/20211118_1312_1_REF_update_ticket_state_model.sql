-- UP

UPDATE ticket SET state = 5 WHERE state = 40;
UPDATE ticket SET state = 55 WHERE state = 35;


-- DOWN

UPDATE ticket SET state = 40 WHERE state = 5;
UPDATE ticket SET state = 35 WHERE state = 55;



-- UP

CREATE TABLE IF NOT EXISTS `webhook_log` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,    
    `receive_datetime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `message` longtext NOT NULL,    
    `processed` tinyint(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

-- DOWN

DROP TABLE IF EXISTS `webhook_log`;
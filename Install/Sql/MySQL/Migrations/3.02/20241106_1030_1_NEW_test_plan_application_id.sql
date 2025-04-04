-- UP

ALTER TABLE `test_plan`
ADD `application_id` int(11) NULL;

ALTER TABLE `test_plan`
ADD CONSTRAINT FK_application FOREIGN KEY  (application_id) REFERENCES application(id) ON DELETE RESTRICT ON UPDATE RESTRICT

-- DOWN

ALTER TABLE `test_plan`
DROP FOREIGN KEY FK_application
DROP application_id;
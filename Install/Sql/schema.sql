CREATE TABLE "application" (
    "app_alias" varchar(100) NOT NULL,
    "client_id" int NOT NULL,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "description" text,
    "development_url" varchar(255),
    "id" int NOT NULL AUTO_INCREMENT,
    "latest_version" varchar(20) NOT NULL DEFAULT '',
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "name" varchar(128) NOT NULL,
    "package_url" varchar(200),
    "testing_url" varchar(255),
    PRIMARY KEY ("id")
);

CREATE TABLE "application_file" (
    "application_id" int NOT NULL,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_flag" tinyint NOT NULL DEFAULT 0,
    "filepath" varchar(250) NOT NULL,
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "application_file" ("application_id", "filepath");

CREATE TABLE "approval" (
    "approved_by_resource_id" int NOT NULL,
    "created_by_user_oid" binary(16),
    "created_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "description" varchar(250),
    "effort" decimal(5,1),
    "id" int NOT NULL AUTO_INCREMENT,
    "milestone_id" int,
    "modified_by_user_oid" binary(16),
    "modified_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "project_id" int NOT NULL,
    "resource_id" int,
    "ticket_id" int,
    PRIMARY KEY ("id")
);
CREATE INDEX ON "approval" ("milestone_id");
CREATE INDEX ON "approval" ("project_id");
CREATE INDEX ON "approval" ("ticket_id");

CREATE TABLE "client" (
    "code" varchar(5) NOT NULL,
    "created_by_user_oid" binary(16),
    "created_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "description" text,
    "id" int NOT NULL AUTO_INCREMENT,
    "importance" int NOT NULL DEFAULT 0,
    "modified_by_user_oid" binary(16),
    "modified_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "name" varchar(50) NOT NULL,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "client" ("name");

CREATE TABLE "dates" (
    "date" date NOT NULL,
    "day_no" int NOT NULL,
    "id" int NOT NULL,
    "month_no" int NOT NULL,
    "quarter_no" int NOT NULL,
    "weekday_no" int NOT NULL,
    "weekend_flag" tinyint DEFAULT 0,
    "week_no" int NOT NULL,
    "year_no" int NOT NULL,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "dates" ("date");
CREATE UNIQUE INDEX ON "dates" ("year_no", "month_no", "day_no");

CREATE TABLE "external_system" (
    "client_id" int,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "name" varchar(50) NOT NULL,
    "project_id" int,
    "ticket_url_pattern" varchar(200),
    "url" varchar(200),
    PRIMARY KEY ("id")
);

CREATE TABLE "external_test_link" (
    "comment" varchar(400) DEFAULT '',
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "custom_url" varchar(400) DEFAULT '',
    "external_system_id" int NOT NULL,
    "external_ticket_id" varchar(400) NOT NULL DEFAULT '',
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "test_case_id" int,
    "test_plan_id" int,
    PRIMARY KEY ("id")
);
ALTER TABLE "external_test_link" ADD FOREIGN KEY ("test_case_id") REFERENCES "test_case" ("id");
CREATE INDEX ON "external_test_link" ("test_case_id");

CREATE TABLE "external_ticket_link" (
    "comment" varchar(400) DEFAULT '',
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "custom_url" varchar(400) DEFAULT '',
    "external_system_id" int NOT NULL,
    "external_ticket_id" varchar(400) DEFAULT '',
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ticket_id" int NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE "feature" (
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "description" text,
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "module_id" int NOT NULL,
    "name" varchar(128) NOT NULL,
    "parent_feature_id" int,
    "priority" tinyint,
    "test_setup" longtext,
    PRIMARY KEY ("id")
);
CREATE INDEX ON "feature" ("module_id");

CREATE TABLE "feature_files" (
    "application_file_id" int NOT NULL,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "feature_id" int NOT NULL,
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "feature_files" ("feature_id", "application_file_id");

CREATE TABLE "feature_tickets" (
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "feature_id" int NOT NULL,
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ticket_id" int NOT NULL,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "feature_tickets" ("ticket_id", "feature_id");

CREATE TABLE "flag" (
    "color" varchar(20),
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "description" varchar(500),
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "name" varchar(50) NOT NULL,
    "obstacle_flag" tinyint NOT NULL DEFAULT 0,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "flag" ("name");

CREATE TABLE "installation" (
    "client_id" int NOT NULL,
    "created_by_user_oid" binary(16),
    "created_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "current_build_time" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "current_workbench_version" varchar(30) NOT NULL DEFAULT '',
    "deployer_host_alias" varchar(100),
    "description" text,
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16),
    "modified_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "name" varchar(50) NOT NULL,
    "url" varchar(100) NOT NULL,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "installation" ("name");

CREATE TABLE "milestone" (
    "created_by_user_oid" binary(16),
    "created_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "date" date NOT NULL,
    "date_to" date,
    "description" text,
    "effort_plan_estimated_h" decimal(5,1),
    "effort_real_h" decimal(5,1),
    "effort_rem_estimated_h" decimal(5,1),
    "id" int NOT NULL AUTO_INCREMENT,
    "installation_id" int,
    "location" varchar(50),
    "milestone_type_id" int,
    "modified_by_user_oid" binary(16),
    "modified_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "name" varchar(50) NOT NULL,
    "objectives" varchar(250),
    "project_id" int NOT NULL,
    "release_id" int,
    "show_in_calendar" tinyint NOT NULL DEFAULT 1,
    "status" varchar(50),
    PRIMARY KEY ("id")
);
ALTER TABLE "milestone" ADD FOREIGN KEY ("installation_id") REFERENCES "installation" ("id");
ALTER TABLE "milestone" ADD FOREIGN KEY ("milestone_type_id") REFERENCES "milestone_type" ("id");
ALTER TABLE "milestone" ADD FOREIGN KEY ("release_id") REFERENCES "release" ("id");
CREATE INDEX ON "milestone" ("installation_id");
CREATE INDEX ON "milestone" ("milestone_type_id");
CREATE INDEX ON "milestone" ("release_id");
CREATE UNIQUE INDEX ON "milestone" ("name");

CREATE TABLE "milestone_type" (
    "color" varchar(7) NOT NULL,
    "created_by_user_oid" binary(16),
    "created_on" datetime DEFAULT '1970-01-01 00:00:00',
    "description" varchar(100) NOT NULL,
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16),
    "modified_on" datetime DEFAULT '1970-01-01 00:00:00',
    "name" varchar(50) NOT NULL,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "milestone_type" ("name");

CREATE TABLE "module" (
    "application_id" int NOT NULL,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "description" text,
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "name" varchar(128) NOT NULL,
    "test_setup" longtext,
    PRIMARY KEY ("id")
);

CREATE TABLE "project" (
    "client_id" int NOT NULL DEFAULT 0,
    "created_by_user_oid" binary(16),
    "created_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "date_end" date,
    "date_start" date,
    "description" text,
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16),
    "modified_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "objectives" varchar(250),
    "state" int NOT NULL DEFAULT 10,
    "title" varchar(128) NOT NULL,
    PRIMARY KEY ("id")
);
CREATE INDEX ON "project" ("state");

CREATE TABLE "project_tickets" (
    "comment" text,
    "created_by_user_oid" binary(16),
    "created_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16),
    "modified_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "position" int NOT NULL DEFAULT 0,
    "priority" tinyint NOT NULL,
    "project_id" int NOT NULL,
    "ticket_id" int NOT NULL,
    PRIMARY KEY ("id")
);
CREATE INDEX ON "project_tickets" ("ticket_id");
CREATE UNIQUE INDEX ON "project_tickets" ("project_id", "ticket_id");

CREATE TABLE "release_applications" (
    "application_id" int NOT NULL,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "description" text,
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "release_id" int NOT NULL,
    PRIMARY KEY ("id")
);
ALTER TABLE "release_applications" ADD FOREIGN KEY ("application_id") REFERENCES "application" ("id");
ALTER TABLE "release_applications" ADD FOREIGN KEY ("release_id") REFERENCES "release" ("id");
CREATE INDEX ON "release_applications" ("application_id");
CREATE UNIQUE INDEX ON "release_applications" ("release_id", "application_id");

CREATE TABLE "release_deployments" (
    "change_ticket" varchar(50),
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deployed_by_resource_id" int NOT NULL,
    "deployed_on" datetime NOT NULL,
    "description" text,
    "id" int NOT NULL AUTO_INCREMENT,
    "installation_id" int NOT NULL,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "release_id" int NOT NULL,
    "type" varchar(2) NOT NULL,
    PRIMARY KEY ("id")
);
ALTER TABLE "release_deployments" ADD FOREIGN KEY ("deployed_by_resource_id") REFERENCES "resource" ("id");
ALTER TABLE "release_deployments" ADD FOREIGN KEY ("installation_id") REFERENCES "installation" ("id");
ALTER TABLE "release_deployments" ADD FOREIGN KEY ("release_id") REFERENCES "release" ("id");
CREATE INDEX ON "release_deployments" ("deployed_by_resource_id");
CREATE INDEX ON "release_deployments" ("installation_id");
CREATE INDEX ON "release_deployments" ("release_id");

CREATE TABLE "release_includes" (
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "release_id" int NOT NULL,
    "release_included_id" int NOT NULL,
    PRIMARY KEY ("id")
);
ALTER TABLE "release_includes" ADD FOREIGN KEY ("release_id") REFERENCES "release" ("id");
ALTER TABLE "release_includes" ADD FOREIGN KEY ("release_included_id") REFERENCES "release" ("id");
CREATE INDEX ON "release_includes" ("release_id");
CREATE INDEX ON "release_includes" ("release_included_id");

CREATE TABLE "request" (
    "client_id" int,
    "created_by_user_oid" binary(16),
    "created_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "date_received" date NOT NULL,
    "date_submitted" date,
    "description" text,
    "file_location" varchar(200),
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16),
    "modified_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "name" varchar(50) NOT NULL,
    "summary" varchar(200),
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "request" ("name");

CREATE TABLE "request_requirement" (
    "answer_status" int,
    "billing" int,
    "comment" text,
    "created_by_user_oid" binary(16),
    "created_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "est_build_d" decimal(8,2),
    "est_design_d" decimal(8,2),
    "est_group" varchar(20),
    "est_test_d" decimal(8,2),
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16),
    "modified_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "no" int,
    "phase" int,
    "priority" int,
    "request_id" int NOT NULL,
    "requirement_text" text,
    "section" varchar(100) NOT NULL DEFAULT '',
    "subsection" varchar(100) NOT NULL DEFAULT '',
    "ticket_id" int,
    PRIMARY KEY ("id")
);
CREATE INDEX ON "request_requirement" ("request_id");

CREATE TABLE "resource" (
    "created_by_user_oid" binary(16),
    "created_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "description" text,
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16),
    "modified_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "name" varchar(128) NOT NULL,
    "user_oid" binary(16),
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "resource" ("name");

CREATE TABLE "sprint" (
    "closed_flag" tinyint NOT NULL DEFAULT 0,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "description" varchar(250) NOT NULL DEFAULT '',
    "end_on" date NOT NULL,
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "name" varchar(100) NOT NULL,
    "release_id" int,
    "start_on" date NOT NULL,
    PRIMARY KEY ("id")
);
ALTER TABLE "sprint" ADD FOREIGN KEY ("release_id") REFERENCES "release" ("id");
CREATE INDEX ON "sprint" ("release_id");

CREATE TABLE "tag" (
    "created_by_user_oid" binary(16),
    "created_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16),
    "modified_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "name" varchar(50) NOT NULL,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "tag" ("name");

CREATE TABLE "test_case" (
    "archived_flag" tinyint NOT NULL DEFAULT 0,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "description" longtext,
    "effort_planned" time,
    "feature_id" int NOT NULL,
    "id" int NOT NULL AUTO_INCREMENT,
    "login_data" text,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "name" varchar(128) NOT NULL,
    "priority" tinyint,
    "retest_required_time" datetime,
    PRIMARY KEY ("id")
);
CREATE INDEX ON "test_case" ("feature_id");

CREATE TABLE "test_case_coverage" (
    "comment" varchar(300) NOT NULL DEFAULT '',
    "covers_test_case_id" int NOT NULL,
    "created_by_user_oid" binary(16),
    "created_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16),
    "modified_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "test_case_id" int NOT NULL,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "test_case_coverage" ("test_case_id", "covers_test_case_id");

CREATE TABLE "test_case_flags" (
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "explanation" varchar(500),
    "flag_id" int NOT NULL,
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "test_case_id" int NOT NULL,
    PRIMARY KEY ("id")
);
ALTER TABLE "test_case_flags" ADD FOREIGN KEY ("flag_id") REFERENCES "flag" ("id");
ALTER TABLE "test_case_flags" ADD FOREIGN KEY ("test_case_id") REFERENCES "test_case" ("id");
CREATE INDEX ON "test_case_flags" ("flag_id");
CREATE INDEX ON "test_case_flags" ("test_case_id");

CREATE TABLE "test_case_issue" (
    "assigned_to" varchar(50),
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL,
    "description" longtext NOT NULL,
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL,
    "priority" int,
    "severity" int,
    "state" int NOT NULL DEFAULT 10,
    "test_case_id" int NOT NULL,
    "title" varchar(250) NOT NULL,
    "type" int NOT NULL DEFAULT 1,
    PRIMARY KEY ("id")
);
ALTER TABLE "test_case_issue" ADD FOREIGN KEY ("test_case_id") REFERENCES "test_case" ("id");
CREATE INDEX ON "test_case_issue" ("test_case_id");

CREATE TABLE "test_case_issue_comment" (
    "action_required" int NOT NULL,
    "comment" longtext NOT NULL,
    "comment_type" int NOT NULL,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL,
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL,
    "test_case_issue_id" int NOT NULL,
    PRIMARY KEY ("id")
);
ALTER TABLE "test_case_issue_comment" ADD FOREIGN KEY ("test_case_issue_id") REFERENCES "test_case_issue" ("id");
CREATE INDEX ON "test_case_issue_comment" ("test_case_issue_id");

CREATE TABLE "test_log" (
    "comment" text,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "effort" time,
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "tested_build_time" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "tested_by_resource_id" int NOT NULL,
    "tested_installation_id" int NOT NULL,
    "tested_on" datetime NOT NULL,
    "tested_workbench_version" varchar(50) NOT NULL,
    "test_case_id" int NOT NULL,
    "test_description" longtext,
    "test_log_type_id" int NOT NULL,
    "test_ok_flag" tinyint NOT NULL DEFAULT 0,
    "test_plan_id" int,
    "ticket_id" int,
    PRIMARY KEY ("id")
);
CREATE INDEX ON "test_log" ("test_case_id", "test_ok_flag");

CREATE TABLE "test_log_type" (
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL,
    "explanation" varchar(500),
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL,
    "name" varchar(100) NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE "test_plan" (
    "application_id" int,
    "closed_flag" tinyint NOT NULL DEFAULT 0,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "description" text,
    "estimated_effort" int,
    "id" int NOT NULL AUTO_INCREMENT,
    "milestone_id" int,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "name" varchar(128) NOT NULL,
    "release_id" int,
    "resource_id" int,
    "sprint_id" int,
    "state" int NOT NULL DEFAULT 10,
    PRIMARY KEY ("id")
);
ALTER TABLE "test_plan" ADD FOREIGN KEY ("application_id") REFERENCES "application" ("id");
ALTER TABLE "test_plan" ADD FOREIGN KEY ("release_id") REFERENCES "release" ("id");
ALTER TABLE "test_plan" ADD FOREIGN KEY ("sprint_id") REFERENCES "sprint" ("id");
CREATE INDEX ON "test_plan" ("application_id");
CREATE INDEX ON "test_plan" ("release_id");
CREATE INDEX ON "test_plan" ("sprint_id");

CREATE TABLE "test_plan_cases" (
    "assigned_to_resource_id" int,
    "comment" varchar(1000),
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "priority" tinyint NOT NULL DEFAULT 1,
    "test_case_id" int NOT NULL,
    "test_plan_id" int NOT NULL,
    PRIMARY KEY ("id")
);
ALTER TABLE "test_plan_cases" ADD FOREIGN KEY ("assigned_to_resource_id") REFERENCES "resource" ("id");
CREATE INDEX ON "test_plan_cases" ("assigned_to_resource_id");
CREATE UNIQUE INDEX ON "test_plan_cases" ("test_plan_id", "test_case_id");

CREATE TABLE "test_scenario" (
    "application_id" int,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "description" text,
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "name" varchar(128) NOT NULL,
    "setup" text,
    "test_type_id" int NOT NULL,
    PRIMARY KEY ("id")
);
CREATE INDEX ON "test_scenario" ("test_type_id");

CREATE TABLE "test_scenario_cases" (
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "sequence" int NOT NULL,
    "summary" varchar(250),
    "test_case_id" int,
    "test_scenario_id" int NOT NULL,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "test_scenario_cases" ("test_scenario_id", "test_case_id");

CREATE TABLE "test_type" (
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "name" varchar(50) NOT NULL,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "test_type" ("name");

CREATE TABLE "ticket" (
    "assigned_at_pos" int,
    "assigned_to" int,
    "complexity" int,
    "created_by_user_oid" binary(16),
    "created_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "description" longtext,
    "effort_plan_estimated_h" decimal(5,1),
    "effort_real_h" decimal(5,1),
    "effort_rem_estimated_h" decimal(5,1),
    "id" int NOT NULL AUTO_INCREMENT,
    "milestone_at_pos" int,
    "milestone_id" int,
    "modified_by_user_oid" binary(16),
    "modified_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "parent_ticket_id" int,
    "release_id" int,
    "severity" int,
    "sprint_id" int,
    "sprint_pos" int,
    "state" int NOT NULL DEFAULT 10,
    "test_case_id" int,
    "ticket_type_id" int NOT NULL,
    "time_booking_text" varchar(100),
    "title" varchar(250) NOT NULL,
    PRIMARY KEY ("id")
);
ALTER TABLE "ticket" ADD FOREIGN KEY ("release_id") REFERENCES "release" ("id");
ALTER TABLE "ticket" ADD FOREIGN KEY ("test_case_id") REFERENCES "test_case" ("id");
CREATE INDEX ON "ticket" ("parent_ticket_id");
CREATE INDEX ON "ticket" ("release_id");
CREATE INDEX ON "ticket" ("state");
CREATE INDEX ON "ticket" ("test_case_id");

CREATE TABLE "ticket_comment" (
    "action_required" int NOT NULL,
    "comment" text NOT NULL,
    "comment_type" int NOT NULL,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL,
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL,
    "ticket_id" int NOT NULL,
    PRIMARY KEY ("id")
);
ALTER TABLE "ticket_comment" ADD FOREIGN KEY ("ticket_id") REFERENCES "ticket" ("id");
CREATE INDEX ON "ticket_comment" ("ticket_id");

CREATE TABLE "ticket_log" (
    "comment" longtext NOT NULL,
    "created_by_user_oid" binary(16),
    "created_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16),
    "modified_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "resource_id" int NOT NULL,
    "state" int NOT NULL,
    "ticket_id" int NOT NULL,
    PRIMARY KEY ("id")
);
CREATE INDEX ON "ticket_log" ("ticket_id", "created_on");

CREATE TABLE "ticket_tags" (
    "created_by_user_oid" binary(16),
    "created_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16),
    "modified_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "tag_id" int NOT NULL,
    "ticket_id" int NOT NULL,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "ticket_tags" ("tag_id", "ticket_id");

CREATE TABLE "ticket_type" (
    "bug_flag" tinyint NOT NULL DEFAULT 0,
    "created_by_user_oid" binary(16),
    "created_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "description" text,
    "id" int NOT NULL AUTO_INCREMENT,
    "incident_flag" tinyint NOT NULL DEFAULT 0,
    "modified_by_user_oid" binary(16),
    "modified_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "name" varchar(50) NOT NULL,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "ticket_type" ("name");

CREATE TABLE "vcs_update" (
    "application_id" int NOT NULL,
    "author_name" varchar(100),
    "branch" varchar(100),
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "name" varchar(250) NOT NULL,
    "update_time" datetime NOT NULL,
    "update_type" varchar(50),
    "vcs_id" varchar(100),
    "vcs_url" varchar(250),
    "webhook_log_id" int,
    PRIMARY KEY ("id")
);

CREATE TABLE "vcs_update_files" (
    "application_file_id" int NOT NULL,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_flag" tinyint NOT NULL DEFAULT 0,
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "vcs_update_id" int NOT NULL,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "vcs_update_files" ("vcs_update_id", "application_file_id");

CREATE TABLE "webhook_log" (
    "created_by_user_oid" binary(16),
    "created_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "failed" tinyint NOT NULL DEFAULT 0,
    "failed_log_id" varchar(10),
    "failed_message" varchar(250),
    "id" int NOT NULL AUTO_INCREMENT,
    "ignored" tinyint NOT NULL DEFAULT 0,
    "message" longtext NOT NULL,
    "modified_by_user_oid" binary(16),
    "modified_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "processed" tinyint NOT NULL DEFAULT 0,
    "received_on" datetime NOT NULL,
    "repo_url" varchar(250),
    "result" text,
    PRIMARY KEY ("id")
);

CREATE TABLE "_migrations" (
    "down_datetime" timestamp,
    "down_result" longtext,
    "down_script" longtext NOT NULL,
    "failed_flag" tinyint NOT NULL DEFAULT 0,
    "failed_message" longtext,
    "id" int NOT NULL AUTO_INCREMENT,
    "log_id" varchar(10),
    "migration_name" varchar(300) NOT NULL,
    "skip_flag" tinyint NOT NULL DEFAULT 0,
    "up_datetime" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "up_result" longtext,
    "up_script" longtext NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE "release" (
    "client_id" int NOT NULL,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "date_eol" date,
    "date_planned" date,
    "date_released" date,
    "date_staging" date,
    "description" text,
    "id" int NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "name" varchar(100) NOT NULL,
    "release_notes" text,
    PRIMARY KEY ("id")
);
ALTER TABLE "release" ADD FOREIGN KEY ("client_id") REFERENCES "client" ("id");
CREATE INDEX ON "release" ("client_id");


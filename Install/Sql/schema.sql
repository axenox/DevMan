CREATE TABLE "application" (
    "app_alias" varchar(100) NOT NULL,
    "client_id" int(11) NOT NULL,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT current_timestamp(),
    "description" text DEFAULT NULL,
    "development_url" varchar(255) DEFAULT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "latest_version" varchar(20) NOT NULL DEFAULT '',
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT current_timestamp(),
    "name" varchar(128) NOT NULL,
    "package_url" varchar(200) DEFAULT NULL,
    "testing_url" varchar(255) DEFAULT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE "application_file" (
    "application_id" int(11) NOT NULL,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT current_timestamp(),
    "deleted_flag" tinyint(4) NOT NULL DEFAULT 0,
    "filepath" varchar(250) NOT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "application_file" ("application_id", "filepath");

CREATE TABLE "approval" (
    "approved_by_resource_id" int(11) NOT NULL,
    "created_by_user_oid" binary(16) DEFAULT NULL,
    "created_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "description" varchar(250) DEFAULT NULL,
    "effort" decimal(5,1) DEFAULT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "milestone_id" int(11) DEFAULT NULL,
    "modified_by_user_oid" binary(16) DEFAULT NULL,
    "modified_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "project_id" int(11) NOT NULL,
    "resource_id" int(11) DEFAULT NULL,
    "ticket_id" int(10) DEFAULT NULL,
    PRIMARY KEY ("id")
);
CREATE INDEX ON "approval" ("milestone_id");
CREATE INDEX ON "approval" ("project_id");
CREATE INDEX ON "approval" ("ticket_id");

CREATE TABLE "client" (
    "code" varchar(5) NOT NULL,
    "created_by_user_oid" binary(16) DEFAULT NULL,
    "created_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "description" text DEFAULT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "importance" int(11) NOT NULL DEFAULT 0,
    "modified_by_user_oid" binary(16) DEFAULT NULL,
    "modified_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "name" varchar(50) NOT NULL,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "client" ("name");

CREATE TABLE "dates" (
    "date" date NOT NULL,
    "day_no" int(11) NOT NULL,
    "id" int(11) NOT NULL,
    "month_no" int(11) NOT NULL,
    "quarter_no" int(11) NOT NULL,
    "weekday_no" int(11) NOT NULL,
    "weekend_flag" tinyint(4) DEFAULT 0,
    "week_no" int(11) NOT NULL,
    "year_no" int(11) NOT NULL,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "dates" ("date");
CREATE UNIQUE INDEX ON "dates" ("year_no", "month_no", "day_no");

CREATE TABLE "external_system" (
    "client_id" int(11) DEFAULT NULL,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT current_timestamp(),
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT current_timestamp(),
    "name" varchar(50) NOT NULL,
    "project_id" int(11) DEFAULT NULL,
    "ticket_url_pattern" varchar(200) DEFAULT NULL,
    "url" varchar(200) DEFAULT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE "external_test_link" (
    "comment" varchar(400) DEFAULT '',
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT current_timestamp(),
    "custom_url" varchar(400) DEFAULT '',
    "external_system_id" int(11) NOT NULL,
    "external_ticket_id" varchar(400) NOT NULL DEFAULT '',
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT current_timestamp(),
    "test_case_id" int(11) DEFAULT NULL,
    "test_plan_id" int(11) DEFAULT NULL,
    PRIMARY KEY ("id")
);
ALTER TABLE "external_test_link" ADD FOREIGN KEY ("test_case_id") REFERENCES "test_case" ("id");
CREATE INDEX ON "external_test_link" ("test_case_id");

CREATE TABLE "external_ticket_link" (
    "comment" varchar(400) DEFAULT '',
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT current_timestamp(),
    "custom_url" varchar(400) DEFAULT '',
    "external_system_id" int(11) NOT NULL,
    "external_ticket_id" varchar(400) DEFAULT '',
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT current_timestamp(),
    "ticket_id" int(11) NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE "feature" (
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT current_timestamp(),
    "description" text DEFAULT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT current_timestamp(),
    "module_id" int(11) NOT NULL,
    "name" varchar(128) NOT NULL,
    "parent_feature_id" int(11) DEFAULT NULL,
    "priority" tinyint(4) DEFAULT NULL,
    "test_setup" longtext DEFAULT NULL,
    PRIMARY KEY ("id")
);
CREATE INDEX ON "feature" ("module_id");

CREATE TABLE "feature_files" (
    "application_file_id" int(11) NOT NULL,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT current_timestamp(),
    "feature_id" int(11) NOT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "feature_files" ("feature_id", "application_file_id");

CREATE TABLE "feature_tickets" (
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT current_timestamp(),
    "feature_id" int(11) NOT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT current_timestamp(),
    "ticket_id" int(11) NOT NULL,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "feature_tickets" ("ticket_id", "feature_id");

CREATE TABLE "flag" (
    "color" varchar(20) DEFAULT NULL,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "description" varchar(500) DEFAULT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "name" varchar(50) NOT NULL,
    "obstacle_flag" tinyint(4) NOT NULL DEFAULT 0,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "flag" ("name");

CREATE TABLE "installation" (
    "client_id" int(11) NOT NULL,
    "created_by_user_oid" binary(16) DEFAULT NULL,
    "created_on" datetime NOT NULL DEFAULT current_timestamp(),
    "current_build_time" datetime NOT NULL DEFAULT current_timestamp(),
    "current_workbench_version" varchar(30) NOT NULL DEFAULT '',
    "deployer_host_alias" varchar(100) DEFAULT NULL,
    "description" text DEFAULT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) DEFAULT NULL,
    "modified_on" datetime NOT NULL DEFAULT current_timestamp(),
    "name" varchar(50) NOT NULL,
    "url" varchar(100) NOT NULL,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "installation" ("name");

CREATE TABLE "milestone" (
    "created_by_user_oid" binary(16) DEFAULT NULL,
    "created_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "date" date NOT NULL,
    "date_to" date DEFAULT NULL,
    "description" text DEFAULT NULL,
    "effort_plan_estimated_h" decimal(5,1) DEFAULT NULL,
    "effort_real_h" decimal(5,1) DEFAULT NULL,
    "effort_rem_estimated_h" decimal(5,1) DEFAULT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "installation_id" int(11) DEFAULT NULL,
    "location" varchar(50) DEFAULT NULL,
    "milestone_type_id" int(11) DEFAULT NULL,
    "modified_by_user_oid" binary(16) DEFAULT NULL,
    "modified_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "name" varchar(50) NOT NULL,
    "objectives" varchar(250) DEFAULT NULL,
    "project_id" int(11) NOT NULL,
    "release_id" int(11) DEFAULT NULL,
    "show_in_calendar" tinyint(4) NOT NULL DEFAULT 1,
    "status" varchar(50) DEFAULT NULL,
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
    "created_by_user_oid" binary(16) DEFAULT NULL,
    "created_on" datetime DEFAULT '1970-01-01 00:00:00',
    "description" varchar(100) NOT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) DEFAULT NULL,
    "modified_on" datetime DEFAULT '1970-01-01 00:00:00',
    "name" varchar(50) NOT NULL,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "milestone_type" ("name");

CREATE TABLE "module" (
    "application_id" int(11) NOT NULL,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT current_timestamp(),
    "description" text DEFAULT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT current_timestamp(),
    "name" varchar(128) NOT NULL,
    "test_setup" longtext DEFAULT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE "project" (
    "client_id" int(11) NOT NULL DEFAULT 0,
    "created_by_user_oid" binary(16) DEFAULT NULL,
    "created_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "date_end" date DEFAULT NULL,
    "date_start" date DEFAULT NULL,
    "description" text DEFAULT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) DEFAULT NULL,
    "modified_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "objectives" varchar(250) DEFAULT NULL,
    "state" int(11) NOT NULL DEFAULT 10,
    "title" varchar(128) NOT NULL,
    PRIMARY KEY ("id")
);
CREATE INDEX ON "project" ("state");

CREATE TABLE "project_tickets" (
    "comment" text DEFAULT NULL,
    "created_by_user_oid" binary(16) DEFAULT NULL,
    "created_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) DEFAULT NULL,
    "modified_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "position" int(11) NOT NULL DEFAULT 0,
    "priority" tinyint(3) NOT NULL,
    "project_id" int(11) NOT NULL,
    "ticket_id" int(10) NOT NULL,
    PRIMARY KEY ("id")
);
CREATE INDEX ON "project_tickets" ("ticket_id");
CREATE UNIQUE INDEX ON "project_tickets" ("project_id", "ticket_id");

CREATE TABLE "release_applications" (
    "application_id" int(11) NOT NULL,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT current_timestamp(),
    "description" text DEFAULT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT current_timestamp(),
    "release_id" int(11) NOT NULL,
    PRIMARY KEY ("id")
);
ALTER TABLE "release_applications" ADD FOREIGN KEY ("application_id") REFERENCES "application" ("id");
ALTER TABLE "release_applications" ADD FOREIGN KEY ("release_id") REFERENCES "release" ("id");
CREATE INDEX ON "release_applications" ("application_id");
CREATE UNIQUE INDEX ON "release_applications" ("release_id", "application_id");

CREATE TABLE "release_deployments" (
    "change_ticket" varchar(50) DEFAULT NULL,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT current_timestamp(),
    "deployed_by_resource_id" int(11) NOT NULL,
    "deployed_on" datetime NOT NULL,
    "description" text DEFAULT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "installation_id" int(11) NOT NULL,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT current_timestamp(),
    "release_id" int(11) NOT NULL,
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
    "created_on" datetime NOT NULL DEFAULT current_timestamp(),
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT current_timestamp(),
    "release_id" int(11) NOT NULL,
    "release_included_id" int(11) NOT NULL,
    PRIMARY KEY ("id")
);
ALTER TABLE "release_includes" ADD FOREIGN KEY ("release_id") REFERENCES "release" ("id");
ALTER TABLE "release_includes" ADD FOREIGN KEY ("release_included_id") REFERENCES "release" ("id");
CREATE INDEX ON "release_includes" ("release_id");
CREATE INDEX ON "release_includes" ("release_included_id");

CREATE TABLE "request" (
    "client_id" int(11) DEFAULT NULL,
    "created_by_user_oid" binary(16) DEFAULT NULL,
    "created_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "date_received" date NOT NULL,
    "date_submitted" date DEFAULT NULL,
    "description" text DEFAULT NULL,
    "file_location" varchar(200) DEFAULT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) DEFAULT NULL,
    "modified_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "name" varchar(50) NOT NULL,
    "summary" varchar(200) DEFAULT NULL,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "request" ("name");

CREATE TABLE "request_requirement" (
    "answer_status" int(11) DEFAULT NULL,
    "billing" int(11) DEFAULT NULL,
    "comment" text DEFAULT NULL,
    "created_by_user_oid" binary(16) DEFAULT NULL,
    "created_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "est_build_d" decimal(8,2) DEFAULT NULL,
    "est_design_d" decimal(8,2) DEFAULT NULL,
    "est_group" varchar(20) DEFAULT NULL,
    "est_test_d" decimal(8,2) DEFAULT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) DEFAULT NULL,
    "modified_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "no" int(11) DEFAULT NULL,
    "phase" int(11) DEFAULT NULL,
    "priority" int(11) DEFAULT NULL,
    "request_id" int(11) NOT NULL,
    "requirement_text" text DEFAULT NULL,
    "section" varchar(100) NOT NULL DEFAULT '',
    "subsection" varchar(100) NOT NULL DEFAULT '',
    "ticket_id" int(10) DEFAULT NULL,
    PRIMARY KEY ("id")
);
CREATE INDEX ON "request_requirement" ("request_id");

CREATE TABLE "resource" (
    "created_by_user_oid" binary(16) DEFAULT NULL,
    "created_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "description" text DEFAULT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) DEFAULT NULL,
    "modified_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "name" varchar(128) NOT NULL,
    "user_oid" binary(16) DEFAULT NULL,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "resource" ("name");

CREATE TABLE "sprint" (
    "closed_flag" tinyint(4) NOT NULL DEFAULT 0,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT current_timestamp(),
    "description" varchar(250) NOT NULL DEFAULT '',
    "end_on" date NOT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT current_timestamp(),
    "name" varchar(100) NOT NULL,
    "release_id" int(11) DEFAULT NULL,
    "start_on" date NOT NULL,
    PRIMARY KEY ("id")
);
ALTER TABLE "sprint" ADD FOREIGN KEY ("release_id") REFERENCES "release" ("id");
CREATE INDEX ON "sprint" ("release_id");

CREATE TABLE "tag" (
    "created_by_user_oid" binary(16) DEFAULT NULL,
    "created_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) DEFAULT NULL,
    "modified_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "name" varchar(50) NOT NULL,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "tag" ("name");

CREATE TABLE "test_case" (
    "archived_flag" tinyint(4) NOT NULL DEFAULT 0,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT current_timestamp(),
    "description" longtext DEFAULT NULL,
    "effort_planned" time DEFAULT NULL,
    "feature_id" int(11) NOT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "login_data" text DEFAULT NULL,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT current_timestamp(),
    "name" varchar(128) NOT NULL,
    "priority" tinyint(4) DEFAULT NULL,
    "retest_required_time" datetime DEFAULT NULL,
    PRIMARY KEY ("id")
);
CREATE INDEX ON "test_case" ("feature_id");

CREATE TABLE "test_case_coverage" (
    "comment" varchar(300) NOT NULL DEFAULT '',
    "covers_test_case_id" int(11) NOT NULL,
    "created_by_user_oid" binary(16) DEFAULT NULL,
    "created_on" datetime NOT NULL DEFAULT current_timestamp(),
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) DEFAULT NULL,
    "modified_on" datetime NOT NULL DEFAULT current_timestamp(),
    "test_case_id" int(11) NOT NULL,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "test_case_coverage" ("test_case_id", "covers_test_case_id");

CREATE TABLE "test_case_flags" (
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "explanation" varchar(500) DEFAULT NULL,
    "flag_id" int(11) NOT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "test_case_id" int(11) NOT NULL,
    PRIMARY KEY ("id")
);
ALTER TABLE "test_case_flags" ADD FOREIGN KEY ("flag_id") REFERENCES "flag" ("id");
ALTER TABLE "test_case_flags" ADD FOREIGN KEY ("test_case_id") REFERENCES "test_case" ("id");
CREATE INDEX ON "test_case_flags" ("flag_id");
CREATE INDEX ON "test_case_flags" ("test_case_id");

CREATE TABLE "test_case_issue" (
    "assigned_to" varchar(50) DEFAULT NULL,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL,
    "description" longtext NOT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL,
    "priority" int(11) DEFAULT NULL,
    "severity" int(11) DEFAULT NULL,
    "state" int(11) NOT NULL DEFAULT 10,
    "test_case_id" int(11) NOT NULL,
    "title" varchar(250) NOT NULL,
    "type" int(11) NOT NULL DEFAULT 1,
    PRIMARY KEY ("id")
);
ALTER TABLE "test_case_issue" ADD FOREIGN KEY ("test_case_id") REFERENCES "test_case" ("id");
CREATE INDEX ON "test_case_issue" ("test_case_id");

CREATE TABLE "test_case_issue_comment" (
    "action_required" int(11) NOT NULL,
    "comment" longtext NOT NULL,
    "comment_type" int(11) NOT NULL,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL,
    "test_case_issue_id" int(11) NOT NULL,
    PRIMARY KEY ("id")
);
ALTER TABLE "test_case_issue_comment" ADD FOREIGN KEY ("test_case_issue_id") REFERENCES "test_case_issue" ("id");
CREATE INDEX ON "test_case_issue_comment" ("test_case_issue_id");

CREATE TABLE "test_log" (
    "comment" text DEFAULT NULL,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT current_timestamp(),
    "effort" time DEFAULT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT current_timestamp(),
    "tested_build_time" datetime NOT NULL DEFAULT current_timestamp(),
    "tested_by_resource_id" int(11) NOT NULL,
    "tested_installation_id" int(10) NOT NULL,
    "tested_on" datetime NOT NULL,
    "tested_workbench_version" varchar(50) NOT NULL,
    "test_case_id" int(11) NOT NULL,
    "test_description" longtext DEFAULT NULL,
    "test_log_type_id" int(11) NOT NULL,
    "test_ok_flag" tinyint(1) NOT NULL DEFAULT 0,
    "test_plan_id" int(11) DEFAULT NULL,
    "ticket_id" int(10) DEFAULT NULL,
    PRIMARY KEY ("id")
);
CREATE INDEX ON "test_log" ("test_case_id", "test_ok_flag");

CREATE TABLE "test_log_type" (
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL,
    "explanation" varchar(500) DEFAULT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL,
    "name" varchar(100) NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE "test_plan" (
    "application_id" int(11) DEFAULT NULL,
    "closed_flag" tinyint(1) NOT NULL DEFAULT 0,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT current_timestamp(),
    "description" text DEFAULT NULL,
    "estimated_effort" int(5) DEFAULT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "milestone_id" int(11) DEFAULT NULL,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT current_timestamp(),
    "name" varchar(128) NOT NULL,
    "release_id" int(11) DEFAULT NULL,
    "resource_id" int(11) DEFAULT NULL,
    "sprint_id" int(11) DEFAULT NULL,
    "state" int(11) NOT NULL DEFAULT 10,
    PRIMARY KEY ("id")
);
ALTER TABLE "test_plan" ADD FOREIGN KEY ("application_id") REFERENCES "application" ("id");
ALTER TABLE "test_plan" ADD FOREIGN KEY ("release_id") REFERENCES "release" ("id");
ALTER TABLE "test_plan" ADD FOREIGN KEY ("sprint_id") REFERENCES "sprint" ("id");
CREATE INDEX ON "test_plan" ("application_id");
CREATE INDEX ON "test_plan" ("release_id");
CREATE INDEX ON "test_plan" ("sprint_id");

CREATE TABLE "test_plan_cases" (
    "assigned_to_resource_id" int(11) DEFAULT NULL,
    "comment" varchar(1000) DEFAULT NULL,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT current_timestamp(),
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT current_timestamp(),
    "priority" tinyint(4) NOT NULL DEFAULT 1,
    "test_case_id" int(11) NOT NULL,
    "test_plan_id" int(11) NOT NULL,
    PRIMARY KEY ("id")
);
ALTER TABLE "test_plan_cases" ADD FOREIGN KEY ("assigned_to_resource_id") REFERENCES "resource" ("id");
CREATE INDEX ON "test_plan_cases" ("assigned_to_resource_id");
CREATE UNIQUE INDEX ON "test_plan_cases" ("test_plan_id", "test_case_id");

CREATE TABLE "test_scenario" (
    "application_id" int(11) DEFAULT NULL,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT current_timestamp(),
    "description" text DEFAULT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT current_timestamp(),
    "name" varchar(128) NOT NULL,
    "setup" text DEFAULT NULL,
    "test_type_id" int(11) NOT NULL,
    PRIMARY KEY ("id")
);
CREATE INDEX ON "test_scenario" ("test_type_id");

CREATE TABLE "test_scenario_cases" (
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT current_timestamp(),
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT current_timestamp(),
    "sequence" int(11) NOT NULL,
    "summary" varchar(250) DEFAULT NULL,
    "test_case_id" int(11) DEFAULT NULL,
    "test_scenario_id" int(11) NOT NULL,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "test_scenario_cases" ("test_scenario_id", "test_case_id");

CREATE TABLE "test_type" (
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT current_timestamp(),
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT current_timestamp(),
    "name" varchar(50) NOT NULL,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "test_type" ("name");

CREATE TABLE "ticket" (
    "assigned_at_pos" int(10) DEFAULT NULL,
    "assigned_to" int(11) DEFAULT NULL,
    "complexity" int(11) DEFAULT NULL,
    "created_by_user_oid" binary(16) DEFAULT NULL,
    "created_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "description" longtext DEFAULT NULL,
    "effort_plan_estimated_h" decimal(5,1) DEFAULT NULL,
    "effort_real_h" decimal(5,1) DEFAULT NULL,
    "effort_rem_estimated_h" decimal(5,1) DEFAULT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "milestone_at_pos" int(11) DEFAULT NULL,
    "milestone_id" int(10) DEFAULT NULL,
    "modified_by_user_oid" binary(16) DEFAULT NULL,
    "modified_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "parent_ticket_id" int(10) DEFAULT NULL,
    "release_id" int(11) DEFAULT NULL,
    "severity" int(11) DEFAULT NULL,
    "sprint_id" int(11) DEFAULT NULL,
    "sprint_pos" int(11) DEFAULT NULL,
    "state" int(11) NOT NULL DEFAULT 10,
    "test_case_id" int(11) DEFAULT NULL,
    "ticket_type_id" int(10) NOT NULL,
    "time_booking_text" varchar(100) DEFAULT NULL,
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
    "action_required" int(11) NOT NULL,
    "comment" text NOT NULL,
    "comment_type" int(11) NOT NULL,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL,
    "ticket_id" int(11) NOT NULL,
    PRIMARY KEY ("id")
);
ALTER TABLE "ticket_comment" ADD FOREIGN KEY ("ticket_id") REFERENCES "ticket" ("id");
CREATE INDEX ON "ticket_comment" ("ticket_id");

CREATE TABLE "ticket_log" (
    "comment" longtext NOT NULL,
    "created_by_user_oid" binary(16) DEFAULT NULL,
    "created_on" datetime NOT NULL DEFAULT current_timestamp(),
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) DEFAULT NULL,
    "modified_on" datetime NOT NULL DEFAULT current_timestamp(),
    "resource_id" int(11) NOT NULL,
    "state" int(11) NOT NULL,
    "ticket_id" int(11) NOT NULL,
    PRIMARY KEY ("id")
);
CREATE INDEX ON "ticket_log" ("ticket_id", "created_on");

CREATE TABLE "ticket_tags" (
    "created_by_user_oid" binary(16) DEFAULT NULL,
    "created_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) DEFAULT NULL,
    "modified_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "tag_id" int(11) NOT NULL,
    "ticket_id" int(10) NOT NULL,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "ticket_tags" ("tag_id", "ticket_id");

CREATE TABLE "ticket_type" (
    "bug_flag" tinyint(1) NOT NULL DEFAULT 0,
    "created_by_user_oid" binary(16) DEFAULT NULL,
    "created_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "description" text DEFAULT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "incident_flag" tinyint(1) NOT NULL DEFAULT 0,
    "modified_by_user_oid" binary(16) DEFAULT NULL,
    "modified_on" datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
    "name" varchar(50) NOT NULL,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "ticket_type" ("name");

CREATE TABLE "vcs_update" (
    "application_id" int(11) NOT NULL,
    "author_name" varchar(100) DEFAULT NULL,
    "branch" varchar(100) DEFAULT NULL,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT current_timestamp(),
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT current_timestamp(),
    "name" varchar(250) NOT NULL,
    "update_time" datetime NOT NULL,
    "update_type" varchar(50) DEFAULT NULL,
    "vcs_id" varchar(100) DEFAULT NULL,
    "vcs_url" varchar(250) DEFAULT NULL,
    "webhook_log_id" int(11) DEFAULT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE "vcs_update_files" (
    "application_file_id" int(11) NOT NULL,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT current_timestamp(),
    "deleted_flag" tinyint(4) NOT NULL DEFAULT 0,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT current_timestamp(),
    "vcs_update_id" int(11) NOT NULL,
    PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX ON "vcs_update_files" ("vcs_update_id", "application_file_id");

CREATE TABLE "webhook_log" (
    "created_by_user_oid" binary(16) DEFAULT NULL,
    "created_on" datetime NOT NULL DEFAULT current_timestamp(),
    "failed" tinyint(4) NOT NULL DEFAULT 0,
    "failed_log_id" varchar(10) DEFAULT NULL,
    "failed_message" varchar(250) DEFAULT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "ignored" tinyint(4) NOT NULL DEFAULT 0,
    "message" longtext NOT NULL,
    "modified_by_user_oid" binary(16) DEFAULT NULL,
    "modified_on" datetime NOT NULL DEFAULT current_timestamp(),
    "processed" tinyint(1) NOT NULL DEFAULT 0,
    "received_on" datetime NOT NULL,
    "repo_url" varchar(250) DEFAULT NULL,
    "result" text DEFAULT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE "_migrations" (
    "down_datetime" timestamp DEFAULT NULL,
    "down_result" longtext DEFAULT NULL,
    "down_script" longtext NOT NULL,
    "failed_flag" tinyint(1) NOT NULL DEFAULT 0,
    "failed_message" longtext DEFAULT NULL,
    "id" int(8) NOT NULL AUTO_INCREMENT,
    "log_id" varchar(10) DEFAULT NULL,
    "migration_name" varchar(300) NOT NULL,
    "skip_flag" tinyint(1) NOT NULL DEFAULT 0,
    "up_datetime" timestamp NOT NULL DEFAULT current_timestamp(),
    "up_result" longtext DEFAULT NULL,
    "up_script" longtext NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE "release" (
    "client_id" int(11) NOT NULL,
    "created_by_user_oid" binary(16) NOT NULL,
    "created_on" datetime NOT NULL DEFAULT current_timestamp(),
    "date_eol" date DEFAULT NULL,
    "date_planned" date DEFAULT NULL,
    "date_released" date DEFAULT NULL,
    "date_staging" date DEFAULT NULL,
    "description" text DEFAULT NULL,
    "id" int(11) NOT NULL AUTO_INCREMENT,
    "modified_by_user_oid" binary(16) NOT NULL,
    "modified_on" datetime NOT NULL DEFAULT current_timestamp(),
    "name" varchar(100) NOT NULL,
    "release_notes" text DEFAULT NULL,
    PRIMARY KEY ("id")
);
ALTER TABLE "release" ADD FOREIGN KEY ("client_id") REFERENCES "client" ("id");
CREATE INDEX ON "release" ("client_id");


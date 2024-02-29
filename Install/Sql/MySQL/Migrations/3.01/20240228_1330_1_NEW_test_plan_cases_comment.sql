-- UP
IF COL_LENGTH('test_plan_cases', `comment`) IS NULL
ALTER TABLE test_plan_cases
ADD `comment` varchar(1000) NULL
GO;

-- DOWN
IF COL_LENGTH('test_plan_cases', `comment`) IS NOT NULL
ALTER TABLE test_plan_cases
DROP COLUMN `comment`
GO;
-- UP
ALTER TABLE test_plan_cases
ADD COLUMN `comment` varchar(1000) NULL

-- DOWN
ALTER TABLE test_plan_cases
DROP COLUMN `comment`
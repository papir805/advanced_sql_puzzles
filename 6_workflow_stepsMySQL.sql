use twitterdb

DROP TABLE IF EXISTS WorkflowSteps;
CREATE TABLE WorkflowSteps(workflow text, step_number int, completion_date date);
INSERT INTO WorkflowSteps VALUES
('Alpha',1,'2018-7-2'),
('Alpha',2,'2018-7-2'),
('Alpha',3,'2018-7-1'),
('Bravo',1,'2018-6-25'),
('Bravo',2,NULL),
('Bravo',3,'2018-6-27'),
('Charlie',1,NULL),
('Charlie',2,'2018-7-1');

SELECT * FROM WorkflowSteps;

SELECT workflow
FROM WorkflowSteps
WHERE completion_date IS NULL;

SELECT *, COUNT(*) OVER (PARTITION BY workflow)
FROM WorkflowSteps;

SELECT SUM(CASE WHEN completion_date IS NULL THEN 0 ELSE 1 END) OVER (PARTITION BY workflow) AS "sum",
       MAX(step_number) OVER (PARTITION BY workflow) AS "max"
FROM WorkflowSteps;

SELECT workflow, COUNT(*), COUNT(completion_date)
FROM WorkflowSteps
GROUP BY workflow
HAVING count(*) <> count(completion_date);
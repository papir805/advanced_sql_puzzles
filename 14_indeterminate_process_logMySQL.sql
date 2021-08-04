use twitterdb

DROP TABLE IF EXISTS workflows;
CREATE TABLE workflows(workflow text, step_number int, status text);
INSERT INTO workflows
VALUES ('Alpha', 1, 'Error'),
       ('Alpha', 2, 'Complete'),
       ('Bravo', 1, 'Complete'),
       ('Bravo', 2, 'Complete'),
       ('Charlie', 1, 'Complete'),
       ('Charlie', 2, 'Error'),
       ('Delta', 1, 'Complete'),
       ('Delta', 2, 'Running'),
       ('Echo', 1, 'Running'),
       ('Echo', 2, 'Error'),
       ('Foxtrot', 1, 'Error');

-- USE SUM/CASE to get the total number of errors, running, and complete processes partitioned by workflow
WITH workflow_totals
     AS (SELECT *,
                Sum(CASE
                      WHEN status = 'Error' THEN 1
                      ELSE 0
                    END)
                  OVER (
                    PARTITION BY workflow ROWS BETWEEN unbounded preceding AND
                  unbounded
                  following) AS tot_error,
                Sum(CASE
                      WHEN status = 'Complete' THEN 1
                      ELSE 0
                    END)
                  OVER (
                    PARTITION BY workflow ROWS BETWEEN unbounded preceding AND
                  unbounded
                  following) AS tot_complete,
                Sum(CASE
                      WHEN status = 'Running' THEN 1
                      ELSE 0
                    END)
                  OVER (
                    PARTITION BY workflow ROWS BETWEEN unbounded preceding AND
                  unbounded
                  following) AS tot_running
         FROM   workflows),

-- Use conditional logic to determine the overall status of a workflow bases on the totals of Complete, Error, and Running
     workflow_status
     AS (SELECT *,
                CASE
                  WHEN tot_complete = Max(step_number)
                                        OVER (
                                          PARTITION BY workflow) THEN 'Complete'
                  WHEN tot_error = Max(step_number)
                                     OVER (
                                       PARTITION BY workflow) THEN 'Error'
                  WHEN tot_error > 0
                       AND tot_complete > 0
                        OR tot_running > 0
                           AND tot_error > 0 THEN 'Indeterminate'
                  WHEN tot_running > 0
                       AND tot_complete > 0 THEN 'Running'
                END AS overall_status
         FROM   workflow_totals)

-- filter the results so that we only get one row per partition
SELECT DISTINCT workflow,
                First_value(overall_status)
                  OVER (
                    PARTITION BY workflow) AS status
FROM   workflow_status; 


DROP TABLE IF EXISTS StatusRank;
CREATE TABLE StatusRank(status text, rk int);
INSERT INTO StatusRank
VALUES ('Error', 1),
       ('Running', 2),
       ('Complete', 3);

WITH cte_CountExistsError AS 
(
SELECT workflow, COUNT(DISTINCT status) AS DistinctCount
FROM workflows AS a
WHERE EXISTS (SELECT 1
FROM workflows AS b
WHERE status = 'Error' AND a.workflow = b.workflow)
GROUP BY workflow
),

cte_ErrorWorkflows AS
(
SELECT a.workflow,
       (CASE WHEN DistinctCount > 1 THEN 'Indeterminate' ELSE a.status END) AS status
FROM workflows AS a
INNER JOIN cte_CountExistsError AS b
ON a.workflow = b.workflow
GROUP BY a.workflow, (CASE WHEN DistinctCount > 1 THEN 'Indeterminate' ELSE a.status END)
)

SELECT DISTINCT
       a.workflow,
       FIRST_VALUE(a.status) OVER (PARTITION BY workflow ORDER BY b.rk) AS statusdd
FROM workflows AS a
INNER JOIN StatusRank AS b
ON a.status = b.status
WHERE a.workflow NOT IN (SELECT workflow FROM cte_ErrorWorkflows)
UNION
SELECT Workflow, Status
FROM cte_ErrorWorkflows
ORDER BY Workflow;;
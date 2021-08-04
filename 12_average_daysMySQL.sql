use twitterdb

DROP TABLE IF EXISTS workflow_table;
CREATE TABLE workflow_table(workflow text, execution_date date);
INSERT INTO workflow_table
VALUES ('Alpha', '2018-6-1'),
       ('Alpha', '2018-6-14'),
       ('Alpha', '2018-6-15'),
       ('Bravo', '2018-6-1'),
       ('Bravo', '2018-6-2'),
       ('Bravo', '2018-6-19'),
       ('Charlie', '2018-6-1'),
       ('Charlie', '2018-6-15'),
       ('Charlie', '2018-6-30');

SELECT *
FROM workflow_table;

-- My solution:  Works by finding the difference between the last and first execution date 
-- partitioned by workflow, as well as a count of the total number of jobs per workflow minus 1,
-- this gets us the Δx in execution dates for use in calculating the average in the next step.
-- Lastly a row_number column to help with filtering later

WITH t1 AS (
SELECT workflow,
       LAST_VALUE(execution_date) OVER (PARTITION BY workflow 
       	                                ORDER BY execution_date ROWS 
       	                                BETWEEN UNBOUNDED PRECEDING
       	                                AND UNBOUNDED FOLLOWING) - 
       FIRST_VALUE(execution_date) OVER (PARTITION BY workflow
       	                                 ORDER BY execution_date ROWS
       	                                 BETWEEN UNBOUNDED PRECEDING
       	                                 AND UNBOUNDED FOLLOWING) AS total_days,
       COUNT(workflow) OVER (PARTITION BY workflow) - 1 AS cnt,
       ROW_NUMBER() OVER (PARTITION BY workflow) AS rn
FROM workflow_table
)

-- Compute the average by taking the total days and dividing by the Δx, then filtering out
-- duplicate results with WHERE clause
SELECT workflow, FLOOR(total_days/cnt) AS average_days
FROM t1
WHERE rn = 1;

-- Alternative solution using date diff to compute all the date differences, then using built in
-- AVG function

WITH diff_tbl AS (
SELECT workflow,
       execution_date,
       DATEDIFF(execution_date, LAG(execution_date, 1) OVER (PARTITION BY workflow 
       	                                                     ORDER BY execution_date)) AS diff
FROM workflow_table
)

SELECT workflow, FLOOR(AVG(diff)) AS average_days
FROM diff_tbl
GROUP BY workflow;
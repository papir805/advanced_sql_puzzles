use twitterdb

DROP TABLE IF EXISTS groupings CASCADE;
CREATE TABLE groupings(step_number int, test_case text, status text);

INSERT INTO Groupings VALUES
(1,'Test Case 1','Passed'),
(2,'Test Case 2','Passed'),
(3,'Test Case 3','Passed'),
(4,'Test Case 4','Passed'),
(5,'Test Case 5','Failed'),
(6,'Test Case 6','Failed'),
(7,'Test Case 7','Failed'),
(8,'Test Case 8','Failed'),
(9,'Test Case 9','Failed'),
(10,'Test Case 10','Passed'),
(11,'Test Case 11','Passed'),
(12,'Test Case 12','Passed');

SELECT * FROM groupings;

-- My solution
-- Use CASE statement to figure out which statuses are equal to the one prior to it.
WITH cte_preprocessing AS (
  SELECT *,
         CASE
             WHEN status = LAG(status, 1) OVER (ORDER BY step_number) THEN 0
             ELSE 1
         END AS for_grouping
  FROM groupings
),

-- Compute cumulative sum to be used for grouping later.
cte_for_grouping AS (
  SELECT *,
         SUM(for_grouping) OVER (ORDER BY step_number) AS cum_sum
  FROM cte_preprocessing
),

-- Use cumulative sum to PARTITION the statuses and compute the COUNT for each consecutive status with
-- DISTINCT to remove duplicate results from the window function in the prior CTE
cte_for_postprocessing AS (
  SELECT DISTINCT 
         status,
         COUNT(status) OVER (PARTITION BY cum_sum) AS consecutive_counts
  FROM cte_for_grouping
)

-- Get results as well as row numbers
SELECT *, ROW_NUMBER() OVER () AS 'order'
FROM cte_for_postprocessing;

-- Their solution
-- Assign row_numbers after PARITIONING by status, then compute the difference between the step_number
-- and the row number, which can be used to for grouping in the next CTE
WITH a AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY status ORDER BY step_number) AS row_num,
         step_number - ROW_NUMBER() OVER (PARTITION BY status ORDER BY step_number) AS row_diff
  FROM groupings
)

-- GROUP BY status and row_diff then use the MAX - MIN + 1 in each group to figure out
-- how many occurrences of each status there were.
SELECT status,
       MAX(step_number) - MIN(step_number) + 1 AS consecutive_counts
FROM a
GROUP BY status, row_diff;
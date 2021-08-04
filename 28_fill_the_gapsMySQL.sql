use twitterdb

DROP TABLE IF EXISTS gaps CASCADE;

CREATE TABLE gaps(row_num int, workflow text);


INSERT INTO gaps
VALUES (1,'Alpha'),
(2,NULL),
(3,NULL),
(4,NULL),
(5,'Bravo'),
(6,NULL),
(7,'Charlie'),
(8,NULL),
(9,NULL);

SELECT * FROM gaps;

-- Solution using session variables and CASE statements.  Since case statements evaluate row by row,
-- The first non-null row value will be set to @prev, which is then assigned to any future null row
-- value.  When another non-null row value is found, that will be set to @prev and the cycle repeats
SELECT row_num,
       CASE
            WHEN workflow IS NULL THEN @prev
            ELSE @prev := workflow
       END AS workflow2
FROM gaps;

-- Another solution using COUNT to create a grouping condition to be used in the CTE below.
-- COUNT(workflow) ignores NULL values in the workflow column, which is the key for this trick to work
WITH distinct_counts AS (
  SELECT row_num,
         workflow,
         COUNT(workflow) OVER (ORDER BY row_num) AS distinct_count
  FROM gaps
)

-- Use the grouping criteria distinct_count to create partitions and FIRST_VALUE() to find the
-- first value of each partition, then fill that it in for all NULL values in that partition
SELECT row_num,
       distinct_count,
       FIRST_VALUE(workflow) OVER (PARTITION BY distinct_count ORDER BY row_num) AS workflow
FROM distinct_counts
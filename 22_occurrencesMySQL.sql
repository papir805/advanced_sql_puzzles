use twitterdb

DROP TABLE IF EXISTS process_log;
CREATE TABLE process_log(workflow text, occurrences int, log_message text);

INSERT INTO process_log VALUES
('Alpha',5,'Error: Conversion Failed'),
('Alpha',8,'Status Complete'),
('Alpha',9,'Error: Unidentified error occurred'),
('Bravo',3,'Error: Cannot Divide by 0'),
('Bravo',1,'Error: Unidentified error occurred'),
('Charlie',10,'Error: Unidentified error occurred'),
('Charlie',7,'Error: Conversion Failed'),
('Charlie',6,'Status Complete');

SELECT * FROM process_log;

-- GROUP BY log_message to figure out which log_message occurs the most
WITH occurrences AS (
  SELECT log_message AS max_log_message, MAX(occurrences) AS max_occurrences
  FROM process_log
  GROUP BY log_message
),

-- INNER JOIN occurrences and process_log.  This will help us determine which workflow had the
-- log message that occurred the most often.  We can filter out results that don't match this criteria
-- in the next CTE
joined_tbl AS (
SELECT *
FROM occurrences AS o
INNER JOIN process_log AS pl
ON o.max_log_message = pl.log_message
)

-- Only show workflows and their log_message WHERE the occurrences of that log message equaled
-- the max_occurrences of that log message
SELECT workflow,
       log_message
FROM joined_tbl
WHERE occurrences = max_occurrences
ORDER BY workflow, log_message;

-- Their solution, using a correlated subquery
SELECT workflow, occurrences, log_message
FROM process_log AS e1
WHERE occurrences > ALL(SELECT e2.occurrences
                        FROM process_log AS e2
                        WHERE e2.log_message = e1.log_message AND
                              e2.workflow <> e1.workflow)
ORDER BY workflow, log_message
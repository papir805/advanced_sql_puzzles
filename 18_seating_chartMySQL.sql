use twitterdb

DROP TABLE IF EXISTS seating_chart;
CREATE TABLE seating_chart(seat_number int);

INSERT INTO seating_chart
VALUES (1), (7), (13), (14), (15), (27), (28), (29), (30), (31), (32), (33), (34),
       (35), (52), (53), (54), (60);

-- Assign each seat_number a continuous rank
WITH ranked AS (
  SELECT *,
         RANK() OVER (ORDER BY seat_number) AS rk
  FROM seating_chart
),

-- Find the difference between seat_number and the continuous rank AS rank_diff, which can be used
-- as a grouping criteria.  Consecutive seat numbers will have the same rank_diff.
ranked_differences AS (
  SELECT *,
         seat_number - rk AS rank_diff
  FROM ranked
),

-- Partition by rank_diff and then find the minimum and maximum seat_number in each partition
min_max AS (
  SELECT *,
         MIN(seat_number) OVER (PARTITION BY rank_diff) AS min_seat,
         MAX(seat_number) OVER (PARTITION BY rank_diff) AS max_seat
  FROM ranked_differences
),

-- Use DISTINCT to eliminate duplicate results that occur from using window functions in the
-- previous CTE
group_by_diff AS (
  -- SELECT rank_diff, MIN(min_seat) AS min_seat, MAX(max_seat) AS max_seat
  SELECT DISTINCT rank_diff, min_seat AS min_seat, max_seat AS max_seat
  FROM min_max
  -- GROUP BY rank_diff
),

-- Assign ranking to each group of consecutive seats for use in CASE statement in next CTE
rank_diff AS (
  SELECT RANK() OVER (ORDER BY rank_diff) AS rk,
         min_seat,
         max_seat
  FROM group_by_diff
),

-- Use CASE logic to set up correct start/end values for seat gaps
last_table AS (
  SELECT CASE
            WHEN rk = 1 THEN 1
            ELSE LAG(max_seat, 1) OVER (ORDER BY max_seat) + 1
         END AS gap_start,
         min_seat - 1 AS gap_end
  FROM rank_diff
)

-- Filter out results that don't make sense that results from our CASE logic in the CTE above.
-- Better CASE logic might be able to avoid this, I just need to put more thought into it.
SELECT * FROM last_table
WHERE gap_end <> 0;

-- Find how many seat numbers are missing in our table of seat_numbers
SELECT MAX(seat_number) - COUNT(seat_number) AS total_missing_numbers
FROM seating_chart;

-- Use MOD and GROUP BY to determine how many even and odd seat numbers are in the table
SELECT
       CASE
          WHEN MOD(seat_number, 2) = 0 THEN 'Even Numbers'
          ELSE 'Odd Numbers'
       END AS type,
       COUNT(*) AS cnt
FROM seating_chart
GROUP BY type
ORDER BY type;


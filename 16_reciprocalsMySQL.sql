use twitterdb

DROP TABLE IF EXISTS reciprocals;

CREATE TABLE reciprocals(player_a int, player_b int, score int);

INSERT INTO reciprocals
VALUES (1001, 2002, 150),
       (3003, 4004, 15),
       (4004, 3003, 125),
       (4004, 1001, 125);

-- Self join using LEFT JOIN to distinguish values that are symmetric pairs (x1 = y2 & x2 = y1) from non-symmetric pairs based on NULL conditions
WITH joined_tbl AS (
	SELECT r1.player_a AS r1a,
	       r1.player_b AS r1b,
	       r1.score AS score1,
	       r2.player_a AS r2a,
	       r2.player_b r2b,
	       r2.score AS score2
	FROM reciprocals AS r1
	LEFT JOIN reciprocals AS r2
	ON r1.player_a = r2.player_b AND
	   r1.player_b = r2.player_a
	),

-- Identify symmetric pairs to later UNION with non-symmetric pairs these would NOT produce null values, so
-- we filter using WHERE IS NOT NULL, also aggregate the score.
symmetric_pairs AS (
-- SELECT r1.player_a,
--        r1.player_b,
--        r1.score + r2.score AS score
-- FROM reciprocals AS r1
-- INNER JOIN reciprocals AS r2
-- ON r1.player_a = r2.player_b AND r1.player_b = r2.player_a
-- WHERE r1.player_a < r1.player_b
SELECT r1a, r1b, score1 + score2 AS score FROM joined_tbl
WHERE r2a IS NOT NULL AND r2b IS NOT NULL AND r1a < r1b
),

-- Identify non-symmetric pairs.  These would have produced NULL values so we filter using WHERE IS NULL
non_symmetric_pairs AS (
SELECT r1a, r1b, score1 AS score FROM joined_tbl
WHERE r2a IS  NULL AND r2b IS NULL
)

-- Union non_symmetric_pairs with symmetric_pairs
SELECT * FROM non_symmetric_pairs
UNION
SELECT * FROM symmetric_pairs;

-- Their solution.  Works by reorganizing the player_a and player_b column so that the playerA number is always less than playerB,
-- this allows for aggregate functions to sum based on GROUP BY conditions on playerA, playerB
SELECT a.playerA, a.playerB, SUM(score)
FROM (
      SELECT
      (CASE WHEN player_a <= player_b THEN player_a ELSE player_b END) AS playerA,
      (CASE WHEN player_a <= player_b THEN player_b ELSE player_a END) AS playerB,
      score FROM reciprocals
      ) AS a
GROUP BY a.playerA, a.playerB
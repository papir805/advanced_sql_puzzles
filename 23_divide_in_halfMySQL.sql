use twitterdb

DROP TABLE IF EXISTS player_scores CASCADE;
CREATE TABLE player_scores(player_id int, score int);
INSERT INTO player_scores
VALUES (1001, 2343),
       (2002, 9432),
       (3003, 6548),
       (4004, 1054),
       (5005, 6832);

SELECT * FROM player_scores;


WITH ranked AS (
  SELECT *,
         PERCENT_RANK() OVER (ORDER BY score) AS pct_rk
  FROM player_scores
)

SELECT CASE
           WHEN pct_rk >= 0.5 THEN 1
           ELSE 2
       END AS category,
       player_id,
       score
FROM ranked
ORDER BY category, score DESC;

--  Their solution
SELECT NTILE(2) OVER (ORDER BY score DESC) AS quartile,
       player_id,
       score
FROM player_scores AS a;
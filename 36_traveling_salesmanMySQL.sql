use twitterdb

DROP TABLE IF EXISTS travels CASCADE;

CREATE TABLE travels(dep_city LONGTEXT, arrival_city LONGTEXT, cost int);

INSERT INTO travels VALUES
('Austin','Dallas',100),
('Dallas','Austin',150),
('Dallas','Memphis',200),
('Memphis','Des Moines',300),
('Dallas','Des Moines',400);

SELECT * FROM travels;

WITH RECURSIVE
tripsss(iter, node, front) AS (
  SELECT 0 AS iter, trv1.dep_city AS node, trv1.arrival_city AS front
  FROM travels AS trv1
  WHERE dep_city = 'Austin'
  AND arrival_city = 'Dallas'
    UNION
  SELECT iter + 1, tp.node, trv2.arrival_city AS front
  FROM tripsss AS tp, travels AS trv2
  WHERE tp.front = trv2.dep_city
  AND iter < 10
  AND tp.node <> trv2.arrival_city
)

SELECT * FROM tripsss;

WITH RECURSIVE
tripsss(iter, node, front, tot_cost, route) AS (
  SELECT 0 AS iter,
         trv1.dep_city AS node,
         trv1.arrival_city AS front,
         trv1.cost AS tot_cost,
         CONCAT(trv1.dep_city, ', ', trv1.arrival_city) AS route
  FROM travels AS trv1
  WHERE dep_city = 'Austin'
  AND arrival_city = 'Dallas'
    UNION
  SELECT iter + 1,
         tp.node,
         trv2.arrival_city AS front,
         tp.tot_cost + trv2.cost AS tot_cost,
         CONCAT(tp.route, ', ', trv2.arrival_city) AS route
  FROM tripsss AS tp, travels AS trv2
  WHERE tp.front = trv2.dep_city
  AND iter < 10
  AND tp.node <> trv2.arrival_city
)

SELECT * FROM tripsss;




WITH cte_Graph AS
(
SELECT dep_city, arrival_city, Cost FROM travels
UNION ALL
SELECT arrival_city, dep_city, Cost FROM travels
UNION ALL
SELECT arrival_city, arrival_city, 0 FROM travels
UNION ALL
SELECT dep_city, dep_city, 0 FROM travels
)
SELECT DISTINCT
 g1.dep_city,
 g2.dep_city,
 g3.dep_city,
 g4.dep_city,
 g4.arrival_city,
 (g1.Cost + g2.Cost + g3.Cost + g4.Cost) AS TotalCost
FROM cte_Graph AS g1 INNER JOIN
 cte_Graph AS g2 ON g1.arrival_city = g2.dep_city INNER JOIN
 cte_Graph AS g3 ON g2.arrival_city = g3.dep_city INNER JOIN
 cte_Graph AS g4 ON g3.arrival_city = g4.dep_city
WHERE g1.dep_city = 'Austin' AND
 g4.arrival_city = 'Des Moines'
ORDER BY 6,1,2,3,4;
use twitterdb

DROP TABLE IF EXISTS sales CASCADE;
CREATE TABLE sales(year int, amount int);
INSERT INTO sales
VALUES (2018, 352645),
       (2017, 165565),
       (2017, 254654),
       (2016, 159521),
       (2016, 251696),
       (2016, 111894);

SELECT * FROM sales;

WITH grouped AS (
  SELECT year, SUM(amount) AS total
  FROM sales
  GROUP BY year
)

-- SELECT SUM(
--            CASE 
--                WHEN year = 2018 THEN total
--                ELSE 0
--            END) AS '2018'
-- FROM grouped

SELECT SUM(CASE
           WHEN year = 2018 THEN total
       END) AS '2018',
       SUM(CASE
           WHEN year = 2017 THEN total
       END) AS '2017',
       SUM(CASE
           WHEN year = 2016 THEN total
       END) AS '2016'
FROM grouped;
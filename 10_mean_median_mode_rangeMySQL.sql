use twitterdb

DROP TABLE IF EXISTS sample_data;
CREATE TABLE sample_data(value int);
INSERT INTO sample_data
VALUES (5), (6), (10), (10), (13), (13), (13), (14), (17), (20), (81), (90), (76);

SELECT * FROM sample_data;

WITH avg_tbl AS (SELECT AVG(s.value) AS mean
FROM sample_data AS s),

median_tbl AS (SELECT t1.value AS median
FROM (SELECT s.value, CUME_DIST() OVER (ORDER BY s.value ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS rk
FROM sample_data AS s) AS t1
WHERE t1.rk >= 0.5
LIMIT 1),

range_tbl AS (SELECT MAX(value) - MIN(VALUE) AS 'easier_range'
FROM sample_data)

SELECT *
FROM avg_tbl
CROSS JOIN median_tbl
CROSS JOIN range_tbl;
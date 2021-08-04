use twitterdb

DROP TABLE IF EXISTS sample_data CASCADE;
CREATE TABLE sample_data(integer_value int);

INSERT INTO sample_data
VALUES (3759), (3760), (3761), (3762), (3763);

SELECT * FROM sample_data;

SELECT DISTINCT NTH_VALUE(integer_value, 2) OVER (ORDER BY integer_value DESC) AS 2nd_value
FROM sample_data;

SELECT integer_value AS 2nd_value
FROM sample_data
WHERE integer_value < (SELECT MAX(integer_value) FROM sample_data)
ORDER BY integer_value DESC
LIMIT 1;

WITH row_numbers AS (
  SELECT *, ROW_NUMBER() OVER (ORDER BY integer_value DESC) AS row_num
  FROM sample_data
)

SELECT integer_value AS 2nd_value
FROM row_numbers
WHERE row_num = 2;

SELECT integer_value AS 2nd_value
FROM sample_data
ORDER BY integer_value DESC
LIMIT 1 OFFSET 1;
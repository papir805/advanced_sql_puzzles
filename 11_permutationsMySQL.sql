use twitterdb

DROP TABLE IF EXISTS cases;
CREATE TABLE cases(test_case text);
INSERT INTO cases
VALUES ('A'),
       ('B'),
       ('C');

WITH tbl AS (
	SELECT *, ROW_NUMBER() OVER (ORDER BY test_case) AS rn
	FROM cases)

SELECT * FROM tbl;

-- CROSS JOIN forces a permutation but because we do it twice, it opens the door for repeated values
SELECT t1.test_case AS case1,
       t2.test_case AS case2,
       t3.test_case AS case3
FROM cases AS t1
CROSS JOIN cases AS t2
CROSS JOIN cases AS t3;

-- Using WHERE we can filter out repeated values among the columns in our permutations
SELECT t1.test_case AS case1,
       t2.test_case AS case2,
       t3.test_case AS case3
FROM cases AS t1
CROSS JOIN cases AS t2
CROSS JOIN cases AS t3
WHERE t1.test_case <> t2.test_case
AND
      t2.test_case <> t3.test_case
AND
      t1.test_case <> t3.test_case;

-- Introduce row numbers based on our desired ordering criteria, CONCAT the results, and we're done
SELECT ROW_NUMBER() OVER (ORDER BY t1.test_case, t2.test_case) AS rn,
       CONCAT(t1.test_case, ',',
       t2.test_case, ',',
       t3.test_case) AS output
FROM cases AS t1
CROSS JOIN cases AS t2
CROSS JOIN cases AS t3
WHERE t1.test_case <> t2.test_case
AND
      t2.test_case <> t3.test_case
AND
      t1.test_case <> t3.test_case
ORDER BY t1.test_case, t2.test_case;




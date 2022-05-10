use twitterdb

DROP TABLE IF EXISTS dancers;

CREATE TABLE dancers(student_id int, gender text);

INSERT INTO dancers
VALUES (1001, 'M'),
       (2002, 'M'),
       (3003, 'M'),
       (4004, 'M'),
       (5005, 'M'),
       (6006, 'F'),
       (7007, 'F'),
       (8008, 'F'),
       (9009, 'F');

SELECT * FROM dancers;

-- First find all male student_ids and assign row numbers
WITH men(male_id, male_gender, male_rn) AS (SELECT *,
       ROW_NUMBER() OVER () AS rn
FROM dancers
WHERE gender = 'M'),

-- Find all female student_ids and assign row numbers
women(female_id, female_gender, female_rn) AS (SELECT *,
       ROW_NUMBER() OVER () AS rn
FROM dancers
WHERE gender = 'F'),

-- MySQL doesn't support a full outer join, but since we want to preserve any null values
-- that result from pairing the men and the women, we need it.  We can set ourselves up for 
-- a full outer join by doing a LEFT JOIN a RIGHT JOIN and then a UNION to remove duplicate entries
left_joined_tbl AS (
	SELECT *
	FROM men AS m
	LEFT JOIN women AS w
	ON m.male_rn = w.female_rn
	),

right_joined_tbl AS (
	SELECT *
	FROM men AS m
	RIGHT JOIN women AS w
	ON m.male_rn = w.female_rn
	),

full_outer_join AS (
SELECT * FROM left_joined_tbl
UNION
SELECT * FROM right_joined_tbl
)

SELECT male_id, male_gender, female_id, female_gender
FROM full_outer_join;
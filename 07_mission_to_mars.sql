use twitterdb

DROP TABLE IF EXISTS candidates;
CREATE TABLE candidates(candidate_id int, description text);
INSERT INTO candidates
VALUES (1001, 'Geologist'),
       (1001, 'Astrogator'),
       (1001, 'Biochemist'),
       (1001, 'Technician'),
       (2002, 'Surgeon'),
       (2002, 'Geologist'),
       (2002, 'Machinist'),
       (3003, 'Cryologist'),
       (4004, 'Selenologist');

SELECT * FROM candidates;

DROP TABLE IF EXISTS requirements;
CREATE TABLE requirements(description text);
INSERT INTO requirements
VALUES ('Geologist'),
       ('Astrogator'),
       ('Technician');

SELECT * FROM requirements;

-- INNER JOIN SO THAT ONLY candidates with the correct description are kept
WITH joined_tbl AS (SELECT c.candidate_id
FROM candidates AS c
INNER JOIN requirements AS r
ON c.description = r.description)

-- GROUP BY candidate id, count the number of requirements they have, then find which candidates have
-- the correct number of requirements or more.
SELECT jt.candidate_id
FROM joined_tbl AS jt
GROUP BY jt.candidate_id
HAVING COUNT(*) >= (SELECT COUNT(*) FROM requirements AS r);
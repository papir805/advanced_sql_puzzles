use twitterdb

DROP TABLE IF EXISTS personnel CASCADE;
CREATE TABLE personnel(spaceman_id int, job_description text, mission_count int);

INSERT INTO Personnel VALUES
(1001,'Astrogator',6),
(2002,'Astrogator',12),
(3003,'Astrogator',17),
(4004,'Geologist',21),
(5005,'Geologist',9),
(6006,'Geologist',8),
(7007,'Technician',13),
(8008,'Technician',2),
(9009,'Technician',7);

-- My solution
WITH temp AS (
  SELECT job_description, MAX(mission_count) AS maximum, MIN(mission_count) AS minimum
  FROM personnel
  GROUP BY job_description
),

temp2 AS (
  SELECT DISTINCT p.job_description,
         CASE
             WHEN p.job_description = 'Astrogator' AND p.mission_count = t.maximum THEN p.spaceman_id
             WHEN p.job_description = 'Geologist' AND p.mission_count = t.maximum THEN p.spaceman_id
             WHEN p.job_description = 'Technician' AND p.mission_count = t.maximum THEN p.spaceman_id
         END AS most_experienced,
         CASE
             WHEN p.job_description = 'Astrogator' AND p.mission_count = t.minimum THEN p.spaceman_id
             WHEN p.job_description = 'Geologist' AND p.mission_count = t.minimum THEN p.spaceman_id
             WHEN p.job_description = 'Technician' AND p.mission_count = t.minimum THEN p.spaceman_id
         END AS least_experienced
  FROM personnel AS p
  INNER JOIN temp AS t
  ON t.job_description = p.job_description
)

SELECT job_description,
       SUM(COALESCE(most_experienced, 0)) AS most_experienced,
       SUM(COALESCE(least_experienced, 0)) AS least_experienced
FROM temp2
GROUP BY job_description;



-- My other, better, solution
WITH rankings AS (
  SELECT *,
         RANK() OVER (PARTITION BY job_description ORDER BY mission_count DESC) AS rk_desc,
         RANK() OVER (PARTITION BY job_description ORDER BY mission_count) AS rk_asc
  FROM personnel
)

SELECT job_description,
       SUM(CASE 
           WHEN rk_desc = 1 THEN spaceman_id
           ELSE 0
       END) AS most_experienced,
       SUM(CASE
           WHEN rk_asc = 1 THEN spaceman_id
           ELSE 0
           END) AS least_experienced
FROM rankings
GROUP BY job_description;

-- Their solution
SELECT DISTINCT job_description,
       FIRST_VALUE(spaceman_id) OVER (PARTITION BY job_description ORDER BY mission_count DESC) AS most_experienced,
       LAST_VALUE(spaceman_id) OVER (PARTITION BY job_description ORDER BY mission_count ASC RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS least_experienced
FROM personnel;
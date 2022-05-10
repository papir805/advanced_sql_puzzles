use twitterdb

DROP TABLE IF EXISTS mgr_emp;
CREATE TABLE mgr_emp(employee_id int, manager_id int, job_title text, salary int);
INSERT INTO mgr_emp
VALUES (1001, NULL, 'President', 185000),
       (2002, 1001, 'Director', 120000),
       (3003, 1001, 'Office Manager', 97000),
       (4004, 2002, 'Engineer', 110000),
       (5005, 2002, 'Engineer', 142000),
       (6006, 2002, 'Engineer', 160000);

SELECT *,
       DENSE_RANK() OVER (ORDER BY manager_id) - 1 AS depth
FROM mgr_emp;
use twitterdb

DROP TABLE IF EXISTS licenses;
CREATE TABLE licenses(employee_id int, license text);
INSERT INTO licenses
VALUES (1001, 'Class A'),
       (1001, 'Class B'),
       (1001, 'Class C'),
       (2002, 'Class A'),
       (2002, 'Class B'),
       (2002, 'Class C'),
       (3003, 'Class A'),
       (3003, 'Cladd D');

SELECT * FROM licenses;

WITH class_a AS (
SELECT employee_id FROM licenses
WHERE license = 'Class A'),

class_b AS (
SELECT employee_id FROM licenses
WHERE license = 'Class B'),

class_c AS (
SELECT employee_id FROM licenses
WHERE license = 'Class C')

-- My Solution which seems simpler for when there are only a few different license classes,
-- but would require more code the more classes there are.
SELECT DISTINCT employee_id
FROM licenses
WHERE employee_id IN 
	(SELECT employee_id FROM class_a)
	AND employee_id IN
	(SELECT employee_id FROM class_b)
	AND employee_id IN
	(SELECT employee_id FROM class_c);

-- Alternative solution
WITH cte_employeecount AS
(
SELECT employee_id,
       COUNT(*) AS LicenseCount
FROM licenses
GROUP BY employee_id
),

cte_EmployeeCountCombined AS
(
SELECT  a.employee_id AS EmployeeID,
        b.employee_id AS EmployeeID2,
        COUNT(*) AS LicenseCountCombo
FROM licenses AS a
INNER JOIN licenses AS b
ON a.license = b.license
WHERE a.employee_id <> b.employee_id
GROUP BY a.employee_id, b.employee_id
)



SELECT a.EmployeeID, a.EmployeeID2, a.LicenseCountCombo
FROM cte_EmployeeCountCombined AS a INNER JOIN
     cte_employeecount AS b ON a.LicenseCountCombo = b.LicenseCount AND
                               a.EmployeeID <> b.Employee_id;

-- SELECT  a.employee_id AS EmployeeID, a.license,
--         b.employee_id AS EmployeeID2, b.license
-- FROM licenses AS a
-- INNER JOIN licenses AS b
-- ON a.license = b.license
-- WHERE a.employee_id <> b.employee_id
-- -- GROUP BY a.employee_id, b.employee_id
-- ORDER BY a.employee_id, b.employee_id
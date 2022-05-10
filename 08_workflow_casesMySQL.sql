use twitterdb

DROP TABLE IF EXISTS workflow_cases;

CREATE TABLE workflow_cases(workflow text, case_1 int, case_2 int, case_3 int);

INSERT INTO workflow_cases
VALUES ('Alpha', 0, 0, 0),
       ('Bravo', NULL, 1, 1),
       ('Charlie', 1, 0, 0),
       ('Delta', 0, 0, 0);

SELECT * FROM workflow_cases;

SELECT workflow, COALESCE(case_1, 0)+COALESCE(case_2, 0)+COALESCE(case_3, 0) AS passed
FROM workflow_cases;
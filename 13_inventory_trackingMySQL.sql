use twitterdb

DROP TABLE IF EXISTS inventory;
CREATE TABLE inventory(da_te date, quantity_adjustment int);
INSERT INTO inventory
VALUES ('2018-7-1', 100),
       ('2018-7-2', 75),
       ('2018-7-3', -150),
       ('2018-7-4', 50),
       ('2018-7-5', -100);

SELECT * FROM inventory;

SELECT *, SUM(quantity_adjustment) OVER (ORDER BY da_te) AS inventory
FROM inventory;
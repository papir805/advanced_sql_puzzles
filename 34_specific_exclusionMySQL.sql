use twitterdb

DROP TABLE IF EXISTS orders CASCADE;

CREATE TABLE orders(customer_id int, order_id text, amount int);


INSERT INTO Orders VALUES
(1001,'Ord143937',25),
(1001,'Ord789765',50),
(2002,'Ord345434',65),
(3003,'Ord465633',50);


SELECT *
FROM orders;


SELECT *
FROM orders
WHERE customer_id <> 1001
OR amount <> 50;


SELECT *
FROM orders
WHERE NOT(customer_id = 1001 AND amount = 50);
use twitterdb
DROP TABLE IF EXISTS orders;
CREATE TABLE orders(customer_id int, order_id text, delivery_state text, amount int);
INSERT INTO orders 
VALUES
(1001,'Ord936254','CA',340),
(1001,'Ord143876','TX',950),
(1001,'Ord654876','TX',670),
(1001,'Ord814356','TX',860),
(2002,'Ord342176','WA',320),
(3003,'Ord265789','CA',650),
(3003,'Ord387654','CA',830),
(4004,'Ord476126','TX',120);

SELECT * FROM orders;

WITH ca_customers AS (
	SELECT customer_id AS ca_cust_id
	FROM orders
	WHERE delivery_state = 'CA'
	)

SELECT *
FROM orders
WHERE customer_id IN (SELECT ca_cust_id FROM ca_customers) AND
delivery_state = 'TX';
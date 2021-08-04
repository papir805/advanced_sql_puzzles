use twitterdb

DROP TABLE IF EXISTS orders CASCADE;
CREATE TABLE orders(order_id text, customer_id int, order_count int, vendor text);

INSERT INTO orders VALUES
('Ord195342',1001,12,'Direct Parts'),
('Ord245532',1001,54,'Direct Parts'),
('Ord344394',1001,32,'ACME'),
('Ord442423',2002,7,'ACME'),
('Ord524232',2002,16,'ACME'),
('Ord645363',2002,5,'Direct Parts');

SELECT * FROM orders;

WITH max_orders AS (
  SELECT customer_id, MAX(order_count) AS max_order_cnt
  FROM orders
  GROUP BY customer_id
)

SELECT o.customer_id, o.vendor
FROM max_orders AS mo 
INNER JOIN orders AS o
ON mo.customer_id = o.customer_id AND
mo.max_order_cnt = o.order_count
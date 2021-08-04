use twitterdb

DROP TABLE IF EXISTS orders;
CREATE TABLE orders(order_id text, customer_id int, order_date date, amount text, state text);

INSERT INTO orders
VALUES ('Ord145332',1001,'2018-1-1',100,'TX'),
('Ord657895',1001,'2018-1-1',150,'TX'),
('Ord887612',1001,'2018-1-1',75,'TX'),
('Ord654374',1001,'2018-2-1',100,'TX'),
('Ord345362',1001,'2018-3-1',100,'TX'),
('Ord912376',2002,'2018-2-1',75,'TX'),
('Ord543219',2002,'2018-2-1',150,'TX'),
('Ord156357',3003,'2018-1-1',100,'IA'),
('Ord956541',3003,'2018-2-1',100,'IA'),
('Ord856993',3003,'2018-3-1',100,'IA'),
('Ord864573',4004,'2018-4-1',100,'IA'),
('Ord654525',4004,'2018-5-1',50,'IA'),
('Ord987654',4004,'2018-5-1',100,'IA');

SELECT * FROM orders;

-- Extract month of each order to be used in next CTE
WITH orders_months AS (
  SELECT o.*, EXTRACT(MONTH FROM o.order_date) AS month_number
  FROM orders AS o
),

-- Partition by customer_id and month_number to find the average monthly order amount for each customer
-- and use this to create a boolean column which tells us if that customer had a monthly order average
-- of at least 100 or not
customer_month_averages AS (
  SELECT *,
         AVG(amount) OVER (PARTITION BY customer_id, month_number ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) >= 100 AS "atleast100"
  FROM orders_months
),

-- Partition by state and using our boolean condition atleast100 from the previous CTE we SUM how 
-- many customers had a monthly average of at least 100.  Next PARTITION BY state again and COUNT
-- how many entries for each state.  If the SUM of our boolean condition atleast100 equals the COUNT
-- then we know that all companies had a monthly average of at least 100 for that state.
-- Treat this as a new boolean condition and creat a new column for filtering in the next step
last_table AS (
  SELECT *,
         SUM(CASE 
         	       WHEN atleast100 = 1 THEN 1
         	       ELSE 0
       	     END) OVER (PARTITION BY STATE) = COUNT(*) OVER (PARTITION BY state) AS "all_greater_than_100"
  FROM customer_month_averages
)

-- use WHERE to filter out states that didn't have all customers with an average monthly order >= 100
-- use DISTINCT to filter out duplicates that result from the window function in the previous CTE
SELECT DISTINCT lt.state AS state_with_all_customers_with_avg_monthly_orders_at_least100
FROM last_table AS lt
WHERE lt.all_greater_than_100 = 1;

-- Their solution
WITH cte_avg_monthly_sales_customers AS (
  SELECT o.customer_id, o.order_date, AVG(o.amount) AS average_value, o.state
  FROM orders AS o
  GROUP BY o.customer_id, o.order_date, o.state
)

SELECT state
FROM cte_avg_monthly_sales_customers
GROUP BY state
HAVING MIN(average_value) >= 100;


SELECT * FROM orders;

SELECT o.state
FROM orders AS o
WHERE (SELECT AVG(amount) OVER (PARTITION BY customer_id, order_date ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
              FROM orders
              WHERE customer_id = o.customer_id) >= 100
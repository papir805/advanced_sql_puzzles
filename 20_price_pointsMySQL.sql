use twitterdb

DROP TABLE IF EXISTS products;
CREATE TABLE products(product_id int, unit_price text, effective_date date);
INSERT INTO products
VALUES (1001, '$1.99', '2018-1-1'),
       (1001, '$2.99', '2018-4-15'),
       (1001, '$3.99', '2018-6-8'),
       (2002, '$1.99', '2018-4-17'),
       (2002, '$2.99', '2018-5-19');

SELECT * FROM products;


SELECT DISTINCT 
       product_id,
       LAST_VALUE(effective_date) OVER (PARTITION BY product_id ORDER BY effective_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS a,
       LAST_VALUE(unit_price) OVER (PARTITION BY product_id ORDER BY effective_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS b
FROM products;
use twitterdb

DROP TABLE IF EXISTS sales CASCADE;

CREATE TABLE sales(sales_rep_id int, invoice_id text, amount int, sales_type text);

INSERT INTO sales VALUES
(1001,'Inv345756',13454,'International'),
(2002,'Inv546744',3434,'International'),
(4004,'Inv234745',54645,'International'),
(5005,'Inv895745',234345,'International'),
(7007,'Inv006321',776,'International'),
(1001,'Inv734534',4564,'Domestic'),
(2002,'Inv600213',34534,'Domestic'),
(3003,'Inv757853',345,'Domestic'),
(6006,'Inv198632',6543,'Domestic'),
(8008,'Inv977654',67,'Domestic');

WITH cte_international AS (
  SELECT *
  FROM sales
  WHERE sales_type = 'International'
),

cte_domestic AS (
  SELECT *
  FROM sales
  WHERE sales_type = 'Domestic'
),

outer_join AS (
  SELECT d1.sales_rep_id
  FROM cte_domestic AS d1
  LEFT JOIN cte_international AS i1
  ON d1.sales_rep_id = i1.sales_rep_id
  WHERE i1.sales_rep_id IS NULL
    UNION
  SELECT i1.sales_rep_id
  FROM cte_domestic AS d1
  RIGHT JOIN cte_international AS i1
  ON d1.sales_rep_id = i1.sales_rep_id
  WHERE d1.sales_rep_id IS NULL
)

SELECT *
FROM outer_join
ORDER BY sales_rep_id;
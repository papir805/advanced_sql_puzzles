use twitterdb

DROP TABLE IF EXISTS order_fullfillment CASCADE;
DROP TABLE IF EXISTS manufacturing_time CASCADE;

CREATE TABLE order_fullfillment(order_id text, product_id text, days_to_delivery int);
CREATE TABLE manufacturing_time(part_id text, product_id text, days_to_manufacture int);

INSERT INTO Order_Fullfillment VALUES
('Ord893456','Widget',7),
('Ord923654','Gizmo',3),
('Ord187239','Doodad',9);


INSERT INTO Manufacturing_Time VALUES
('AA-111','Widget',7),
('BB-222','Widget',2),
('CC-333','Widget',3),
('DD-444','Widget',1),
('AA-111','Gizmo',7),
('BB-222','Gizmo',2),
('AA-111','Doodad',7),
('DD-444','Doodad',1);

SELECT *
FROM order_fullfillment AS o
INNER JOIN manufacturing_time AS mf
ON mf.days_to_manufacture <= o.days_to_delivery
AND o.product_id = mf.product_id;

-- My solution using a correlated subquery
SELECT o.order_id, o.product_id
FROM order_fullfillment AS o
WHERE o.days_to_delivery >= ALL (SELECT mf.days_to_manufacture 
	                             FROM manufacturing_time AS mf
	                             WHERE mf.product_id = o.product_id);

-- My other solution using CTEs and an INNER JOIN
-- We find the maximum days to manufacture each component of a given product_id as that's the bottleneck
-- in regards to manufacturing that specific product
WITH maximum_days_to_manufature AS (
  SELECT mf.product_id, MAX(mf.days_to_manufacture) AS maximum
  FROM manufacturing_time AS mf
  GROUP BY mf.product_id
)

-- Then we use the maximum days to manufacture as an INNER JOIN condition
-- returning only product_ids that have a days_to_delivery that's at least as big as 
-- the maximum days to manufacture that product
SELECT DISTINCT o.order_id, o.product_id
FROM order_fullfillment AS o
INNER JOIN maximum_days_to_manufature AS md
ON md.product_id = o.product_id
AND o.days_to_delivery >= md.maximum
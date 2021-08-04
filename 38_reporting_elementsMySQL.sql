use twitterdb

DROP TABLE IF EXISTS RegionSales CASCADE;

CREATE TABLE RegionSales(region text, distributor text, sales int);

INSERT INTO RegionSales VALUES
('North','ACE',10),
('South','ACE',67),
('East','ACE',54),
('North','Direct Parts',8),
('South','Direct Parts',7),
('West','Direct Parts',12),
('North','ACME',65),
('South','ACME',9),
('West','ACME',1),
('East','ACME',7);

SELECT * FROM RegionSales;

WITH distinct_regions AS (
  SELECT DISTINCT
    region
  FROM RegionSales
),

distinct_distributors AS (
  SELECT DISTINCT
    distributor
  FROM RegionSales
),

all_combos AS (
  SELECT dr.region,
         dd.distributor,
         CASE
             WHEN dr.region = 'North' THEN 1
             WHEN dr.region = 'South' THEN 2
             WHEN dr.region = 'East' THEN 3
             WHEN dr.region = 'West' THEN 4
         END AS rn
  FROM   distinct_regions AS dr, 
         distinct_distributors AS dd
)

SELECT ac.region, ac.distributor, COALESCE(rs.sales, 0) AS sales
FROM all_combos AS ac
LEFT JOIN RegionSales AS rs
ON ac.region = rs.region
AND ac.distributor = rs.distributor
ORDER BY ac.distributor, ac.rn;
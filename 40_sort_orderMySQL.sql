use twitterdb

DROP TABLE IF EXISTS sort_order CASCADE;

CREATE TABLE sort_order(city text);

INSERT INTO Sort_Order VALUES
('Atlanta'),('Baltimore'),('Chicago'),('Denver');

SELECT * FROM sort_order;

-- My solution
SELECT so.city
FROM sort_order AS so
ORDER BY FIELD(so.city, 'Baltimore', 'Denver', 'Atlanta', 'Chicago');

SELECT so.city
FROM sort_order AS so
ORDER BY FIELD(SUBSTRING(so.city, 1, 1), 'B', 'D', 'A', 'C');

-- Their solution
SELECT City
FROM Sort_Order
ORDER BY (CASE City WHEN 'Atlanta' THEN 2 WHEN 'Baltimore' THEN 1 WHEN 'Chicago' THEN 4
WHEN 'Denver' THEN 1 END);
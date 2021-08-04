use twitterdb

DROP TABLE IF EXISTS group_criteria CASCADE;

CREATE TABLE group_criteria(order_id text,
                            distributor text,
                            facility int,
                            zone text,
                            amount int);

INSERT INTO group_criteria VALUES
('Ord156795','ACME',123,'ABC',100),
('Ord826109','ACME',123,'ABC',75),
('Ord342876','Direct Parts',789,'XYZ',150),
('Ord994981','Direct Parts',789,'XYZ',125);

SELECT * FROM group_criteria;

-- My solution
WITH density AS (
  SELECT DISTINCT distributor, facility, zone,
  DENSE_RANK() OVER (ORDER BY distributor, facility, zone) AS rn
  FROM group_criteria
)

SELECT d.rn, g.order_id, g.distributor, g.facility, g.zone, g.amount
FROM density AS d
INNER JOIN group_criteria AS g
ON d.distributor = g.distributor
AND d.facility = g.facility
AND d.zone = g.zone;

-- Their solution
SELECT DENSE_RANK() OVER (ORDER BY distributor, facility, zone) AS rn,
       order_id,
       distributor,
       facility,
       zone,
       amount
FROM group_criteria;
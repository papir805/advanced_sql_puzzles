use twitterdb

DROP TABLE IF EXISTS phone;
CREATE TABLE phone(customer_id int, type text, phone_number text);
INSERT INTO phone
VALUES (1001, 'Cellular', '555-897-5421'),
       (1001, 'Work', '555-897-6542'),
       (1001, 'Home', '555-698-9874'),
       (2002, 'Cellular', '555-963-6544'),
       (2002, 'Work', '555-812-9856'),
       (3003, 'Cellular', '555-987-6541');

WITH ranked_phone AS (
	SELECT *,
	       ROW_NUMBER() OVER (PARTITION BY type ORDER BY customer_id) AS rn
	FROM phone
	)


SELECT 
       MAX(CASE WHEN type = 'Cellular' THEN phone_number END) AS Cellular,
       MAX(CASE WHEN type = 'Work' THEN phone_number END) AS Work,
       MAX(CASE WHEN type = 'Home' THEN phone_number END) AS Home
FROM ranked_phone
GROUP BY rn;

SELECT customer_id,
       MAX(CASE WHEN type = 'Cellular' THEN phone_number END) AS Cellular,
       MAX(CASE WHEN type = 'Work' THEN phone_number END) AS Work,
       MAX(CASE WHEN type = 'Home' THEN phone_number END) AS Home
FROM phone
GROUP BY customer_id;
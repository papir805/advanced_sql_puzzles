use twitterdb
DROP TABLE IF EXISTS queries;
CREATE TABLE queries(sequence int, syntax text);
INSERT INTO queries
VALUES (1, 'SELECT'),
       (2, 'Product'),
       (3, 'UnitPrice'),
       (4, 'EffectiveDate'),
       (5, 'FROM'),
       (6, 'Products'),
       (7, 'WHERE'),
       (8, 'UnitPrice'),
       (9, '> 100');

SELECT GROUP_CONCAT(CASE WHEN sequence IN (2, 3) 
	                THEN CONCAT(syntax, ',') 
	                ELSE syntax 
	                END ORDER BY sequence 
	                SEPARATOR ' '
	                ) AS syntax
FROM queries;

WITH RECURSIVE cte_DMLGroupConcat(String2,Depth) AS
(
SELECT CAST('' AS CHAR(255)),
       MAX(sequence)
FROM queries
UNION ALL
SELECT CONCAT(cte_ordered.syntax, ' ', cte_concat.string2), cte_concat.depth - 1
FROM cte_DMLGroupConcat AS cte_concat
INNER JOIN queries AS cte_ordered
ON cte_concat.depth = cte_ordered.sequence
WHERE depth>0
)

SELECT string2 AS syntax
FROM cte_DMLGroupConcat
WHERE depth = 0
;
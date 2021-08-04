use twitterdb
DROP TABLE IF EXISTS SampleData;
CREATE TABLE SampleData(IntegerValue int);
INSERT INTO SampleData 
VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10);

SELECT IntegerValue AS num,
mod(IntegerValue, 2) AS "num%2",
CASE WHEN mod(IntegerValue, 2) > 0 THEN'Prime Number'
     WHEN IntegerValue <= 2 THEN 'Prime Number'
     END AS is_prime
FROM SampleData;
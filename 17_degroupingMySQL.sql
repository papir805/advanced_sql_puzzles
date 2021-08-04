use twitterdb

DROP TABLE IF EXISTS items;

CREATE TABLE items(product text, quantity int);

INSERT INTO items
VALUES ('Pencil', 3),
       ('Eraser', 4),
       ('Notebook', 2);


SELECT REPEAT(CONCAT(product, ' '), quantity)
FROM items;

WITH RECURSIVE 
item_list(product, quantity) AS (
  SELECT CASE
              WHEN MAX(items) = 0 THEN NULL
              'Pencil')
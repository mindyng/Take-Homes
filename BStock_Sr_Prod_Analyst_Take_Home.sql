--Run here: https://www.db-fiddle.com/f/7Lo6BB8NGoPgsWstmdwjnE/8

CREATE TABLE table_A (
  "transaction_id" VARCHAR(6),
  "seller_id" INTEGER,
  "buyer_id" INTEGER,
  "item_id" VARCHAR(4),
  "quantity" INTEGER,
  "item_price" INTEGER,
  "payment_process_yn" VARCHAR(1),
  "Transaction_date" VARCHAR(10)
);

INSERT INTO table_A
  ("transaction_id", "seller_id", "buyer_id", "item_id", "quantity", "item_price", "payment_process_yn", "Transaction_date")
VALUES
  ('215645', '12315', '94224', 'b546', '2', '2025', 'y', '15/06/2020'),
  ('564544', '15358', '11258', 'b564', '5', '3080', 'y', '15/02/2018'),
  ('513135', '12252', '27315', 'b644', '4', '14050', 'n', '26/05/2021'),
  ('545464', '15846', '21535', 'b852', '3', '1065', 'n', '24/09/2020'),
  ('456465', '85421', '12021', 'b654', '1', '200', 'y', '13/08/2020');

CREATE TABLE table_B (
  "seller_id" INTEGER,
  "country_name" VARCHAR(6)
);

INSERT INTO table_B
  ("seller_id", "country_name")
VALUES
  ('12315', 'USA'),
  ('15358', 'USA'),
  ('12252', 'Canada'),
  ('15846', 'Canada'),
  ('85421', 'China');
  
 -- What is the weekly revenue for 2020?

ALTER TABLE table_A
    ALTER COLUMN "Transaction_date" TYPE DATE USING TO_DATE("Transaction_date", 'DD/MM/YYYY'); --Transaction_date column is string type. TO_CHAR function will be used later to convert date to ISO, but only takes non-string. So TO_DATE used here to produce non-string data type.


ALTER TABLE table_A
    ALTER COLUMN "Transaction_date" TYPE DATE USING TO_DATE((TO_CHAR("Transaction_date", 'YYYY/MM/DD')), 'YYYY/MM/DD'); --TO_DATE converts string into a date format. Before doing that, needed to convert our data into ISO format.

SELECT DATE_PART('week', "Transaction_date") AS week --With data in ISO and date format, we extract week value.
, SUM(CASE WHEN payment_process_yn = 'y' THEN  quantity * item_price ELSE 0 END) AS revenue
FROM table_A
WHERE "Transaction_date" BETWEEN '2020/01/01' AND '2020/12/31'
GROUP BY 1
ORDER BY 1;

-- What is the highest actual revenue for each country? (The final result of your query has to show a record for each country and the record must have all details (i.e. all fields in Table A below) of the transaction)

WITH base AS (

SELECT table_B.country_name
, table_A.transaction_id
, table_A.seller_id
, table_A.buyer_id
, table_A.item_id
, table_A.quantity
, table_A.item_price
, table_A.payment_process_yn
, table_A."Transaction_date"
, SUM(CASE WHEN table_A.payment_process_yn = 'y' THEN table_A.quantity * table_A.item_price ELSE 0 END) AS revenue
FROM table_A 
RIGHT JOIN table_B
ON table_A.seller_id = table_B.seller_id
GROUP BY 1
, 2
, 3
, 4
, 5
, 6
, 7
, 8
, 9
  
)
  
SELECT country_name
, transaction_id
, seller_id
, buyer_id
, item_id
, quantity
, item_price
, payment_process_yn
, "Transaction_date"
, revenue AS highest_revenue
FROM 

(

SELECT country_name
, transaction_id
, seller_id
, buyer_id
, item_id
, quantity
, item_price
, payment_process_yn
, "Transaction_date"
, revenue 
, DENSE_RANK() OVER (PARTITION BY country_name ORDER BY revenue DESC, "Transaction_date" DESC) AS revenue_rank
FROM base
  
) AS subq

WHERE revenue_rank = 1
ORDER BY revenue DESC;

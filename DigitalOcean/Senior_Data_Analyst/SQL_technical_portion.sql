--Run here: https://www.db-fiddle.com/f/r91N4b7R4pTkvS6Wnqa6w8/8

CREATE TABLE invoice_items (
  "user_id" INTEGER,
  "invoice_month" TIMESTAMP,
  "invoice_item_type" VARCHAR(18),
  "resource_id" VARCHAR(9),
  "amount" FLOAT
);

INSERT INTO invoice_items
  ("user_id", "invoice_month", "invoice_item_type", "resource_id", "amount")
VALUES
  ('19505', '12/1/2017', 'DROPLETS_TYPE', '392058496', '10.00'),
  ('19505', '12/1/2017', 'BACKUPS_TYPE', 'null', '2.00'),
  ('19505', '1/1/2018', 'DROPLETS_TYPE', '392058496', '10.00'),
  ('19505', '1/1/2018', 'DROPLETS_TYPE', '405849382', '2.17'),
  ('19505', '1/1/2018', 'BACKUPS_TYPE', 'null', '2.00'),
  ('19506', '12/1/2017', 'DROPLETS_TYPE', '239483829', '640.00'),
  ('19506', '12/1/2017', 'BLOCK_STORAGE_TYPE', '582938', '200.00');

CREATE TABLE users (
  "user_id" INTEGER,
  "email" VARCHAR(16),
  "created_at" TIMESTAMP
);

INSERT INTO users
  ("user_id", "email", "created_at")
VALUES
  ('19505', 'john@hotmail.com', '2016-04-02 18:40:50'),
  ('19505', 'john@gmail.com', '2017-09-15 13:10:22');

CREATE TABLE customer_satisfaction_scores (
  "user_id" INTEGER,
  "created_at" TIMESTAMP,
  "csat_score" INTEGER
);

INSERT INTO customer_satisfaction_scores
  ("user_id", "created_at", "csat_score")
VALUES
  ('6574651', '2017-10-08 14:23:56', '7'),
  ('543334', '2017-10-15 18:14:08', '2'),
  ('137846', '2017-10-19 6:45:31', '5'),
  ('2450345', '2017-11-15 11:30:29', '8'),
  ('3859696', '2017-11-15 11:33:11', '6'),
  ('1834789', '2017-11-15 11:34:55', '1'),
  ('9827342', '2017-12-18 10:13:09', '6'),
  ('2069757', '2017-12-20 8:56:20', '3');


--assumuing all dates are in 2022 Q1
CREATE TABLE customer_support_tickets (
  "Ticket Type" VARCHAR(12),
  "Month" TIMESTAMP,
  "Count" INTEGER
);

INSERT INTO customer_support_tickets
  ("Ticket Type", "Month", "Count")
VALUES
  ('Billing', 'Jan-19-2022', '5637'),
  ('Software/App', 'Jan-19-2022', '2453'),
  ('Account', 'Jan-19-2022', '567'),
  ('Performance', 'Jan-19-2022', '4563'),
  ('Risk', 'Jan-19-2022', '1342'),
  ('Other', 'Jan-19-2022', '654'),
  ('Billing', 'Feb-19-2022', '6735'),
  ('Software/App', 'Feb-19-2022', '4837'),
  ('Account', 'Feb-19-2022', '311'),
  ('Performance', 'Feb-19-2022', '4362'),
  ('Risk', 'Feb-19-2022', '897'),
  ('Other', 'Feb-19-2022', '756'),
  ('Billing', 'Mar-19-2022', '5647'),
  ('Software/App', 'Mar-19-2022', '8647'),
  ('Account', 'Mar-19-2022', '415'),
  ('Performance', 'Mar-19-2022', '6235'),
  ('Risk', 'Mar-19-2022', '1854'),
  ('Other', 'Mar-19-2022', '892');
  
--1. Monthly spend totals by user’s most recent email. 

-- Assumed that even though user did not have email provided, their measurements still mattered. So included user_id and email as level of granularity.

WITH base AS (

SELECT 
invoice.user_id
, users.email
, invoice.invoice_month
, invoice.invoice_item_type
, CASE WHEN invoice_item_type = 'DROPLETS_TYPE' THEN 1 ELSE 0 END AS droplets_count
, SUM(invoice.amount) OVER (PARTITION BY invoice.user_id, users.email, invoice.invoice_month) AS total_spend
FROM 
(
SELECT user_id
, email
, created_at
FROM users
ORDER BY 3 DESC
LIMIT 1
) users

RIGHT JOIN

(
SELECT *
FROM invoice_items
) invoice

ON users.user_id = invoice.user_id
)

--2. A field showing their count of droplets used that month
--3. A field that gives a value of “Low Value” if the customer spent <$500 and “High Value” if the customer spent >=$500 in a given month.

SELECT user_id
, email AS recent_email
, invoice_month
, SUM(droplets_count) AS count_droplets
, total_spend
, CASE WHEN total_spend <500 THEN 'Low Value' ELSE 'High Value' END AS spend_segment
FROM base
GROUP BY 1
, 2
, 3
, 5
, 6
ORDER BY 1
, 3;

--4. Given the customer_satisfaction_scores table, construct a SQL query that would return one row per month, containing the average customer satisfaction score (CSAT) for that month as well as a column giving the 6-month trailing average CSAT score.

SELECT *
, CASE WHEN ROW_NUMBER() OVER (ORDER BY year_month) > 1
       THEN AVG(csat) OVER (ORDER BY year_month DESC
                ROWS BETWEEN 1 FOLLOWING AND 6 FOLLOWING)
       ELSE NULL 
  END AS csat_six_mo
FROM 
(
SELECT TO_CHAR(created_at, 'YYYY-MM') AS year_month
, AVG(csat_score) AS csat
FROM customer_satisfaction_scores
GROUP BY 1
ORDER BY 1
) subq;

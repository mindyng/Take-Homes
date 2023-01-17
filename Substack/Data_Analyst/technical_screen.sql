--Run code here: https://www.db-fiddle.com/f/339hEb5ztu7phUn5BkmwWU/4

CREATE TABLE publications (
  "id" INTEGER,
  "subdomain" VARCHAR(14),
  "created_at" VARCHAR(30),
  "country" VARCHAR(2),
  "author_id" INTEGER
);

INSERT INTO publications
  ("id", "subdomain", "created_at", "country", "author_id")
VALUES
  (1, 'barrysbuddies', '@July 25, 2020 7:13 AM', 'US', 3),
  (2, 'sendmetomars', '@July 1, 2020 1:14 AM', 'US', 1),
  (3, 'willyswonders', '@July 2, 2020 4:17 PM', 'GB', 2);
  
 CREATE TABLE users (
  "id" INTEGER,
  "name" VARCHAR(14),
  "email" VARCHAR(21),
  "created_at" VARCHAR(40),
  "country" VARCHAR(2)
);

INSERT INTO users
  ("id", "name", "email", "created_at", "country")
VALUES
  (1, 'Emon Tusk', 'emon@example.com', '@June 16, 2020 1:14 PM (EDT)', 'US'),
  (2, 'Will Gates', 'william@microsoft.com', '@June 25, 2020 10:07 AM (EDT)', 'US'),
  (3, 'Barry Gage', 'bg@google.com', '@June 30, 2020 12:23 PM (EDT)', 'US'),
  (4, 'Geoff Beesoz', 'geoff@amazon.com', '@July 5, 2020 5:33 AM (EDT)', 'US');
  
 CREATE TABLE subscriptions (
  "id" INTEGER,
  "publication_id" INTEGER,
  "user_id" INTEGER,
  "created_at" VARCHAR(40),
  "expires_at" VARCHAR(40),
  "email_disabled" BOOLEAN,
  "type" VARCHAR(5)
);

INSERT INTO subscriptions
  ("id", "publication_id", "user_id", "created_at", "expires_at","email_disabled", "type")
VALUES
  (1, 2, 3, '@July 1, 2020 12:23 AM (EDT)', '@August 1, 2020 12:23 AM (EDT)', FALSE, 'comp'),
  (2, 2, 2, '@July 29, 2020 11:08 AM (EDT)', '@August 29, 2020 11:08 AM (EDT)', FALSE, NULL),
  (3, 3, 2, '@July 29, 2020 1:43 PM (EDT)', '@July 29, 2021 1:43 PM (EDT)', FALSE, 'gift'),
  (4, 3, 1, '@August 2, 2020 12:21 PM (EDT))', NULL, TRUE, NULL),
  (5, 2, 1, '@July 27, 2020 7:11 AM (EDT)', '@August 3, 2022 7:11 AM (EDT)', FALSE, NULL),
  (6, 1, 1, '@July 26, 2020 9:16 PM (EDT)', '@August 26, 2020 9:16 PM (EDT)', TRUE, NULL);
  
CREATE TABLE subscribed (
  "id" INTEGER,
  "publication_id" INTEGER,
  "user_id" INTEGER,
  "timestamp" VARCHAR(40)
);

INSERT INTO subscribed
  ("id", "publication_id", "user_id", "timestamp")
VALUES
  (1, 2, 3, '@July 1, 2020 2:07 AM'),
  (2, 1, 1, '@July 26, 2020 2:10 PM');

  
CREATE TABLE unsubscribed (
  "id" INTEGER,
  "timestamp" VARCHAR(40),
  "publication_id" INTEGER,
  "user_id" INTEGER,
  "unsubscribe_reason" VARCHAR(40)
);

INSERT INTO unsubscribed
  ("id", "publication_id", "user_id", "timestamp", "unsubscribe_reason")
VALUES
  (1, 1, 1, '@August 1, 2020 4:15 AM', 'too_expensive'),
  (2, 1, 2, '@August 4, 2020 12:00 AM', NULL);
  
--1. How many publications are created per day?

SELECT DATE(TO_TIMESTAMP(RIGHT(created_at, -1), 'Month DD, YYYY HH:MI AM')) AS date
, COUNT(DISTINCT id) AS num_publications
FROM publications
GROUP BY 1
ORDER BY 1;

--2. For each publication (by subdomain):

-- a. As of today, how many paid and free subscriptions are there?
-- i. The output should be → 1 row per pub w/ 3 columns

WITH subs AS (
SELECT p.id AS pub_id
, p.subdomain
, p.created_at
, p.country
, p.author_id
, s.id AS sub_id
, s.publication_id
, s.user_id
, s.created_at
, TO_TIMESTAMP(SUBSTR(s.expires_at, 2, LENGTH(s.expires_at) - 6), 'Month DD, YYYY HH:MI AM') AS expires_at
, s.email_disabled
, s.type
FROM publications AS p
LEFT JOIN subscriptions AS s
ON p.id = s.publication_id 
)

, subs2 AS (
SELECT subdomain
, SUM(CASE WHEN expires_at IS NULL OR NOW() > expires_at THEN 1 ELSE 0 END) AS free_sub
, COUNT(publication_id) AS total_sub
FROM subs
WHERE (CASE WHEN pub_id = publication_id AND author_id = user_id THEN 1 ELSE 0 END) = 0
AND email_disabled IS FALSE
GROUP BY 1
ORDER BY 1
) 

SELECT subdomain
, free_sub
, total_sub - free_sub AS paid_sub  
FROM subs2;

-- b. Now, adjust query to split out these columns:
-- total_email_list (free + paid)
-- paying_subscription
-- comped_subscriptions
-- gifted_subscriptions
-- i. The output should be → 1 row per pub w/ 5 columns

WITH subs AS (
SELECT p.id AS pub_id
, p.subdomain
, p.created_at
, p.country
, p.author_id
, s.id AS sub_id
, s.publication_id
, s.user_id
, s.created_at
, TO_TIMESTAMP(SUBSTR(s.expires_at, 2, LENGTH(s.expires_at) - 6), 'Month DD, YYYY HH:MI AM') AS expires_at
, s.email_disabled
, s.type
FROM publications AS p
LEFT JOIN subscriptions AS s
ON p.id = s.publication_id 
)

SELECT subdomain
, COUNT(*) AS total_email_list
, COUNT(*) - (SUM(CASE WHEN expires_at IS NULL OR NOW() > expires_at THEN 1 ELSE 0 END)) AS paying_subscriptions
, SUM(CASE WHEN NOW() <= expires_at AND type = 'comp' THEN 1 ELSE 0 END) AS comped_subscriptions
, SUM(CASE WHEN NOW() <= expires_at AND type = 'gift' THEN 1 ELSE 0 END) AS gifted_subscriptions
FROM subs
WHERE (CASE WHEN pub_id = publication_id AND author_id = user_id THEN 1 ELSE 0 END) = 0
AND email_disabled IS FALSE
GROUP BY 1
ORDER BY 1;

-- 3. For each publication, what is the percentage change in the number of new subscriptions each week?
-- For example, pretend publication X had 10 subscriptions this week and 8 subscriptions in the week prior.
-- Then publication X had a 25% week-over-week ( WoW ) increase in subscriptions.

WITH base AS (
SELECT date_trunc('week', day)::date as week
, day
, publication_id
, COUNT(publication_id) OVER (PARTITION BY date_trunc('week', day)::date, publication_id) AS sub_per_pub_per_week
FROM GENERATE_SERIES('2020-07-01', '2020-08-04', '1 day'::INTERVAL) AS day
LEFT JOIN subscribed AS s 
ON (day = DATE(TO_TIMESTAMP(RIGHT(timestamp, -1), 'Month DD, YYYY HH:MI AM')))
ORDER BY 1
) 

, week_level_sub_count AS (
SELECT DISTINCT week
, publication_id
, sub_per_pub_per_week
FROM base
ORDER BY 1
, 2
)
 
, previous_week_count AS (
SELECT *
, COALESCE((LAG(sub_per_pub_per_week, 1) OVER (PARTITION BY publication_id ORDER BY week)), 0) AS previous_week_sub
FROM week_level_sub_count
ORDER BY 1
, 2
)

SELECT week
, publication_id
, (sub_per_pub_per_week - previous_week_sub)/(NULLIF(previous_week_sub,0))::FLOAT * 100 AS wow_perc
FROM previous_week_count
ORDER BY 1
, 2;

-- 4. For each publication, what is the total number of subscribers on any given day?
-- The output should be a table with 3 columns, corresponding to 1 row per day per pub and the total subscriber count on that day.

WITH base AS (
SELECT *
FROM GENERATE_SERIES('2020-07-01', '2020-08-04', '1 day'::INTERVAL) AS day
LEFT JOIN subscribed AS s 
ON (day = DATE(TO_TIMESTAMP(RIGHT(timestamp, -1), 'Month DD, YYYY HH:MI AM')))
ORDER BY 1
)

, before_cancel AS (
SELECT day
, publication_id
, user_id 
FROM base
WHERE day < (SELECT MIN(DATE(TO_TIMESTAMP(RIGHT(timestamp, -1), 'Month DD, YYYY HH:MI AM'))) FROM unsubscribed)
ORDER BY 1,
2
)

, after_cancel AS (
SELECT day
, base.publication_id AS base_pub
, base.user_id AS base_user_id
, u.timestamp
, u.publication_id AS u_pub
, u.user_id AS u_user_id
FROM base
LEFT JOIN unsubscribed u
ON base.publication_id = u.publication_id
AND base.user_id = u.user_id
AND day <= DATE(TO_TIMESTAMP(RIGHT(u.timestamp, -1), 'Month DD, YYYY HH:MI AM'))
WHERE day >= (SELECT MIN(DATE(TO_TIMESTAMP(RIGHT(timestamp, -1), 'Month DD, YYYY HH:MI AM'))) FROM unsubscribed) 	
ORDER BY 1,
2
)

, union_cte AS (
SELECT day
, publication_id
, user_id
FROM before_cancel
UNION
SELECT day
, base_pub AS publication_id
, base_user_id AS user_id
FROM after_cancel
WHERE u_pub IS NULL
) 

SELECT day
, publication_id
, SUM(COUNT(publication_id)) OVER (PARTITION BY publication_id ORDER BY day) AS pubs_to_date
FROM union_cte
GROUP BY 1
, 2
ORDER BY 1
, 2;

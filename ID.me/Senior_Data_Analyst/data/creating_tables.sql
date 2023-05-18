CREATE TABLE customer_accounts (
  "account_id" INTEGER,
  "email" VARCHAR(18),
  "current_tier" VARCHAR(18),
  "created_at" TIMESTAMP,
  "updated_at" TIMESTAMP
);

INSERT INTO customer_accounts
  ("account_id", "email", "current_tier", "created_at", "updated_at")
VALUES
  ('1', 'abc@123.com', 'Free', '2019-05-01 21:13:05.156042+00', '2019-05-01 21:13:11.804514+00'),
  ('2', '123@abc.com', 'Medium', '2019-07-12 16:05:02.414454+00', '2020-01-04 17:23:05.594305+00'),
  ('3', 'hello@world.com', 'Enterprise', '2019-07-23 12:26:47.571431+00', '2019-09-17 04:32:32.493065+00');

CREATE TABLE customer_interactions (
  "account_id" INTEGER,
  "channel" VARCHAR(5),
  "category" VARCHAR(14),
  "service_rep" VARCHAR(7),
  "status" VARCHAR(8),
  "created_at" TIMESTAMP,
  "completed_at" TIMESTAMP
);

INSERT INTO customer_interactions
  ("account_id", "channel", "category", "service_rep", "status", "created_at", "completed_at")
VALUES
  ('1', 'web', 'Tech Support', 'Andy', 'resolved', '2021-01-25 19:11:35.295813+00', '2021-01-25 19:13:52.812371+00'),
  ('1', 'email', 'Billing', 'Jillian', 'open', '2021-04-06 22:23:09.581234+00', NULL),
  ('3', 'web', 'Billing', 'Monica', 'resolved', '2021-11-13 06:25:54.821374+00', '2021-11-15 12:19:33.882136+00'),
  ('7', 'phone', 'Account Change', 'Derek', 'canceled', '2022-02-14 15:02:47.219352+00', '2022-02-20 09:22:48.145523+00');
 
CREATE TABLE customer_licenses (
  "account_id" INTEGER,
  "license_data" JSONB, --accepts string array and string dict
  "created_at" TIMESTAMP,
  "updated_at" TIMESTAMP
);

INSERT INTO customer_licenses
  ("account_id", "license_data", "created_at", "updated_at")
VALUES 
  (1, '{"license_id": "d17cb11cda9ba249c22f67e4aed65d0f65f1a80c", "role": "analyst", "status": "active"}', '2022-03-12 02:56:37.652093+00', '2022-03-12 02:56:37.652093+00'),
  (6, '{"license_id": "be49ad8f4a68fbbdd1674b41da20759f54b0e930", "role": "developer", "status": "active"}', '2021-05-28 04:42:58.955093+00', '2021-05-28 04:42:58.955093+00'),
  (6, '{"license_id": "8541866bb3a4c4ecf070b2c1b2f7bb9c0934d287", "role": "admin", "status": "active"}', '2022-10-30 21:33:46.353060+00', '2022-10-30 21:33:46.353060+00'),
  (35,'{"license_id": "60831f59a531eef325e525ad58bae0e5e8c2d75a", "role":"developer", "status":"disabled"}', '2021-03-26 02:38:02.136033+00', '2022-07-21 23:03:29.862040+00');
  
CREATE TABLE customer_invoices (
  "account_id" INTEGER,
  "invoice_created" TIMESTAMP,
  "price" FLOAT,
  "payment_method" VARCHAR(18),
  "payment_total" FLOAT
);

INSERT INTO customer_invoices
  ("account_id", "invoice_created", "price", "payment_method", "payment_total")
VALUES
  ('1', '2019-05-01 21:13:05.156042+00', '0.00', NULL, '0.00'),
  ('2', '2020-01-04 17:23:05.594305+00', '50.00', 'Credit', '51.20'),
  ('3', '2019-09-17 04:32:32.493065+00', '500.00', 'ACH', '500.00');

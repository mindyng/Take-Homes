-- Ref: (creation of tables and queries) https://www.db-fiddle.com/f/cGXjLQJ3Gz1vy7ucVMjngx/2

SELECT account_id
, license_data ->> 'license_id' AS license_id
, license_data ->> 'role' AS role
, license_data ->> 'status' AS status
, created_at
, updated_at
FROM customer_licenses;

-- Ref: (creation of tables and queries) https://www.db-fiddle.com/f/cGXjLQJ3Gz1vy7ucVMjngx/2
-- 3. The customer service team has asked one of the data analysts to develop a dashboard to illustrate the monthly interaction volume of the accounts with the 10 highest number of active developer licenses. They are looking for various breakdowns by account, month, interaction channel, category, service representative, and interaction status.

-- You have been tasked with designing a model to provide the data for the analyst. How would you structure the output? Include the query you would use to create the model.

--SQL query plan:
--filter on active licenses
--by account, get count of active dev licenses
--rank in descending order highest amount of active dev licenses per account
--filter table by top 10
--join this table to interactions table
--make sure final table has interaction month, high active dev lic account_id's, interaction channel, category, service representative, interaction status

WITH unnesting AS (
SELECT account_id
, license_data ->> 'license_id' AS license_id
, license_data ->> 'role' AS role
, license_data ->> 'status' AS status
, created_at
, updated_at
FROM customer_licenses
)

, active_dev_flag AS (SELECT account_id
, SUM(CASE WHEN role = 'developer' AND status = 'active' THEN 1 ELSE 0 END) AS total_active_dev_lic
FROM unnesting
GROUP BY 1
)

, activity_rank AS (SELECT account_id
, total_active_dev_lic
, DENSE_RANK() OVER (ORDER BY total_active_dev_lic DESC) AS active_account_rank
FROM active_dev_flag
)

SELECT EXTRACT(MONTH FROM created_at) AS interaction_month
, most_active_dev_lic.account_id
, channel AS interaction_channel
, category
, service_rep
, status
FROM (SELECT account_id
FROM activity_rank 
WHERE active_account_rank <= 10) AS most_active_dev_lic 
JOIN customer_interactions
ON most_active_dev_lic.account_id = customer_interactions.account_id
ORDER BY 1;

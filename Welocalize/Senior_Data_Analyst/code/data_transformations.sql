CREATE TABLE postgres.public.welocalize_requests AS
SELECT ROUND(average_duration_request_received_to_quoted_business_seconds, 1) AS average_duration_request_received_to_quoted_business_seconds
, ROUND(average_duration_request_received_to_quoted_business_seconds, 1)/60/60/24 AS average_duration_request_received_to_quoted_business_days
, project_manager_id
, requests_managed_simultaneously_by_project_manager
, service_line
, CASE WHEN is_client_deliverable_past_due = 'N' THEN FALSE
	WHEN is_client_deliverable_past_due = 'Y' THEN TRUE
	ELSE NULL END AS is_client_deliverable_past_due
FROM postgres.public.welocalize
WHERE is_client_deliverable_past_due != 'Unspecified';

CREATE TABLE postgres.public.welocalize_deliverables AS
SELECT client_deliverable_id
, date_client_deliverable_delivered
, total_tasks
, words
, ROUND(lateness_of_client_deliverable_seconds, 1) AS lateness_of_client_deliverable_seconds
, ROUND(lateness_of_client_deliverable_seconds, 1)/60/60/24 AS lateness_of_client_deliverable_days
, CASE WHEN is_client_deliverable_past_due = 'N' THEN FALSE
	WHEN is_client_deliverable_past_due = 'Y' THEN TRUE
    END AS is_client_deliverable_past_due
FROM postgres.public.welocalize
WHERE is_client_deliverable_past_due != 'Unspecified';

CREATE TABLE postgres.public.welocalize_translation_task AS
SELECT translations_for_client_by_supplier_to_date
, average_duration_offer_sent_to_task_claimed_seconds
, average_duration_offer_sent_to_task_claimed_seconds/60/60 AS average_duration_offer_sent_to_task_claimed_hours
, average_duration_task_claimed_to_task_started_seconds
, average_duration_task_claimed_to_task_started_seconds/60/60/24 AS average_duration_task_claimed_to_task_started_days
, source_language_locale_code 
, target_language_locale_code 
, content_specialty 
, translation_supplier_id 
, CASE WHEN is_client_deliverable_past_due = 'N' THEN FALSE
	WHEN is_client_deliverable_past_due = 'Y' THEN TRUE
	ELSE NULL END AS is_client_deliverable_past_due
FROM postgres.public.welocalize
WHERE is_client_deliverable_past_due != 'Unspecified';

--OTD/non-OTD frequencies
SELECT date_client_deliverable_delivered) AS date_delivered
, ROUND(SUM(CASE WHEN is_client_deliverable_past_due = TRUE THEN 1 ELSE 0 END) * 1.0/COUNT(*) * 100, 2) AS non_otd_perc
, ROUND(SUM(CASE WHEN is_client_deliverable_past_due = FALSE THEN 1 ELSE 0 END) * 1.0/COUNT(*) * 100, 2) AS otd_perc
FROM postgres.public.welocalize_deliverables
GROUP BY 1
ORDER BY 1;

--month:
SELECT EXTRACT(MONTH FROM date_client_deliverable_delivered) AS date_delivered_month
, ROUND(SUM(CASE WHEN is_client_deliverable_past_due = TRUE THEN 1 ELSE 0 END) * 1.0/COUNT(*) * 100, 2) AS non_otd_perc
, ROUND(SUM(CASE WHEN is_client_deliverable_past_due = FALSE THEN 1 ELSE 0 END) * 1.0/COUNT(*) * 100, 2) AS otd_perc
FROM postgres.public.welocalize_deliverables
GROUP BY 1
ORDER BY 1;

--weekly:
SELECT EXTRACT(WEEK FROM date_client_deliverable_delivered) AS date_delivered_week
, ROUND(SUM(CASE WHEN is_client_deliverable_past_due = TRUE THEN 1 ELSE 0 END) * 1.0/COUNT(*) * 100, 2) AS non_otd_perc
, ROUND(SUM(CASE WHEN is_client_deliverable_past_due = FALSE THEN 1 ELSE 0 END) * 1.0/COUNT(*) * 100, 2) AS otd_perc
FROM postgres.public.welocalize_deliverables
GROUP BY 1
ORDER BY 1;

--day of month:
SELECT EXTRACT(DAY FROM date_client_deliverable_delivered) AS day_delivered
, ROUND(SUM(CASE WHEN is_client_deliverable_past_due = TRUE THEN 1 ELSE 0 END) * 1.0/COUNT(*) * 100, 2) AS non_otd_perc
, ROUND(SUM(CASE WHEN is_client_deliverable_past_due = FALSE THEN 1 ELSE 0 END) * 1.0/COUNT(*) * 100, 2) AS otd_perc
FROM postgres.public.welocalize_deliverables
GROUP BY 1
ORDER BY 1;

--day of week:
SELECT EXTRACT(DOW FROM date_client_deliverable_delivered) AS dow_delivered
, ROUND(SUM(CASE WHEN is_client_deliverable_past_due = TRUE THEN 1 ELSE 0 END) * 1.0/COUNT(*) * 100, 2) AS non_otd_perc
, ROUND(SUM(CASE WHEN is_client_deliverable_past_due = FALSE THEN 1 ELSE 0 END) * 1.0/COUNT(*) * 100, 2) AS otd_perc
FROM postgres.public.welocalize_deliverables
GROUP BY 1
ORDER BY 1;

--PENDING:
--waiting for Kevin's re to confirm on service line; FOR NOW: it is defined in requests table and not deliverables table
--run this in dbt?

CREATE TABLE postgres.public.welocalize_requests AS
SELECT ROUND(average_duration_request_received_to_quoted_business_seconds, 1) AS average_duration_request_received_to_quoted_business_seconds
, project_manager_id
, requests_managed_simultaneously_by_project_manager
, service_line --not sure if at deliverable/at request level
FROM postgres.public.welocalize;


CREATE TABLE postgres.public.welocalize_deliverables AS
SELECT client_deliverable_id
, date_client_deliverable_delivered
, total_tasks
, words
--, average_duration_request_received_to_quoted_business_seconds --request level
, average_duration_offer_sent_to_task_claimed_seconds
, average_duration_task_claimed_to_task_started_seconds
--, translations_for_client_by_supplier_to_date --task level
--, source_language_locale_code --task level
--, target_language_locale_code --task level
--, project_manager_id --request level
--, requests_managed_simultaneously_by_project_manager --request level
--, content_specialty --task level
--, translation_supplier_id --task level
--, service_line --not sure if at deliverable/at request level
, ROUND(lateness_of_client_deliverable_seconds, 1) AS lateness_of_client_deliverable_seconds
, CASE WHEN is_client_deliverable_past_due = 'N' THEN FALSE
	WHEN is_client_deliverable_past_due = 'Y' THEN TRUE
	ELSE NULL END AS is_client_deliverable_past_due
FROM postgres.public.welocalize;

CREATE TABLE postgres.public.welocalize_translation_task AS
SELECT translations_for_client_by_supplier_to_date
, source_language_locale_code 
, target_language_locale_code 
, content_specialty 
, translation_supplier_id 
FROM postgres.public.welocalize;

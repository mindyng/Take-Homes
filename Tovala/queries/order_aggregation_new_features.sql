--what do i want to capture in general about orders per customer
select customer_id
-- ,term_id
-- ,term_start_date
-- ,cohort
, AVG(case when month(term_start_date) IN (1,11,12) then 1 else 0 end) as seasonal_break_flag
, MAX(cohort_week_without_holidays) as tenure
, MODE(case when order_statu IS NULL THEN 'paused or canceled sub' ELSE order_statu end) AS most_frequent_order_status
, MODE(subscription_status) as most_freq_sub
, MAX(running_total_fulfilled_order_count) as most_fulfilled_orders
, MAX(case when last_eight_week_order_count is null then 0 else last_eight_week_order_count end) as eight_wk_window_most_placed_orders
, AVG(consecutive_skip_count) as avg_consec_skips

, AVG(CASE WHEN order_statu = 'skipped' THEN 1 ELSE 0 END) AS skipped
from customer_term_summary
--where term_start_date NOT IN ('2020-11-23', '2020-12-21', '2021-11-22', '2021-12-20', '2022-11-21', '2022-12-19')
group by 1
limit 10

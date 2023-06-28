with cts_no_outliers as (
select * 
from customer_term_summary 
where term_start_date not in ('2020-11-23', '2020-12-21', '2021-11-22', '2021-12-20', '2022-11-21', '2022-12-19')
)

, last_active as (
select customer_id
, MAX(term_start_date) as last_active
from cts_no_outliers
where subscription_status = 'active'
group by 1
)

, recency as (select distinct t1.customer_id
, MAX(term_start_date) OVER () - last_active AS weeks_since_last_tx
from cts_no_outliers as t1
left join last_active as t2
on t1.customer_id = t2.customer_id
)


--what do i want to capture in general about orders per customer
, cts_agg as (
select cts.customer_id
, weeks_since_last_tx
, MODE(case when year(term_start_date) IN (2020,2021) then 1 else 0 end) as pandemic_flag
, MODE(case when month(term_start_date) IN (1,11,12) then 1 else 0 end) as seasonal_break_flag
, MAX(cohort_week_without_holidays) as tenure
, MODE(case when order_statu IS NULL THEN 'paused or canceled sub' ELSE order_statu end) AS most_frequent_order_status
, MODE(subscription_status) as most_freq_sub
, MAX(running_total_fulfilled_order_count) as most_fulfilled_orders
, AVG(case when last_eight_week_order_count is null then 0 else last_eight_week_order_count end) as eight_wk_window_most_placed_orders
, AVG(consecutive_skip_count) as avg_consec_skips
, MAX(running_total_fulfilled_order_count) / MAX(cohort_week_without_holidays) as orders_per_tenure
, MODE(CASE WHEN order_statu = 'skipped' THEN 1 ELSE 0 END) AS skipped

from cts_no_outliers as cts
join recency as r
ON cts.customer_id = r.customer_id
group by 1, 2
)

select cts_agg.customer_id
, weeks_since_last_tx
, pandemic_flag
, seasonal_break_flag
, tenure
, most_frequent_order_status
, most_freq_sub
, most_fulfilled_orders
, eight_wk_window_most_placed_orders
, avg_consec_skips
, orders_per_tenure
, skipped

, FIRST_ORDER_SIZE
, IS_ACTIVE_OVEN_USER
, LATEST_STATUS
, IS_FIRST_OVEN_AFFIRM_ORDER
, AGE
, GENDER
, ETHNICITY
, EDUCATION_LEVEL		
, MARITAL_STATUS
, EST_HOUSEHOLD_INCOME
, HOME_OWNERSHIP					
, HOUSEHOLD_SIZE
, HOUSEHOLD_ADULT_COUNT
, LIKELIHOOD_OF_CHILDREN
, DINING_OUT_SPEND
, ALCOHOL_SPEND
, TECH_ADOPTION	
, ENVIRONMENTAL_CONSCIOUSNESS	
, COUNTY_TYPE	
, COUNTY_POPULATION	
, FITNESS_ENTHUSIAST_PROB	
, BUYS_KITCHEN_AID_APPLIANCES	
, ORGANIC_PURCHASER	
, BRAND_LOYALIST	
, TRENDSETTER	
, DEAL_SEEKER
, RECREATIONAL_SHOPPER	
, QUALITY_CONSCIOUS	
, IMPULSE_BUYER	
, MAINSTREAM_ADOPTER	
, NOVELTY_SEEKER	
, GROCERY_DELIVERY_USER	
, FOODIE	
, DO_NOT_MAIL	
, WAREHOUSE_CLUB_MEMBERSHIP_PROB	
, LOYALTY_CARD_PROB
, MAGAZINE_PURCHASE_PROB	
, FAST_FOOD_PROB	
, HEALTHY_LIVING_PROB

, STATUS	
, OVEN_PURCHASE_PRICE

from cts_agg
left join customer_facts as cf
on cts_agg.customer_id = cf.customer_id
left join oven_orders as oo
on cts_agg.customer_id = oo.customer_id
order by 1

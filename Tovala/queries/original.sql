with srs as (
select
term_start_date
, count(distinct case when order_statu = 'skipped' then
customer_term_id end) as skip_count // status on order was “skipped”
, count(distinct case when subscription_status = 'active' then
customer_term_id end) as active_count // status on account was “active”
, skip_count / active_count as skip_rate
from interview.customer_term_summary
group by 1
)
select term_start_date, skip_rate
from srs
order by 1

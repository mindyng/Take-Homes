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
--where term_start_date NOT IN ('2020-11-23', '2020-12-21', '2021-11-22', '2021-12-20', '2022-11-21', '2022-12-19') //take out outliers
order by 1

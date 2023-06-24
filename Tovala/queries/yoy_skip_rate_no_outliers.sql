WITH srs AS (
SELECT 
term_start_date
, YEAR(term_start_date) AS year
, WEEKOFYEAR(term_start_date) AS wk_in_yr
, COUNT(DISTINCT CASE WHEN order_statu = 'skipped' THEN customer_term_id END) AS skip_count //status on order was “skipped”
, COUNT(DISTINCT CASE WHEN subscription_status = 'active' THEN customer_term_id END) AS active_count //status on account was “active”
, ROUND((skip_count / active_count),2) AS skip_rate
FROM interview.customer_term_summary
WHERE term_start_date NOT IN ('2020-11-23', '2020-12-21', '2021-11-22', '2021-12-20', '2022-11-21', '2022-12-19') //take out holiday outliers
AND term_start_date NOT BETWEEN '2020-03-15' AND '2021-12-31' //take out pandemic response activity 
group by 1
)

SELECT TO_VARCHAR(YEAR(t1.term_start_date)) AS year
, ROUND(AVG((t1.skip_rate - t2.skip_rate) / t2.skip_rate), 2) AS yoy_avg_skip_rate
FROM srs AS t1
JOIN srs AS t2
ON t1.wk_in_yr = t2.wk_in_yr
AND t1.year - 1 = t2.year
GROUP BY 1
ORDER BY 1

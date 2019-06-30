--::EDA::

--thistle_web.SUBSCRIPTION_SUBSCRIPTION
--14,000 records
--date_initialized start: 2017-01-01 00:35:30:239792+00
--date_initialized end: 2017-03-31 23:48:10.402488+00
--based on these dates, total records span 3 whole months
--DATA INTEGRITY ISSUES - MANY NULL'S
--cancellation id total: 2712 (non-null's counted only)

--thistle_web.SUBSCRIPTION_SUBSCRIPTIONCANCELLATION
--total: 3684
--earliest cancellation: 2016-06-02 05:16:16 560706+00
--latest cancellation: 2019-03-28 05:48:42.975698+00
--time span: about 6 mo + 2 yrs + 3 mo = 2 yrs + 9 mo's
--this means if subscription and cancellation combined, then there would be
--cancellation dates preceding beginning of sub dataset; this will be resolved with
--joining on primary and foreign key
--most frequent cancel_reason is blank, then 'other', then 'too expensive', then 'traveling'
--total: 966 resumed sub after cancelling
--3684 subscription id's listed (distinct: 2786)--> subscriptions cancelled more than once?

--after doing a left join, (total: 14898 records), but 898 unmatched records of c to s

--public.WEEKLY_SUBSCRIPTION
--total: 14 records only

--1.
--How many customers started the subscription flow each month.

select extract(month from date_initialized) as month, count(extract(month from date_initialized)) as month_counts
from thistle_web.subscriptions_subscription
where extract(month from date_initialized) is not null
group by extract(month from date_initialized);

--How many customers completed subscription.

select extract(month from date_initialized) as month, count(date_initialized) as number_completed_sub
from thistle_web.subscriptions_subscription
where date_paused is null
and date_to_resume is null
and extract(month from date_initialized) is not null
group by extract(month from date_initialized)

--How many % completed.
/*Strategy:
get number completed subscription
get number started subscription
Divide completed/subscriptions_started
Multiply by 100
Round to 2 decimal places
*/

--SUBQUERY of both prior queries needed to perform muliple calculations on
--columns


--2.
--a.# People signing up for sub
--for meat vs. veg plans

select protein_type, count(date_initialized) as number_signed_up_for_sub
from thistle_web.subscriptions_subscription
where protein_type is not null
and protein_type != ''
group by protein_type

--b.Signup success rate (# people who enter checkout flow)
--for meat vs. veg plans

select protein_type, count(protein_type) as number_entered_checkout
from thistle_web.subscriptions_subscription
where protein_type is not null
and protein_type != ''
group by protein_type

--3. Please calculate how many customers cancel within 14 (<=) days of signing up.

select sum(case when (extract (day from c.date_cancelled)-extract (day from s.date_initialized)) <= 14 then 1 else 0 end) as cancel_within_14days
from thistle_web.subscriptions_subscription s
left join thistle_web.subscriptions_subscriptioncancellation c
on s.id=c.subscription_id

--4. Retention by weekly cohort.
/*Strategy:
table needed: public.weekly_subscription and thistle_web.subscriptions_subscription
columns needed:
cohort: year expressed in yyyy-mm-dd
week: date beginning of 7 day range e.g. 2018-01-01, then 2018-01-08
week_number: within one year-52 total
cohort_total: window function on rows with the same cohort (sum() over cohort())
active_subs: sum of sub's for 7 days starting from the date specified
active_percent: active_subs/cohort total with two decimal points */

select year as cohort, week, week_no as week_number, sum(subscriptions_started) over (partition by year) as cohort_total,
subscriptions_started as active_subs, round((100*case when sum(subscriptions_started) over (partition by year)>0 then subscriptions_started/sum(subscriptions_started) over (partition by year) else 0 end),2) as active_percent
from public.weekly_subscription
order by 2, 3

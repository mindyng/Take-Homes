--Questions:

--1. Write a SQL query to identify all subscribers for each date.  The result should have columns "summary_date", "restaurant_id" and a row should be present for each (date, id) if and only if that customer had a subscription in effect on that date (regardless of whether they placed an order).

select created_at summary_date, restaurant_id
from promo_codes
where type = 'MonthlySubscription'
and created_at < '2017-10-01'
group by 1,2
order by 1; 

--Notes: NULL under restaurant_id means that order was done by non-restaurant business (other small business). Also, order_id is NULL / is not NULL because all that matters is that subscription is MonthlySubscription is TRUE.


--2. What is different between our subscription and à la carte customers with respect to number of orders per month, dollar value per order, and revenue per order? Does this differ by region?

--a. subscription vs. a la carte customers' orders per month

--Note: Assumption is that LapsedCustomer is a customer who has not made a repeat purchase within an expected time frame. So promo given to them in order to encourage reorder.

select p.type as subscription, extract(month from o.created_at) as month, count(*) as no_orders
from orders o
left join promo_codes p
on o.id = p.order_id
where o.created_at < '2017-10-01'
and o.status in (4,8)
group by 1,2
order by 2, 3 desc;

--Notes: Most orders came from customers who did not complete order with a promotion code, e.g. no MonthlySubscription. This means most orders came from a la carte customers for all 12 months. However, with those who did use a promotion code, MonthlySubscription was the top promo code used for all months except for November. Assumption here is that it was not offered for that month or it was not used by customers during that time of the year.

--b. subscription vs. a la carte customers' dollar value per order

select p.type as subscription, avg(o.cart_total/100) as avg_cart_total, min(o.cart_total/100) as min_cart_total, max(o.cart_total/100) as max_cart_total
from orders o
left join promo_codes p
on o.id = p.order_id
where o.created_at < '2017-10-01'
and o.status in (4,8)
group by 1
order by 2 desc;

--We can see here that dollar value per order breaks down with customers who used LapsedCustomerPromo having highest average per cart total. However, this seems to be one data point/all data points being of that value. So it is not the best representation of customer behavior. Following behind these customers is Monthly Subscription customers spending an average of about $800/cart total.

--c. subscription vs. a la carte customers' revenue per order

select p.type as subscription, avg(o.charged/100) as avg_charged, min(o.charged/100) as min_charged, max(o.charged/100) as max_charged
from orders o
left join promo_codes p
on o.id = p.order_id
where o.created_at < '2017-10-01'
and o.status in (4,8)
group by 1
order by 2 desc;


--LapsedCustomerPromo customers either had division by 0 or had NULL values in charged column. So they are discounted here. So we can see here that MonthlySubscription customers produce the most revenue on average per order.

--d. Region Analysis: subscibers vs a la carte orders per month

select s.name as region, p.type as subscription, extract(month from o.created_at) as month, count(*) as no_orders
from orders o
left join promo_codes p
on o.id = p.order_id
left join stores s
on o.store_id = s.id
where o.created_at < '2017-10-01'
and o.status in (4,8)
group by 1,2,3
order by 3, 4 desc;

--RD San Francisco by far had the highest orders of which came from a la carte customers. Region did not change subscription vs. a la carte customer behavior. Regardless of where order was being placed, a la carte customer order numbers dominated monthly subscribers' orders per month.

--e. Region Analysis: subscibers vs a la carte customers' dollar value per order 

select s.name as region, p.type as subscription, avg(o.cart_total/100) as avg_cart_total, min(o.cart_total/100) as min_cart_total, max(o.cart_total/100) as max_cart_total
from orders o
left join promo_codes p
on o.id = p.order_id
left join stores s
on o.store_id = s.id
where o.created_at < '2017-10-01'
and o.status in (4,8)
group by 1,2
order by 3 desc;

--RD Oakland and RD San Francisco regions have the highest dollar value per order. 

select s.name as region, p.type as subscription, avg(o.charged/100) as avg_charged, min(o.charged/100) as min_charged, max(o.charged/100) as max_charged
from orders o
left join promo_codes p
on o.id = p.order_id
left join stores s
on o.store_id = s.id
where o.created_at < '2017-10-01'
and o.status in (4,8)
group by 1,2
order by 3 desc;

--Here the trend was different. RD Van Nuys throws off the Bay Area dominance by showing up 4th in ranking of highest revenue per order. Though Bay Area still dominates with RD SF and RD Oakland leading the pack. Monthly Subscribers did have highest revenue per order. 

--3. What additional interesting trends did you find?

--Please refer to Python notebook link.

--4. If you had full freedom, what would you do given this data?

--I would predict demand, revenue and reordered items. I would look into personalizing recommendations for each customer (subscription holder or not) as well as look into dynamic price optimization.

--Additional Considerations:

--5. If you are interested in determining profitability, assume our COGS, on a per order basis, is $70. 

--This is completed in attached Jupyter Notebook with further analysis.
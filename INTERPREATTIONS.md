
## Q1 — Daily Business Summary

Calculates daily order and revenue KPIs for the last 90 days, including AOV, payment success/failure rates, 
refund amounts, and day-over-day revenue trends by joining daily order and refund summaries.

Used `COUNT(order_id)` instead of Distinct count since order_id is unique. 
Used `WHERE payment_status = 'failed'` instead of status column because only cancelled orders 
have payment status as failed. Grouped the CTEs by date to avoid row explosion and filtered 
the data to only previous 90 days.


The revenue peaked on April 5th to 7.9M and since then MTD revenue for May declined by almost 57% 
and orders by 56% and in June MTD revenue declined by 42% and orders by 41%.


Need to check why orders and revenue declining since April, though the AOV didn't decline as much.



## Q2 —  Monthly Cohort Retention

Calculates monthly customer cohort retention by tracking repeat paid purchases over the first 
three months after signup, with censoring applied to incomplete cohorts.

Built cohorts and monthly activity in separate CTEs, then used 
COUNT(DISTINCT customer_id) FILTER (WHERE month_diff = n) for retention. Applied cohort censoring 
with CASE to return NULL for months that are not yet fully observable.


The Cohort Retention rate is constantly dropping since March. The cohorts that signed up in march 
and in other months dropped month tthrough month.


Why is there a decline in cohort retention rates. Are the customers not liking the 
products.


## Q3 — Funnel Conversion Analysis

Aggregates sessions by acquisition channel through the product view → add to cart → checkout → purchase funnel 
and computes conversion rates between each stage.

Used conditional aggregation with COUNT(DISTINCT session_id) FILTER(WHERE ) to compute all funnel 
stages in one pass over session_events, avoiding row explosion from multiple joins and improving readability.


Organic and Paid campaigns drives the most traffic but email has the highest session to purchase rate. Although
the veiw to cart rate, cart to checkout percentage rate is similar to all channels but more than 80% customer volume
is driven by organic and paid campaigns only.


The view to cart rate drops by almost 60% that needs to be checked if this part of the funnel can be optimized.



## Q4 — Top Products by Revenue

The query calculates product-level sales performance by combining line items, products, category, refunds,
and calculates KPIs like revenue, order count, returns and net revenue after deducting refunds.

Filtered the revenue cte to return only paid orders, and used `100.0 *` to get the value in actual percentage.
Used `Max(r.return_qty)` to avoid not grouped error. Used `Nullif(Sum(qty), 0` to avoid divide by zero error.


Electronic products such as smart watche, headphones, and speakers are the most sold products in the product 
catalog. They drive the most revenue and orders. hair, Makeup wearables are the worst sold. 


Is it worth keeping the lowest selling SKUs and focus on the most sold ones instead, since inventory also costs
or if we can clear the inventory through some offers.

## Q5 — Category Health Analysis

The query aggregates category-level sales performance by calculating orders, units sold, revenue, returns 
or each category.

Filtered the sales cte to return only paid orders, joined order_items, products and category and aggregated category level 
data. Calculated returns for each category and grouped the returns CTE to avoid row explosion in the final query.


Smart watches, headphones, and speakers are the top 3 generated the most revenue and contribute around 50% to it, 
while haircare, makeup, and skincare generate the least revenue and amount to roughly 5% of the total revenue.



The order count and units sold of the least selling SKUs is almost similar to the most selling SKUs by revenue, 
need to optimise inventory for more revenue generating SKUs.


WITH customer_LTV
     AS ( SELECT   customer_id,
                   Date(Min(created_at))                 AS first_order_date,
                   Date(Max(created_at))                 AS last_order_date,
                   Count(order_id)                       AS total_orders,
                   Sum(total)                            AS total_revenue,
                   Sum(total)::INTEGER / Count(order_id) AS AOV,
                   CASE
                     WHEN Sum(total) <= 999
                     THEN '0-999'
                     WHEN Sum(total) <= 4999
                     THEN '1000-4999'
                     WHEN Sum(total) <= 19999
                     THEN '5000-19999'
                     ELSE '20000+'
                   END                                   AS ltv_bucket
          FROM     ecom.orders
          WHERE    Lower(status) != 'cancelled'
                   AND Date(created_at) >= (SELECT Max(created_at)
                                            FROM   ecom.orders) - INTERVAL '90 days'
          GROUP BY customer_id ) 
  SELECT   *,
           100.0 * Sum(total_revenue) OVER(PARTITION BY ltv_bucket) / Sum(total_revenue) OVER() AS ltv_bucket_share_of_revenue
  FROM     customer_LTV
  ORDER BY total_revenue DESC 

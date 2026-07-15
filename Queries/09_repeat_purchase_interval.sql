----With Eliminating same day intervals

WITH customer_orders
     AS ( SELECT customer_id,
                 order_id,
                 Date(created_at)                                                          AS order_date,
                 Lead(Date(created_at)) OVER(PARTITION BY customer_id ORDER BY created_at) AS next_order_date
          FROM   ecom.orders
          WHERE  Lower(status) != 'cancelled'
                 AND Date(created_at) >= (SELECT Max(created_at)
                                          FROM   ecom.orders) - INTERVAL '90 days' ) 
  SELECT Avg(next_order_date - order_date)                                         AS avg_days_to_next_order,
         Percentile_cont(0.5) WITHIN GROUP (ORDER BY next_order_date - order_date) AS median_days_to_next_order,
         Percentile_cont(0.9) WITHIN GROUP (ORDER BY next_order_date - order_date) AS p90_days_to_next_order,
         Count(DISTINCT customer_id)                                               AS customers_with_repeat_order
  FROM   customer_orders c
  WHERE  next_order_date IS NOT NULL
         AND next_order_date != order_date 


----Without Eliminating same day intervals

WITH customer_orders
     AS ( SELECT customer_id,
                 order_id,
                 Date(created_at)                                                          AS order_date,
                 Lead(Date(created_at)) OVER(PARTITION BY customer_id ORDER BY created_at) AS next_order_date
          FROM   ecom.orders
          WHERE  Lower(status) != 'cancelled'
                 AND Date(created_at) >= (SELECT Max(created_at)
                                          FROM   ecom.orders) - INTERVAL '90 days' ) 
  SELECT Avg(next_order_date - order_date)                                         AS avg_days_to_next_order,
         Percentile_cont(0.5) WITHIN GROUP (ORDER BY next_order_date - order_date) AS median_days_to_next_order,
         Percentile_cont(0.9) WITHIN GROUP (ORDER BY next_order_date - order_date) AS p90_days_to_next_order,
         Count(DISTINCT customer_id)                                               AS customers_with_repeat_order
  FROM   customer_orders c
  WHERE  next_order_date IS NOT NULL

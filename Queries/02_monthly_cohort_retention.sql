
WITH customer_cohorts
     AS ( SELECT Date_trunc('MONTH', created_at)::DATE AS cohort_month,
                 customer_id
          FROM   ecom.customers
          WHERE  Date(created_at) >= (SELECT Max(created_at)
                                      FROM   ecom.orders) - INTERVAL '90 DAYS' ), 
     customer_order_months
     AS ( SELECT DISTINCT customer_id,
                          Date_trunc('MONTH', created_at)::DATE AS order_month
          FROM   ecom.orders
          WHERE  payment_status = 'paid'
                 AND Date(created_at) >= (SELECT Max(created_at)
                                          FROM   ecom.orders) - INTERVAL '90 DAYS' ), 
     customer_monthly_activity
     AS ( SELECT c.customer_id,
                 cohort_month,
                 order_month,
                 ((Extract(YEAR FROM order_month) - Extract(YEAR FROM cohort_month)) * 12 + (Extract(MONTH FROM order_month) - Extract(MONTH FROM cohort_month))) AS month_diff
          FROM   customer_cohorts c
                 LEFT JOIN customer_order_months o
                 ON c.customer_id = o.customer_id
          WHERE  order_month IS NULL
                 OR order_month >= cohort_month ), 
     max_date
     AS ( SELECT Date_trunc('month', Max(created_at))::DATE AS max_order_month
          FROM   ecom.orders ), 
     cohort_base
     AS ( SELECT   cohort_month,
                   Count(DISTINCT customer_id)                               AS cohort_size,
                   Count(DISTINCT customer_id) FILTER (WHERE month_diff = 1) AS m1_retained,
                   Count(DISTINCT customer_id) FILTER (WHERE month_diff = 2) AS m2_retained,
                   Count(DISTINCT customer_id) FILTER (WHERE month_diff = 3) AS m3_retained
          FROM     customer_monthly_activity
          GROUP BY cohort_month ) 
  SELECT   b.cohort_month,
           b.cohort_size,
           CASE
             WHEN b.cohort_month + INTERVAL '1 month' <= m.max_order_month
             THEN b.m1_retained
           END         AS m1_retained,
           CASE
             WHEN b.cohort_month + INTERVAL '2 month' <= m.max_order_month
             THEN b.m2_retained
           END         AS m2_retained,
           CASE
             WHEN b.cohort_month + INTERVAL '3 month' <= m.max_order_month
             THEN b.m3_retained
           END         AS m3_retained,
           100.0 * CASE
                     WHEN b.cohort_month + INTERVAL '1 month' <= m.max_order_month
                     THEN Round(b.m1_retained::NUMERIC / Nullif(b.cohort_size,0), 4)
                   END AS m1_retention_rate,
           100.0 * CASE
                     WHEN b.cohort_month + INTERVAL '2 month' <= m.max_order_month
                     THEN Round(b.m2_retained::NUMERIC / Nullif(b.cohort_size,0), 4)
                   END AS m2_retention_rate,
           100.0 * CASE
                     WHEN b.cohort_month + INTERVAL '3 month' <= m.max_order_month
                     THEN Round(b.m3_retained::NUMERIC / Nullif(b.cohort_size,0), 4)
                   END AS m3_retention_rate
  FROM     cohort_base b
           CROSS JOIN max_date m
  ORDER BY b.cohort_month

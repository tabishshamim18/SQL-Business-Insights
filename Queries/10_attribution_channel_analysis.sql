
WITH touches
     AS ( SELECT o.order_id,
                 o.customer_id,
                 o.session_id,
                 o.total,
                 t.touched_at,
                 t.channel,
                 Row_number() OVER(PARTITION BY o.customer_id ORDER BY t.touched_at)      AS first_touch,
                 Row_number() OVER(PARTITION BY o.customer_id ORDER BY t.touched_at DESC) AS last_touch
          FROM   ecom.orders o
                 LEFT JOIN ecom.attribution_touches t USING(session_id)
          WHERE  Lower(status) != 'cancelled' ), 
     first_touch_tbl
     AS ( SELECT   'First_touch'                                 AS attribution_model,
                   Coalesce(channel, 'direct')                   AS channel,
                   Sum(total) FILTER(WHERE first_touch = 1)      AS first_touch_revenue,
                   Count(order_id) FILTER(WHERE first_touch = 1) AS first_touch_orders
          FROM     touches
          GROUP BY channel ), 
     last_touch_tbl
     AS ( SELECT   'Last_touch'                                 AS attribution_model,
                   Coalesce(channel, 'direct')                  AS channel,
                   Sum(total) FILTER(WHERE last_touch = 1)      AS last_touch_revenue,
                   Count(order_id) FILTER(WHERE last_touch = 1) AS last_touch_orders
          FROM     touches
          GROUP BY channel ) 
  SELECT *,
         100.0 * first_touch_revenue / Sum(first_touch_revenue) OVER() AS share_of_revenue
  FROM   first_touch_tbl
  UNION ALL
  SELECT *,
         100.0 * last_touch_revenue / Sum(last_touch_revenue) OVER() AS share_of_revenue
  FROM   last_touch_tbl
  ORDER BY channel,
           attribution_model 

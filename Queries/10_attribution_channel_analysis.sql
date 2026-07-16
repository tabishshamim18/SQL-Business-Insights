
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
                   Sum(total) FILTER(WHERE first_touch = 1)      AS revenue,
                   Count(order_id) FILTER(WHERE first_touch = 1) AS orders
          FROM     touches
          GROUP BY channel ), 
     last_touch_tbl
     AS ( SELECT   'Last_touch'                                 AS attribution_model,
                   Coalesce(channel, 'direct')                  AS channel,
                   Sum(total) FILTER(WHERE last_touch = 1)      AS revenue,
                   Count(order_id) FILTER(WHERE last_touch = 1) AS orders
          FROM     touches
          GROUP BY channel ) 
  SELECT *,
         100.0 * revenue / Sum(revenue) OVER() AS share_of_revenue
  FROM   first_touch_tbl
  UNION ALL
  SELECT *,
         100.0 * revenue / Sum(revenue) OVER() AS share_of_revenue
  FROM   last_touch_tbl
  ORDER BY revenue DESC

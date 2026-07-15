WITH sessions_base
     AS ( SELECT   Coalesce(c.channel,'direct')                                                AS channel,
                   Count(DISTINCT e.session_id)                                                AS sessions,
                   Count(DISTINCT e.session_id) FILTER (WHERE e.event_type = 'product_view')   AS product_view_sessions,
                   Count(DISTINCT e.session_id) FILTER (WHERE e.event_type = 'add_to_cart')    AS add_to_cart_sessions,
                   Count(DISTINCT e.session_id) FILTER (WHERE e.event_type = 'begin_checkout') AS begin_checkout_sessions,
                   Count(DISTINCT e.session_id) FILTER (WHERE e.event_type = 'purchase')       AS purchase_sessions
          FROM     ecom.session_events e
                   LEFT JOIN ecom.session_channels c
                   ON e.session_id = c.session_id
          WHERE    Date(e.occurred_at) >= '2026-04-19'
          GROUP BY Coalesce(c.channel,'direct')) 
  SELECT *,
         100.0 * add_to_cart_sessions / Nullif(product_view_sessions,0)   AS view_to_cart_rate,
         100.0 * begin_checkout_sessions / Nullif(add_to_cart_sessions,0) AS cart_to_checkout_rate,
         100.0 * purchase_sessions / Nullif(begin_checkout_sessions,0)    AS checkout_to_purchase_rate,
         100.0 * purchase_sessions / Nullif(sessions,0)                   AS session_to_purchase_rate
  FROM   sessions_base

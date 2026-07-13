WITH orders
     AS ( SELECT   Date(created_at)                                                                                      AS order_date,
                   Sum(total)                                                                                            AS revenue,
                   Count(order_number)                                                                                   AS orders,
                   Sum(total) / Count(DISTINCT order_number)                                                             AS AOV,
                   100.0 * (Count(order_number) FILTER(WHERE payment_status = 'paid')) / Nullif(Count(order_number),0)   AS paid_order_rate,
                   100.0 * (Count(order_number) FILTER(WHERE payment_status = 'failed')) / Nullif(Count(order_number),0) AS cancelled_order_rate,
                   100.0 * (Sum(total) - Lag(Sum(total)) OVER()) / Nullif(Lag(Sum(total)) OVER(),0)                      AS revenue_vs_yesterday_pct,
                   100.0 * (Sum(total) - Lag(Sum(total),7) OVER()) / Nullif(Lag(Sum(total),7) OVER(),0)                  AS revenue_vs_last_weekday_pct
          FROM     ecom.orders
          WHERE    Date(created_at) >= (SELECT Max(created_at)
                                        FROM   ecom.orders) - INTERVAL '90 DAYS'
          GROUP BY Date(created_at) ), 
     refunds
     AS ( SELECT   Date(created_at) AS refund_date,
                   Sum(amount)      AS refund_amount
          FROM     ecom.refunds
          WHERE    Date(created_at) >= (SELECT Max(created_at)
                                        FROM   ecom.refunds) - INTERVAL '90 DAYS'
          GROUP BY Date(created_at) ) 
  SELECT   o.order_date,
           o.revenue,
           o.orders,
           o.AOV,
           o.paid_order_rate,
           o.cancelled_order_rate,
           Coalesce(r.refund_amount,0) AS refund_amount,
           o.revenue_vs_yesterday_pct,
           o.revenue_vs_last_weekday_pct
  FROM     orders o
           LEFT JOIN refunds r
           ON o.order_date = r.refund_date
  ORDER BY order_date DESC


WITH product_revenue
     AS ( SELECT p.product_id,
                 p.product_name,
                 c.category_name AS category,
                 o.order_id,
                 qty,
                 payment_status,
                 line_total
          FROM   ecom.orders o
                 LEFT JOIN ecom.order_items i
                 ON o.order_id = i.order_id
                 LEFT JOIN ecom.product_variants v
                 ON i.variant_id = v.variant_id
                 LEFT JOIN ecom.products p
                 ON v.product_id = p.product_id
                 LEFT JOIN ecom.categories c
                 ON p.category_id = c.category_id
          WHERE  payment_status = 'paid' ), 
     product_return
     AS ( SELECT   v.product_id,
                   Sum(qty)       AS return_qty,
                   Sum(qty * CASE
                               WHEN sale_price IS NULL
                               THEN list_price
                               ELSE sale_price
                             END) AS refund_amount
          FROM     ecom.return_items r
                   LEFT JOIN ecom.prices p
                   ON r.variant_id = p.variant_id
                   LEFT JOIN ecom.product_variants v
                   ON r.variant_id = v.variant_id
          GROUP BY v.product_id ) 
  SELECT   p.product_id,
           p.product_name,
           p.category,
           Sum(line_total)                                                       AS gross_revenue,
           Count(DISTINCT order_id)                                              AS orders_count,
           Sum(qty)                                                              AS units_sold,
           Max(r.return_qty)                                                     AS returns_count,
           100.0 * Coalesce(Max(r.return_qty), 0)::NUMERIC / Nullif(Sum(qty), 0) AS return_rate,
           Max(r.refund_amount)                                                  AS refund_amount,
           Sum(line_total) - Coalesce(Max(r.refund_amount),0)                    AS net_revenue
  FROM     product_revenue p
           LEFT JOIN product_return r USING(product_id)
  GROUP BY product_id,
           product_name,
           category
  ORDER BY net_revenue DESC 

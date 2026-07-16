WITH category_sales
     AS ( SELECT c.category_id,
                 c.category_name AS category,
                 o.order_id,
                 qty             AS qty_sold,
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
     category_return
     AS ( SELECT   c.category_id,
                   Count(return_id) AS returns
          FROM     ecom.return_items r
                   LEFT JOIN ecom.product_variants v
                   ON r.variant_id = v.variant_id
                   LEFT JOIN ecom.products p
                   ON v.product_id = p.product_id
                   LEFT JOIN ecom.categories c
                   ON p.category_id = c.category_id
          GROUP BY c.category_id) 
  SELECT   category,
           Count(order_id)                                  AS orders_with_category,
           Sum(qty_sold)                                    AS units_sold,
           Sum(line_total)                                  AS revenue,
           Max(returns)                                     AS returns,
           100.0 * Max(returns) / Nullif(Count(order_id),0) AS return_rate_pct
  FROM     category_sales c
           LEFT JOIN category_return r USING(category_id)
  GROUP BY category
  ORDER BY revenue DESC

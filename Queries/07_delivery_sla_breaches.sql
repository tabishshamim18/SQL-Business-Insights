WITH delivery_SLA
     AS ( SELECT s.shipment_id,
                 s.shipped_at,
                 s.delivered_at,
                 Date(delivered_at) - Date(shipped_at) AS delivery_days,
                 s.status,
                 c.carrier_id,
                 c.carrier_name,
                 m.shipping_method_id,
                 m.method_name
          FROM   ecom.shipments s
                 LEFT JOIN ecom.shipping_carriers c
                 ON s.carrier_id = c.carrier_id
                 LEFT JOIN ecom.shipping_methods m
                 ON s.shipping_method_id = m.shipping_method_id
          WHERE  s.status = 'delivered' ) 
  SELECT   carrier_name                                                          AS carrier,
           method_name                                                           AS shipping_method,
           Count(*)                                                              AS delivered_orders,
           Avg(delivery_days)                                                    AS avg_delivery_days,
           Percentile_cont(0.5) WITHIN GROUP (ORDER BY delivery_days)            AS median_delivery_days,
           Percentile_cont(0.9) WITHIN GROUP (ORDER BY delivery_days)            AS p90_delivery_days,
           Count(*) FILTER(WHERE delivery_days > 5)                              AS late_deliveries,
           100.0 * Count(*) FILTER(WHERE delivery_days > 5) / Nullif(Count(*),0) AS late_rate
  FROM     delivery_SLA
  GROUP BY carrier_name,
           method_name
  ORDER BY late_rate DESC

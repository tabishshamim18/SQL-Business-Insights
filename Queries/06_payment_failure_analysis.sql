WITH payment_attempts
     AS ( SELECT   i.payment_method_id,
                   m.method_name,
                   Count(*)                                                              AS attempts,
                   Count(*) FILTER(WHERE status = 'failed')                              AS failures,
                   100.0 * Count(*) FILTER(WHERE status = 'failed') / Nullif(Count(*),0) AS failure_rate
          FROM     ecom.payment_intents i
                   LEFT JOIN ecom.payment_methods m
                   ON i.payment_method_id = m.payment_method_id
          GROUP BY i.payment_method_id,
                   m.method_name ), 
     payment_failures
     AS ( SELECT   i.payment_method_id,
                   t.error_code,
                   t.error_message,
                   Count(*)                                                                   AS failure_reason_count,
                   Row_number() OVER(PARTITION BY i.payment_method_id ORDER BY Count(*) DESC) AS rn
          FROM     ecom.payment_intents i
                   LEFT JOIN ecom.payment_transactions t
                   ON i.payment_intent_id = t.payment_intent_id
          WHERE    i.status = 'failed'
          GROUP BY i.payment_method_id,
                   t.error_code,
                   t.error_message ) 
  SELECT 	method_name                             AS payment_method,
         	attempts                                failures,
         	failure_rate,
         	error_code                              AS top_error_code,
         	error_message                           AS top_error_message,
         	100.0 * failure_reason_count / failures AS top_error_share_of_failures
  FROM   	payment_attempts a
         	LEFT JOIN payment_failures f ON a.payment_method_id = f.payment_method_id
  AND 	 	rn = 1
  ORDER BY  failures DESC

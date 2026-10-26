SELECT order_id, customer_id, item, amount
FROM orders
WHERE status = 'completed'
ORDER BY amount DESC, order_id ASC
LIMIT 5;

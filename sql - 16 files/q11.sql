-- INNER JOIN is appropriate because this report includes completed orders with a matched customer region.
-- COUNT(DISTINCT customer_id) is needed because one customer may place multiple completed orders in the same month.
SELECT c.region,
       o.order_month,
       COUNT(*) AS number_of_orders,
       COUNT(DISTINCT o.customer_id) AS number_of_customers,
       SUM(o.amount) AS total_revenue,
       AVG(o.amount) AS average_revenue
FROM orders AS o
JOIN customers AS c ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
GROUP BY c.region, o.order_month
ORDER BY c.region ASC, o.order_month ASC;

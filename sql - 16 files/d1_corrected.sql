-- Revenue by region for completed orders only; retain regions above the 80,000 threshold.
-- HAVING is used because the threshold applies to the grouped SUM.
SELECT c.region AS region,
       SUM(CAST(o.amount AS NUMERIC)) AS revenue
FROM orders AS o
JOIN customers AS c ON c.customer_id = o.customer_id
WHERE o.status = 'completed'
GROUP BY c.region
HAVING SUM(CAST(o.amount AS NUMERIC)) > 80000
ORDER BY revenue DESC;

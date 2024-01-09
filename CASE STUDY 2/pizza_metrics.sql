use pizza_runner;
show tables;
# 1. How many pizzas were ordered?

SELECT COUNT(*) AS pizzas_ordered
FROM customer_orders;
# 14 pizzas were ordered. 

#2. How many unique customer orders were made?
SELECT COUNT(DISTINCT order_id) AS unique_customer_orders
FROM customer_orders;

# 10 unique customer orders

# 3. How many successful orders were delivered by each runner?
SELECT runner_id, COUNT(order_id) AS number_of_orders
FROM runner_orders
WHERE distance != 0
GROUP BY runner_id;

# 4. How many of each type of pizza was delivered?

SELECT  p.pizza_name, COUNT(c.pizza_id) as pizzas_ordered
FROM customer_orders c
JOIN pizza_names p
ON c.pizza_id = p.pizza_id
GROUP BY c.pizza_id;

# 5. How many Vegetarian and Meatlovers were ordered by each customer?

SELECT c.customer_id, p.pizza_name,COUNT(p.pizza_name) as pizzas_ordered
FROM customer_orders c
JOIN pizza_names p
ON c.pizza_id = p.pizza_id
GROUP BY c.customer_id, p.pizza_name
ORDER BY c.customer_id;

# 6. What was the maximum number of pizzas delivered in a single order?

SELECT COUNT(c.order_id) as orders_placed
FROM customer_orders c
JOIN runner_orders r
ON c.order_id = r.order_id
GROUP BY c.order_id
ORDER BY orders_placed
DESC
LIMIT 1;

# 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

SELECT 
    customer_id, 
    COUNT(CASE WHEN exclusions IS NULL AND extras IS NULL THEN 1 END) AS no_changes,
    COUNT(CASE WHEN exclusions IS NOT NULL OR extras IS NOT NULL THEN 1 END) AS order_changed
FROM customer_orders
GROUP BY customer_id;

# 8. How many pizzas were delivered that had both exclusions and extras?

SELECT COUNT(c.order_id) AS orders_delivered
FROM customer_orders c
JOIN runner_orders r
ON c.order_id = r.order_id
WHERE c.extras IS NOT NULL OR c.exclusions IS NOT NULL AND r.distance != 0;

# 9. What was the total volume of pizzas ordered for each hour of the day?
SELECT HOUR(order_date) AS hour_of_day, COUNT(order_id) AS orders_placed
FROM customer_orders
GROUP BY hour_of_day;

# 10. What was the volume of orders for each day of the week?

SELECT DAY(order_date) AS day_of_week, COUNT(order_id) AS orders_placed
FROM customer_orders
GROUP BY day_of_week;

## This shows the columns, the data types... 
describe customer_orders;

select * from customer_orders;
select * from runner_orders;







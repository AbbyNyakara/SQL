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









select * from customer_orders;
select * from runner_orders;







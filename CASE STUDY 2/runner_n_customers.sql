use pizza_runner;

#How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

SELECT week(registration_date) AS week, COUNT(runner_id)
FROM runners
GROUP BY week;

#What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

SELECT r.runner_id, AVG(TIMESTAMPDIFF(MINUTE, c.order_date, r.pickup_time)) AS avg_time_taken_minutes
FROM customer_orders c 
JOIN runner_orders r
ON c.order_id = r.order_id
GROUP BY r.runner_id;

#Is there any relationship between the number of pizzas and how long the order takes to prepare?






#What was the average distance travelled for each customer?

#What was the difference between the longest and shortest delivery times for all orders?

#What was the average speed for each runner for each delivery and do you notice any trend for these values?

#What is the successful delivery percentage for each runner?



show tables;
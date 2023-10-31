use pizza_runner;
show tables;
# 1. How many pizzas were ordered?

SELECT COUNT(order_id) AS pizzas_ordered
FROM customer_orders;
# 14 pizzas were ordered. 

# 2. How many unique customer orders were made?
SELECT COUNT(DISTINCT order_id) as unique_orders
FROM customer_orders;

# 10 unique customer orders

# 3.How many successful orders were delivered by each runner?
select * from runner_orders;
SET SQL_SAFE_UPDATES = 0;

# Update the null values
UPDATE runner_orders
SET pickup_time = NULL
WHERE pickup_time = 'null';

# Clean the runner_orders table
UPDATE runner_orders
SET cancellation = NULL
WHERE cancellation = 'null' OR cancellation = '';


SHOW INDEX FROM customer_orders WHERE Column_name = 'order_id';




ALTER TABLE parent_table
ADD INDEX index_name (parent_column);


DESCRIBE runner_orders;
DESCRIBE customer_orders;
# Add the foreign keys to the tables 
ALTER TABLE runner_orders
ADD FOREIGN KEY (order_id)
REFERENCES customer_orders(order_id);


# query: 
SELECT r.runner_id, COUNT (c.order_id) AS orders_per_runner
FROM runner_orders r
JOIN customer_orders c 
ON c.order_id = r.order_id
WHERE r.cancellations IS NOT NULL
GROUP BY runner_id
;







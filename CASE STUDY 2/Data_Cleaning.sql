# Data cleaning and adding the foreign keys 

use pizza_runner;
show tables;

# Customer_orders table
SET SQL_SAFE_UPDATES = 0;

# Exclusions column
UPDATE customer_orders
SET exclusions = NULL
WHERE exclusions = 'null' OR exclusions = '';

#Extras columns
UPDATE customer_orders
SET extras = NULL 
WHERE extras = 'null' OR extras = '';


# pizza_names table

ALTER TABLE pizza_names 
ADD CONSTRAINT fk_pizza_names
FOREIGN KEY (pizza_id)
REFERENCES customer_orders(pizza_id);


# Runner orders table 

UPDATE runner_orders
SET pickup_time = NULL
WHERE pickup_time = 'null' OR  pickup_time = '';

UPDATE runner_orders
SET distance = NULL
WHERE distance = 'null';

UPDATE runner_orders
SET duration = NULL
WHERE duration = 'null';

UPDATE runner_orders
SET cancellation = NULL
WHERE cancellation = 'null' OR cancellation = '';

SELECT DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS 
  WHERE table_name = 'runner_orders';

select * from runner_orders;














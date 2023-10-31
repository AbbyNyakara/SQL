# Data cleaning and adding the foreign keys 

use pizza_runner;
show tables;

# Customer_orders table
drop table customer_orders;

# Exclusions column
UPDATE customer_orders
SET exclusions = NULL
WHERE exclusions = 'null' OR exclusions = '';

#Extras columns
UPDATE customer_orders
SET extras = NULL 
WHERE extras = 'null' OR extras = '';

# ADD THE PRIMARY KEY THAT THE FOREIGN KEYS IN OTHER TABLES WILL REFERENCE 

ALTER TABLE customer_orders
ADD CONSTRAINT pk1_customer_orders
PRIMARY KEY (order_id);

# pizza_names table

ALTER TABLE pizza_names 
ADD CONSTRAINT fk_pizza_names
FOREIGN KEY (pizza_id)
REFERENCES customer_orders(pizza_id);




select * from pizza_recipes;









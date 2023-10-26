CREATE SCHEMA dannys_diner;
USE dannys_diner;

CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
  
  /* QUESTIONS TO BE ANSWERED*/
  
#1. What is the total amount each customer spent at the restaurant?
SELECT sales.customer_id AS customer_id,
    SUM(menu.price) AS total_spent
FROM sales
JOIN menu
	ON sales.product_id = menu.product_id
GROUP BY 1;

#2. How many days has each customer visited the restaurant?
SELECT DISTINCT customer_id, 
		COUNT(DISTINCT order_date) AS total_days_visited
FROM sales
GROUP BY 1;

#3 What was the first item from the menu purchased by each customer?
-- Use a temporary table then rank per the customer ids then outside the CTE select only those with rank #1

WITH CTE AS (SELECT sales.customer_id, 
                menu.product_name, 
                RANK() OVER (PARTITION BY sales.customer_id ORDER BY sales.order_date) AS ranking
					FROM sales
					JOIN menu
						ON menu.product_id = sales.product_id)
			
SELECT DISTINCT customer_id, product_name AS first_purchase
 FROM CTE
 WHERE ranking = 1;

-- NOTE: the distinct statement above helps filter further to ensure that we are only retriving
-- distinct product names(in the case that some customer bought the same product twice on their first day)

#4 What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT menu.product_name, COUNT(sales.product_id) AS most_popular_food
	FROM sales
	JOIN menu
		ON sales.product_id = menu.product_id
	GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 1;
    
#5 Which item was the most popular for each customer?
 
WITH CTE AS(
			SELECT sales.customer_id, 
					menu.product_name, 
                    COUNT(menu.product_id),
                    RANK () OVER (PARTITION BY customer_id ORDER BY COUNT(menu.product_id) DESC) AS ranking
            FROM sales 
            JOIN menu 
				ON sales.product_id = menu.product_id
			GROUP BY 1,2)
SELECT customer_id, 
		product_name AS popular_choice
 FROM CTE
 WHERE ranking = 1;

#6. Which item was purchased first by the customer after they became a member?

WITH CTE AS(
			SELECT members.customer_id,
					sales.order_date,
				RANK() OVER(PARTITION BY members.customer_id ORDER BY sales.order_date) AS membership_purchase,
                menu.product_name
            FROM sales 
            JOIN members 
				ON sales.customer_id = members.customer_id
            JOIN menu
				ON sales.product_id = menu.product_id
			WHERE sales.order_date >= members.join_date)
			
SELECT CTE.customer_id, 
		CTE.product_name
 FROM CTE
 WHERE CTE.membership_purchase = 1;

#7 Which item was purchased just before the customer became a member?

WITH
CTE AS(
			SELECT members.customer_id,
					sales.order_date, 
                    members.join_date,
					RANK() OVER(PARTITION BY members.customer_id ORDER BY sales.order_date DESC) AS membership_purchase,
					menu.product_name
            FROM sales 
            JOIN members 
				ON sales.customer_id = members.customer_id
            JOIN menu
				ON sales.product_id = menu.product_id
			WHERE sales.order_date < members.join_date)
-- NOTE: In the select statement below, I refer to the columns in the select statement as (CTE.,... and not sales.customer_id)			
SELECT DISTINCT CTE.customer_id, 
			CTE.product_name
 FROM CTE
 WHERE CTE.membership_purchase = 1;
 
 
#8. What is the total items and amount spent for each member before they became a member?

WITH CTE AS
			(SELECT sales.customer_id, 
					sales.product_id, 
					SUM(menu.price) AS total_price 
				FROM sales 
				JOIN menu 
					ON sales.product_id = menu.product_id 
				JOIN members
					ON sales.customer_id = members.customer_id
				WHERE sales.order_date < members.join_date 
				GROUP BY 1,2)
    SELECT CTE.customer_id, 
			COUNT(CTE.product_id) AS product_count,
            SUM(CTE.total_price) AS total_amount
		FROM CTE 
        GROUP BY  1
        ORDER BY 1;

#9. If each $1 spent equates to 10 points and 
#sushi has a 2x points multiplier - how many points would each customer have?

SELECT sales.customer_id, 
		SUM(menu.price * (CASE WHEN menu.product_name = 'sushi' THEN 20 ELSE 10 END)) AS total_points
	FROM sales
    JOIN menu
    ON sales.product_id = menu.product_id
	GROUP BY 1;
        
        
#10 In the first week after a customer joins the program (including their join date) they earn 2x points on all items,
# not just sushi - how many points do customer A and B have at the end of January?

SELECT sales.customer_id, 
		SUM(menu.price * (CASE WHEN sales.order_date < members.join_date AND menu.product_name <> 'sushi' THEN 10
								WHEN sales.order_date - members.join_date BETWEEN 0 AND 7 THEN 20
                                WHEN sales.order_date -members.join_date > 7 THEN 10
                                WHEN menu.product_name = 'sushi' THEN 20
                                ELSE 10 END)) AS total_point
FROM menu
JOIN sales
	ON menu.product_id = sales.product_id
		JOIN members
			ON sales.customer_id = members.customer_id
GROUP BY 1
ORDER BY 1;

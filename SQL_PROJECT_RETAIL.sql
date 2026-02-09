-- SQL RETAIL SALES ANALYSIS 
--CREATE DATABASE SQL_PROJECT_RETAIL;

--CREATE TABLE
DROP TABLE IF EXISTS RETAIL_SALES;
CREATE TABLE RETAIL_SALES
	(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(10),
	age INT,
	category VARCHAR(15),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

SELECT * FROM RETAIL_SALES;

--COUNT ROWS 
SELECT COUNT(*)
FROM RETAIL_SALES;

-- CHECK WETHER THE NULL IS OR NOT IN TRANSACTION ID 
SELECT * FROM RETAIL_SALES
WHERE quantity IS NULL;

--CHECK OVERALL DATASET HAS NULL OR NOT
SELECT * FROM RETAIL_SALES
WHERE transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL	
	OR
	customer_id IS NULL	
	OR
	gender IS NULL	
	OR
	age	IS NULL
	OR
	category IS NULL	
	OR
	quantity	IS NULL
	OR
	price_per_unit	IS NULL
	OR
	cogs	IS NULL
	OR
	total_sale IS NULL;

--DATA CLEANING DELETE ALL NULL VALUES
DELETE FROM RETAIL_SALES
WHERE transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL	
	OR
	customer_id IS NULL	
	OR
	gender IS NULL	
	OR
	age	IS NULL
	OR
	category IS NULL	
	OR
	quantity	IS NULL
	OR
	price_per_unit	IS NULL
	OR 
	cogs	IS NULL
	OR
	total_sale IS NULL;

--DATA EXPLORATION

-- HOW MANY SALES WE HAVE?
SELECT COUNT(*) FROM RETAIL_SALES;

--HOW MANY UNIQUE CUSTOMERS WE HAVE?
SELECT COUNT(DISTINCT customer_id) AS total_sale FROM RETAIL_SALES;

SELECT COUNT(DISTINCT category) AS total_sale FROM RETAIL_SALES;
SELECT DISTINCT category FROM RETAIL_SALES;

-- DATA ANALYSIS & BUSINESS KEY PROBELEMS & ANSWERS

--MY ANALYSIS & FINDINGS
--Q1. WRITE A SQL QUERY TO RETRIEVE ALL COLUMNS FOR SALES MADE ON '2022-11-05'.
SELECT *
FROM RETAIL_SALES
WHERE sale_date = '2022-11-05';

--Q2. WRITE A SQL QUERY TO RETRIEVE ALL TRANSACTIONS WHERE THE CATEGORY IS 'CLOTHING' AND THE QUANTITY SOLD IS MORE THAN 4 IN THE MONTH OF NOV-2022
SELECT 
	*
FROM RETAIL_SALES
WHERE category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'yyyy-mm') = '2022-11'
	AND 
	quantity>4

--Q3. WRITE A SQL QUERY TO CALCULATE THE TOTAL SALES (total_sale) FOR EACH CATEGORY.
SELECT
	category,
	SUM(total_sale) AS net_sale,
	count(*) as total_orders
from retail_sales
group by 1

--Q4. WRITE A SQL QUERY TO FIND THE AVERAGE AGE OF CUSTOMERS WHO PURCHASED ITEMS FROM THE 'beauty' CATEGORY.
SELECT
	ROUND(AVG(age), 2) AS AVG_AGE
FROM RETAIL_SALES
WHERE category='Beauty'

--Q5. WRITE A SQL QUERY TO FIND ALL TRANSACTIONS WHERE THE TOTAL_SALE IS GREATER THAN 1000.
SELECT * FROM RETAIL_SALES
WHERE total_sale > 1000

--Q6. WRITE A SQL QUERY TO FINE THE TOTAL NUMBER OF TRANSACTION (transaction_id) MADE BY EACH GENDER IN EACH CATEGORY.
SELECT
	category,
	gender,
	COUNT(*) AS TOTAL_TRANS
FROM RETAIL_SALES
GROUP BY category,gender
ORDER BY 1

--Q7. WRITE A SQL QUERY TO CALCULATE THE AVERAGE SALE FOR EACH MONTH. FIND OUT BEST SELLING MONTH IN EACH YEAR.
SELECT 
	year,
	month,
	avg_sale
from
(
SELECT
	EXTRACT(YEAR FROM sale_date) AS YEAR,
	EXTRACT(MONTH FROM sale_date) AS MONTH,
	AVG(total_sale) AS AVG_SALE,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as RANK
FROM RETAIL_SALES
GROUP BY 1, 2
) AS T1
WHERE RANK=1

--order by 1, 3 DESC

--Q8. WRITE A SQL QUERY TO FIND THE TOP 5 CUSTOMERS BASED ON THE HIGHEST TOTAL SALES
SELECT 
	customer_id,
	SUM(total_sale) as total_sales
from RETAIL_SALES
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Q9. WRITE A SQL QUERY TO FIND THE NUMBER OF UNIQUE CUSTOMERS WHO PURCHASED ITEMS FROM EACH CATEGORY.
SELECT
	category,
	COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM RETAIL_SALES
GROUP BY category

--Q10. WRITE A SQL QUERY TO CREATE EACH SHIFT AND NUMBER OF ORDERS (EXAMPLE MORNING <=12,AFTERNOON BETWEEN 12&17, EVENING>17)
WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17  THEN 'Afternoon'
		ELSE 'Evening'
	END as SHIFT
FROM RETAIL_SALES
)
SELECT
	SHIFT,
	COUNT(*) as total_orders
from hourly_sale
group by SHIFT

--Q11. profit analysis
SELECT
  category,
  SUM(total_sale - cogs) AS total_profit
FROM retail_sales
GROUP BY category;

--Q12.Revenue Contribution %
WITH total_revenue AS (
    SELECT SUM(total_sale)::numeric AS grand_total
    FROM retail_sales
)
SELECT
    r.category,
    ROUND(
        (SUM(r.total_sale)::numeric * 100) / t.grand_total,
        2
    ) AS revenue_pct
FROM retail_sales r
CROSS JOIN total_revenue t
GROUP BY r.category, t.grand_total;

--Q13.Repeat Customers
SELECT customer_id, COUNT(*) AS orders
FROM retail_sales
GROUP BY customer_id
HAVING COUNT(*) > 1;



---------------------END-------------------------
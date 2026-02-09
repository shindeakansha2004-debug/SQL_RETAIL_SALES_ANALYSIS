# SQL_RETAIL_SALES_ANALYSIS
End-to-end SQL retail sales analysis project using real-world data to generate meaningful business insights.

# 🛒 SQL Retail Sales Analysis Project

## 📌 Project Overview

This project focuses on analyzing retail sales data using **SQL** to uncover meaningful business insights. The analysis includes sales trends, customer behavior, category performance, profit analysis, and revenue contribution. The goal is to simulate a **real-world Data Analyst task** using structured queries and business-oriented problem solving.

---

## 🎯 Objectives

* Clean and validate retail sales data
* Perform exploratory data analysis (EDA)
* Answer key business questions using SQL
* Analyze customer behavior and sales trends
* Calculate profit and revenue contribution
* Practice advanced SQL concepts (CTE, Window Functions)

---

## 🗂 Dataset Description

The dataset represents retail transaction-level data.

**Columns used:**

* `transactions_id` – Unique transaction ID
* `sale_date` – Date of transaction
* `sale_time` – Time of transaction
* `customer_id` – Unique customer identifier
* `gender` – Gender of customer
* `age` – Age of customer
* `category` – Product category (e.g., Clothing, Beauty)
* `quantity` – Quantity sold
* `price_per_unit` – Price per item
* `cogs` – Cost of goods sold
* `total_sale` – Total transaction value

---

## 🧹 Data Cleaning Steps

* Checked for NULL values across all columns
* Removed records containing missing values (for practice purposes)
* Validated data consistency

> ⚠️ Note: In real-world projects, missing values are usually handled using imputation or validation rules instead of deleting records.

---

## 🔍 Exploratory Data Analysis (EDA)

* Total number of transactions
* Total unique customers
* Total unique product categories

---

## 📊 Business Questions & Analysis

Below are the key SQL queries used to answer real-world business questions in this project. Each query demonstrates a specific SQL concept and business insight.

### 1️⃣ Sales on a Specific Date

* Retrieved all transactions made on **2022-11-05**

### 2️⃣ Category-based Monthly Sales

* Transactions for **Clothing** category
* Quantity sold **greater than 4**
* Filtered for **November 2022**

### 3️⃣ Total Sales by Category

* Net sales and total orders per category

### 4️⃣ Customer Demographics

* Average age of customers purchasing from **Beauty** category

### 5️⃣ High-Value Transactions

* Transactions with total sales greater than **1000**

### 6️⃣ Gender-wise Category Analysis

* Number of transactions by gender in each category

### 7️⃣ Best Selling Month (Advanced)

* Calculated average monthly sales
* Identified **best selling month per year** using **Window Functions (RANK)**

### 8️⃣ Top Customers

* Top 5 customers based on highest total sales

### 9️⃣ Customer Reach

* Number of unique customers per category

### 🔟 Shift-wise Sales Analysis (CTE)

* Classified sales into:

  * Morning (<12)
  * Afternoon (12–17)
  * Evening (>17)
* Counted total orders per shift

### 1️⃣1️⃣ Profit Analysis

* Calculated total profit per category

### 1️⃣2️⃣ Revenue Contribution (%)

* Calculated percentage contribution of each category to total revenue using **CTE and numeric casting**

### 1️⃣3️⃣ Repeat Customers

* Identified customers with more than one purchase

---

## 🗃️ Database & Table Creation

```sql
-- Create Retail Sales Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
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
```

---

## 🧾 SQL Queries Used

```sql
-- Q1: Sales made on a specific date
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

```sql
-- Q2: Clothing transactions with quantity > 4 in Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND sale_date BETWEEN '2022-11-01' AND '2022-11-30'
  AND quantity > 4;
```

```sql
-- Q3: Total sales and total orders by category
SELECT category,
       SUM(total_sale) AS net_sale,
       COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;
```

```sql
-- Q4: Average age of customers in Beauty category
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';
```

```sql
-- Q5: High value transactions
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```

```sql
-- Q6: Transactions by gender and category
SELECT category, gender, COUNT(*) AS total_trans
FROM retail_sales
GROUP BY category, gender;
```

```sql
-- Q7: Best selling month in each year (Window Function)
SELECT year, month, avg_sale
FROM (
  SELECT EXTRACT(YEAR FROM sale_date) AS year,
         EXTRACT(MONTH FROM sale_date) AS month,
         AVG(total_sale) AS avg_sale,
         RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date)
                      ORDER BY AVG(total_sale) DESC) AS rank
  FROM retail_sales
  GROUP BY 1,2
) t
WHERE rank = 1;
```

```sql
-- Q8: Top 5 customers by total sales
SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

```sql
-- Q9: Unique customers per category
SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;
```

```sql
-- Q10: Shift-wise order analysis using CTE
WITH hourly_sale AS (
  SELECT *,
         CASE
           WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
           WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
           ELSE 'Evening'
         END AS shift
  FROM retail_sales
)
SELECT shift, COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;
```

```sql
-- Q11: Profit analysis by category
SELECT category,
       SUM(total_sale - cogs) AS total_profit
FROM retail_sales
GROUP BY category;
```

```sql
-- Q12: Revenue contribution percentage by category
WITH total_revenue AS (
  SELECT SUM(total_sale)::numeric AS grand_total
  FROM retail_sales
)
SELECT r.category,
       ROUND((SUM(r.total_sale)::numeric * 100) / t.grand_total, 2) AS revenue_pct
FROM retail_sales r
CROSS JOIN total_revenue t
GROUP BY r.category, t.grand_total;
```

```sql
-- Q13: Repeat customers
SELECT customer_id, COUNT(*) AS orders
FROM retail_sales
GROUP BY customer_id
HAVING COUNT(*) > 1;
```

---

## 🛠 SQL Concepts Used

* `SELECT`, `WHERE`, `GROUP BY`, `HAVING`
* Aggregate Functions (`SUM`, `AVG`, `COUNT`)
* Date & Time Functions (`EXTRACT`, `TO_CHAR`)
* **Common Table Expressions (CTE)**
* **Window Functions (RANK)**
* Conditional logic using `CASE`

---

## 📈 Key Insights

* Certain categories contribute significantly more to revenue
* Repeat customers play an important role in overall sales
* Sales volume varies by time of day
* Monthly sales trends help identify peak performance periods

---

## 🧠 Learning Outcomes

* Hands-on experience with real-world SQL analysis
* Improved understanding of business-driven queries
* Confidence in using advanced SQL techniques

---

## 🚀 Conclusion

This project demonstrates practical SQL skills required for a **Data Analyst role**, combining data cleaning, exploration, and advanced analytical queries to generate actionable business insights.

---

## 👩‍💻 Author

**Akansha**
Aspiring Data Analyst | SQL | Data Science Intern

---

⭐ *If you like this project, feel free to star the repository!*

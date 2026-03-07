use sql_project_1;
create table Retail_Sales(
transactions_id	INT,
sale_date DATE,
sale_time TIME,
customer_id	INT,
gender VARCHAR(10),
age	INT,
category VARCHAR(20),
quantity int,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT
);

-- Display the first 5 rows from the Retail_Sales table.
SELECT * FROM Retail_Sales
LIMIT 5;

-- Find the total number of records in the Retail_Sales table.
SELECT COUNT(*) FROM Retail_Sales;


-- Find the number of non-NULL total_sale values in the table.
SELECT COUNT(total_sale) FROM Retail_Sales;

-- ANALYSIS OF DATA

-- 1.Find the total number of unique customers who made purchases.

SELECT COUNT(DISTINCT customer_id) FROM Retail_Sales;

-- 2.Find all sales transactions that occurred on 5th November 2022.

SELECT * FROM Retail_Sales
WHERE sale_date = '2022-11-05';

-- 3.Retrieve all Electronics sales transactions where the quantity sold is greater than 3 during December 2023.

SELECT * FROM Retail_Sales
WHERE category = 'Electronics'
AND quantity > 3
AND date_format(sale_date, '%Y-%m') = '2023-12';

-- 4.Calculate the total quantity of Electronics products sold where more than 3 units were purchased per transaction in December 2022.

SELECT category,SUM(quantity) FROM Retail_Sales
WHERE category = 'Electronics'
AND quantity > 3
AND date_format(sale_date, '%Y-%m') = '2022-12'
GROUP BY 1;

-- 5.Find the total sales revenue and total number of orders for each product category.

SELECT category,SUM(total_sale) AS net_sales ,
COUNT(*) AS total_orders
FROM Retail_Sales
GROUP BY 1;
 
-- 6.Calculate the average age of customers purchasing products in each category.

SELECT category,ROUND(AVG(age),2) AS avg_age
FROM Retail_Sales
GROUP BY 1;

-- 7.Find the average age of customers who purchased Beauty products.

SELECT ROUND(AVG(age),2) AS avg_age
FROM Retail_Sales
WHERE category = 'Beauty';

-- 8.Retrieve all transactions where the total sale amount exceeded 1100.

SELECT * FROM Retail_Sales
WHERE total_sale > 1100;

-- 9.Determine the number of transactions made by each gender within each product category.

SELECT category,gender,COUNT(*) AS total_tansactions
FROM Retail_Sales
GROUP BY 1,2
ORDER BY category,gender DESC;

-- 10.Calculate the average monthly sales for each year and month, and sort the results by year and highest average sales.

SELECT 
	  YEAR(sale_date) AS Sale_year ,
      MONTH(sale_date) AS Sale_month , 
      ROUND(AVG(total_sale),2) AS Total_Sales
FROM Retail_Sales
GROUP BY 1,2
ORDER BY 1 ASC,3 desc;

-- 11.Identify the month with the highest average sales in each year.

SELECT * FROM(
	SELECT 
		YEAR(sale_date) AS sale_year,
		MONTH(sale_date) AS sale_month,
		ROUND(AVG(total_sale),2) AS avg_sales,
		RANK() OVER(
			PARTITION BY YEAR(sale_date)
			ORDER BY ROUND(AVG(total_sale),2) DESC) AS rnk
	FROM Retail_Sales
	GROUP BY 1,2
) t1 
WHERE rnk = 1;

-- 12.Find the top 5 customers who generated the highest total sales revenue.

SELECT customer_id , SUM(total_sale) AS total_sales
FROM Retail_Sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 13.Calculate the number of unique customers who purchased products in each category.

SELECT category,COUNT(DISTINCT customer_id) AS cnt_unique_customers	   
FROM Retail_Sales
GROUP BY 1;


--  14.Analyze the number of orders placed during different time shifts (Morning, Afternoon, Evening).

-- USING CTE
WITH sales AS(
	SELECT *,
		CASE 
			WHEN HOUR(sale_time) < 12 THEN 'Morning'
			WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END AS Shift
	 FROM Retail_Sales
 )
 SELECT shift,COUNT(*) AS total_orders
 FROM sales
 GROUP BY 1;
 
-- USING SUBQUERY
 SELECT shift, COUNT(*) AS total_orders
FROM (
    SELECT *,
        CASE 
            WHEN HOUR(sale_time) < 12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM Retail_Sales
) t
GROUP BY shift;

-- END 
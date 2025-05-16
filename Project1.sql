# --SQl Retail Sales Analysis - p1--
CREATE DATABASE sql_project_p1;
USE sql_project_p1;

# Create Table
CREATE TABLE retail_sales(
				transactions_id	INT PRIMARY KEY,
				sale_date DATE,
                sale_time TIME,
                customer_id INT,
                gender	VARCHAR(100),
                age	INT,
                category VARCHAR(15),	
                quantiy	INT,
                price_per_unit	INT,
                cogs FLOAT,
                total_sale INT
                );
			

SELECT * FROM retail_sales;

SELECT COUNT(DISTINCT(customer_id)) FROM retail_sales;

# Data Exploration

# How many sales we have
SELECT COUNT(total_sale) AS TOTAL_SALES FROM retail_sales;

#How many unique customer we have
SELECT COUNT(DISTINCT(customer_id)) AS TOTAL_CUSTOMERS FROM retail_sales;

# How many unique category we have
SELECT DISTINCT category FROM retail_sales;

# Data Analysis & Business Key Problems & Answers
#Q1 Write a sql query to retrive all columns for sales made on 2022-11-05
SELECT * FROM retail_sales
WHERE sale_date='2022-11-05';

#Q2 Write a sql query to retrive all transaction where the category is clothing and the quantity sold is more than 4 and the month of Nov-2022
SELECT * FROM retail_sales
WHERE category='Clothing' AND sale_date BETWEEN '2022-11-01' AND '2022-11-30' AND quantiy>=4;

#Q3 Calculate the total sale for each category
SELECT category, SUM(total_sale) AS Net_Sales FROM retail_sales
GROUP BY category;

#Q4 Write sql query to find the average age of customer who purchased items from Beauty category
SELECT ROUND(AVG (age),2) FROM retail_sales
WHERE category='Beauty';

#Q5 Write sql query to find all transaction where the total sales is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale>1000;

#Q6 Write sql query tofind the total number of transaction made by each genderin each category
SELECT category, gender, COUNT(transactions_id) FROM retail_sales
GROUP BY category, gender;

#Q7 Write sql query to calculate the average sales  for each month. Find out best selling month in each year.
SELECT * FROM (
SELECT EXTRACT(YEAR FROM sale_date) AS year,EXTRACT(MONTH FROM sale_date)AS month, AVG(total_sale) AS avg_Sales, RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS RANKS
FROM retail_sales
GROUP BY year, month
ORDER BY RANKS, year, month
) AS T1
WHERE RANKS=1;

#Q8 Write sql query to find out top 5 customers based on the highest total sale
SELECT customer_id, SUM(total_sale) FROM retail_sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC
LIMIT 5;

#Q9 Write sql query to find out the number of unique customers who purchase items from each category
SELECT category, COUNT(DISTINCT customer_id) AS customers FROM retail_sales
GROUP BY category;

#Q10 Write sql query to create each shift and number of orders (Example Morning <=12,  Afternoon Between 12 & 17, Evening >17)
WITH hourly_sales
AS (
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) <=12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
	END AS Shift
FROM retail_sales)
SELECT Shift, COUNT(transactions_id) AS Orders FROM hourly_sales
GROUP BY Shift;

# End of Project
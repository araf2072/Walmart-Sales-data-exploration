SELECT * FROM walmartsales.sales;


UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

SELECT * FROM walmartsales.sales;

-- add day name
SELECT	date, DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

SELECT * FROM walmartsales.sales;

-- Add month_name column
SELECT date, MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

-- unique city

SELECT DISTINCT city
FROM sales;


SELECT 	DISTINCT city, branch
FROM sales;

-- work on product
SELECT DISTINCT product_line
FROM sales;

-- most selling product line

select sum(quantity) as qty, product_line from sales
GROUP BY product_line
ORDER BY qty DESC;

-- revenue by month
SELECT month_name AS month, SUM(total) AS total_revenue
FROM sales
GROUP BY month_name 
ORDER BY total_revenue;

-- highest cogs month

SELECT month_name AS month, SUM(cogs) AS cogs
FROM sales
GROUP BY month_name 
ORDER BY cogs;

-- revenue by product line
SELECT product_line, SUM(total) as total_revenue
FROM sales
GROUP BY product_line
order by total_revenue desc;

-- revenue by city

SELECT branch,city,SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch 
ORDER BY total_revenue;

-- vat by product line

SELECT	product_line,AVG(tax_pct) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- label good or bad
SELECT AVG(quantity) AS avg_qnty
FROM sales;

SELECT	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;


-- Which branch sold more products than average product sold?
SELECT 	branch, SUM(quantity) AS qnty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- common product by gender
SELECT	gender,product_line, COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- average rating each product line
SELECT ROUND(AVG(rating), 2) as avg_rating, product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- customer part
SELECT distinct customer_type from sales;

SELECT	DISTINCT payment FROM sales;

SELECT customer_type, count(*) as count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

-- who buys most

SELECT	customer_type, COUNT(*)
FROM sales
GROUP BY customer_type;

-- customer by gender
SELECT gender, COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- gender distribution by branch

SELECT	gender, COUNT(*) as gender_cnt
FROM sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;


-- calculate the time of the day when customers give most ratings
SELECT	time_of_day, AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Looks like time of the day does not really affect the rating, its
-- more or less the same rating each time of the day.alter


-- calculate the time of the day when customers give most ratings per branch
SELECT time_of_day, AVG(rating) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.


-- the day of the week has the best avg ratings?
SELECT day_name, AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;
-- Mon, Tue and Friday are the top best days for good ratings
-- why is that the case, how many sales are made on these days?



-- the day of the week which has the best average ratings per branch?
SELECT day_name, COUNT(day_name) total_sales
FROM sales
WHERE branch = "C"
GROUP BY day_name
ORDER BY total_sales DESC;


-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- ---------------------------- Sales ---------------------------------
-- --------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday 
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;
-- Evenings experience most sales, the stores are 
-- filled during the evening hours

--  the customer types which  brings the most revenue?
SELECT customer_type, SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue;

-- largest tax/VAT percent by the city
SELECT	city, ROUND(AVG(tax_pct), 2) AS avg_tax_pct
FROM sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;

-- pays the most in VAT by the customer
SELECT	customer_type, AVG(tax_pct) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax;

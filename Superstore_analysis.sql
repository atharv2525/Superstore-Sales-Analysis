CREATE TABLE global_superstore (
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    market VARCHAR(50),
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(10,2),
    shipping_cost DECIMAL(10,2),
    order_priority VARCHAR(50),
    year INT,
    month VARCHAR(20),
    month_no INT,
    delivery_days INT,
    profit_margin DECIMAL(10,4)
);

use global_superstore_db;
LOAD DATA LOCAL INFILE '/Users/atharvsahu/Downloads/Superstore Project/Global_Superstore_Cleaned.csv'
INTO TABLE global_superstore
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*)
FROM global_superstore;

select *
from global_superstore
limit 10;

-- 1.Total sales,profit and orders
SELECT
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM global_superstore;

-- 2.Sales and profit by category,sub-category
SELECT
    category,sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM global_superstore
GROUP BY category,sub_category
ORDER BY total_sales DESC;

-- 3.top 10 countries by sales
SELECT
    country,
    ROUND(SUM(sales), 2) AS total_sales
FROM global_superstore
GROUP BY country
ORDER BY total_sales DESC
LIMIT 10;

-- 4. top 10 customers by revenue
SELECT
    customer_name,
    ROUND(SUM(sales), 2) AS total_sales
FROM global_superstore
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 10;

-- 5. Avg delivery time by ship mode
SELECT
    ship_mode,
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days
FROM global_superstore
GROUP BY ship_mode
ORDER BY avg_delivery_days;

-- 6.Monthly sales trend
SELECT
    year,
    month,
    ROUND(SUM(sales),2) AS total_sales
FROM global_superstore
GROUP BY year, month_no, month
ORDER BY year, month_no;

-- 7.top 10 products by sales
SELECT
    product_name,
    ROUND(SUM(sales),2) AS total_sales
FROM global_superstore
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;

-- 8.Bottom 10 products by profit
SELECT
    product_name,
    ROUND(SUM(profit),2) AS total_profit
FROM global_superstore
GROUP BY product_name
ORDER BY total_profit ASC
LIMIT 10;

-- 9.Top 5 customers in each region
WITH customer_sales AS (
    SELECT
        region,
        customer_name,
        ROUND(SUM(sales),2) AS total_sales,
        DENSE_RANK() OVER (
            PARTITION BY region
            ORDER BY SUM(sales) DESC
        ) AS rnk
    FROM global_superstore
    GROUP BY region, customer_name
)

SELECT *
FROM customer_sales
WHERE rnk <= 5;

-- 10.sales contribution percentage by category
SELECT
    category,
    ROUND(SUM(sales),2) AS category_sales,
    ROUND(
        (SUM(sales) * 100.0) /
        SUM(SUM(sales)) OVER (),
        2
    ) AS sales_contribution_pct
FROM global_superstore
GROUP BY category;



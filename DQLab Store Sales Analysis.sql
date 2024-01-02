-- DQLAB STORE SALES PERFORMANCE ANALYSIS 

SELECT * FROM project.clean_data;

-- adding additional column called "Revenue" which is gotten from the multiplication of the order_quantity and sales column

ALTER TABLE project.clean_data
ADD COLUMN revenue INT GENERATED ALWAYS AS (order_quantity * discount_value) STORED;

/* ANALYSIS TO BE MADE:
1.  Top 5 customers producing Highest Revenues
2.  Product Category producing Highest Revenues
3.  Product Category cantaining more Quantity Ordered
4.  Top 5 Sub-Product Categories producing Highest Revenues
5.  Top 5 Sub-Product Categories containing more Quanity Ordered
6.  On what Month did the highest producing revenue occured
7.  How many orders were completed 
8.  How many orders were returned
9.  How many orders were cancelled
*/

-- 1. analysing top 5 customers producing highest revenues
SELECT customer, revenue FROM project.clean_data
ORDER BY revenue DESC
LIMIT 5;

-- 2. analysing Product Category producing Highest Revenues
SELECT product_category AS `Product Category`, SUM(revenue) AS Revenue
FROM project.clean_data
GROUP BY `Product Category`
ORDER BY Revenue DESC;

-- 3. analysing Product Category cantaining more Quantity Ordered
SELECT product_category AS `Product Category`, SUM(order_quantity) AS total_quantity
FROM project.clean_data
GROUP BY `Product Category`
ORDER BY total_quantity DESC;

-- 4. Top 5 Sub-Product Categories producing Highest Revenues
SELECT product_sub_category AS `Product Sub Category`, SUM(revenue) AS Revenue
FROM project.clean_data
GROUP BY `Product Sub Category`
ORDER BY Revenue DESC
LIMIT 5;

-- 5. Top 5 Sub-Product Categories containing more Quanity Ordered
SELECT product_sub_category AS `Product Sub Category`, SUM(order_quantity) AS `Ordered Quantity`
FROM project.clean_data
GROUP BY `Product Sub Category`
ORDER BY `Ordered Quantity` DESC
LIMIT 5;

-- 6. On what Month did the highest producing revenue occured
ALTER TABLE project.clean_data
MODIFY COLUMN order_date DATETIME;

ALTER TABLE project.clean_data
ADD COLUMN `Month` VARCHAR(255) GENERATED ALWAYS AS (MONTHNAME(order_date)) STORED;

SELECT `Month`, Revenue
FROM (
    SELECT `Month`, SUM(revenue) AS Revenue
    FROM project.clean_data
    GROUP BY `Month`
) AS Month_Revenue
ORDER BY Revenue DESC
LIMIT 1;

-- 7. How many orders were completed 
SELECT count(order_status) AS `Completed Orders`
FROM project.clean_data
WHERE order_status = 'Order Finished';

-- 8. How many orders were returned 
SELECT count(order_status) AS `Orders Returned`
FROM project.clean_data
WHERE order_status = 'Order Returned';

-- 9. How many orders were cancelled 
SELECT count(order_status) AS `Orders Cancelled`
FROM project.clean_data
WHERE order_status = 'Order Cancelled';

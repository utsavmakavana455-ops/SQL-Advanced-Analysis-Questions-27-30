/*
Let's continue with **Questions 27–30** using the same `orders` dataset.

### 27. Find the highest order for each customer

Find each customer's highest individual order amount.

### 28. Find customers whose average order value is above the overall average

Calculate each customer's average order amount and return only customers whose average is higher than the overall average order amount.

### 29. Find the most popular product by quantity

Calculate the total quantity sold for each product and identify the product with the highest total quantity sold.

### 30. Calculate month-over-month sales

Calculate total monthly sales and the difference between each month and the previous month's sales.
*/


# 27. Highest order for each customer
SELECT
    customer_name,
    MAX(amount) AS highest_order
FROM orders
GROUP BY customer_name
ORDER BY highest_order DESC;

# 28. Customers with above-average order value
SELECT
    customer_name,
    ROUND(AVG(amount), 2) AS customer_avg_order
FROM orders
GROUP BY customer_name
HAVING AVG(amount) > (
    SELECT AVG(amount)
    FROM orders
)
ORDER BY customer_avg_order DESC;

#29. Most popular product by quantity
SELECT
    product,
    SUM(quantity) AS total_quantity_sold
FROM orders
GROUP BY product
ORDER BY total_quantity_sold DESC
LIMIT 1;

# 30. Month-over-month sales
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
        SUM(amount) AS total_sales
    FROM orders
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
)
SELECT
    sales_month,
    total_sales,
    LAG(total_sales) OVER (
        ORDER BY sales_month
    ) AS previous_month_sales,
    total_sales - LAG(total_sales) OVER (
        ORDER BY sales_month
    ) AS sales_difference
FROM monthly_sales
ORDER BY sales_month;
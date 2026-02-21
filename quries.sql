-- 1. Employee & Department Analytics
-- 1.1 Find duplicate records in a table

SELECT department_name, COUNT(*) AS count
FROM departments
GROUP BY department_name
HAVING COUNT(*) > 1;

-- 1.2 Second highest salary from employees

SELECT MAX(salary) AS second_highest_salary
FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);

-- 1.3 Employees without a department (left join)

SELECT e.*
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
WHERE d.department_id IS NULL;

-- 1.4 Top 3 highest-paid employees

SELECT employee_id, employee_name, salary
FROM employees
ORDER BY salary DESC
LIMIT 3;    

-- 1.5 Employees hired after 2023

SELECT *
FROM employees
WHERE hire_date > '2023-01-01';

-- 1.6 Employees hired on weekends

SELECT *
FROM employees
WHERE EXTRACT(DOW FROM hire_date) IN (0, 6);

--  1.7 Employees with salary between 50,000 and 80,000

SELECT *
FROM employees
WHERE salary BETWEEN 50000 AND 80000
ORDER BY salary DESC;

--  1.8 Rank employees by salary within each department

SELECT employee_name, salary, employee_id,
    RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
FROM employees

-- 1.9 each department's average salary

SELECT department_id, AVG(salary) AS average_salary
FROM employees
GROUP BY department_id;


-- 1.10 Percentage of employees in each department

SELECT d.department_name,
        COUNT(*) AS emp_count,
        ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM employees), 2) AS percentage
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;


-- 1.11 Maximum salary difference within each department

SELECT department_id,
       MAX(salary) - MIN(salary) AS salary_difference
FROM employees
GROUP BY department_id;

-- 2. Sales & Product Performance
-- 2.1 Total revenue per product

SELECT p.product_name,
        SUM(o.total_amount) AS total_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- 2.2 products with no sales

SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id
WHERE o.order_id IS NULL;

-- 2.3 top 5 selling product by quantity
SELECT p.product_name, SUM(o.quantity) AS total_quantity
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity DESC
LIMIT 5;

-- 2.4 monthly with month name sales revenue and order count

SELECT STRFTIME('%Y-%m', order_date) AS month,
       SUM(total_amount) AS total_revenue,
       COUNT(order_id) AS order_count
FROM orders
GROUP BY month
ORDER BY month;

-- 2.5 product sales distribution by category (% of total revenue)

WITH total_revenue AS (
    SELECT SUM(total_amount) AS grand_total FROM orders
)

SELECT p.product_name,
        SUM(o.total_amount) AS product_revenue,
        ROUND(100.0 * SUM(o.total_amount) / (SELECT grand_total FROM total_revenue), 2) AS revenue_percentage
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue_percentage DESC;

-- 2.6 prodcuts contribution to 80% of revenue (Pareto analysis)

WITH product_revenue AS (
    SELECT p.product_id,
            p.product_name,
            SUM(o.total_amount) AS revenue
    FROM orders o
    JOIN products p ON o.product_id = p.product_id
    GROUP BY p.product_id, p.product_name
),

total_rev AS (
    SELECT SUM(revenue) AS total FROM product_revenue
),

revenue_with_cumulative AS (
    SELECT product_id, product_name, revenue,
            SUM(revenue) OVER (ORDER BY revenue DESC) AS running_total,
            ROUND(100.0 * SUM(revenue) OVER (ORDER BY revenue DESC) / (SELECT total FROM total_rev), 2) AS cumulative_percentage
    FROM product_revenue
)

SELECT product_id, product_name, revenue, running_total, cumulative_percentage
FROM revenue_with_cumulative
WHERE cumulative_percentage <= 80
ORDER BY revenue DESC;

-- 3. Customer & Order Behaviour
-- 3.1 Order count per customer

SELECT c.customer_name, COUNT(o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY order_count DESC;

-- 3.2  Customers who made purchases but never returned products

SELECT DISTINCT c.customer_id, c.customer_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE NOT EXISTS (
    SELECT 1 FROM returns r WHERE r.customer_id = c.customer_id 
)

-- 3.3 Average order value per customer

SELECT c.customer_name, AVG(o.total_amount) AS average_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY average_order_value DESC;

-- 3.4 latest order placed by each customer

SELECT c.customer_id, c.customer_name, o.order_date, o.total_amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_date = (
    SELECT MAX(order_date) FROM orders WHERE customer_id = c.customer_id
)
ORDER BY o.order_date DESC;

-- alternative using ROW_NUMBER()

WITH ranked AS (
    SELECT c.customer_id, c.customer_name, o.order_date, o.total_amount,
            ROW_NUMBER() OVER (PARTITION BY c.customer_id ORDER BY o.order_date DESC) as rn
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
)

SELECT customer_id, customer_name, order_date, total_amount
FROM ranked
WHERE rn = 1

-- 3.5 total revenue and count per region

SELECT region, SUM(total_amount) AS total_amount, COUNT(*) AS order_count
FROM orders
GROUP BY region
ORDER BY total_amount DESC;

-- 3.6 customers with more than 5 orders

SELECT c.customer_name, COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING COUNT(o.order_id) > 5

-- 3.7 order above the average order value

SELECT *
FROM orders
WHERE total_amount > (SELECT AVG(total_amount) FROM orders)

-- 3.8 customers who ordered in every month of 2023

SELECT c.customer_id, c.customer_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE STRFTIME('%Y', o.order_date) = '2023'
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT STRFTIME('%m', o.order_date)) = 12

-- 3.9 first and last order date for each customer
SELECT c.customer_id, c.customer_name,
       MIN(o.order_date) AS first_order_date,
       MAX(o.order_date) AS last_order_date
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY first_order_date;

-- 3.10 churned customers (no orders in last 3 months)

SELECT c.customer_id, c.customer_name, MAX(o.order_date) AS last_order_date
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING MAX(o.order_date) < DATE('now', '-3 months')
ORDER BY c.customer_id;

-- revenue generated by new customers (first-time orders)

WITH first_orders AS (
    SELECT customer_id, MIN(order_date) AS first_order_date
    FROM orders
    GROUP BY customer_id
)

SELECT SUM(o.total_amount) AS revenue_from_new_customers
FROM orders o
JOIN first_orders fo ON o.customer_id = fo.customer_id AND o.order_date = fo.first_order_date;

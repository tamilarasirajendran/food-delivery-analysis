USE food_delivery_db;


--  OVERALL KPIs


-- Total Orders
SELECT COUNT(*) AS total_orders
FROM orders;

-- Total Revenue
SELECT ROUND(SUM(Final_Amount), 2) AS total_revenue
FROM orders;

-- Average Order Value
SELECT ROUND(AVG(Final_Amount), 2) AS avg_order_value
FROM orders;

-- Average Delivery Time
SELECT ROUND(AVG(Delivery_Time_Min), 2) AS avg_delivery_time
FROM orders
WHERE Order_Status = 'Delivered';

-- Cancellation Rate (%)
SELECT 
    ROUND(
        SUM(CASE WHEN Order_Status = 'Cancelled' THEN 1 ELSE 0 END) 
        / COUNT(*) * 100, 2
    ) AS cancellation_rate_pct
FROM orders;

-- Average Delivery Rating
SELECT ROUND(AVG(Delivery_Rating), 2) AS avg_delivery_rating
FROM orders
WHERE Delivery_Rating IS NOT NULL;

-- Average Profit Margin %
SELECT ROUND(AVG(Profit_Margin_Pct), 2) AS avg_profit_margin_pct
FROM orders;

--  CUSTOMER ANALYSIS


-- Top 10 Customers by Revenue
SELECT 
    c.Customer_ID,
    c.City,
    ROUND(SUM(o.Final_Amount), 2) AS total_spent
FROM orders o
JOIN customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.City
ORDER BY total_spent DESC
LIMIT 10;

-- Age Group vs Average Order Value
SELECT 
    Age_Group,
    ROUND(AVG(Final_Amount), 2) AS avg_order_value
FROM orders o
JOIN customers c ON o.Customer_ID = c.Customer_ID
GROUP BY Age_Group;

-- Weekday vs Weekend Orders
SELECT 
    Order_Day_Type,
    COUNT(*) AS total_orders
FROM orders
GROUP BY Order_Day_Type;


--  REVENUE & PROFIT ANALYSIS


-- Monthly Revenue Trend
SELECT 
    DATE_FORMAT(Order_Date, '%Y-%m') AS order_month,
    ROUND(SUM(Final_Amount), 2) AS monthly_revenue
FROM orders
GROUP BY order_month
ORDER BY order_month;

-- Discount Impact on Profit
SELECT 
    CASE 
        WHEN Discount_Applied > 0 THEN 'Discount Applied'
        ELSE 'No Discount'
    END AS discount_flag,
    ROUND(AVG(Profit_Margin), 2) AS avg_profit
FROM orders
GROUP BY discount_flag;

-- Top 10 Cities by Revenue
SELECT 
    c.City,
    ROUND(SUM(o.Final_Amount), 2) AS city_revenue
FROM orders o
JOIN customers c 
    ON o.Customer_ID = c.Customer_ID
GROUP BY c.City
ORDER BY city_revenue DESC
LIMIT 10;


--  DELIVERY PERFORMANCE


-- Average Delivery Time by City
SELECT 
    c.City,
    ROUND(AVG(o.Delivery_Time_Min), 2) AS avg_delivery_time
FROM orders o
JOIN customers c 
    ON o.Customer_ID = c.Customer_ID
WHERE o.Order_Status = 'Delivered'
GROUP BY c.City
ORDER BY avg_delivery_time;


-- Distance vs Average Delivery Time
SELECT 
    ROUND(Distance_km, 0) AS distance_bucket_km,
    ROUND(AVG(Delivery_Time_Min), 2) AS avg_delivery_time
FROM orders
GROUP BY distance_bucket_km
ORDER BY distance_bucket_km;

-- Delivery Rating vs Delivery Time
SELECT 
    Delivery_Rating,
    ROUND(AVG(Delivery_Time_Min), 2) AS avg_delivery_time
FROM orders
WHERE Delivery_Rating IS NOT NULL
GROUP BY Delivery_Rating
ORDER BY Delivery_Rating;


--  RESTAURANT PERFORMANCE


-- Top 10 Restaurants by Rating
SELECT 
    Restaurant_ID,
    ROUND(AVG(Restaurant_Rating), 2) AS avg_rating
FROM restaurants
GROUP BY Restaurant_ID
ORDER BY avg_rating DESC
LIMIT 10;

-- Cancellation Rate by Restaurant
SELECT 
    Restaurant_ID,
    ROUND(
        SUM(CASE WHEN Order_Status = 'Cancelled' THEN 1 ELSE 0 END) 
        / COUNT(*) * 100, 2
    ) AS cancellation_rate_pct
FROM orders
GROUP BY Restaurant_ID
ORDER BY cancellation_rate_pct DESC;

-- Cuisine-wise Performance
SELECT 
    r.Cuisine_Type,
    COUNT(o.Order_ID) AS total_orders,
    ROUND(AVG(o.Final_Amount), 2) AS avg_order_value
FROM orders o
JOIN restaurants r ON o.Restaurant_ID = r.Restaurant_ID
GROUP BY r.Cuisine_Type
ORDER BY total_orders DESC;


--  OPERATIONAL INSIGHTS


-- Peak Hour Demand
SELECT 
    Peak_Hour,
    COUNT(*) AS total_orders
FROM orders
GROUP BY Peak_Hour;

-- Payment Mode Preference
SELECT 
    Payment_Mode,
    COUNT(*) AS total_orders
FROM orders
GROUP BY Payment_Mode
ORDER BY total_orders DESC;

-- Cancellation Reason Analysis
SELECT 
    Cancellation_Reason,
    COUNT(*) AS total_cancellations
FROM orders
WHERE Order_Status = 'Cancelled'
GROUP BY Cancellation_Reason
ORDER BY total_cancellations DESC;

-- 01_create_tables.sql - Normalized 3NF Schema
CREATE DATABASE IF NOT EXISTS food_delivery_db;
USE food_delivery_db;

-- Customers (deduplicated)
CREATE TABLE customers (
    Customer_ID VARCHAR(50) PRIMARY KEY,
    Customer_Age INT,
    Age_Group ENUM('Young','Adult','Middle','Senior'),
    Gender VARCHAR(10),
    City VARCHAR(50)
);


-- Restaurants

CREATE TABLE restaurants (
    Restaurant_ID VARCHAR(50) PRIMARY KEY,
    Restaurant_Name VARCHAR(100),
    Cuisine_Type VARCHAR(50),
    Restaurant_Rating DECIMAL(3,2),
    City VARCHAR(50)
);

-- Delivery Partners

CREATE TABLE delivery_partners (
    Delivery_Partner_ID VARCHAR(50) PRIMARY KEY,
    Avg_Rating DECIMAL(3,2)
);

-- Orders (FACT TABLE)

CREATE TABLE orders (
    Order_ID VARCHAR(50) PRIMARY KEY,
    Customer_ID VARCHAR(50),
    Restaurant_ID VARCHAR(50),
    Delivery_Partner_ID VARCHAR(50),

    Order_Date DATE,
    Order_Hour INT,
    Order_Day_Type VARCHAR(10),
    Peak_Hour TINYINT,

    Order_Value DECIMAL(10,2),
    Discount_Applied DECIMAL(10,2),
    Final_Amount DECIMAL(10,2),

    Payment_Mode VARCHAR(20),
    Order_Status VARCHAR(20),
    Cancellation_Reason VARCHAR(50),

    Delivery_Time_Min INT,
    Distance_km DECIMAL(5,2),
    Delivery_Rating INT,

    Profit_Margin DECIMAL(10,2),
    Profit_Margin_Pct DECIMAL(5,2),

    FOREIGN KEY (Customer_ID) REFERENCES customers(Customer_ID),
    FOREIGN KEY (Restaurant_ID) REFERENCES restaurants(Restaurant_ID),
    FOREIGN KEY (Delivery_Partner_ID) REFERENCES delivery_partners(Delivery_Partner_ID)
);
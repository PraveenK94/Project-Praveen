-- Database and Table Creation

CREATE DATABASE sales_olap;

-- Connect to the database

\c sales_olap

CREATE TABLE sales_sample (
    Product_Id INTEGER,
    Region VARCHAR(50),
    Date DATE,
    Sales_Amount NUMERIC
);


INSERT INTO sales_sample (Product_Id, Region, Date, Sales_Amount) VALUES
(101, 'East', '2024-01-15', 5000),
(102, 'West', '2024-01-15', 6000),
(101, 'North', '2024-01-16', 4500),
(103, 'South', '2024-01-16', 5500),
(102, 'East', '2024-01-17', 7000),
(101, 'West', '2024-01-17', 4800),
(103, 'North', '2024-01-18', 6200),
(102, 'South', '2024-01-18', 5300),
(101, 'East', '2024-01-19', 5800),
(103, 'West', '2024-01-19', 6500);

-- OLAP Operations:
-- a) Drill Down (from Region to Product level):
-- First level (Region)
SELECT 
    Region,
    SUM(Sales_Amount) as Total_Sales
FROM sales_sample
GROUP BY Region
ORDER BY Region;

-- Drill down to Product level within each Region
SELECT 
    Region,
    Product_Id,
    SUM(Sales_Amount) as Total_Sales
FROM sales_sample
GROUP BY Region, Product_Id
ORDER BY Region, Product_Id;

-- Further drill down to daily sales
SELECT 
    Region,
    Product_Id,
    Date,
    SUM(Sales_Amount) as Total_Sales
FROM sales_sample
GROUP BY Region, Product_Id, Date
ORDER BY Region, Product_Id, Date;

-- b) Rollup (from Product to Region level):

SELECT 
    Region,
    Product_Id,
    SUM(Sales_Amount) as Total_Sales
FROM sales_sample
GROUP BY ROLLUP(Region, Product_Id)
ORDER BY Region, Product_Id;

-- c) Cube (multiple dimension analysis):

SELECT 
    COALESCE(Region, 'All Regions') as Region,
    COALESCE(TO_CHAR(Date, 'YYYY-MM'), 'All Dates') as Month,
    COALESCE(Product_Id::TEXT, 'All Products') as Product,
    SUM(Sales_Amount) as Total_Sales
FROM sales_sample
GROUP BY CUBE(Region, TO_CHAR(Date, 'YYYY-MM'), Product_Id)
ORDER BY Region, Month, Product;

-- d) Slice (specific criteria):

-- Slice by Region
SELECT 
    Product_Id,
    Date,
    Sales_Amount
FROM sales_sample
WHERE Region = 'East';

-- Slice by Date Range
SELECT 
    Product_Id,
    Region,
    Sales_Amount
FROM sales_sample
WHERE Date BETWEEN '2024-01-15' AND '2024-01-17';

-- e) Dice (multiple criteria):

SELECT *
FROM sales_sample
WHERE Region IN ('East', 'West')
AND Date BETWEEN '2024-01-15' AND '2024-01-17'
AND Product_Id IN (101, 102);

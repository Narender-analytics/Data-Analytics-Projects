create database ZEPTO_PROJECT;
USE ZEPTO_PROJECT;

DROP TABLE IF EXISTS ZEPTO;
CREATE TABLE ZEPTO(
	sku_id serial PRIMARY KEY ,
	category VARCHAR(120),
	Name VARCHAR(150) NOT NULL,
	mrp NUMERIC(8,2),
	discountPercent NUMERIC(8,2),
	availableQuantity INTEGER,
	discountedSellingPrice NUMERIC(8,2),
	weightInGms INTEGER,
	outOfStock VARCHAR(20),
	quantity INTEGER
	 );
SELECT * FROM ZEPTO;

-- DATA EXPLORATION

-- COUNT OF ROWS 
SELECT COUNT(*) FROM ZEPTO;

SELECT * FROM ZEPTO
WHERE category is null
or 
name is null 
or 
mrp is null
or   
discountPercent is null 
or  
availableQuantity is null
or 
discountedSellingPrice is null 
or 
weightInGms is null
or
outOfStock is null
or 
quantity is null; 

-- DIFFERENT PRODUCT CATEGORIES
SELECT DISTINCT
    category
FROM
    ZEPTO
ORDER BY CATEGORY; 

-- PRODUCTS IN STOCK VS OUT OF STOCK 
SELECT 
    outOfStock, COUNT(sku_id)
FROM
    zepto
GROUP BY outOfStock;

-- PRODUCT NAMES PRESENT MULTIPLE TIMES 
SELECT 
    name, COUNT(sku_id)
FROM
    ZEPTO
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) desc;
 
-- DATA CLEANING 

-- PRODUCTS WIHT PRICE = 0 
SELECT 
    *
FROM
    ZEPTO
WHERE
    mrp = 0 OR discountedSellingPrice = 0;

-- PRODUCTS WITH PRICE = 0 
DELETE FROM ZEPTO 
WHERE
    mrp = 0;
    
-- CONVERT PAISE TO RUPEES
UPDATE ZEPTO 
SET 
    mrp = mrp / 100.0,
    discountedSellingPrice = discountedSellingPrice / 100.0;

SELECT mrp, discountedSellingPrice from ZEPTO;

-- FIND THE TOP 10 BEST VALUE PRODUCTS BASED ON DISCOUNTED PERCENTAGE.
SELECT DISTINCT
    name, mrp, discountPercent
FROM
    ZEPTO
ORDER BY discountPercent DESC
LIMIT 10;

-- WHAT ARE THE PRODUCTS WITH HIGH MRP BUT OUT OF STOCK.
SELECT 
    name, mrp, outOfStock
FROM
    ZEPTO
WHERE
    outOfStock = 'TRUE'
ORDER BY mrp DESC
LIMIT 10;

-- CALCULATE ESTIMATED REVENUE FOR EACH CATEGORY.

SELECT 
    category, SUM(discountedSellingPrice) revenue
FROM
    ZEPTO
GROUP BY category
ORDER BY revenue DESC;

-- FIND ALL THE PRODUCTS WHERE MRP IS GREATER THAN RS.500 AND DISCOUNT IS LESS THAN 10% . 

SELECT DISTINCT
    name, mrp, discountPercent
FROM
    zepto
WHERE
    mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC , discountPercent DESC;

-- IDENTIFY THE TOP 5 CATEGORIES OFFERING THE HIGHEST AVERAGE DISCOUNT PERCENTAGE . 

SELECT 
    category, ROUND(AVG(discountPercent), 2) AS avg_discount
FROM
    zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- FIND THE PRICE PER GRAM FOR PRODUCTS ABOVE 100G AND SORT BY BEST VALUE . 

SELECT DISTINCT
    name,
    weightInGms,
    discountedSellingPrice,
    ROUND(discountedSellingPrice / weightInGms, 2) AS price_per_gram
FROM
    zepto
WHERE
    weightInGms >= 100
ORDER BY price_per_gram;

-- GROUP THE PRODUCTS INTO CATEGORIES LIKE LOW, MEDIUM, BULK.

SELECT DISTINCT
    name,
    weightInGms,
    CASE
        WHEN weightInGms < 1000 THEN 'LOW'
        WHEN weightInGms < 5000 THEN 'MEDIUM'
        ELSE 'BULK'
    END AS weight_category
FROM
    zepto;

-- WHAT IS THE TOTAL INVENTORY WEIGHT PER CATEGORY.

SELECT 
    category,
    SUM(weightInGms * availableQuantity) AS total_weight
FROM
    zepto
GROUP BY category
ORDER BY total_weight;
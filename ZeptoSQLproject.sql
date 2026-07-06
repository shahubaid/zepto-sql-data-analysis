-- Creating a table named zepto, as per our dataset:

DROP TABLE IF EXISTS zepto; 


CREATE TABLE ZEPTO (
	SKU_ID SERIAL PRIMARY KEY,
	CATEGORY VARCHAR(120),
	NAME VARCHAR(150) NOT NULL,
	MRP NUMERIC(8, 2),
	DISCOUNT_PERCENT NUMERIC(5, 2),
	AVAILABLE_QUANTITY INTEGER,
	DISCOUNTED_SELLING_PRICE NUMERIC(8, 2),
	WT_IN_GMS INTEGER,
	OUT_OF_STOCK BOOL,
	QUANTITY INTEGER
);

-- Counting the rows from the table:
SELECT
	COUNT(*)
FROM
	ZEPTO;

-- Sample data:
SELECT
	*
FROM
	ZEPTO
LIMIT 10;

-- Checking NULL values (one by one):
SELECT
	*
FROM
	ZEPTO
WHERE
	CATEGORY IS NULL
	OR NAME IS NULL
	OR MRP IS NULL
	OR DISCOUNT_PERCENT IS NULL
	OR AVAILABLE_QUANTITY IS NULL
	OR DISCOUNTED_SELLING_PRICE IS NULL
	OR WT_IN_GMS IS NULL
	OR OUT_OF_STOCK IS NULL
	OR QUANTITY IS NULL;
-- Now that, there is no NULL VALUE,
-- Lets check the different product category:
SELECT DISTINCT
	CATEGORY
FROM
	ZEPTO
ORDER BY
	CATEGORY;

-- Products in stock vs Products out of stock:
SELECT
	OUT_OF_STOCK,
	COUNT(SKU_ID)
FROM
	ZEPTO
GROUP BY
	OUT_OF_STOCK;

-- Product names present multiple times:
SELECT
	NAME,
	COUNT(SKU_ID) AS "Number of SKU's"
FROM
	ZEPTO
GROUP BY
	NAME
HAVING
	COUNT(SKU_ID) > 1
ORDER BY
	COUNT(SKU_ID) DESC;

-- DATA CLEANING:

-- Check if any product has a zero cost:
SELECT
	*
FROM
	ZEPTO
WHERE
	MRP = 0
	OR DISCOUNTED_SELLING_PRICE = 0;

-- (so we got a product from Home & Cleaning category whose mrp=0)
-- delete the product with zero mrp
DELETE FROM ZEPTO
WHERE
	MRP = 0;

-- (I observed that the mrp is given in paisa)
--  Convert paisa into rupees:
UPDATE ZEPTO
SET
	MRP = MRP / 100.0,
	DISCOUNTED_SELLING_PRICE = DISCOUNTED_SELLING_PRICE / 100.0;

--(check the change)
SELECT
	MRP,
	DISCOUNTED_SELLING_PRICE
FROM
	ZEPTO;

-- (Lets face some direct questions)
	-- Business Analysis
-- Q1: Find the top 10 best value products based on discount percentage?
SELECT DISTINCT
	NAME,
	MRP,
	DISCOUNT_PERCENT
FROM
	ZEPTO
ORDER BY
	DISCOUNT_PERCENT DESC
LIMIT
	10;

-- Q2: What are the products with high mrp but out of stock?
SELECT DISTINCT
	NAME,
	MRP
FROM
	ZEPTO
WHERE
	OUT_OF_STOCK = TRUE
	AND MRP > (
		SELECT
			AVG(MRP)
		FROM
			ZEPTO
	)
ORDER BY
	MRP DESC;

-- Q3: Calculate estimated revenue of each category?
SELECT
	CATEGORY,
	SUM(DISCOUNTED_SELLING_PRICE * AVAILABLE_QUANTITY) AS REVENUE
FROM
	ZEPTO
GROUP BY
	CATEGORY
ORDER BY
	REVENUE DESC;

-- Q4: Find products priced above the average selling price?
SELECT category, name, discounted_selling_price
FROM zepto
WHERE
	discounted_selling_price > (
		SELECT
			AVG(discounted_selling_price)
		FROM zepto
	)
ORDER BY
	category;
	
-- Q5: Identify the top 5 categories offering the highest average discount percentage?
SELECT
	CATEGORY,
	ROUND(AVG(DISCOUNT_PERCENT), 2) AS AVG_DISCOUNT_PERCENT
FROM
	ZEPTO
GROUP BY
	CATEGORY
ORDER BY
	AVG_DISCOUNT_PERCENT DESC
LIMIT
	5;

-- Q6: Find the price per gram for products above 100gram and sort by best value?
SELECT DISTINCT
	NAME,
	WT_IN_GMS,
	DISCOUNTED_SELLING_PRICE,
	ROUND(DISCOUNTED_SELLING_PRICE / WT_IN_GMS, 2) AS PRICE_PER_GRAM
FROM
	ZEPTO
WHERE
	WT_IN_GMS >= 100
ORDER BY
	PRICE_PER_GRAM;


-- Q7: Group the products into categories like LOW, MEDIUM, BULK?
SELECT DISTINCT
	NAME,
	WT_IN_GMS,
	CASE
		WHEN WT_IN_GMS < 1000 THEN 'Low'
		WHEN WT_IN_GMS < 5000 THEN 'Medium'
		ELSE 'Bulk'
	END AS WEIGHT_CATEGORY
FROM
	ZEPTO;
	
-- Q8: Rank the top 5 most expensive products?
SELECT *
FROM
(
    SELECT category,
           name,
           discounted_selling_price,
           ROW_NUMBER() OVER (ORDER BY discounted_selling_price DESC) AS product_rank
    FROM zepto
) AS ranked_products
WHERE product_rank <= 5;

-- Q9. Find the products where mrp is greater than 500rs & discount is less than 10%?
SELECT DISTINCT
	NAME,
	MRP,
	DISCOUNT_PERCENT
FROM
	ZEPTO
WHERE
	MRP > 500
	AND DISCOUNT_PERCENT < 10
ORDER BY
	MRP DESC,
	DISCOUNT_PERCENT DESC;

-- Q10. What is the total inventory weight per category?
SELECT
	CATEGORY,
	SUM(WT_IN_GMS * AVAILABLE_QUANTITY) AS TOTAL_WEIGHT
FROM
	ZEPTO
GROUP BY
	CATEGORY
ORDER BY
	TOTAL_WEIGHT;

-- Q11. Find the category with the highest number of products?
SELECT category,
       COUNT(*) AS total_products
FROM zepto
GROUP BY category
ORDER BY total_products DESC
LIMIT 1;
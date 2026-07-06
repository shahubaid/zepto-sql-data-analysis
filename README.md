# 🛒 Zepto SQL Business Analysis

<p align="center">

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-Data%20Analysis-blue?style=for-the-badge)
![pgAdmin](https://img.shields.io/badge/pgAdmin-4-orange?style=for-the-badge)

</p>

---

# 📌 Project Overview

This project analyzes **Zepto's product catalog** using **PostgreSQL** to answer real world business questions.

The project begins with **data exploration and cleaning**, followed by SQL analysis to extract meaningful business insights related to pricing, discounts, inventory, revenue estimation, and product categorization.

The objective of this project is to demonstrate **beginner to intermediate SQL skills** used in real world data analysis.

---

# 📊 Project Statistics

| Metric | Value |
|---------|------|
| Database | PostgreSQL |
| Dataset | Zepto Product Dataset |
| Total Records | 2935 |
| Business Questions Solved | 11 |
| Data Cleaning Steps | 6 |
| SQL Concepts Used | 10+ |

---

# 📂 Dataset

**Source:** Kaggle

### Dataset contains:

- Product Name
- Category
- MRP
- Discounted Selling Price
- Discount Percentage
- Available Quantity
- Product Weight
- Stock Availability

---

# 🛠 Tools Used

- PostgreSQL
- pgAdmin 4
- SQL
- GitHub

---

# 💡 SQL Concepts Covered

- Data Cleaning
- Filtering
- Aggregate Functions
- GROUP BY
- HAVING
- ORDER BY
- CASE Statements
- Subqueries
- Window Functions
- ROW_NUMBER()
- Mathematical Calculations

---

# 🧹 Data Cleaning Performed

Before starting the business analysis, the dataset was cleaned to improve data quality.

The following cleaning steps were performed:

- Checked for NULL values
- Verified unique product categories
- Identified duplicate product names
- Removed products with zero MRP
- Converted monetary values from Paisa to Rupees
- Verified stock availability

---


# 📈 Business Analysis using SQL (📋 Business Questions)

---

# Q1. Find the Top 10 Best Value Products based on Discount Percentage?

## 🎯 Business Purpose

Identify products offering the highest discounts to attract price-sensitive customers.

## 💻 SQL Query

```sql
SELECT DISTINCT
	name,
	mrp,
	discount_percent
FROM
	zepto
ORDER BY
	discount_percent DESC
LIMIT
	10;
```

## 📷 Output

![Q1 Output](https://github.com/shahubaid/zepto-sql-data-analysis/blob/main/Screenshots/1.highest_discount_products.png?raw=true)

## 📌 Business Insight

Products with higher discounts can be promoted during seasonal campaigns to improve customer engagement and sales.

---

# Q2. Find High MRP Products that are Out of Stock?

## 🎯 Business Purpose

Identify expensive products that are currently unavailable to customers.

## 💻 SQL Query

```sql
SELECT DISTINCT
	name,
	mrp
FROM
	zepto
WHERE
	out_of_stock = TRUE
	AND mrp > (
		SELECT
			AVG(mrp)
		FROM
			zepto
	)
ORDER BY
	mrp DESC;
```

## 📷 Output

![Q2 Output](https://github.com/shahubaid/zepto-sql-data-analysis/blob/main/Screenshots/2.high_mrp_out_of_stock.png?raw=true)


## 📌 Business Insight

Restocking premium products quickly can reduce potential revenue loss.

---

# Q3. Calculate Estimated Revenue for each Category?

## 🎯 Business Purpose

Estimate category-wise revenue contribution.

## 💻 SQL Query

```sql
SELECT
	category,
	SUM(discounted_selling_price * available_quantity) AS revenue
FROM
	zepto
GROUP BY
	category
ORDER BY
	revenue DESC;
```

## 📷 Output

![Q3 Output](https://github.com/shahubaid/zepto-sql-data-analysis/blob/main/Screenshots/3.estimated_revenue_by_category.png?raw=true)

## 📌 Business Insight

High-performing categories deserve greater attention in inventory planning and marketing.

---

# Q4. Find Products Priced Above the Overall Average Selling Price?

## 🎯 Business Purpose

Identify premium-priced products.

## 💻 SQL Query

```sql
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
```

## 📷 Output

![Q4 Output](https://github.com/shahubaid/zepto-sql-data-analysis/blob/main/Screenshots/4.above_avg_products.png?raw=true)

## 📌 Business Insight

Premium priced products can be analyzed separately for pricing and positioning strategies.

---

# Q5. Identify the Top 5 Categories Offering the Highest Average Discount?

## 🎯 Business Purpose

Determine which categories rely the most on discounting.

## 💻 SQL Query

```sql
SELECT
	category,
	ROUND(AVG(discount_percent), 2) AS avg_discount_percent
FROM
	zepto
GROUP BY
	category
ORDER BY
	avg_discount_percent DESC
LIMIT
	5;
```

## 📷 Output

![Q5 Output](https://github.com/shahubaid/zepto-sql-data-analysis/blob/main/Screenshots/5.average_discount_by_category.png?raw=true)

## 📌 Business Insight

Higher average discounts may indicate competitive pricing or lower product demand.

---

# Q6. Find the price per gram for products above 100gram and sort by best value?

## 🎯 Business Purpose

Compare products fairly regardless of package size.

## 💻 SQL Query

```sql
SELECT DISTINCT
	name,
	wt_in_gms,
	discounted_selling_price,
	ROUND(discounted_selling_price / wt_in_gms, 2) AS price_per_gram
FROM
	zepto
WHERE
	wt_in_gms >= 100
ORDER BY
	price_per_gram;
```

## 📷 Output

![Q6 Output](https://github.com/shahubaid/zepto-sql-data-analysis/blob/main/Screenshots/6.price_per_gram_analysis.png?raw=true)

## 📌 Business Insight

Lower price per gram provides better value to customers.

---

# Q7. Categorize Products into Light, Medium and Bulk based on Weight?

## 🎯 Business Purpose

Segment products according to package size.

## 💻 SQL Query

```sql
SELECT DISTINCT
	name,
	wt_in_gms,
	CASE
		WHEN wt_in_gms < 1000 THEN 'Light'
		WHEN wt_in_gms < 5000 THEN 'Medium'
		ELSE 'Bulk'
	END AS weight_category
FROM
	zepto;
```

## 📷 Output

![Q7 Output](https://github.com/shahubaid/zepto-sql-data-analysis/blob/main/Screenshots/7.product_weight_categories.png?raw=true)

## 📌 Business Insight

Weight segmentation helps improve inventory planning and warehouse management.

---

# Q8. Rank the Top 5 Most Expensive Products?

## 🎯 Business Purpose

Identify premium products available in the catalog.

## 💻 SQL Query

```sql
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
```

## 📷 Output

![Q8 Output](https://github.com/shahubaid/zepto-sql-data-analysis/blob/main/Screenshots/8.top_5_expensive_products.png?raw=true)

## 📌 Business Insight

Ranking expensive products helps evaluate premium pricing strategies.

---

# Q9. Find Products with MRP greater than ₹500 and Discount less than 10%?

## 🎯 Business Purpose

Identify premium products that sell without heavy discounting.

## 💻 SQL Query

```sql
SELECT DISTINCT
	name,
	mrp,
	discount_percent
FROM
	zepto
WHERE
	mrp > 500
	AND discount_percent < 10
ORDER BY
	mrp DESC,
	discount_percent DESC;
```

## 📷 Output

![Q9 Output](https://github.com/shahubaid/zepto-sql-data-analysis/blob/main/Screenshots/9.specific_mrp_and_discount.png?raw=true)

## 📌 Business Insight

Products maintaining high prices with low discounts may indicate strong customer demand.

---

# Q10. Calculate Total Inventory Weight Available in each Category?

## 🎯 Business Purpose

Measure inventory volume across product categories.

## 💻 SQL Query

```sql
SELECT
	category,
	SUM(wt_in_gms * available_quantity) AS total_weight
FROM
	zepto
GROUP BY
	category
ORDER BY
	total_weight DESC;
```

## 📷 Output

![Q10 Output](https://github.com/shahubaid/zepto-sql-data-analysis/blob/main/Screenshots/10.inventory_weight_per_category.png?raw=true)

## 📌 Business Insight

Categories with higher inventory weight require better warehouse planning.

---

# Q11. Find the Category with the Highest Number of Products?

## 🎯 Business Purpose

Identify the category with the widest product assortment.

## 💻 SQL Query

```sql
SELECT category,
       COUNT(*) AS total_products
FROM zepto
GROUP BY category
ORDER BY total_products DESC
LIMIT 1;
```

## 📷 Output

![Q11 Output](https://github.com/shahubaid/zepto-sql-data-analysis/blob/main/Screenshots/11.category_with_max_products.png?raw=true)

## 📌 Business Insight

Categories containing more products usually require additional inventory management.

---

# 📂 Repository Structure

```
zepto-sql-data-analysis
│
├── README.md
├── Zepto_SQL_Project.sql
├── zepto.csv
└── Screenshots/
```

---

# 🎓 Key Learnings

Through this project, I learned how to:

- Import and clean raw datasets.
- Analyze business problems using SQL.
- Perform aggregations and filtering.
- Work with GROUP BY and HAVING.
- Use CASE statements for categorization.
- Write Subqueries.
- Apply Window Functions for ranking.
- Convert SQL outputs into meaningful business insights.
- Organize a complete SQL portfolio project using GitHub.

---

# 🚀 Future Improvements

- Build an interactive Power BI dashboard using the same dataset.
- Perform Exploratory Data Analysis (EDA) using Python.
- Develop a complete SQL + Python + Power BI business analytics project.

---

# 👨‍💻 About Me

I am an aspiring **Data Analyst** with a strong interest in transforming raw data into meaningful business insights.

Currently learning:

- SQL
- Python
- Power BI
- Excel

---

## 📬 Connect With Me

- **GitHub:** [shahubaid](https://github.com/shahubaid)
- **LinkedIn:** [Ubaid Shah](https://www.linkedin.com/in/ubaid-shah-6924003a8/)

---

⭐ If you found this project helpful, feel free to **Star** this repository.

# Grocery-Sales-SQL-Analysis-
Exploratory Data Analysis (EDA) of retail grocery sales and inventory volume using Microsoft SQL Server (SSMS). Implements data cleaning, matrix pivots, and window functions to extract business intelligence.

# 🛒 Grocery Retail Analytics: Revenue & Inventory EDA

An end-to-end Exploratory Data Analysis (EDA) project leveraging **Microsoft SQL Server (SSMS)** to extract actionable business insights from an 8,500+ record grocery retail database.

---

## Project Description & Overview
This project focuses on performing an end-to-end Exploratory Data Analysis (EDA) on a comprehensive retail database containing over 8,500 rows of transactional records. The script transitions systematically from initial data hygiene and standardization to high-level strategic financial reporting. By writing optimized SQL queries, the project isolates global performance metrics, profiles product categories, and tracks store performance across regional layout cohorts.

---

## Technical Skills Highlighted
* **Data Cleansing:** Standardizing text inconsistencies using conditional mapping expressions (`CASE WHEN`).
* **Advanced Aggregations:** Matrix transformations utilizing multi-column grouping (`GROUP BY`) and data distribution sorting.
* **Complex Data Restructuring:** Transforming long transactional rows into dynamic horizontal summary reports via subqueries and `PIVOT` operators.
* **Strategic Window Calculations:** Generating precise cross-row financial market share breakdowns using analytical clauses (`OVER()`).

---
## Phase 1: Data Standardization & Cleaning

The dataset originally contained fragmented categorical indicators for product configurations (`'LF'`, `'low fat'`, and `'reg'`). The following script unifies these into consistent corporate headers:

```sql
USE grocery_sales_db;

-- 1. Standardize text inconsistencies in categorical columns
UPDATE [Grocery Data]
SET Item_Fat_Content =
    CASE
        WHEN Item_Fat_Content IN ('LF','low fat') THEN 'Low Fat'
        WHEN Item_Fat_Content = 'reg' THEN 'Regular'
        ELSE Item_Fat_Content
    END;

-- 2. Post-cleaning validation check
SELECT DISTINCT Item_Fat_Content FROM [Grocery Data];


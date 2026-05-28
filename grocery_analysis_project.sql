-- =====================================================================
-- GROCERY REVENUE EXPLORATORY DATA ANALYSIS (EDA)
-- =====================================================================
USE grocery_sales_db;

-- =====================================================================
-- PHASE 1: DATA CLEANING & STANDARDIZATION
-- =====================================================================

-- Baseline row validation count
SELECT COUNT(*) AS Raw_Row_Count FROM [Grocery Data];

-- Standardize text inconsistencies in categorical columns
UPDATE [Grocery Data]
SET Item_Fat_Content =
    CASE
        WHEN Item_Fat_Content IN ('LF','low fat') THEN 'Low Fat'
        WHEN Item_Fat_Content = 'reg' THEN 'Regular'
        ELSE Item_Fat_Content
    END;

-- Post-cleaning validation check
SELECT DISTINCT Item_Fat_Content FROM [Grocery Data];


-- =====================================================================
-- PHASE 2: GLOBAL KEY PERFORMANCE INDICATORS (KPIs)
-- =====================================================================

-- 1. Total Global Sales (Formatted in Millions)
SELECT CONCAT(CAST(SUM(Total_Sales)/1000000.0 AS DECIMAL(10,2)), 'M') AS Total_Sales_Millions
FROM [Grocery Data];

-- 2. Performance Tracking: Total Sales for 2022 Cohort Stores
SELECT CONCAT(CAST(SUM(Total_Sales)/1000000.0 AS DECIMAL(10,2)), 'M') AS Total_2022_Sales
FROM [Grocery Data]
WHERE Outlet_Establishment_Year = 2022;

-- 3. Operational Performance: Average Transaction Value
SELECT CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales
FROM [Grocery Data];

-- 4. Inventory Volume: Global Distinct Item Records Count
SELECT COUNT(*) AS Total_No_Of_Items
FROM [Grocery Data];

-- 5. Operational Volume: Total Items Tracked for 2022 Cohort
SELECT COUNT(*) AS No_Of_Items_2022
FROM [Grocery Data]
WHERE Outlet_Establishment_Year = 2022;

-- 6. Customer Satisfaction: Average Overall Product Rating
SELECT CAST(AVG(Rating) AS DECIMAL(10,1)) AS Avg_Rating
FROM [Grocery Data];


-- =====================================================================
-- PHASE 3: GRANULAR SEGMENTATION & DEEP-DIVES
-- =====================================================================

-- A. Performance Metrics broken down by Fat Content Segment
SELECT Item_Fat_Content, 
    CONCAT(CAST(SUM(Total_Sales)/1000.0 AS DECIMAL(10,0)), 'K') AS Total_Sales_Thousands,
    CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
    COUNT(*) AS No_Of_Items, 
    CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM [Grocery Data]
GROUP BY Item_Fat_Content
ORDER BY Total_Sales_Thousands DESC;

-- B. Product Analysis: Top 5 Highest Performing Item Categories (FIXED SORT)
SELECT TOP 5 Item_Type,
    CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
    COUNT(*) AS No_Of_Items, 
    CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating    
FROM [Grocery Data]
GROUP BY Item_Type
ORDER BY Total_Sales DESC; -- Fixed from ASC to capture true top performers

-- C. Subquery & PIVOT: Sales Matrix by Region Tier and Fat Type
SELECT Outlet_Location_Type, 
       ISNULL([Low Fat], 0) AS Low_Fat, 
       ISNULL([Regular], 0) AS Regular
FROM 
(
    SELECT Outlet_Location_Type, Item_Fat_Content, 
           CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM [Grocery Data]
    GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT 
(
    SUM(Total_Sales) 
    FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;

-- D. Timeline Matrix: Performance Trend by Outlet Launch Year
SELECT Outlet_Establishment_Year,
    CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
    COUNT(*) AS No_Of_Items, 
    CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM [Grocery Data]
GROUP BY Outlet_Establishment_Year
ORDER BY Total_Sales DESC;


-- =====================================================================
-- PHASE 4: ADVANCED WINDOW FUNCTION CONTRIBUTION ANALYSIS
-- =====================================================================

-- I. Revenue Share Matrix by Physical Store Layout Size
SELECT 
    Outlet_Size, 
    CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM [Grocery Data]
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;

-- II. Market Contribution Metrics by Regional Geographic Tiers
SELECT Outlet_Location_Type,
    CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage,
    CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
    COUNT(*) AS No_Of_Items, 
    CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM [Grocery Data]
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC;

-- III. Complete Competitive Landscape Breakdown by Operational Business Layout
SELECT Outlet_Type, 
    CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS Avg_Sales,
    CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage,
    COUNT(*) AS No_Of_Items,
    CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating,
    CAST(AVG(Item_Visibility) AS DECIMAL(10,2)) AS Item_Visibility
FROM [Grocery Data]
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC;
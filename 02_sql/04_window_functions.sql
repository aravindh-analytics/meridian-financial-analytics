-- ============================================================
-- SCRIPT 04: Window Functions — YTD, MoM Growth, Rolling Avg
-- Project:   Meridian Retail Group — Financial Analytics
-- Author:    Aravindh R
-- Purpose:   Time-intelligence metrics using SQL window functions:
--            YTD cumulative revenue, MoM growth %, 3-month avg
-- Output:    180 rows (5 departments × 36 months)
-- Powers:    Page 5 — Revenue Momentum (Power BI)
-- Audience:  Sales Leadership, Strategy Team
-- ============================================================

USE meridian_financials;

-- Step 1: Monthly revenue and cost per department (base aggregation)
WITH Monthly_Dept AS (
    SELECT
        d.year,
        d.month_num,
        d.month_name,
        d.quarter,
        dep.dept_name,
        SUM(f.revenue)               AS Monthly_Revenue,
        SUM(f.cost)                  AS Monthly_Cost,
        SUM(f.revenue) - SUM(f.cost) AS Monthly_Gross_Profit

    FROM financials   f
    JOIN `date`       d   ON f.date_id     = d.date_id
    JOIN scenario     s   ON f.scenario_id = s.scenario_id
    JOIN departments  dep ON f.dept_id     = dep.dept_id

    WHERE s.scenario_name = 'Actual'

    GROUP BY
        d.year,
        d.month_num,
        d.month_name,
        d.quarter,
        dep.dept_name
)

-- Step 2: Apply window functions on top of the base aggregation
SELECT
    Year,
    Month_Num,
    Month_Name,
    Quarter,
    Dept_Name,
    Monthly_Revenue,
    Monthly_Cost,
    Monthly_Gross_Profit,

    -- YTD Revenue: cumulative sum reset every January per department
    SUM(Monthly_Revenue) OVER (
        PARTITION BY Year, Dept_Name   -- resets per year AND per dept
        ORDER BY Month_Num
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    )                                                       AS YTD_Revenue,

    -- Prior month revenue (for MoM calculation)
    -- PARTITION BY Dept prevents Dec of Sales bleeding into Jan of IT
    LAG(Monthly_Revenue, 1) OVER (
        PARTITION BY Dept_Name
        ORDER BY Year, Month_Num
    )                                                       AS Prev_Month_Revenue,

    -- MoM Growth %: how much did revenue change vs last month
    -- Returns NULL for January (no prior month — correct behaviour)
    ROUND(
        (
            Monthly_Revenue
            - LAG(Monthly_Revenue, 1) OVER (
                PARTITION BY Dept_Name
                ORDER BY Year, Month_Num
            )
        ) * 100
        / NULLIF(
            LAG(Monthly_Revenue, 1) OVER (
                PARTITION BY Dept_Name
                ORDER BY Year, Month_Num
            )
        , 0)
    , 2)                                                    AS MoM_Growth_Pct,

    -- 3-Month Rolling Average: smooths seasonal spikes
    -- PARTITION BY Dept prevents cross-department averaging
    ROUND(
        AVG(Monthly_Revenue) OVER (
            PARTITION BY Dept_Name
            ORDER BY Year, Month_Num
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        )
    , 0)                                                    AS Three_Month_Avg_Revenue

FROM Monthly_Dept
ORDER BY
    Dept_Name   ASC,
    Year        ASC,
    Month_Num   ASC;

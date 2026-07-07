-- ============================================================
-- SCRIPT 02: Budget vs Actual Variance Analysis
-- Project:   Meridian Retail Group — Financial Analytics
-- Author:    Aravindh R
-- Purpose:   Compare actual revenue/cost vs budget targets
--            at department-month granularity
-- Output:    180 rows (5 depts × 36 months)
-- Powers:    Page 2 — Budget vs Actual
--            Page 4 — Revenue Intelligence (Power BI)
-- Audience:  CFO, Finance Manager, Department Heads
-- ============================================================

USE meridian_financials;

-- Step 1: Aggregate Actual and Budget side-by-side using CASE WHEN pivot
WITH Actual_V_Budget AS (
    SELECT
        da.year,
        da.quarter,
        da.month_name,
        da.month_num,
        d.dept_name,

        -- Actual figures
        SUM(CASE WHEN s.scenario_name = 'Actual' THEN f.revenue ELSE 0 END)
                                                            AS Actual_Revenue,
        SUM(CASE WHEN s.scenario_name = 'Budget' THEN f.revenue ELSE 0 END)
                                                            AS Budget_Revenue,
        SUM(CASE WHEN s.scenario_name = 'Actual' THEN f.cost    ELSE 0 END)
                                                            AS Actual_Cost,
        SUM(CASE WHEN s.scenario_name = 'Budget' THEN f.cost    ELSE 0 END)
                                                            AS Budget_Cost

    FROM financials  f
    JOIN scenario    s  ON f.scenario_id = s.scenario_id
    JOIN departments d  ON f.dept_id     = d.dept_id
    JOIN `date`      da ON f.date_id     = da.date_id

    GROUP BY
        d.dept_name,
        da.year,
        da.quarter,
        da.month_name,
        da.month_num
)

-- Step 2: Calculate variance metrics from the pivoted CTE
SELECT
    Year,
    Quarter,
    Month_Name,
    Month_Num,
    Dept_Name,

    -- Raw values (needed for Actual vs Budget bar charts in Power BI)
    Actual_Revenue,
    Budget_Revenue,
    Actual_Cost,
    Budget_Cost,

    -- Revenue Variance: positive = beat budget, negative = missed
    (Actual_Revenue - Budget_Revenue)                       AS Rev_Variance,

    -- Variance %: ALWAYS divide by Budget (the plan), not Actual
    ROUND(
        (Actual_Revenue - Budget_Revenue) * 100
        / NULLIF(Budget_Revenue, 0)
    , 2)                                                    AS Rev_Var_Pct,

    -- Cost Variance: positive = overspent vs budget (bad)
    (Actual_Cost - Budget_Cost)                             AS Cost_Variance,

    -- Cost Variance %: divide by Budget Cost (the approved amount)
    ROUND(
        (Actual_Cost - Budget_Cost) * 100
        / NULLIF(Budget_Cost, 0)
    , 2)                                                    AS Cost_Var_Pct

FROM Actual_V_Budget
ORDER BY
    Dept_Name   ASC,
    Year        ASC,
    Month_Num   ASC;

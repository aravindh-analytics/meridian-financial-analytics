-- ============================================================
-- SCRIPT 03: Department Profitability Analysis
-- Project:   Meridian Retail Group — Financial Analytics
-- Author:    Aravindh R
-- Purpose:   Gross profit, margin %, cost efficiency ratio,
--            and annual profit ranking per department
-- Output:    15 rows (5 departments × 3 years)
-- Powers:    Page 6 — Profitability Rank (Power BI)
-- Audience:  Executive Team, Department Heads
-- ============================================================

USE meridian_financials;

-- Step 1: Aggregate revenue and cost per department per year
WITH Rev_Cost_Table AS (
    SELECT
        de.year,
        d.dept_name,
        d.cost_centre_flag,
        SUM(f.revenue)  AS Revenue,
        SUM(f.cost)     AS Cost

    FROM departments  d
    JOIN financials   f  ON f.dept_id     = d.dept_id
    JOIN `date`       de ON f.date_id     = de.date_id
    JOIN scenario     s  ON f.scenario_id = s.scenario_id

    WHERE s.scenario_name = 'Actual'

    GROUP BY
        de.year,
        d.dept_name,
        d.cost_centre_flag
)

-- Step 2: Calculate profitability metrics and ranking
SELECT
    Year,
    Dept_Name,
    Cost_Centre_Flag,
    Revenue,
    Cost,

    -- Gross Profit
    Revenue - Cost                                          AS Gross_Profit,

    -- Gross Margin % — NOTE: parentheses are CRITICAL here
    -- Without them: Revenue - (Cost * 100 / Revenue) = wrong result
    -- With them: (Revenue - Cost) * 100 / Revenue = correct margin
    ROUND(
        (Revenue - Cost) * 100
        / NULLIF(Revenue, 0)
    , 2)                                                    AS Gross_Margin_Pct,

    -- Cost Efficiency: how many rupees spent per rupee earned
    -- Lower is better: Sales ~0.63 vs HR ~0.95
    ROUND(
        Cost / NULLIF(Revenue, 0)
    , 4)                                                    AS Cost_To_Revenue_Ratio,

    -- Annual profit ranking: Rank 1 = most profitable department
    RANK() OVER (
        PARTITION BY Year
        ORDER BY (Revenue - Cost) DESC
    )                                                       AS Profit_Rank

FROM Rev_Cost_Table
ORDER BY
    Year        ASC,
    Profit_Rank ASC;

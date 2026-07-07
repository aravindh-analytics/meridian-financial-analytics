-- ============================================================
-- SCRIPT 06: Executive Summary — Annual Headline KPIs
-- Project:   Meridian Retail Group — Financial Analytics
-- Author:    Aravindh R
-- Purpose:   Single annual KPI row per year for board-level
--            reporting — Revenue, Cost, Profit, Margin, Variance
-- Output:    3 rows (one per fiscal year — fastest-loading table)
-- Powers:    Page 2 — Budget vs Actual KPI cards (Power BI)
-- Audience:  CEO, CFO, Board of Directors
-- ============================================================

USE meridian_financials;

-- Step 1: Aggregate Actual and Budget revenue/cost by year
WITH Executive_KPI AS (
    SELECT
        d.year,

        SUM(CASE WHEN s.scenario_name = 'Actual' THEN f.revenue ELSE 0 END)
                                                            AS Actual_Revenue,
        SUM(CASE WHEN s.scenario_name = 'Budget' THEN f.revenue ELSE 0 END)
                                                            AS Budget_Revenue,
        SUM(CASE WHEN s.scenario_name = 'Actual' THEN f.cost    ELSE 0 END)
                                                            AS Actual_Cost

    FROM financials  f
    JOIN `date`      d ON f.date_id     = d.date_id
    JOIN scenario    s ON s.scenario_id = f.scenario_id

    GROUP BY d.year
)

-- Step 2: Calculate all executive-level KPIs
SELECT
    Year,
    Actual_Revenue,
    Budget_Revenue,
    Actual_Cost,

    -- Gross Profit
    Actual_Revenue - Actual_Cost                            AS Gross_Profit,

    -- Revenue Variance: how much did we miss/beat the plan?
    Actual_Revenue - Budget_Revenue                         AS Revenue_Variance,

    -- Revenue Variance %: divide by Budget (the target, not actual)
    ROUND(
        (Actual_Revenue - Budget_Revenue) * 100
        / NULLIF(Budget_Revenue, 0)
    , 2)                                                    AS Revenue_Var_Pct,

    -- Budget Achievement %: what % of our plan did we achieve?
    -- Industry standard metric for plan attainment reporting
    ROUND(
        Actual_Revenue * 100
        / NULLIF(Budget_Revenue, 0)
    , 2)                                                    AS Budget_Achievement_Pct,

    -- Net Margin %: core profitability efficiency metric
    ROUND(
        (Actual_Revenue - Actual_Cost) * 100
        / NULLIF(Actual_Revenue, 0)
    , 2)                                                    AS Net_Margin_Pct

FROM Executive_KPI
ORDER BY Year ASC;

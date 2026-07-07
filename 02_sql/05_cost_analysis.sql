-- ============================================================
-- SCRIPT 05: Cost Overrun Analysis
-- Project:   Meridian Retail Group — Financial Analytics
-- Author:    Aravindh R
-- Purpose:   Identify departments exceeding cost budgets
--            with absolute overrun and % overrun by year
-- Output:    15 rows (5 departments × 3 years)
-- Powers:    Page 3 — Cost Intelligence (Power BI)
-- Audience:  CFO, Operations Head, Finance Manager
-- ============================================================

USE meridian_financials;

-- Step 1: Aggregate Actual and Budget costs side-by-side
WITH Budget_Actual_Cost AS (
    SELECT
        d.year,
        de.dept_name,

        SUM(CASE WHEN s.scenario_name = 'Actual' THEN f.cost ELSE 0 END)
                                                            AS Actual_Cost,
        SUM(CASE WHEN s.scenario_name = 'Budget' THEN f.cost ELSE 0 END)
                                                            AS Budget_Cost

    FROM financials   f
    JOIN `date`       d  ON f.date_id     = d.date_id
    JOIN scenario     s  ON f.scenario_id = s.scenario_id
    JOIN departments  de ON f.dept_id     = de.dept_id

    GROUP BY
        d.year,
        de.dept_name
)

-- Step 2: Calculate cost overrun metrics and status flag
SELECT
    Year,
    Dept_Name,
    Actual_Cost,
    Budget_Cost,

    -- Cost Overrun amount: positive = overspent vs budget
    Actual_Cost - Budget_Cost                               AS Cost_Outrun,

    -- Cost Overrun %: divide by BUDGET (the plan) not Actual
    -- This answers: "by what % did we exceed our approved budget?"
    ROUND(
        (Actual_Cost - Budget_Cost) * 100
        / NULLIF(Budget_Cost, 0)
    , 2)                                                    AS Cost_Outrun_Pct,

    -- Budget Status flag: drives conditional formatting in Power BI
    CASE
        WHEN Actual_Cost > Budget_Cost THEN 'Over Budget'
        WHEN Actual_Cost = Budget_Cost THEN 'On Budget'
        ELSE 'Under Budget'
    END                                                     AS Cost_Category

FROM Budget_Actual_Cost
ORDER BY
    Year            ASC,
    Cost_Outrun_Pct DESC;   -- Worst offenders appear first

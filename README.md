# Meridian Retail Group — Financial Performance Analytics Platform

> End-to-end analytics solution: MySQL → Power Query → Power BI  
> 3-year P&L analysis · 5 departments · 6 SQL scripts · 6-page dashboard

---

## Project Overview

Designed and delivered a complete financial analytics platform for a 
mid-sized retail company. The CFO lacked a single source of truth for 
revenue performance, budget tracking, and departmental profitability — 
data lived across three disconnected spreadsheets with no version control.

**Solution:** Designed a MySQL star schema, built 6 analytical SQL scripts 
using CTEs and window functions, built an ETL pipeline in Power Query, and 
delivered a 6-page interactive Power BI dashboard serving the CEO, CFO, 
and 5 department heads.

---

## Business Problem

The CFO's exact complaint:
> "I have revenue data in one file, costs in another, and budgets in a 
> third spreadsheet. I don't know if we're on track, which department is 
> overspending, or what our real profit margin is."

**5 specific pain points this project resolved:**
- No single source of truth → 6-page dashboard, one platform
- No budget variance visibility → Page 2 & 4, monthly + annual
- No profitability ranking → Page 6, department scorecard
- No time-intelligence → YTD, MoM growth, 3-month rolling average
- Cost overrun blindness → Page 3, real-time cost intelligence

---

## Tools & Technologies

| Tool | Purpose |
|------|---------|
| MySQL | Star schema database, 6 analytical SQL scripts |
| Power Query | ETL pipeline, data cleaning, type validation |
| Power BI Desktop | 12+ DAX measures, 6-page interactive dashboard |

---

## Data Architecture

**Star Schema:** 1 fact table + 3 dimension tables  
**Fact Table:** `fact_financials` — 360 rows (5 depts × 36 months × 2 scenarios)  
**Dimensions:** `dim_date`, `dim_department`, `dim_scenario`

---

## SQL Scripts

| Script | Business Question | Output |
|--------|-----------------|--------|
| 01_revenue_trends | How has revenue moved across 3 years? | 36 rows |
| 02_budget_variance | Which departments missed their targets? | 180 rows |
| 03_dept_profitability | Which departments are most profitable? | 15 rows |
| 04_window_functions | What is YTD and MoM growth? | 180 rows |
| 05_cost_analysis | Which departments overspent their budgets? | 15 rows |
| 06_executive_summary | Annual headline KPIs for the board | 3 rows |

---

## Dashboard Pages

| Page | Table | Audience | Story |
|------|-------|----------|-------|
| Revenue Overview | Revenue Trends | CEO/Board | 3-year growth trajectory |
| Budget vs Actual | Executive Summary | CFO | Annual variance analysis |
| Cost Intelligence | Cost Analysis | Operations | Department cost overruns |
| Revenue Intelligence | Budget Variance | Finance Manager | Monthly variance drill-down |
| Revenue Momentum | Monthly KPIs | Sales Leadership | MoM growth velocity |
| Profitability Rank | Dept Profitability | Executive Team | Annual ranking scorecard |

---

## Key Business Findings

1. **Revenue growth is decelerating** — 3.9% YoY in FY2022→23 slowing 
   to 2.8% in FY2023→24. Cost growth (4.1% CAGR) is outpacing revenue.

2. **Seasonal budget misalignment confirmed** — January–March miss budget 
   by 3–5% every year. October–December consistently beat targets by 1–2%. 
   Pattern repeats identically across all 3 fiscal years.

3. **Marketing requires immediate ROI review** — $6.15M cumulative cost 
   overrun over 3 years with simultaneous revenue underperformance. Only 
   department where both revenue AND cost performance fail simultaneously.

---

## How to Use This Project

1. Clone the repo or download the zip
2. Import CSV files in `/01_data/` into MySQL using the star schema
3. Run SQL scripts in `/02_sql/` in numbered order
4. Open `/04_dashboard/meridian_dashboard.pbix` in Power BI Desktop
5. Full documentation in `/05_documentation/`

---

## Connect

LinkedIn: https://shorturl.at/Os6HR 
Email: aravindh.r0601@gmail.com

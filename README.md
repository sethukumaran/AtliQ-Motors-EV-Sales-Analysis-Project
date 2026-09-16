# AtliQ-Motors-EV-Sales-Analysis-Project

## Project Overview
AtliQ Motors is an automotive company from the USA specializing in electric vehicles (EVs). The company has achieved a strong market position in North America and plans to expand its EV and hybrid vehicle business into India.  However, AtliQ Motors currently has a limited presence in the Indian market.

Before launching its bestselling models in India, the company wants to understand the existing electric vehicle market, customer adoption patterns, manufacturer performance, state-level demand, market penetration, growth opportunities, and infrastructure-related factors.

This project was completed from the perspective of a Data Analyst supporting the AtliQ Motors India expansion strategy.

The analysis uses:

- SQL for advanced business analysis.
- Python for exploratory data analysis and visualisation.
- EV sales data by manufacturers and states.
- Fiscal-year and quarterly trend analysis.
- EV penetration and growth calculations.
- Revenue estimation using assumed average vehicle prices.

The original business case asks the analytics team to study the Indian EV market and provide insights that can support strategic expansion decisions. :contentReference[oaicite:1]{index=1}

---

# Business Problem

AtliQ Motors wants to enter the Indian EV market but requires a detailed market assessment before making investment and expansion decisions.

The primary business questions include:

1. Which EV manufacturers dominate the 2-wheeler market?
2. Which states have the highest EV penetration rates?
3. Which states have experienced declining EV penetration?
4. How have the leading 4-wheeler manufacturers performed over time?
5. How does Delhi compare with Karnataka in EV adoption?
6. Which manufacturers have achieved the highest growth between FY2022 and FY2024?
7. Which states have the fastest growth in total vehicle sales?
8. Which months represent peak and low EV sales seasons?
9. What could EV sales look like by 2030 under a CAGR-based projection?
10. What is the estimated EV revenue growth between different fiscal years?

The project also considers secondary business questions related to customer adoption, government incentives, charging infrastructure, manufacturing location, brand positioning, and strategic recommendations. :contentReference[oaicite:2]{index=2}

---

# Project Objectives

The main objectives of this project are:

- Analyse electric vehicle sales trends in India.
- Identify leading and underperforming EV manufacturers.
- Measure EV penetration across Indian states.
- Compare 2-wheeler and 4-wheeler market performance.
- Calculate year-over-year growth and CAGR.
- Identify seasonal patterns in EV sales.
- Evaluate state-level market opportunities.
- Estimate future EV sales using historical CAGR.
- Estimate potential revenue growth using assumed average selling prices.
- Generate actionable business insights for AtliQ Motors.

---

# Dataset Description

The project uses three main datasets.

## 1. Date Dimension

File used:

`dim_date.csv`

Important columns:

| Column | Description |
|---|---|
| date | Transaction or reporting date |
| fiscal_year | Financial year associated with the date |
| quarter | Financial quarter |

The date dimension is used to connect daily EV sales records with fiscal years and quarters.

---

## 2. EV Sales by Manufacturer

File used:

`electric_vehicle_sales_by_makers.csv`

Important columns:

| Column | Description |
|---|---|
| date | Sales reporting date |
| vehicle_category | 2-Wheelers or 4-Wheelers |
| maker | EV manufacturer |
| electric_vehicles_sold | Number of EVs sold |

This dataset is used to analyse manufacturer performance, market leaders, quarterly trends, CAGR, and revenue estimates.

---

## 3. EV Sales by State

File used:

`electric_vehicle_sales_by_state.csv`

Important columns:

| Column | Description |
|---|---|
| date | Sales reporting date |
| state | Indian state |
| vehicle_category | 2-Wheelers or 4-Wheelers |
| electric_vehicles_sold | EV units sold |
| total_vehicles_sold | Total vehicle units sold |

This dataset is used to calculate EV penetration, state growth, state comparisons, seasonal trends, and future sales projections.

---

# Tools and Technologies Used

## SQL
- SQL Server / MSSQL-compatible analytical concepts
- Aggregation functions
- Common Table Expressions (CTEs)
- Window Functions
- `RANK()`
- `DENSE_RANK()`
- `PARTITION BY`
- Conditional Aggregation
- `CASE WHEN`
- `GROUP BY`
- `HAVING`
- `JOIN`
- Date Functions
- CAGR Calculations
- Market Penetration Analysis
- Revenue Estimation

## Python
- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- Jupyter Notebook

## Data Preparation and Cleaning

Before beginning the analysis, the datasets were loaded into Python using Pandas.
The following preparation steps were performed:

Imported the required libraries.
Loaded the date, manufacturer, and state datasets.
Converted date columns into proper datetime format.
Merged fiscal year and quarter information into the manufacturer and state fact tables.
Performed sanity checks on the imported data.
Verified fiscal-year coverage.
Checked vehicle categories and manufacturer names.
Prepared the datasets for SQL and Python analysis.

## Advanced SQL & Python Analysis

The SQL analysis file contains queries designed to answer the business questions using advanced SQL techniques.

1. List the top 3 and bottom 3 makers for the fiscal years 2023 and 2024 in terms of the number of 2-wheelers sold.
2. Identify the top 5 states with the highest penetration rate in 2-wheeler and 4-wheeler EV sales in FY 2024.
3. List the states with negative penetration (decline) in EV sales from 2022 to 2024?
4. What are the quarterly trends based on sales volume for the top 5 EV makers (4-wheelers) from 2022 to 2024?
5. How do the EV sales and penetration rates in Delhi compare to Karnataka for 2024?
6. List down the compounded annual growth rate (CAGR) in 4-wheeler units for the top 5 makers from 2022 to 2024.
7. List down the top 10 states that had the highest compounded annual growth rate (CAGR) from 2022 to 2024 in total vehicles sold.
8. What are the peak and low season months for EV sales based on the data from 2022 to 2024?
9. What is the projected number of EV sales (including 2-wheelers and 4-wheelers) for the top 10 states by penetration rate in 2030, based on the compounded annual growth rate (CAGR) from previous years?
10. Estimate the revenue growth rate of 4-wheeler and 2-wheelers EVs in India for 2022 vs 2024 and 2023 vs 2024, assuming an average unit price.
11. What are the primary reasons for customers choosing 4-wheeler EVs in 2023 and 2024 (cost savings, environmental concerns, government incentives)?
12. How do government incentives and subsidies impact the adoption rates of 2-wheelers and 4-wheelers? Which states in India provided most subsidies?
13. How does the availability of charging stations infrastructure correlate with the EV sales and penetration rates in the top 5 states?
codebasics.io
14. Who should be the brand ambassador if AtliQ Motors launches their EV/Hybrid vehicles in India and why?
15. Which state of India is ideal to start the manufacturing unit? (Based on subsidies provided, ease of doing business, stability in governance etc.)
16. Your top 3 recommendations for AtliQ Motors.

## Exploratory Data Analysis Objectives

The Python analysis focuses on:
- Understanding the overall structure of EV sales.
- Comparing 2-wheeler and 4-wheeler sales.
- Analysing manufacturer performance.
- Understanding state-level EV penetration.
- Identifying quarterly and seasonal trends.
- Comparing growth rates.
- Detecting high-potential markets.
- Supporting business recommendations through visual storytelling.

## Business Insight
The results can support:
- Seasonal marketing.
- Production planning.
- Dealer inventory management.
- Promotional campaigns.

## Limitations of the Analysis

The following limitations should be considered before using the findings for investment decisions.
- The analysis is based on historical sales data.
- Historical growth does not guarantee future growth.
- CAGR-based projections assume consistent future growth.
- Revenue estimates use assumed average vehicle prices.
- The analysis does not include detailed profitability or cost structures.
- Customer-level demographic and behavioural information is not available.
- Charging infrastructure data is not included in the primary dataset.
- Government incentive information requires separate external research.
- Sales data alone cannot establish causation.
- State-level performance may vary because of policy, infrastructure, income, and population differences.

## Secondary Research Opportunities

The project identifies several areas where additional research can improve strategic recommendations.
Customer Adoption Drivers
Study why customers purchase EVs:
- Fuel-cost savings.
- Environmental concerns.
- Government subsidies.
- Lower maintenance costs.
- Technology features.
- Brand reputation.
- Charging convenience.
- 
## Conclusion

This project demonstrates how advanced SQL and Python can be combined to transform raw electric vehicle sales data into meaningful business intelligence.
Through manufacturer analysis, state-level penetration studies, CAGR calculations, quarterly trends, seasonality analysis, and revenue estimation, the project provides a comprehensive understanding of the Indian EV market.
The analysis establishes a strong foundation for AtliQ Motors to evaluate market opportunities and plan its expansion strategy in India. However, historical sales data should be combined with external research on government incentives, charging infrastructure, customer behaviour, manufacturing costs, and competitive conditions before making final business decisions.Overall, the project showcases an end-to-end analytics approach that connects technical data analysis with real-world business strategy and decision-making.

create database ev_sales_analytics
use ev_sales_analytics

CREATE TABLE dim_date (
    date DATE,
    fiscal_year INT,
    quarter VARCHAR(5)
);

CREATE TABLE ev_makers (
    date DATE,
    vehicle_category VARCHAR(20),
    maker VARCHAR(100),
    electric_vehicles_sold INT
);

CREATE TABLE ev_states (
    date DATE,
    state VARCHAR(100),
    vehicle_category VARCHAR(20),
    electric_vehicles_sold INT,
    total_vehicles_sold INT
);

select * from dbo.dim_date
select * from dbo.electric_vehicle_sales_by_makers
select * from electric_vehicle_sales_by_state

### Q1. Top 3 and Bottom 3 makers for FY 2023 and FY 2024 (2-Wheelers sold)

-- Top 3
SELECT d.fiscal_year, m.maker,
       SUM(m.electric_vehicles_sold) AS units_sold
FROM ev_makers m
JOIN dim_date d ON m.date = d.date
WHERE m.vehicle_category = '2-Wheelers'
  AND d.fiscal_year IN (2023, 2024)
GROUP BY d.fiscal_year, m.maker
ORDER BY d.fiscal_year, units_sold DESC;

-- To get TOP 3 per year use a window function
WITH ranked AS (
    SELECT d.fiscal_year, m.maker,
           SUM(m.electric_vehicles_sold) AS units_sold,
           RANK() OVER (PARTITION BY d.fiscal_year
                        ORDER BY SUM(m.electric_vehicles_sold) DESC) AS rnk
    FROM ev_makers m
    JOIN dim_date d ON m.date = d.date
    WHERE m.vehicle_category = '2-Wheelers'
      AND d.fiscal_year IN (2023, 2024)
    GROUP BY d.fiscal_year, m.maker
)
SELECT * FROM ranked WHERE rnk <= 3;

-- Bottom 3 (change ORDER BY to ASC)
WITH ranked AS (
    SELECT d.fiscal_year, m.maker,
           SUM(m.electric_vehicles_sold) AS units_sold,
           RANK() OVER (PARTITION BY d.fiscal_year
                        ORDER BY SUM(m.electric_vehicles_sold) ASC) AS rnk
    FROM ev_makers m
    JOIN dim_date d ON m.date = d.date
    WHERE m.vehicle_category = '2-Wheelers'
      AND d.fiscal_year IN (2023, 2024)
    GROUP BY d.fiscal_year, m.maker
)
SELECT * FROM ranked WHERE rnk <= 3;

---Q2. Top 5 states by penetration rate (2W & 4W) in FY 2024

SELECT state, vehicle_category,
       ROUND(SUM(electric_vehicles_sold) * 100.0 /
             NULLIF(SUM(total_vehicles_sold),0), 2) AS penetration_pct
FROM ev_states s
JOIN dim_date d ON s.date = d.date
WHERE d.fiscal_year = 2024
GROUP BY state, vehicle_category
ORDER BY vehicle_category, penetration_pct DESC;

-- Q3. States with negative penetration / decline from 2022 → 2024

WITH pen AS (
    SELECT s.state, d.fiscal_year,
           SUM(s.electric_vehicles_sold) * 100.0 /
           NULLIF(SUM(s.total_vehicles_sold),0) AS pen_pct
    FROM ev_states s
    JOIN dim_date d ON s.date = d.date
    GROUP BY s.state, d.fiscal_year
),
p AS (
    SELECT state,
           MAX(CASE WHEN fiscal_year=2022 THEN pen_pct END) AS fy22,
           MAX(CASE WHEN fiscal_year=2024 THEN pen_pct END) AS fy24
    FROM pen GROUP BY state
)
SELECT state, fy22, fy24
FROM p
WHERE fy24 < fy22;

-- Q4. Quarterly trends – Top 5 EV makers (4-Wheelers), 2022-2024

WITH top5 AS (
    SELECT maker
    FROM ev_makers m
    JOIN dim_date d ON m.date = d.date
    WHERE m.vehicle_category='4-Wheelers'
      AND d.fiscal_year BETWEEN 2022 AND 2024
    GROUP BY maker
    ORDER BY SUM(electric_vehicles_sold) DESC
)
SELECT d.fiscal_year, d.quarter, m.maker,
       SUM(m.electric_vehicles_sold) AS units
FROM ev_makers m
JOIN dim_date d ON m.date = d.date
JOIN top5 t ON t.maker = m.maker
WHERE m.vehicle_category='4-Wheelers'
GROUP BY d.fiscal_year, d.quarter, m.maker
ORDER BY m.maker, d.fiscal_year, d.quarter;

-- Q5. Delhi vs Karnataka – EV Sales & Penetration (2024)
SELECT s.state, s.vehicle_category,
       SUM(s.electric_vehicles_sold) AS ev_sales,
       ROUND(SUM(s.electric_vehicles_sold)*100.0/
             NULLIF(SUM(s.total_vehicles_sold),0),2) AS pen_pct
FROM ev_states s
JOIN dim_date d ON s.date = d.date
WHERE d.fiscal_year=2024
  AND s.state IN ('Delhi','Karnataka')
GROUP BY s.state, s.vehicle_category;


-- Q6. CAGR of 4-Wheeler units – Top 5 makers (2022 → 2024)

WITH fy AS (
    SELECT m.maker,
           SUM(CASE WHEN d.fiscal_year=2022 THEN m.electric_vehicles_sold END) AS fy22,
           SUM(CASE WHEN d.fiscal_year=2024 THEN m.electric_vehicles_sold END) AS fy24
    FROM ev_makers m
    JOIN dim_date d ON m.date = d.date
    WHERE m.vehicle_category='4-Wheelers'
    GROUP BY m.maker
)
SELECT maker, fy22, fy24,
       ROUND((POWER(fy24/NULLIF(fy22,0), 0.5) - 1) * 100, 2) AS cagr_pct
FROM fy
WHERE fy22 > 0
ORDER BY fy24 DESC

-- Q7. Top 10 states by CAGR (Total vehicles sold, 2022 → 2024)

WITH fy AS (
    SELECT s.state,
           SUM(CASE WHEN d.fiscal_year=2022 THEN s.total_vehicles_sold END) AS fy22,
           SUM(CASE WHEN d.fiscal_year=2024 THEN s.total_vehicles_sold END) AS fy24
    FROM ev_states s
    JOIN dim_date d ON s.date = d.date
    GROUP BY s.state
)
SELECT state, fy22, fy24,
       ROUND((POWER(fy24/NULLIF(fy22,0), 0.5) - 1)*100, 2) AS cagr_pct
FROM fy
WHERE fy22 > 0
ORDER BY cagr_pct DESC

-- Q8. Peak & low season months for EV sales (2022 – 2024)

SELECT MONTHNAME(date) AS month_name,
       AVG(daily_total) AS avg_sales
FROM (
    SELECT date, SUM(electric_vehicles_sold) AS daily_total
    FROM ev_states
    WHERE date BETWEEN '2022-04-01' AND '2024-03-31'
    GROUP BY date
) t
GROUP BY MONTHNAME(date)
ORDER BY avg_sales DESC;


-- Q9. Projected EV sales for top 10 states by penetration in 2030

WITH pen AS (
    SELECT state, SUM(electric_vehicles_sold)*100.0/
           NULLIF(SUM(total_vehicles_sold),0) AS pen_pct
    FROM ev_states s JOIN dim_date d ON s.date = d.date
    WHERE d.fiscal_year = 2024
    GROUP BY state
),
top10 AS (
    SELECT state FROM pen ORDER BY pen_pct DESC LIMIT 10
),
ev AS (
    SELECT s.state,
           SUM(CASE WHEN d.fiscal_year=2022 THEN s.electric_vehicles_sold END) AS fy22,
           SUM(CASE WHEN d.fiscal_year=2024 THEN s.electric_vehicles_sold END) AS fy24
    FROM ev_states s
    JOIN dim_date d ON s.date=d.date
    JOIN top10 t ON t.state = s.state
    GROUP BY s.state
)
SELECT state, fy24,
       POWER(fy24/NULLIF(fy22,0), 0.5) - 1 AS cagr,
       ROUND(fy24 * POWER(POWER(fy24/NULLIF(fy22,0),0.5), 6)) AS projected_2030
FROM ev
WHERE fy22 > 0;


-- Q10. Revenue growth rate (2022 vs 2024, 2023 vs 2024)

WITH rev AS (
    SELECT m.vehicle_category, d.fiscal_year,
           SUM(m.electric_vehicles_sold) *
             CASE m.vehicle_category
               WHEN '2-Wheelers' THEN 85000
               WHEN '4-Wheelers' THEN 15000000 END AS revenue
    FROM ev_makers m
    JOIN dim_date d ON m.date = d.date
    GROUP BY m.vehicle_category, d.fiscal_year
)
SELECT vehicle_category,
       MAX(CASE WHEN fiscal_year=2022 THEN revenue END) AS rev_2022,
       MAX(CASE WHEN fiscal_year=2023 THEN revenue END) AS rev_2023,
       MAX(CASE WHEN fiscal_year=2024 THEN revenue END) AS rev_2024,
       ROUND((MAX(CASE WHEN fiscal_year=2024 THEN revenue END) /
              MAX(CASE WHEN fiscal_year=2022 THEN revenue END) - 1)*100,2)
              AS growth_22_24_pct,
       ROUND((MAX(CASE WHEN fiscal_year=2024 THEN revenue END) /
              MAX(CASE WHEN fiscal_year=2023 THEN revenue END) - 1)*100,2)
              AS growth_23_24_pct
FROM rev
GROUP BY vehicle_category;
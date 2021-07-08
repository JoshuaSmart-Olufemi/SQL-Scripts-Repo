WITH CTE AS (

SELECT DISTINCT (A) AS [Distinct Customers]
FROM
(
SELECT [start_date],[customer_id], 
SUM([monthly_amount]) OVER(PARTITION BY [customer_id])/ COUNT([customer_id]) OVER (PARTITION BY [customer_id]) AS A
FROM [dbo].[subscription_periods]
) AS TEMP
)
SELECT SUM([Distinct Customers]) AS ARPU FROM CTE
--------------------------------------------------------------
-- 4 YEARS
SELECT COUNT(DISTINCT(YEAR([start_date])))
FROM [dbo].[subscription_periods]

SELECT customer_id, COUNT(DISTINCT([customer_id]))
FROM [dbo].[subscription_periods] 
GROUP BY customer_id
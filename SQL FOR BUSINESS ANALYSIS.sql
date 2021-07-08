SELECT [BusinessEntityID],
[HireDate]
FROM [HumanResources].[Employee]
WHERE [HireDate] BETWEEN '2008/12/01' AND '2008/12/08' 
ORDER BY 2 ASC /* ORDER BY SECOND COLUMN*/

SELECT COUNT(1)
FROM [HumanResources].[Department]
SELECT *
FROM [HumanResources].[Department]

--DAILY HIRE COUNT OF EMPLOYEES HIRED--
SELECT [HireDate], 
COUNT(1) AS 'Number Hired On This Date'
FROM [HumanResources].[Employee]
GROUP BY [HireDate]
--HAVING COUNT(1) > 3
ORDER BY 1

--MONTHLY HIRE COUNT

SELECT MONTH([HireDate]) AS 'Hire Month', 
COUNT(1) AS 'Number Hired Per Month'
FROM [HumanResources].[Employee]
GROUP BY MONTH([HireDate])
ORDER BY 1


--YEARLY HIRE COUNT
SELECT YEAR([HireDate]) AS 'Hire Month', 
COUNT(1) AS 'Number Hired Per Year'
FROM [HumanResources].[Employee]
GROUP BY YEAR([HireDate])
ORDER BY 1


--MONTHLY ORDER COUNT
SELECT MONTH([OrderDate]) AS Month,
COUNT(1) AS 'Count of Orders Per Month'
FROM [Sales].[SalesOrderHeader] AS A
LEFT JOIN [Sales].[SalesOrderDetail] AS B
ON A.SalesOrderID = B.SalesOrderID
GROUP BY month([OrderDate])
ORDER BY 1


--MONTHLY ORDER COUNT WITH REVENUE PER MONTH

--First, instead of using count(1) to count the rows per date, we’ll use round(sum(amount_paid), 2) to add up the revenue per date. 
SELECT MONTH([OrderDate]) AS Month,
ROUND(SUM([LineTotal]),0) AS Revenue,
COUNT(1) AS 'Number of Orders Per Month'
FROM [Sales].[SalesOrderHeader] AS A
LEFT JOIN [Sales].[SalesOrderDetail] AS B
ON A.SalesOrderID = B.SalesOrderID
GROUP BY MONTH([OrderDate])
ORDER BY 1

--YEARLY ORDER COUNT WITH REVENUE PER YEAR
SELECT YEAR([OrderDate]) AS Year,
ROUND(SUM([LineTotal]),0) AS Revenue,
COUNT(1) AS 'Number of Orders Per Year'
FROM [Sales].[SalesOrderHeader] AS A
LEFT JOIN [Sales].[SalesOrderDetail] AS B
ON A.SalesOrderID = B.SalesOrderID
GROUP BY YEAR([OrderDate])
ORDER BY 1

--FIND OUT HOW MUCH YOU ARE MAKING monthLY FOR PRODUCT - 'blade'  BY USING THE where CLAUSE
SELECT MONTH([OrderDate]) AS Month,
ROUND(SUM([LineTotal]),0) AS Revenue,
COUNT(1) AS 'Number of Orders Per Month'
FROM [Sales].[SalesOrderHeader] AS A
LEFT JOIN [Sales].[SalesOrderDetail] AS B
ON A.SalesOrderID = B.SalesOrderID
LEFT JOIN [Production].[Product] AS C
ON B.ProductID = C.ProductID
WHERE [Name] = 'Adjustable Race'
GROUP BY MONTH([OrderDate])
ORDER BY 1

SELECT [Name]
FROM [Production].[Product]


-- Revenue Per Product From Highest To Lowest
SELECT[Name] as 'Product Name', 
ROUND(SUM([LineTotal]),0) AS 'Revenue Per Product'
FROM [Sales].[SalesOrderDetail] AS A
LEFT JOIN [Production].[Product] AS B
ON A.ProductID = B.ProductID
GROUP BY [Name]
ORDER BY 2 DESC

/*We have the sum of the the products by revenue, but we still need the percent. 
For that, we’ll need to get the total using a subquery. 
A subquery can perform complicated calculations and create filtered or aggregate tables on the fly.
Subqueries are useful when you want to perform an aggregation outside the context of the current query. 
This will let us calculate the overall total and per-item total at the same time.*/
SELECT [Name] AS 'Product Name',
ROUND(SUM([LineTotal])/ 
(SELECT SUM([LineTotal]) FROM [Sales].[SalesOrderDetail]) * 100.0, 2) AS '% of Revenue Per Product'
FROM [Sales].[SalesOrderDetail] AS A
LEFT JOIN [Production].[Product] AS B
ON A.ProductID = B.ProductID
GROUP BY [Name]
ORDER BY 2 DESC
--COMPARING HOW ONE CATEGORY IS DOING WITH RESPECT TO OTHERS %-WISE
select name,
  case, 
    when 'kale-smoothie'    then 'smoothie'
    when 'banana-smoothie'  then 'smoothie'
    when 'orange-juice'     then 'drink'
    when 'soda'             then 'drink'
    when 'blt'              then 'sandwich'
    when 'grilled-cheese'   then 'sandwich'
    when 'tikka-masala'     then 'dinner'
    when 'chicken-parm'     then 'dinner'
    else 'other'
  end as category, round(1.0 * sum(amount_paid) /
    (select sum(amount_paid) from order_items) * 100, 2) as pct
from order_items
group by 1
order by 2 desc;

SELECT C.[Name] AS 'Category Name',
ROUND(1.0* SUM([LineTotal]) / (SELECT SUM([LineTotal]) FROM [Sales].[SalesOrderDetail])*100,2) AS '% SHARE OF REVENUE PER CATEGORY'
     FROM [Sales].[SalesOrderDetail] AS A
LEFT JOIN [Production].[Product] AS B
ON A.ProductID = B.ProductID
LEFT JOIN [Production].[ProductCategory] AS C
ON B.[ProductSubcategoryID] = C.ProductCategoryID
--WHERE C.[Name] IS NOT NULL
GROUP BY C.[Name]
ORDER BY 2 DESC


-----------------
SELECT [Name], 
COUNT(1) AS 'Number Hired On This Date',
ROUND(SUM([LineTotal]),0)
FROM [Production].[Product] AS A
LEFT JOIN [Sales].[SalesOrderDetail] AS B
ON A.ProductID = B.ProductID
GROUP BY [Name]
ORDER BY 1

SELECT [Name],COUNT(DISTINCT(B.SalesOrderID)) 'Total Individual Customer Orders Per Product',
--COUNT(B.SalesOrderID),
[OrderQty]
FROM [Production].[Product] AS A
LEFT JOIN [Sales].[SalesOrderDetail] AS B
ON
A.[ProductID] = B.[ProductID]
GROUP BY [Name],[OrderQty]
ORDER BY 1,[OrderQty]

SELECT COUNT([OrderQty])
FROM [Sales].[SalesOrderDetail]
WHERE [SalesOrderID] = '43659'

SELECT [Country], COUNT(*)
FROM [dbo].[Customers]
GROUP BY [Country]

SELECT [Name] AS Country,COUNT(*) AS 'Sales Per Region'
FROM [Sales].[SalesOrderHeader] AS A
LEFT JOIN [Sales].[SalesTerritory] AS B
ON A.TerritoryID = B.TerritoryID
GROUP BY [Name]

SELECT[Name]  AS Country,COUNT([CustomerID]) 'Number of Customers Per Country'
FROM [Sales].[SalesOrderHeader] AS A
LEFT JOIN [Sales].[SalesTerritory] AS B
ON A.TerritoryID = B.TerritoryID
GROUP BY [Name]
ORDER BY 2 DESC


--country with the highest MAU per each calendar month, INCORRECT CALCULATIONS
SELECT DATENAME(MONTH,([OrderDate])) AS Month,
([Name]) AS Country,
--ROUND(SUM([LineTotal]),0) AS Revenue,
COUNT(DISTINCT([CustomerID])) AS 'Number of Customers Per Month'
FROM [Sales].[SalesOrderHeader] AS A
LEFT JOIN [Sales].[SalesOrderDetail] AS B
ON A.SalesOrderID = B.SalesOrderID
LEFT JOIN [Sales].[SalesTerritory] AS C
ON A.TerritoryID = C.TerritoryID
GROUP BY DATENAME(MONTH,([OrderDate])),[Name]
ORDER BY 3 DESC



--country with the highest MAU per each calendar month,
SELECT TOP (1) WITH TIES  DATENAME(MONTH,([OrderDate])) AS Month, 
[Group],
       COUNT(*) AS [Number of Customers Per Month]
FROM [Sales].[SalesOrderHeader] soh LEFT JOIN 
     [Sales].[SalesOrderDetail] sod
     ON soh.SalesOrderID = sod.SalesOrderID LEFT JOIN
     [Sales].[SalesTerritory] st
     ON soh.TerritoryID = st.TerritoryID
GROUP BY DATENAME(MONTH,([OrderDate])),[Group] 
ORDER BY ROW_NUMBER() OVER (PARTITION BY DATENAME(MONTH,([OrderDate])) ORDER BY COUNT(*) DESC);


SELECT *
FROM [Purchasing].[PurchaseOrderDetail]
WHERE [DueDate] IN (SELECT MIN([DueDate]) FROM [Purchasing].[PurchaseOrderDetail])

/*SELECT MIN([DueDate])
FROM [Purchasing].[PurchaseOrderDetail]*/

SELECT TOP 1 WITH TIES *
FROM [Purchasing].[PurchaseOrderDetail]
ORDER BY [DueDate] ASC  



SELECT TOP 1 WITH TIES MONTH([OrderDate]) AS Month,
[City],
COUNT(*) AS [Number of Customers Per Month]
FROM [dbo].[Customers] AS C
LEFT JOIN [dbo].[Orders] AS O
ON C.CustomerID = O.CustomerID
GROUP BY  MONTH([OrderDate]),[City]
ORDER BY ROW_NUMBER() OVER (PARTITION BY MONTH([OrderDate]) ORDER BY COUNT(*) DESC);

--SUB QUERY
SELECT [ShipCountry], 
AVG(Number_of_Orders) AS 'Number of Orders' FROM
   (SELECT [CustomerID],[ShipCountry],COUNT(*) AS Number_of_Orders
    FROM [dbo].[Orders]
    GROUP BY [CustomerID],[ShipCountry]) AS SUB
GROUP BY [ShipCountry]

-- Average Number of Orders Per Customer Per Country
SELECT [ShipCountry], 
AVG(Number_of_Orders) AS 'Number of Orders' FROM
   (SELECT [CustomerID],[ShipCountry],COUNT(*) AS Number_of_Orders
    FROM [dbo].[Orders]
    GROUP BY [CustomerID],[ShipCountry]) AS SUB
GROUP BY [ShipCountry]

--Produce a query that returns the country with the highest MAU per each calendar
--month, along with the average session duration of players from this country in that
--month.

SELECT TOP (1) WITH TIES  DATENAME(MONTH,([OrderDate])) AS Month, 
[Name] AS Country,
       COUNT(*) AS [Number of Customers Per Month],
	   DATEDIFF(MONTH,[OrderDate],[ShipDate]) AS 'No. of Months B/W Order & Ship Date'
FROM [Sales].[SalesOrderHeader] soh 
     LEFT JOIN 
     [Sales].[SalesOrderDetail] sod
     ON soh.SalesOrderID = sod.SalesOrderID LEFT JOIN
     [Sales].[SalesTerritory] st
     ON soh.TerritoryID = st.TerritoryID
GROUP BY DATENAME(MONTH,([OrderDate])),[Name],DATEDIFF(MONTH,[OrderDate],[ShipDate])
ORDER BY ROW_NUMBER() OVER (PARTITION BY DATENAME(MONTH,([OrderDate])) ORDER BY COUNT(*) DESC);

--What is the daily accumulative average revenue of Online Vs Reseller customers? (All
--users in their first 2 months since installation) 1 = online 0 = reseller
SELECT --TOP 2 WITH TIES
CONCAT(DAY([OrderDate]),' - ',DATENAME(MONTH,([OrderDate]))) AS Date, 
CASE
     WHEN [OnlineOrderFlag] = 0 THEN 'Reseller'
	 ELSE 'Online'
END AS [OnlineOrderFlag],
ROUND(SUM(LineTotal),0) AS 'Daily Acummulative Revenue'
FROM [Sales].[SalesOrderHeader] AS SOH
LEFT JOIN [Sales].[SalesOrderDetail] AS SOD
ON SOH.SalesOrderID = SOD.SalesOrderID
GROUP BY [OrderDate],[OnlineOrderFlag]
HAVING [OrderDate] BETWEEN [OrderDate] AND DATEADD(MONTH,2,[OrderDate])
ORDER BY [OrderDate],[OnlineOrderFlag] 

--Produce a retention cohort of the first 7 days of all players who started to play the
--game in the recent(PARTICULAR) month
SELECT COUNT( [CustomerID])'Number of Customers Per Day',
[OrderDate]
FROM [Sales].[SalesOrderHeader]
WHERE [OrderDate] BETWEEN '2013-07-01' AND DATEADD(DAY,7,'2013-07-01')
GROUP BY [OrderDate]
ORDER BY [OrderDate] ASC

--DATEPART(MONTH,[OrderDate]) = 7 AND DATENAME(YEAR,[OrderDate]) = 2013 AND [OrderDate] BETWEEN DAY,[OrderDate] AND DATEADD(DAY,7,[OrderDate])
































-- MONTHLY CUSTOMERS/USER COUNT PER REGION
SELECT count([SalesOrderID]),
COUNT(1),
[Name] AS Region
FROM [Sales].[SalesOrderHeader] AS A
LEFT JOIN [Sales].[SalesTerritory] AS B
ON A.TerritoryID = B.TerritoryID
GROUP BY ([SalesOrderID]),[Name]
ORDER BY 1


SELECT MONTH([OrderDate]) AS Month,
COUNT(1)
FROM [Sales].[SalesOrderHeader] AS A
LEFT JOIN [Sales].[SalesOrderDetail] AS B
ON A.SalesOrderID = B.SalesOrderID
GROUP BY month([OrderDate])
ORDER BY 1




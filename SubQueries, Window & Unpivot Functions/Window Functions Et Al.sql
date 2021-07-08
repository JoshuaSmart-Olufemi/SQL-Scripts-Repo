/* Window function to get the min subtotal & subtotal without agg functions*/
SELECT DISTINCT([CustomerID]),
[SubTotal],
MIN([SubTotal]) OVER(ORDER BY [CustomerID] DESC) AS [Minimum Subtotal]
FROM [Sales].[SalesOrderHeader]

/*Retrieving the number of Online & Reseller Sales Channel per country*/
SELECT SSOT.Name AS [Country],
  COUNT(CASE
           WHEN [OnlineOrderFlag] = 0 THEN 'Reseller Channel'
		END) AS [Count of Reseller Channel Outlets],

  COUNT(CASE
            WHEN [OnlineOrderFlag] = 1 THEN 'Online Channel'
		END) AS [Count of Online Channel Outlets]
FROM [Sales].[SalesOrderHeader] AS SSOH
LEFT JOIN [Sales].[SalesTerritory] AS SSOT
ON SSOH.TerritoryID = SSOT.TerritoryID
GROUP BY SSOT.Name
ORDER BY SSOT.Name

/*Retrieving the PERCENTAGE of Online & Reseller Sales Channel per country*/
/*The CASE statement can be used along with the AVG function to get the percentage of a set of values*/
SELECT SST.Name AS [Country],
AVG(CASE
          WHEN [OnlineOrderFlag] = 0 THEN 1
		  ELSE 0
	END)* 100 AS [Percentage of Reseller Channel Outlets],

AVG(CASE
          WHEN [OnlineOrderFlag] = 1 THEN 1
		  ELSE 0
	END)* 100 AS [Percentage of Online Channel Outlets]

FROM [Sales].[SalesOrderHeader] AS SSOH
LEFT JOIN [Sales].[SalesTerritory] AS SST
ON SSOH.TerritoryID = SST.TerritoryID
GROUP BY SST.Name

CONCAT_WS 













-----------
SELECT MAX([ListPrice]) OVER () AS [Most Expensive Product Price],
AVG([ListPrice]) OVER () AS [Average Product Price]
FROM[Production].[Product] 
 SELECT [OnlineOrderFlag]
 FROM [Sales].[SalesOrderHeader]

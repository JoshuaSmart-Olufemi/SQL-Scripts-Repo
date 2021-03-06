/*4)Calculate the average number of days between repeat purchases at customer level*/
SELECT [CustomerID], 
  AVG(CONVERT(decimal(7,2), DATEDIFF(DAY,PriorDate,[OrderDate]))) AS Avg_Time_BW_Purchases
FROM
    (
	SELECT [CustomerID],
	[OrderDate],
	LAG([OrderDate],1) OVER (PARTITION BY [CustomerID] ORDER BY [OrderDate]) AS PriorDate,
	[OrderQty],
	[LineTotal]
	FROM [Sales].[SalesOrderDetail] AS A
	LEFT JOIN [Sales].[SalesOrderHeader] AS B
	ON A.SalesOrderID = B.SalesOrderID
	 ) AS TempTable
GROUP BY [CustomerID],[OrderDate],PriorDate
ORDER BY Avg_Time_BW_Purchases DESC


/*Calculate the average number of days between repeat purchases at customer level*/
SELECT DISTINCT([CustomerID]), AVG([No. of Days Between Purchases]) OVER (PARTITION BY [CustomerID])
FROM(
SELECT [CustomerID],
	[OrderDate],
	CONVERT(DECIMAL(7,1), [OrderDate] - LAG([OrderDate],1) OVER (PARTITION BY [CustomerID] ORDER BY [OrderDate])) AS [No. of Days Between Purchases],
	[OrderQty],
	[LineTotal]
	FROM [Sales].[SalesOrderDetail] AS A
	LEFT JOIN [Sales].[SalesOrderHeader] AS B
	ON A.SalesOrderID = B.SalesOrderID) AS Table1
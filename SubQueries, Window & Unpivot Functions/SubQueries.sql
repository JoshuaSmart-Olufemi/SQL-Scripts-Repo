-------------------------------------------------------SUB-QUERY--------------------------------------------------------
--COMPARING THE AVERAGE REVENUE OF ONE CUSTOMER'S TRANSACTION TO ALL THEIR INDIVIDUAL TRANSACTIONS
SELECT [CustomerID],[LineTotal],
(SELECT
ROUND(AVG([LineTotal]),0) AS Average_Revenue
FROM [Sales].[SalesOrderDetail] AS A
LEFT JOIN [Sales].[SalesOrderHeader] AS B
ON A.SalesOrderID = B.SalesOrderID
WHERE [CustomerID] = 29825
GROUP BY [CustomerID]) AS Average_Revenue
FROM [Sales].[SalesOrderDetail] AS A
LEFT JOIN 
[Sales].[SalesOrderHeader] AS B
ON A.SalesOrderID = B.SalesOrderID
WHERE [CustomerID] = 29825
ORDER BY [CustomerID]

 SELECT [CustomerID],
 ROUND([LineTotal],0) AS [Revenue],
 ROUND(AVG([LineTotal]) OVER (),0) AS [Average Revenue]
 FROM [Sales].[SalesOrderDetail] AS A
 LEFT JOIN [Sales].[SalesOrderHeader] AS B
 ON A.SalesOrderID = B.SalesOrderID
 WHERE [CustomerID] = 29825

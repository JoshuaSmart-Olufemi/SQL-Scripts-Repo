SELECT [ProductID],
SUM([UnitPrice]) AS Sum_Of_Unit_Price
FROM [dbo].[Order Details]
GROUP BY [ProductID]
ORDER BY [ProductID]


SELECT [ProductID],
SUM([UnitPrice]) AS Sum_Of_Unit_Price
FROM [dbo].[Order Details]
GROUP BY ROLLUP ([ProductID])

SELECT[Country],[City],B.UnitPrice
FROM [dbo].[Suppliers] AS A
RIGHT JOIN [dbo].[Products] AS B
ON A.SupplierID = B.SupplierID
GROUP BY ROLLUP([Country],[City],B.UnitPrice)

SELECT [Group] AS Region,
[Name] AS Country,
ROUND(SUM([SalesLastYear]),0) As [Sales Last Year]
FROM [Sales].[SalesTerritory]
GROUP BY ROLLUP([Group],[Name])
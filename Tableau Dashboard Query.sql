SELECT A.OrderID,A.OrderDate,A.ShipCity,A.ShipCountry,D.CompanyName AS ShipCompany, 
DATEDIFF(DAY,A.ShippedDate, A.RequiredDate) AS [Delivery Time in Days],
B.UnitPrice*B.Quantity AS [Revenue],b.Quantity, C.ProductName,C.ProductID,
SUM(B.UnitPrice*B.Quantity) OVER(ORDER BY A.OrderDate rows between unbounded preceding and current row) as [Running Total of Profit],
E.CompanyName AS [Supplier Company], E.Country AS [Region Supplied]
FROM [Orders] AS A
LEFT JOIN [dbo].[Order Details] AS B
ON A.OrderID = B.OrderID
LEFT JOIN [dbo].[Products] AS C
ON B.ProductID = C.ProductID
LEFT JOIN [dbo].[Shippers] AS D
ON A.ShipVia = D.ShipperID 
LEFT JOIN [dbo].[Suppliers] AS E
ON C.SupplierID = E.SupplierID
-------------COUNT OF ORDERS, PROFIT SUM, SUm  OF QUANTITY, COUNT OF PRODUCTS, count of regions
SELECT *
FROM [dbo].[Shippers]

SELECT * FROM [dbo].[Orders]

SELECT MIN([OrderDate]), MAX([OrderDate])
FROM [dbo].[Orders]
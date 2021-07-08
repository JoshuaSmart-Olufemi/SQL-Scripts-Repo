--------------------------    AVERAGE BASKET CALCULATIONS
--A. Average No. Of Items Bought Per Customer
SELECT SUM([OrderQty]) 'Total Sales Qty',
COUNT([SalesOrderID]) 'Total Transactions',
SUM([OrderQty])/
COUNT([SalesOrderID]) 'Average No. Of Items Bought Per Customer'
FROM [Sales].[SalesOrderDetail]

/* B. Average Price Per Item - 
On average, each customer spend $ 400 per item in your store.*/
SELECT 
ROUND((SUM([LineTotal])/ 
SUM([OrderQty])),0) AS Avg_Price_Per_Item,
ROUND(SUM([LineTotal]),0) AS Revenue
FROM [Sales].[SalesOrderDetail] AS A
LEFT JOIN [Sales].[SalesOrderHeader] AS B
ON A.SalesOrderID = B.SalesOrderID
GROUP BY [CustomerID] --TO ADD PER EACH CUSTOMER
ORDER BY [CustomerID]

/*To get the Average Basket Store multiply A By B*/
SELECT 
(SUM([LineTotal])/ 
SUM([OrderQty])) AS Avg_Price_Per_Item,
SUM([OrderQty])/
COUNT(A.[SalesOrderID]) AS Average_No_Of_Items_Bought_Per_Customer,

(SUM([LineTotal])/ 
SUM([OrderQty]) )
*
(SUM([OrderQty])/
COUNT(A.[SalesOrderID])) AS Average_Basket
FROM [Sales].[SalesOrderDetail] AS A
LEFT JOIN [Sales].[SalesOrderHeader] AS B
ON A.SalesOrderID = B.SalesOrderID
--GROUP BY [CustomerID] TO ADD PER EACH CUSTOMER
--ORDER BY [CustomerID]
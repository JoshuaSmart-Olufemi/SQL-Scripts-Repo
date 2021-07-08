/*Question 1
Retrieve information about the products with colour values 
except null, red, silver/black, white and list price between £75 and £750. 
Rename the column StandardCost to Price. Also, sort the results in descending order by list price*/
SELECT [Name],[Color],[ListPrice]
FROM [Production].[Product]
WHERE [ListPrice] BETWEEN 75 AND 750 AND
[Color] NOT IN ('NULL','RED','SILVER/BLACK','WHITE')
ORDER BY [ListPrice] DESC

/*Question 2
Find all the male employees born between 1962 to 1970 and with hire date greater than 2001 
and female employees born between 1972 and 1975 and hire date between 2001 and 2002.*/
SELECT [Gender],[BirthDate],[HireDate]
FROM [HumanResources].[Employee]
WHERE [Gender] = 'M' AND [BirthDate] BETWEEN '1962' AND '1970'
AND [HireDate] > '2001'
OR [Gender] = 'F' AND [BirthDate] BETWEEN '1972' AND '1975' 
AND [HireDate] BETWEEN '2001' AND '2002'
ORDER BY ROW_NUMBER () OVER (PARTITION BY [Gender] ORDER BY [Gender])

SELECT [Gender],[BirthDate],[HireDate]
FROM [HumanResources].[Employee]
WHERE [Gender] = 'F' AND [BirthDate] BETWEEN '1972' AND '1975' 
AND [HireDate] BETWEEN '2001' AND '2002'
ORDER BY [BirthDate],[HireDate]

/*Question 3
Create a list of 10 most expensive products that have a product number beginning with ‘BK’. 
Include only the product ID, Name and colour.*/
SELECT [ProductID],[Name],[Color]
FROM

   (SELECT TOP 10 ([ListPrice]),[ProductID],[Name],[Color]
   FROM [Production].[Product]
   WHERE [ProductNumber] LIKE'BK%') AS Temp

/*Question 4
Create a list of all contact persons, 
where the first 4 characters of the last name are the same as the first four characters of the email address. 
Also, for all contacts whose first name and the last name begin with the same characters, 
create a new column called full name combining first name and the last name only. 
Also provide the length of the new column full name*/
SELECT [FirstName],[LastName],PEA.EmailAddress, 
CONCAT([FirstName],' ',[LastName]) AS [Full Name]
FROM [Person].[Person] AS PP
LEFT JOIN [Person].[EmailAddress] AS PEA
ON PP.BusinessEntityID = PEA.BusinessEntityID
WHERE LEFT([LastName],4) =  LEFT([EmailAddress],4)  AND
[FirstName] = [LastName]

/*Question 5
Return all product subcategories that take an average of 3 days or longer to manufacture*/
SELECT PPS.Name AS [Product Subcategory],
AVG(PP.DaysToManufacture) AS [Average Days To Manufacture]
FROM [Production].[ProductSubcategory] AS PPS
LEFT JOIN [Production].[Product] AS PP
ON PPS.ProductSubcategoryID = PP.ProductSubcategoryID
GROUP BY PPS.Name
HAVING AVG(PP.[DaysToManufacture]) >= 3

/*Question 6
Create a list of product segmentation by defining criteria that places each item in a predefined segment as follows. 
If price gets less than £200 then low value. 
If price is between £201 and £750 then mid value. 
If between £750 and £1250 then mid to high value else higher value. 
Filter the results only for black, silver and red color products.*/
SELECT [Name],[ListPrice],[Color],
CASE
    WHEN [ListPrice] < 200 THEN 'Low Value'
	WHEN [ListPrice] BETWEEN 201 AND 750 THEN 'Mid Value'
	ELSE  'Mid To High Value'
	END AS [Product Segmentation]
FROM [Production].[Product]
WHERE [Color] IN ('Black','Silver','Red')

/*Question 7
How many Distinct Job title are present in the Employee table.*/
SELECT COUNT(DISTINCT[JobTitle])
FROM [HumanResources].[Employee]

/*Question 8
Use employee table and calculate the ages of each employee at the time of hiring*/
SELECT [NationalIDNumber],[HireDate],
DATEDIFF(YEAR,[BirthDate],[HireDate]) AS [Age At Time of Hire]
FROM [HumanResources].[Employee]

/*Question 9
How many employees will be due a long service award in the next 5 years, if long service is 20 years?*/
SELECT [NationalIDNumber],[HireDate],
DATEDIFF(YEAR,[HireDate],GETDATE()) AS [Years On Staff],
YEAR(GETDATE()) - YEAR([HireDate]) + 5 [Years Worked + 5]
FROM [HumanResources].[Employee]
WHERE YEAR(GETDATE()) - YEAR([HireDate]) + 5 >= 20

/*Question 10
How many more years does each employee have to work before reaching sentiment, if sentiment age is 65?*/
SELECT [NationalIDNumber],[HireDate],
YEAR(GETDATE()) - YEAR([HireDate]) AS [Years On Staff],
DATEDIFF(YEAR,[BirthDate],GETDATE()) AS [Age],
65 - (YEAR(GETDATE()) - YEAR([BirthDate])) AS [Years Before Sentiment]
FROM [HumanResources].[Employee]

/*Question 11
Implement new price policy on the product table base on the colour of the item
If white increase price by 8%, If yellow reduce price by 7.5%, If black increase price by 17.2%.
If multi, silver, silver/black or blue take the square root of the price and double the value. 
Column should be called Newprice. For each item, also calculate commission as 37.5% of newly computed list price.*/
SELECT [Color],[ListPrice],
CASE
    WHEN [Color] = 'White' THEN CAST([ListPrice]* 1.08 AS DECIMAL (18,3))
	WHEN [Color] = 'Yellow' THEN CAST([ListPrice] * 1.075 AS DECIMAL (18,3))
	WHEN [Color] = 'Black' THEN CAST([ListPrice] * 1.172 AS DECIMAL (18,3))
	WHEN [Color] = 'Multi' THEN CAST(SQRT([ListPrice])*2 * 1.172 AS DECIMAL (18,3))
	WHEN [Color] = 'Silver' THEN CAST(SQRT([ListPrice])*2 * 1.172 AS DECIMAL (18,3))
	WHEN [Color] = 'Silver/Black' THEN CAST(SQRT([ListPrice])*2 * 1.172 AS DECIMAL (18,3))
	WHEN [Color] = 'Blue' THEN CAST(SQRT([ListPrice])*2 AS DECIMAL (18,3))
	END AS [New Price]
FROM [Production].[Product]

/*Question 12
Print the information about all the Sales.Person and their sales quota. 
For every Sales person you should provide their FirstName, LastName, 
HireDate, SickLeaveHours and Region where they work.*/

/*Question 13
Using adventure works, write a query to extract the following information.
• Product name
• Product category name
• Product subcategory name
• Sales person
• Revenue
• Month of transaction
• Quarter of transaction
• Region*/

/*Question 14
Display the information about the details of an order i.e. order number, order date, 
amount of order, which customer gives the order and which salesman works 
for that customer and how much commission he gets for an order.*/

/*Question 15
For all the products calculate
• Commission as 14.790% of standard cost,
• Margin, if standard cost is increased or decreased as follows:
- Black: +22%,
- Red: -12%
- Silver: +15%
- Multi: +5%
- White: Two times original cost divided by the square root of cost
- For other colors, standard cost remains the same*/

/*Question 16
Create a view to find out the top 5 most expensive products for each colour.*/
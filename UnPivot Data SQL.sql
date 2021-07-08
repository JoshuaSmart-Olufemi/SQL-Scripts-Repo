SELECT [CustomerID],[CompanyName],[ContactName],[Phone],[Fax]
FROM [dbo].[Customers]


--UNPIVOT DATA

WITH cleaned_category AS
(
SELECT [CustomerID],[CompanyName],[ContactName],[Means of Contact], [Contact Numbers]
FROM (SELECT [CustomerID],[CompanyName],[ContactName],[Phone],[Fax] FROM [dbo].[Customers]) AS Customers
UNPIVOT 
([Contact Numbers] FOR [Means of Contact] IN ([Phone],[Fax])) AS [Unpivot Column Headers]

SELECT *
FROM cleaned_category















  With cleaned_orders AS
  (SELECT orders.order_date, -- Put the dates into a true date format: YYYY-MM-DD
 ('20' || right(order_date, 2) || '-' || LEFT(order_date, 1) || '-' || SUBSTR(order_date, 3, 2))::date AS cleaned_date,
 orders.channel_id,
 oc.channel_description,
 orders.customer_type_id,
 ct.customer_type, --Pivot the sales types to be one column instead of six separate category columns
 categories.*,
 CASE category
     WHEN 'fresh' then fresh
     WHEN 'milk' then milk
     WHEN 'grocery' then grocery
     WHEN 'frozen' then frozen
     WHEN 'detergents_paper' then detergents_paper
     WHEN 'delicatessen' then delicatessen
     ELSE NULL
 END AS sales
   FROM brooklyndata.orders orders
   CROSS JOIN
     (SELECT category
      FROM (
            VALUES ('fresh'),('milk'),('grocery'),('frozen'),('detergents_paper'), ('delicatessen')) v(category)) categories
   left join brooklyndata.order_channels oc using(channel_id)
   left join brooklyndata.customer_types ct using(customer_type_id))
SELECT -- Create a column that maps each date into its respective Quarter
 CASE
     WHEN cleaned_date between '2019-01-01' AND '2019-03-31' then 'Q1'
     WHEN cleaned_date between '2019-04-01' AND '2019-06-30' then 'Q2'
     WHEN cleaned_date between '2019-07-01' AND '2019-09-30' then 'Q3'
 END AS quarter,
 channel_description,
 customer_type,
 sum(sales) AS quarterly_sales
FROM cleaned_orders
GROUP BY 1,
         2,
         3
ORDER BY 1,
         2,
         3;
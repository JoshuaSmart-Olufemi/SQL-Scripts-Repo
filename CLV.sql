-- Average Revenue Per User : Monthly Recurring Revenue/ Total Active Users
SELECT monthly_amount AS MRR, COUNT([customer_id]) [Customer Id]
FROM [dbo].[subscription_periods]
GROUP BY monthly_amount
ORDER BY [Customer Id];

SELECT/*[start_date],[end_date], [customer_id],[monthly_amount],*/
SUM([monthly_amount]) OVER (PARTITION BY [customer_id]) AS [MRR PER CUSTOMER]
FROM [dbo].[subscription_periods]

SELECT SUM([monthly_amount]) AS MRR,
COUNT(DISTINCT([customer_id])) [Sum Of Active Users],
ROUND(SUM([monthly_amount])/COUNT(DISTINCT([customer_id])),0) AS ARPU
FROM [dbo].[subscription_periods]

SELECT 
      COUNT(DISTINCT(customer_id)) as count_customerid
      --COUNT([monthly_amount]) as count_mrr
FROM [dbo].[subscription_periods]
WHERE [monthly_amount] = 65

with date_range as ( select '2017-01-01'::date as start_date, '2018-01-01'::date as end_date ), 
start_accounts as ( select distinct account_id from subscription s inner join date_range d on s.start_date <= d.start_date and (s.end_date > d.start_date or s.end_date is null) ), 
end_accounts as ( select distinct account_id from subscription s inner join date_range d on s.start_date <= d.end_date and (s.end_date > d.end_date or s.end_date is null) ), 
churned_accounts as ( Select s.account_id from start_accounts s left outer join end_accounts e on s.account_id=e.account_id where e.account_id is null ), 
start_count as ( select count(start_accounts.*) as n_start from start_accounts ), 
churn_count as ( select count(churned_accounts.*) as n_churn from churned_accounts ) 
select n_churn::float/n_start::float as churn_rate, 1.0-n_churn::float/n_start::float as retention_rate, n_start, N_churn 
from start_count, end_count, churn_count

with mr_r as (
    SELECT * FROM [dbo].[subscription_periods]
),

count_of_customers_with_zero_mrr as (
   
    SELECT
      customer_id,
      mrr,
      COUNT(DISTINCT(customer_id)) as no_churned_customers 
    FROM mr_r
    GROUP BY customer_id, mrr
    HAVING mrr = 0

),



count_of_all_customers as (

    SELECT
      customer_id,
      COUNT(DISTINCT(customer_id)) as total_no_customers
    FROM mr_r 
    GROUP BY customer_id 
)



SELECT 
  no_churned_customers/total_no_customers  AS churn_rate
FROM count_of_customers_with_zero_mrr
LEFT JOIN
count_of_all_customers
ON count_of_customers_with_zero_mrr.customer_id = count_of_all_customers.customer_id  

















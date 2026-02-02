show databases;

use bank_crm;

show Tables;

select * from activecustomer;
select * from bank_churn;
select * from customerinfo;
select * from creditcard;
select * from exitcustomer;
select * from gender;

select 
*
from geography;

-- 1.	What is the distribution of account balances across different regions?

select 
g.GeographyLocation,
round(sum(b.Balance)) as total_amount,
round((sum(b.Balance) * 100/ (select sum(Balance) from bank_churn))) as balance_percentage
from customerinfo c
join geography g on c.GeographyID = g.GeographyID
join bank_churn b on c.CustomerId = b.CustomerId 
group by g.GeographyID
order by total_amount;

# 2.	Identify the top 5 customers with the highest Estimated Salary in the last quarter of the year. (SQL)

select
*
from customerinfo c
where quarter(Bank_DOJ) = 4 
order by EstimatedSalary desc
limit 5;

-- 3. Calculate the average number of products used by customers who have a credit card. (SQL)

select
round(avg(b.NumOfProducts)) as avg_product
from bank_churn b
where b.HasCrCard = 1;

-- 4. Determine the churn rate by gender for the most recent year in the dataset.

select * from gender;

select 
c.GenderID as gender_ID,
g.GenderCategory as gender_category,
round(count(case when b.Exited = 1 then 1 end) * 100/ count(b.CustomerId)) as churn_rate
from bank_churn b
join customerinfo c on b.CustomerId = c.CustomerId
join gender g on c.GenderID = g.GenderID
where b.Exited = 1 and year(c.Bank_DOJ) = 2019
group by gender_ID, gender_category;



-- 5.	Compare the average credit score of customers who have exited and those who remain. (SQL)

select
e.ExitCategory,
round(avg(b.CreditScore)) as Avg_Creditscore
from bank_churn b
join exitcustomer e on e.ExitID = b.Exited
group by e.ExitCategory;


-- 6.	Which gender has a higher average estimated salary, and how does it relate to the number of active accounts? (SQL)

select
g.GenderCategory as customer_gender,
round(avg(EstimatedSalary)) as avg_estimated_salary,
count(c.CustomerId) as no_of_customer
from customerinfo c
join bank_churn b on c.CustomerId = b.CustomerId
join gender g on c.GenderID = g.GenderID
where b.IsActiveMember = 1
group by g.GenderCategory;

select * from bank_churn;

-- 7.	Segment the customers based on their credit score and identify the segment with the highest exit rate. (SQL)

WITH creditSegment AS (
    SELECT 
        *,
        CASE 
            WHEN CreditScore >= 781 THEN 'Excellent'
            WHEN CreditScore BETWEEN 701 AND 780 THEN 'Very Good'
            WHEN CreditScore BETWEEN 611 AND 700 THEN 'Good'
            WHEN CreditScore BETWEEN 510 AND 610 THEN 'Fair'
            ELSE 'Poor'
        END AS CreditScoreSegment
    FROM bank_churn
),
grouped_segment AS(
SELECT
  CreditScoreSegment,
  COUNT(CASE WHEN Exited = 1 THEN 1 END ) * 100 / COUNT(*) AS exit_customer_rate
FROM creditSegment
  GROUP BY CreditScoreSegment
)

SELECT
 CreditScoreSegment,
 ROUND(exit_customer_rate,2) AS Max_Exit_Rate
FROM grouped_segment
ORDER BY exit_customer_rate DESC
LIMIT 1;

-- 8.	Find out which geographic region has the highest number of active customers with a tenure greater than 5 years. (SQL)

select 
GeographyLocation,
COUNT(b.CustomerId) AS total_active_customer
from bank_churn b 
join customerinfo c on b.CustomerId = c.CustomerId
join geography g on c.GeographyID = g.GeographyID
where IsActiveMember = 1 and Tenure > 5
group by GeographyLocation
order by total_active_customer desc
limit 1;

-- 9.	What is the impact of having a credit card on customer churn, based on the available data?

SELECT
    c.Category,
    COUNT(*) AS total_customer,
    COUNT(CASE WHEN b.Exited = 1 THEN 1 END) AS total_exit_customer,
    COUNT(CASE WHEN b.Exited = 1 THEN 1 END) * 100 / COUNT(*) AS churn_rate
FROM bank_churn b
JOIN creditcard c
    ON b.HasCrCard = c.CreditID
GROUP BY c.Category;

-- 10.	For customers who have exited, what is the most common number of products they have used? 

SELECT
NumOfProducts,
COUNT(*) as no_of_product
FROM bank_churn 
WHERE Exited = 1
GROUP BY NumOfProducts
ORDER BY no_of_product desc
LIMIT 1;    

-- 11.	Examine the trend of customers joining over time and identify any seasonal patterns (yearly or monthly). Prepare the data through SQL and then visualize it.

select 
Year(Bank_DOJ) as joining_year,
count(*) as total_customer
from customerinfo
group by joining_year
order by joining_year;

select 
date_format(Bank_DOJ,"%m") as joining_month,
count(*) as total_customer
from customerinfo
group by joining_month
order by joining_month;

select 
date_format(Bank_DOJ, "%Y" ) as joining_year,
date_format(Bank_DOJ,"%m") as joining_month,
count(*) as total_customer
from customerinfo
group by joining_year, joining_month
order by joining_year;

-- 15. Using SQL, write a query to find out the gender-wise average income of males and females in each geography id. Also, rank the gender according to the average value. (SQL)

select 
GeographyLocation, 
GenderCategory,
round(avg(EstimatedSalary )) as avg_salary,
rank() over(partition by GeographyLocation order by avg(EstimatedSalary) desc) as rnk
from customerinfo c
join geography geo on geo.GeographyID = c.GeographyID
join gender g on c.GenderID = g.GenderID 
group by GeographyLocation, GenderCategory ;

select
GenderCategory,
avg()
from bank_churn b
join customerinfo c on b.CustomerId = c.CustomerId
join gender g on c.GenderID = g.GenderID
group by GenderCategory;


-- 16.	Using SQL, write a query to find out the average tenure of the people who have exited in each age bracket (18-30, 30-50, 50+).

SET SQL_SAFE_UPDATES = 0;

alter table customerinfo add age_bracket varchar(20);

UPDATE customerinfo
SET age_bracket =
    CASE
        WHEN Age > 50 THEN '50+'
        WHEN Age BETWEEN 31 AND 50 THEN '30-50'
        ELSE '18-30'
    END
WHERE customerId IS NOT NULL;    
 
select
age_bracket,
round(avg(b.Tenure),2) as avg_tenure
from customerinfo c 
join bank_churn b on c.CustomerId = b.CustomerId
where b.Exited = 1
group by age_bracket;

-- Q19. Rank each bucket of credit score as per the number of customers who have churned the bank. SQL Query: 

select 
	case when creditscore <= 579 then "Poor"
    	when creditscore between 580 and 669 then "Fair"
	when creditscore between 670 and 739 then "Good"
    	when creditscore between 740 and 799 then "Very Good"
    	when creditscore>=800 then "Excellent"
	end as `credit score bucket`,
   	count(case when exited =1 then customerid end) as exit_rate,
    	dense_rank() over(order by count(case when exited =1 then customerid end) desc) as `bucket rank`
from 
	bank_churn
group by 
	`credit score bucket`;


-- 20.	According to the age buckets find the number of customers who have a credit card. Also retrieve those buckets that have lesser than average number of credit cards per bucket.


select 
age_bracket,
count(b.customerId) as total_customer_has_CrCard
from bank_churn b 
join customerinfo c on c.CustomerId = b.CustomerId
where HasCrCard = 1
group by age_bracket
order by total_customer_has_CrCard asc;

-- 21. Rank the Locations as per the number of people who have churned the bank and average balance of the customers.

with grouped_location_data as (
select 
g.GeographyLocation as location,
round(count(case when Exited = 1 then 1 end ) *  100 / count(c.CustomerId),2) as churn_rate,
round(avg(Balance),2) as avg_balance
from bank_churn b 
join customerinfo c on b.CustomerId = c.CustomerId
join geography g on g.GeographyID = c.GeographyID
group by location
)

select 
*,
rank() over(order by churn_rate desc, avg_balance asc) as location_rank
from grouped_location_data;

-- 22.	As we can see that the “CustomerInfo” table has the CustomerID and Surname, now if we have to join it with a table where the primary key is also a combination of CustomerID and Surname, come up with a column where the format is “CustomerID_Surname”.

describe customerinfo;


alter table customerinfo add CustomerID_Surname varchar(50);

update customerinfo
set CustomerID_Surname = concat (customerId, "_", Surname) 
where CustomerId is not null;

select * from geography;

-- 23.	Without using “Join”, can we get the “ExitCategory” from ExitCustomers table to Bank_Churn table? If yes do this using SQL.

select * from exitcustomer;

select
b.*,
(select ExitCategory from exitcustomer e where e.ExitID = b.Exited) as ExitCategory
from bank_churn b; 

-- 25.	Write the query to get the customer IDs, their last name, and whether they are active or not for the customers whose surname ends with “on”.

select
c.CustomerId,
c.surname,
ActiveCategory
from bank_churn b 
join customerinfo c on b.CustomerId = c.CustomerId
join activecustomer a on a.ActiveID = b.IsActiveMember
where c.surname like "%on";


-- 26.  Can you observe any data disrupency in the Customer’s data? As a hint it’s present in the IsActiveMember and Exited columns. One more point to consider is that the data in the Exited Column is absolutely correct and accurate.


select 
*
from bank_churn
where Exited = 1 and IsActiveMember = 1;

-- SELECT 
--   CreditScoreSegment,
--   
-- FROM grouped_segment
-- GROUP BY CreditScoreSegment


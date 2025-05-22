Create database p1_retail;
use p1_retail;
drop  table if exists retail_sales;
create table retail_sales
	(
		transactions_id INT Primary key, 
        sale_date DATE, 
        sale_time TIME,
        customer_id	INT, 
        gender varchar(15),
        age INT, 
        category VARCHAR (15),
        quantiy INT, 
        price_per_unit FLOAT, 
        cogs FLOAT, 
        total_sale FLOAT
	);
    
Select * from retail_sales LIMIT 10;

-- 1. Find the NULL values 

Select * from retail_sales
WHERE
	transactions_id	IS NULL
    OR
    sale_date IS NULL	
    OR
    sale_time IS NULL
    OR
    customer_id	IS NULL
    OR
    gender	IS NULL
    OR
    age	IS NULL
    OR
    category IS NULL
    OR
    quantiy	IS NULL
    OR
    price_per_unit	IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- 2. Delete Null values

DELETE FROM retail_sales 
WHERE
		transactions_id	IS NULL
		OR
		sale_date IS NULL	
		OR
		sale_time IS NULL
		OR
		customer_id	IS NULL
		OR
		gender	IS NULL
		OR
		age	IS NULL
		OR
		category IS NULL
		OR
		quantiy	IS NULL
		OR
		price_per_unit	IS NULL
		OR
		cogs IS NULL
		OR
		total_sale IS NULL;

Select * from retail_sales;

-- Data Analysis

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:

Select * from retail_sales
	WHERE sale_date = '2022-11-05';

Select count(*) from retail_sales
	WHERE sale_date = '2022-11-05';
    
-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

select * from retail_sales 
	where category='Clothing' 
    and month(sale_date)=11 
    and Year(sale_date)= 2022 
    and quantiy>=4;
    
-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.:

select category, sum(total_sale) as 'total_sale' from retail_sales
group by 1 order by total_sale desc;

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

select round(avg(age),2) as 'Avg_age' from retail_sales where category='Beauty';

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:

select * from retail_sales where total_sale>1000;

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

SELECT 
	category, 
    gender, 
    count(transactions_id) AS 'Total_transactions' 
FROM retail_sales
GROUP BY category, gender ORDER BY 1;

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year: 

SELECT 
  YEAR(sale_date) AS Sale_Year, 
  MONTH(sale_date) AS Sale_Month_Num,
  DATE_FORMAT(min(sale_date), '%b') AS Sale_Month,  -- Safe workaround
  Round(AVG(total_sale),2) AS monthly_avg_sale
FROM retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
ORDER BY Sale_Year, Sale_Month_Num;

-- Sub task 2- To put rank by month

Select
	Sale_year,
    Sale_month_num, 
    Sale_Month,
    Monthly_avg_sale,
    Rank() over (
		partition by Sale_year
        order by Monthly_avg_sale desc
	) as rank_in_year
    
    FROM (
		Select 
			Year(sale_date) as Sale_year,
            month(sale_date) as Sale_month_num,
            date_format(min(sale_date), '%b') as Sale_Month,
            round(avg(total_sale), 2) as Monthly_avg_sale
		 from retail_sales
         group by year(sale_date), month(sale_date)
         ) as monthly_summary
	order by Sale_year, rank_in_year;

-- 8. *Write a SQL query to find the top 5 customers based on the highest total sales **:
Select customer_id, sum(total_sale) 'Total_Spent' from retail_sales
group by customer_id order by Total_Spent desc limit 5;

-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.
select
	category, 
    count(distinct customer_id) as Total_customer
    from retail_sales
    group by category
    order by Total_customer desc;
    
-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

Select 
	CASE
		WHEN hour(sale_time)<12 then 'Morning'
        WHEN hour(sale_time) between 12 and 17 then 'Afternoon'
        ELSE 'Evening'
	END as shift,
    count(transactions_id) as Total
from retail_sales
group by shift;

-- END of PROJECT
    

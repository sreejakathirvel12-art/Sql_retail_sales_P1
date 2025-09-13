-- CREAte table
create table retail_sales 
		(
			transactions_id	int,
			sale_date date,
			sale_time time,
			customer_id	int,
			gender varchar(15),
			age	int,
			category varchar(15),	
			quantiy	int,
			price_per_unit float,	
			cogs float,
			total_sale float
		);

-- Data cleaning

select * from retail_sales
limit 10

select count(*) from retail_sales

select * from retail_sales

select * from retail_sales
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;

delete from retail_sales
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;

--Data Exploration

--how many sales
select count(*) as total_sale from retail_sales

--how many unique customers
select count(distinct customer_id) from retail_sales

--how many category and its name
select count(distinct category) from retail_sales;
select distinct category from retail_sales;

--Data analysis & business key problems and answers

--1.Write a SQL query to retreive all the columns for sales made on 2022-11-05
select * from retail_sales
where sale_date = '2022-11-05'

--2.Write a SQL query to retrive all the transactions where the category is clothing and the quantity sold is more than 4 in the month of Nov-2022
select * from retail_sales
where 
	category = 'Clothing'
	and
	quantiy >= 4
	and
	To_char(sale_date, 'YYYY-MM') = '2022-11';

--3.To calculate the total sales for each category
select
	category,
	sum(total_sale) as net_sale,
	count(*) as total_orders
from retail_sales
group by 1

--4.To find the average age of customers who purchased items from the beauty category
select
	round(avg(age),2) as avg_age
from retail_sales
where category = 'Beauty'

--5.To find all transaction where total sales is greater than 1000
select * from retail_sales
where total_sale > 1000

--6.To find the total number of transactions made by each gender in each category
select
	category,
	gender,
	count(*) as total_trans
from retail_sales
group by 
	category,
	gender
order by 1

--7.To calculate the average sale of each month. Find out best selling month in each year.
Select
	year,
	month,
	avg_sale
from
	(select
		extract(year from sale_date) as year,
		extract(month from sale_date) as month,
		avg(total_sale) as avg_sale,
		rank() over(partition by extract(year from sale_date) order by avg(total_sale)desc) as rank
	from retail_sales
	group by 1,2) as t1
where rank = 1

--8.To find the top 5 customers based on the higest total sales
select 
	customer_id,
	sum(total_sale) as total_sales
from retail_sales
group by customer_id
order by 2 desc
limit 5

--9. To find number of unique customers who purchased items from each category
select
	category,
	count(distinct customer_id) as unique_customers
from retail_sales
group by 1

--10. To create each shift and number of orders (Example Morning <= 12, Afternoon between 12 & 17, evening >= 17)
With Hourly_sales
as
(select *,
	case
		when extract(hour from sale_time) < 12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		Else 'Evening'
	End as shift
from retail_sales)
select 
	shift,
	count(*) as total_orders
from Hourly_sales
group by shift

--End of Project
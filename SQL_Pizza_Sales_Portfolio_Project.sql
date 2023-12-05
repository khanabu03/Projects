Select* 
From pizza_sales
-- 
Select sum(total_price) AS Total_Revenue 
from pizza_sales
-- Total Revenue
Select sum(total_price) / count (distinct order_id) AS Average_Order_Value
From pizza_sales
--Average Order Value (use count & distinct to find total in distinct values)
Select sum(quantity) AS Total_Pizzas_Sold 
from pizza_sales
-- Total pizzas sold
Select count(distinct order_id) AS Total_Orders
From pizza_sales
--Total orders
Select cast(cast(sum(quantity) AS decimal(10,2)) / 
CAST(count(distinct order_id) AS decimal(10,2)) AS decimal(10,2)) AS Average_Pizzas_Per_Order
From pizza_sales
-- Average Pizzas Per Order (cast both values to decimal, then cast whole formula to decimal)

Select DATENAME(DW, order_date) AS order_day, count(distinct order_id) AS Total_Orders
From pizza_sales
Group By DATENAME(DW, order_date) 
-- Orders by day of week (use DW in interval to convert date to day of week)
Select DATENAME(Month, order_date) AS Order_Month, count(distinct order_id) AS Total_Orders
From pizza_sales
Group By DATENAME(Month, order_date)
Order By Total_Orders DESC
-- Orders by month (Use Month in interval to get month name)
Select pizza_category, sum(total_price) as total_sales, sum(total_price) * 100 / (Select sum(total_price) From pizza_sales Where Month(order_date) = 1) AS PCT_Total_Sales 
From pizza_sales 
Where Month(order_date) = 1
Group By pizza_category
-- Percantage of sales according to category (use whole another select statement and divide by that to find %, use where to filter by month)
Select pizza_size, Cast(sum(total_price) As Decimal(10,2)) as total_sales, Cast(sum(total_price) * 100 / (Select sum(total_price) From pizza_sales Where Datepart (quarter, order_date)=1) As Decimal(10,2)) AS PCT 
From pizza_sales
Where Datepart (quarter, order_date)=1
Group By pizza_size
Order By PCT Desc
--% of sales from size (Use datepart (quarter...) to filter by quarters of the year)
Select TOP 5 pizza_name, Sum(total_price) AS Total_Revenue
From pizza_sales
Group By pizza_name
Order By Total_Revenue DESC
-- To find top 5 or bottom 5 pizza sales by name (Use TOP to find top in the list, don't use bottom, instead remove DESC in order by)
Select TOP 5 pizza_name, Sum(Quantity) AS Total_Quantity
From pizza_sales
Group By pizza_name
Order By Total_Quantity DESC
-- in terms of quantity
Select TOP 5 pizza_name, Count(Distinct order_id) AS Total_Orders
From pizza_sales
Group By pizza_name
Order By Total_Orders DESC
-- in terms of orders


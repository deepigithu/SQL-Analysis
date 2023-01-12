select * from ['Customer Data$']

select * from ['Orders Data$']


----1Q----

----a]Total_revenue
select SUM(ORDER_TOTAL) as Total_Revenue
from ['Orders Data$']

----b]Total Revenue by top 25 Customers
select top 25 CUSTOMER_KEY,SUM(ORDER_TOTAL) as Total_Revenue
from ['Orders Data$']
group by CUSTOMER_KEY
order by Total_Revenue desc

----c]Total Orders
select Count(ORDER_NUMBER) as Total_Orders
from ['Orders Data$']

----d]Total Orders by top 25 Customers
select top 25 CUSTOMER_KEY,Count(ORDER_NUMBER) as Total_Orders
from ['Orders Data$']
group by CUSTOMER_KEY
order by Total_Orders desc

----e]Number of Customers(distinct)
select count(distinct CUSTOMER_KEY) as distinct_cust
from ['Customer Data$']

----f]Number of Customers Ordered Once
select CUSTOMER_KEY,Count(ORDER_NUMBER) as Total_Orders
from ['Orders Data$']
group by CUSTOMER_KEY
having Count(ORDER_TOTAL)=1

-----g]Number of Customers Ordered Multiple times
select CUSTOMER_KEY,Count(ORDER_NUMBER) as Total_Orders
from ['Orders Data$']
group by CUSTOMER_KEY
having Count(ORDER_TOTAL)>1

----h]Number of Customers referred to Other Customers
select count(CUSTOMER_KEY) as no_of_cust 
from ['Customer Data$']
where [Referred Other customers]='Y'

----i]Which Month as maximum Revenue
select top 1 MONTH(ORDER_DATE) as Month,SUM(ORDER_TOTAL) as Total_Revenue
from['Orders Data$']
group by MONTH(ORDER_DATE)
order by Total_Revenue desc

----j]Numbers of Inactive Customers who havent ordered last 60 days
select count(CUSTOMER_KEY) inactive_cust
from ['Orders Data$']
having MAX(ORDER_DATE)<=DATEADD("d",-60,GETDATE())


-----2Q---

----a]Number of orders by month based on order status
select MONTH(ORDER_DATE) as Month,COUNT(ORDER_NUMBER) AS total_orders,ORDER_STATUS
from ['Orders Data$']
group by MONTH(ORDER_DATE),ORDER_STATUS

----b]Number of orders by month based on delivery status
select MONTH(ORDER_DATE) as Month,COUNT(ORDER_NUMBER) AS total_orders,DELIVERY_STATUS
from ['Orders Data$']
group by MONTH(ORDER_DATE),DELIVERY_STATUS

----c]Month on month growth order count and revenue from NOV 15 to JULY 16
select MONTH(ORDER_DATE) AS Month,COUNT(ORDER_NUMBER) as TOTAL_ORDER,SUM(ORDER_TOTAL) AS REVENUE
from ['Orders Data$']
group by  MONTH(ORDER_DATE)

----d]Month wise split total order value by top 50 customers
select top 50 CUSTOMER_KEY,MONTH(ORDER_DATE) AS Month,COUNT(ORDER_NUMBER) AS TOTAL_ORDER
from['Orders Data$']
group by CUSTOMER_KEY,MONTH(ORDER_DATE)
order by TOTAL_ORDER desc

----e]Month wise split of new and repeat customers
select CUSTOMER_KEY,MONTH(ORDER_DATE) AS Month,(case when COUNT(CUSTOMER_KEY) <= 1 then 'NEW' else 'EXISTING' end) AS CUSTOMERS
FROM ['Orders Data$']
group by MONTH(ORDER_DATE),CUSTOMER_KEY


----3Q----

----a]Total revenue ,total orders by each location
select SUM(o.ORDER_TOTAL) AS TOTAL_REVENUE,Count(o.ORDER_NUMBER) as TOTAL_ORDER ,c.Location  
from ['Orders Data$'] o inner join ['Customer Data$'] c on o.CUSTOMER_KEY=c.CUSTOMER_KEY
group by c.Location

----b]Total revenue, total orders by customer gender
select SUM(o.ORDER_TOTAL) AS TOTAL_REVENUE,Count(o.ORDER_NUMBER) as TOTAL_ORDER ,c.Gender  
from ['Orders Data$'] o inner join ['Customer Data$'] c on o.CUSTOMER_KEY=c.CUSTOMER_KEY
group by c.Gender

----c]Which location as maximum number of Cancellation Orders
select  c.Location,COUNT(o.ORDER_NUMBER) as total_cancellation 
from ['Customer Data$'] c inner join ['Orders Data$'] o on c.CUSTOMER_KEY=o.CUSTOMER_KEY
where o.ORDER_STATUS='Cancelled'
group by c.Location
order by total_cancellation desc

----d]Total customers,orders and revenue by each acquired channel
select count(c.CUSTOMER_KEY) as total_cust,count(o.ORDER_NUMBER) as total_orders,SUM(o.ORDER_TOTAL) as total_revenue,c.[Acquired Channel]
from ['Customer Data$'] c inner join ['Orders Data$'] o on c.CUSTOMER_KEY=o.CUSTOMER_KEY
group by c.[Acquired Channel]


----e]Which Acquired channel is good in terms of revenue,orders and repeat customers
select SUM(o.ORDER_TOTAL) AS TOTAL_REVENUE,COUNT(o.ORDER_NUMBER) AS TOTAL_ORDERS,COUNT( o.CUSTOMER_KEY) AS REPEAT_CUST,o.CUSTOMER_KEY,c.[Acquired Channel] 
from ['Customer Data$'] c inner join ['Orders Data$'] o on c.CUSTOMER_KEY=o.CUSTOMER_KEY
group by c.[Acquired Channel],o.CUSTOMER_KEY
having count(o.CUSTOMER_KEY) > 1
order by TOTAL_REVENUE,TOTAL_ORDERS,REPEAT_CUST desc











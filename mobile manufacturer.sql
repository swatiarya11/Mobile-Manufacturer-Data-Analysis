
--Q1--BEGIN 

-- List all the states in which we have customers who have bought cellphones from 2005 till today.

Select Distinct State from(
select t1.State, SUM(Quantity) as Cnt, YEAR(t2.Date)as Year from Dim_location as t1
join fact_transactions as t2
on t1.IDLocation= t2.IDLocation
where YEAR(t2.Date) >=2005
group by t1.State,YEAR(t2.Date)
) A

--Q1--END

--Q2--BEGIN

-- What state in the US is buying the most 'Samsung' cell phones?

Select top 1 State,Count(*)as cnt from DIM_LOCATION as t1
join FACT_TRANSACTIONS as t2
on t1.IDLocation=t2.IDLocation
join DIM_MODEL as t3
on t2.IDModel = t3.IDModel
join DIM_MANUFACTURER as t4
on t3.IDManufacturer =t4.IDManufacturer
where Country='US' and Manufacturer_Name= 'Samsung'
group by State
order by cnt desc

--Q2--END

--Q3--BEGIN 

--Show the number of transactions for each model per zip code per state.

Select IDModel,State,ZipCode,COUNT(*) no_of_txn from FACT_TRANSACTIONS t1
join DIM_LOCATION t2
on t1.IDLocation= t2.IDLocation
group by IDModel,State,ZipCode

--Q3--END

--Q4--BEGIN

-- Show the cheapest cellphone (Output should contain the price also)

Select top 1 Model_Name,Unit_price from DIM_MODEL
order by Unit_price

--Q4--END

--Q5--BEGIN

-- Find out the average price for each model in the top5 manufacturers in terms of sales quantity and order by average price.

select Manufacturer_Name,t1.IDModel, AVG(TotalPrice) avg_price,SUM(Quantity)total_qty from FACT_TRANSACTIONS t1
join DIM_MODEL as t2
on t1.IDModel=t2.IDModel
join DIM_MANUFACTURER t3
on t2.IDManufacturer = t3.IDManufacturer
where Manufacturer_Name IN (select top 5 Manufacturer_Name from FACT_TRANSACTIONS t1
							join DIM_MODEL t2
							on t1.IDModel= t2.IDModel
							join DIM_MANUFACTURER t3
							on t2.IDManufacturer= t3.IDManufacturer
							group by Manufacturer_Name
							order by SUM(TotalPrice) desc)
group by t1.IDModel, Manufacturer_Name
order by avg_price

--Q5--END

--Q6--BEGIN

-- List the names of the customers and the average amount spent in 2009, where the average is higher than 500.

Select Customer_Name,AVG(TotalPrice) avg_amount from FACT_TRANSACTIONS t1
join DIM_CUSTOMER t2
on t1.IDCustomer = t2.IDCustomer
where YEAR(Date)=2009
group by Customer_Name
HAVING AVG(TotalPrice)> 500
order by avg_amount desc

--Q6--END

--Q7--BEGIN 

-- List if there is any model that was in the top 5 in terms of quantity, simultaneously in 2008, 2009 and 2010.

Select * from(
Select top 5 IDModel from FACT_TRANSACTIONS
where YEAR(Date)= 2008
group by IDModel,YEAR(Date)
order by Sum(Quantity) desc) as A
INTERSECT
Select * from(
Select top 5 IDModel from FACT_TRANSACTIONS
where YEAR(Date)= 2009
group by IDModel,YEAR(Date)
order by Sum(Quantity) desc) as B
INTERSECT
Select * from(
Select top 5 IDModel from FACT_TRANSACTIONS
where YEAR(Date)= 2010
group by IDModel,YEAR(Date)
order by Sum(Quantity) desc) as C

--Q7--END	

--Q8--BEGIN

-- Show the manufacturer with the 2nd top sales in the year of 2009 and the manufacturer with the 2nd top sales in the year of 2010.

WITH RankedManu AS (
SELECT YEAR(date) AS year,mf.manufacturer_name,SUM(t.TotalPrice) AS sales,
DENSE_RANK() OVER (PARTITION BY YEAR(date) ORDER BY SUM(t.TotalPrice) DESC) AS rnk
    FROM Fact_Transactions t
    JOIN Dim_Model m ON t.IDModel= m.IDModel
    JOIN Dim_Manufacturer mf ON m.IDManufacturer = mf.IDManufacturer
    WHERE YEAR(date) IN (2009, 2010)
    GROUP BY YEAR(date), mf.manufacturer_name
)
SELECT year, manufacturer_name, sales
FROM RankedManu
WHERE rnk = 2;

--Q8--END

--Q9--BEGIN

-- Show the manufacturers that sold cellphones in 2010 but did not in 2009.

Select Distinct Manufacturer_Name from FACT_TRANSACTIONS t1
join DIM_MODEL t2 on t1.IDModel=t2.IDModel
join DIM_MANUFACTURER t3 on t2.IDManufacturer= t3.IDManufacturer
where YEAR(Date)=2010
EXCEPT
Select Distinct Manufacturer_Name from FACT_TRANSACTIONS t1
join DIM_MODEL t2 on t1.IDModel=t2.IDModel
join DIM_MANUFACTURER t3 on t2.IDManufacturer= t3.IDManufacturer
where YEAR(Date)=2009

--Q9--END

--Q10--BEGIN

-- Find top 100 customers and their average spend, average quantity by each year. Also find the percentage of change in their spend.
Select *, ((Avg_spend - lag_price)/lag_price) as percentage_change from(
Select *, lag(avg_spend,1) over(partition by idcustomer order by year) as lag_price from(
select top 100 IDCustomer,YEAR(Date) year, AVG(TotalPrice) Avg_spend, SUM(Quantity)qty from FACT_TRANSACTIONS
group by IDCustomer, YEAR(Date)
order by Avg_spend desc) A
)B

--Q10--END
alter table purchase_history
modify column Bill_Date varchar(100)
update  purchase_history
set Bill_Date= STR_TO_DATE(Bill_Date, '%d-%m-%Y') ;
Alter table purchase_history
modify column Bill_Date date;  

-- QUESTION 1 -- 
-- Develop a SQL query that will find out two Products for each product category that are most popular in last 30 days. Popularity is based on maximum quantity sold in a particular category.

SELECT c.Cat_Id,p.Product_Id,
RANK() OVER (PARTITION BY max(c.Cat_Id)  ORDER BY p.Product_Id) AS Trending  
FROM
    purchase_history p
	right JOIN
   product_category c ON c.Product_Id=p.Product_Id
   -- WHERE p.Bill_Date >max(Bill_Date)-INTERVAL 20 DAY
group BY c.Cat_Id ,p.Product_Id HAVING( (SELECT MAX(Bill_Date) FROM purchase_history)- INTERVAL 30 day) limit 4;




-- question 2-- 
-- Develop a query that will assign one voucher to one customer and vice versa. Two customers will not get same voucher. Two Voucher will not be assigned to a single customer. 

CREATE TABLE Customers (Customer_Id VARCHAR(300));
INSERT INTO Customers VALUES('Abhinash'),('Vipin'),('Mahesh'),('Bijoy'),('Bhabani'),('Ashutosh');
CREATE TABLE Vouchers (Voucher_Id VARCHAR(300) UNIQUE);
INSERT INTO Vouchers VALUES('ABXFH'),('SDFGH'),('ERTYY'),('PPLKM');
WITH cte as(SELECT *,ROW_NUMBER() OVER(ORDER BY Customer_Id) rr FROM Customers),cte2 AS(SELECT *,ROW_NUMBER() OVER(ORDER BY Voucher_Id) rr FROM Vouchers)
SELECT Customer_Id Customer_Key,Voucher_Id Gift_Voucher_Key FROM cte c1 LEFT JOIN cte2 c2 ON c1.rr=c2.rr;
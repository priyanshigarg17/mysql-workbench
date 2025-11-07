#DROP DATABASE testdbcustomers
create database testdbnew;
use testdbnew;
create table customers(
customername varchar(255),
contactname varchar(255),
address varchar(255),
city varchar(255),
pincode varchar(255),
country varchar(255)
);
select * from customers;
INSERT INTO
customers (customername, contactname, address, city, pincode, country)
VALUES
('Nikhil', 'Purva', 'ashok vihar', 'delhi', '12345', 'India'),
('Navdeep', 'Ritu', 'chattarpur', 'delhi', '12346', 'India'),
('Vrinda', 'Ramesh', 'irish society', 'cork', '12347', 'Ireland'),
('Shruti', 'Nitin', 'vasundhara', 'Ghaziabad', '12348', 'India'),
('Shruti P', 'Sachin', 'CCsociety', 'Toronto', '12349', 'Canada'),
('Abhishek', 'Sonali', 'Aus society', 'Sydney', '12350', 'Australia'),
('Sumit', 'Naina', 'Aus Society', 'sydney', '12350', 'Australia'),
('Meghna', 'Tejinder', 'Dub Society', 'Dublin', '12352', 'Ireland'),
('Bhamini', 'Abhishek', 'Ashok Vihar', 'Delhi', '12345', 'India'),
('Kunal', 'Naina', 'Cal City', 'Calgary', '12354', 'Canada');

select * from customers;
select count(customername) from customers;
SELECT customername, contactname, country FROM customers;
SELECT * FROM customers WHERE pincode = (SELECT MAX(pincode) FROM customers);
select*from customers where country="Australia";
set sql_safe_updates=0;
delete from customers where customername="Sumit";
update customers set contactname="Rishi", city="Cal" where customername="Kunal";
select * from customers;

select * from customers where pincode between 12347 and 12349;
select count(customername) from customers;

#11--> True
#12--> True
#13--> False
#14-->True
#15--> True

select max(pincode) as largestprice from customers;

#17-> this query will sort the city data in the descending order
SELECT * FROM customers WHERE city='Delhi' AND customername='Nikhil';

SELECT * FROM customers WHERE customername='Sumit';
SELECT * FROM customers WHERE address is not null;
SELECT * FROM customers;

CREATE TABLE orders (
    OrderID int,
    CustomerName varchar(255),
    OrderDate date
);

INSERT INTO 
orders (OrderID, CustomerName, OrderDate) 
VALUES
(1, 'Nikhil', '2023-01-01'),
(2, 'Navdeep', '2023-02-01'),
(3, 'Meghna', '2023-03-01'),
(4, "Kunal", '2023-04-01');

select * from orders;

INSERT INTO 
orders (OrderID, CustomerName, OrderDate) 
VALUES
(5, 'Ayush', '2023-05-01'),
(6, 'Anshul', '2023-06-01');

select * from orders;

select c.customername, o.orderid, o.orderdate
from customers c
join orders o on o.customername = c.customername;

select c.customername, o.orderid, o.orderdate
from customers c
left join orders o on o.customername = c.customername

union

select c.customername, o.orderid, o.orderdate
from customers c
right join orders o on o.customername = c.customername;

select city, count(*) as numberofcustomers
from customers
group by city;

select country, count(*) as numberofcustomers
from customers
group by country;

select distinct city from customers;

alter table customers add email varchar(255);
alter table customers change pincode zipcode varchar(255);

alter table customers add customerid INT AUTO_INCREMENT PRIMARY KEY FIRST;
alter table customers auto_increment=1001;

select*from customers;

set @id:= 1001; #if you have any existing column
update customers
set customerid = (@id:= @id+1)
order by customername;

alter table customers auto_increment = 1018;

create table orders(
order_id int,
product_id int, 
quantity int,
primary key (order_id, product_id);

select customername, COUNT(orderid) as TotalOrders
FROM orders
group by customername;

select customername from orders where orderdate> "2023-03-01";
select * from orders where orderdate > "2023-03-01";

select * from customers
where customername in(
	select customername from orders where orderdate > '2023-03-01'
);

-- retriving customers with orders and displaying total amount of orders placed
select customers.customername, count(orders.orderID) as TotalOrders
from customers
right join orders on customers.customername= orders.customername
group by customers.customername

-- using colaesce to hndle null values for customers without values
select
	customers.customername,
    case
		when count(orders.orderID) = 0 THEN 1
        ELSE COUNT(orders.orderID)
	end as TotalOrders
    From customers
    Left Join orders
		on customers.customername = orders.customername
	Group by customers.customername;
    
insert into 
customers(customername, contactname, address, city, pincode, tel, country)
values
('Vanshika', 'Nikhil', NULL , 'jaipur', 12345, 9999898989, 'India')

select * from customers;

-- to replace a null in a column
SELECT customername, 
       COALESCE(address, 'No Address Provided') AS address
FROM customers;

SELECT customers.customername, COUNT(orders.orderID) AS TotalOrder4
From customers
LEFT JOIN orders on customers.customername = orders.customername
GROUP BY customers. customername

SELECT customers.customername, coalesce(COUNT(orders.orderID), 0) AS TotalOrder4
From customers
LEFT JOIN orders on customers.customername = orders.customername
GROUP BY customers. customername

SELECT 
    customers.customername, 
    COALESCE(SUM(order_id), 0) AS TotalOrders
FROM customers
LEFT JOIN orders 
    ON customers.customername = orders.customername
GROUP BY customers.customername;

SELECT 
    customers.customername, 
    COALESCE(SUM(CASE WHEN orders.OrderID IS NOT NULL THEN 1 END), 1) AS TotalOrders
FROM customers
LEFT JOIN orders 
    ON customers.customername = orders.customername
GROUP BY customers.customername;

-- return only customers whose customername appears in the orders table
SELECT*
FROM customers
WHERE customername IN(
      SELECT customername
      FROM orders
);

SELECT DISTINCT *
FROM customers c
INNER JOIN orders o
    ON c.customername = o.customername;

SELECT * FROM customers
WHERE EXISTS (
    SELECT 1 FROM orders WHERE orders.customername = customers.customername
);

-- creating a view for frequent customers
create view Frequentcustomers AS
select customername, zipcode 
from customers;

select*from Frequentcustomers    -- there will no physical storage

create view newcustomers AS
select customername, zipcode 
from customers
where country ="India";


select*from newcustomers;

create view frequentcustomer AS
select customers.customername, count(orders.orderid) as Totalorders
from customers
join orders on customers.customername=orders.customername
group by customers.customername;

select*from frequentcustomer;



-- step1: create a temporray table to store unique rows

create temporary table temp_customers AS
select Min(CustomerID) AS CustomerID
From customers
GROUP BY customername, contactname, address, city, zipcode, country;

select * from temp_customers;

-- step 2: delete rows that are not in the temporary table
delete from customers
where CustomerID NOT IN (SELECT CustomerID FROM temp_customers);

-- step 3: Drop the temporary table
drop temporary table temp_customers;

ALTER TABLE customers Drop column email;

select*from customers;



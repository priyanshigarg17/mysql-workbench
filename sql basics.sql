create database testdb;
drop database testdb;
create database testdb;
use testdb;
create table customers(
customername varchar (255), 
contactname varchar(255),
address varchar(255), 
city varchar(255),
pincode int,
tel varchar(255),
country varchar(255)
);

select * from customers;
INSERT INTO 
customers(customername, contactname, address, city, pincode, tel, country)
VALUES
('Livia Interiors', 'Priyanshi Garg', '34 Rose Avenue', 'Jaipur', 302017, '9829012345', 'India'),
('Kitchen World', 'Ankit Sharma', '12 MG Road', 'Delhi', 110001, '9811223344', 'India'),
('Zenith Furnishings', 'Riya Mehta', '45 Palm Street', 'Mumbai', 400076, '9933445566', 'India'),
('Elegant Homes', 'Sahil Khanna', '22 Lake View', 'Chandigarh', 160036, '9786523145', 'India'),
('Modular Concepts', 'Neha Verma', '78 Sector 15', 'Noida', 201301, '9887766554', 'India'),
('DecoSpaces', 'Arjun Patel', '88 Dream Plaza', 'Ahmedabad', 380015, '9876543210', 'India'),
('Instyle Kitchens', 'Shruti Rao', '56 Blossom Lane', 'Hyderabad', 500081, '9700112233', 'India'),
('Interior Hub', 'Vijay Gupta', '14 Harmony Tower', 'Pune', 411038, '9866332211', 'India'),
('Kitchen Kraft', 'Pooja Bansal', '25 Main Street', 'Bengaluru', 560034, '9898989898', 'India'),
('Urban Style Co.', 'Rahul Sen', '102 Sector 9', 'Lucknow', 226010, '9123456789', 'India');

ALTER TABLE customers
MODIFY tel varchar(20);
select*from customers;
select * from customers where country="india";
select customername, contactname, address from customers;
select customername, contactname, address from customers limit 5;
select * from customers where country="india" and city="delhi";

select*from customers where city="Delhi" order by pincode;
select*from customers where city="Delhi" order by pincode desc;

set sql_safe_updates=0;
delete from customers where customername="Sumit";


update customers set contactname="Riyu", city="cal" where customername="Kitchen Kraft";
select * from customers;

select*from customers where city="Noida" and customername="Modular Concepts";
select*from customers where not city="Pune";
select count(customername) from customers;
select * from customers where pincode between 160036 and 201301;
select max(pincode) as largestprice from customers;

select*
From customers
where pincode = (
select max(pincode) from customers
);

insert into 
customers(customername, contactname, address, city, pincode, tel, country)
values
('Suran', 'Rakesh', 'ashok vihar', 'meerut', null, 9999898989, 'India'),
('Shresth', 'Savita', 'Mohali', 'chandigarh', 12346, 8997654321, 'India'),
('Ram', 'Ramesh', 'irish society', 'cork', null, 9765432198, 'Scotland');

select*from customers;
select*from customers where pincode is null;
select*from customers where pincode is not null;

create table department(
dept_id varchar(255) , dept_name varchar(255)
);
select * from department;

create table employee(
emp_id varchar (255), emp_name varchar(255) , dept_id varchar(255), salary int, hire_date int, email varchar(255)
);

select * from employee;
ALTER TABLE employee ADD emp_id INT NOT NULL;

ALTER TABLE employee DROP COLUMN hire_date;

INSERT INTO department
VALUES 
(1, 'IT'),
(2, 'HR'),
(3, 'Finance');

select * from department;

INSERT INTO employee (emp_id, emp_name, dept_id, salary, email)
VALUES 
    (101, 'Alice', 1, 60000.00, 'alice@example.com'),
    (102, 'Bob', 2, 55000.00, 'bob@example.com'),
    (103, 'Charlie', 3, 48000.00, 'charlie@example.com'),
    (104, 'David', 1, 62000.00, 'david@example.com'),
    (105, 'Eve', NULL, 70000.00, 'eve@example.com');

select * from employee;

select * from employee where salary between 50000 and 60000;
select*
From employee
where emp_id = (
select max(emp_id) from employee
);

select*from employee where dept_id is null;
select*from employee where dept_id is not null;
select max(salary) from employee;

insert into 
customers(customername, contactname, address, city, pincode, tel, country)
values
('verma', 'Rakesh', 'surat', 'NA', 123456, 9999898989, 'India'),
('surya', 'ritu', 'Mohali', 'chandigarh', 12346, 8997654321, 'India'),
('lakhan', 'Ram', 'irish society', 'NA',234567, 9765432198, 'new zealand');

select*from customers;
set sql_safe_updates=0;
UPDATE customers
set city ="Unknown"
where city ="NA";
select*from customers;

UPDATE customers
set city ="Unknown"
where city IN ('NA', 'N/A', 'null', '');

select*from customers;

UPDATE customers
set pincode = 345678
where pincode is null;

select*from customers;

update customers
set
city="unknown"
or
address="unknown"
where city IN ('NA', 'N/A', 'null', '')
or address in ('NA', 'N/A', 'null', '');


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

alter table customers add email varchar(255);

select * from orders;

select c.customername, o.orderid, o.orderdate
from customers c
join orders o on o.customername = c.customername;


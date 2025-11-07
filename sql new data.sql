create database northwind;
use northwind

-- customers table;

CREATE TABLE Customers(
	CustomerID CHAR(5) PRIMARY KEY,
    CompanyName VARCHAR(50),
    ContactName VARCHAR(50),
    City VARCHAR(50)
);

-- employee table

CREATE TABLE Employees(
	EmployeeID INT PRIMARY KEY, 
    LastName VARCHAR(50),
    FirstName VARCHAR(50),
    Title VARCHAR(50)
    );

-- category table
CREATE TABLE Categories (
	CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50)
);

-- supplier table
CREATE TABLE Suppliers(
	SupplierID INT PRIMARY KEY, 
    CompanyName VARCHAR(50),
    City VARCHAR(50)
);

-- products table
CREATE TABLE Products(
	ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    SupplierID INT,
    CategoryID INT, 
    UnitPrice DECIMAL (10, 2),
    FOREIGN KEY (SupplierID) references Suppliers(SupplierID),
    FOREIGN KEY (CategoryID) references Employees(EmployeeID)
);

-- Orders table

CREATE TABLE Orders (
	OrderID INT PRIMARY KEY,
    CustomerID CHAR(5),
    EmployeeID INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) references Customers(CustomerID),
    foreign key (EmployeeID) references Employees(EmployeeID)
);

-- orderdetils Table
CREATE TABLE OrderDetails (
	OrderID INT,
    ProductID INT, 
    Quantity INT,
    UnitPrice Decimal (10, 2),
    primary key (OrderID, ProductID),
    Foreign Key (OrderID) references Orders(OrderID),
    FOREIGN KEY (ProductID) references Products(ProductID)
);

-- Inserrt sample data
-- Customers (10 rows)
INSERT INTO Customers Values
('ALFKI', 'Alfreds Futterkiste', 'Maria Anders', 'Berlin'),
('ANATR', 'Ana Trujillo Emparedados', 'Ana Trujillo', 'Mexico City'),
('ANTON', 'Antonio Moreno', 'Antonio Moreno', 'Mexico City'),
('AROUT', 'Around the Horn', 'Thomas Hardy', 'London'),
('BERGS', 'Berglunds snabbköp', 'Christina Berglund', 'Luleå'),
('BLAUS', 'Blauer See Delikatessen', 'Hanna Moos', 'Mannheim'),
('BLONP', 'Blondel père et fils', 'Frédérique Citeaux', 'Strasbourg'),
('BOLID', 'Bólido Comidas preparadas', 'Martín Sommer', 'Madrid'),
('BONAP', 'Bon app''', 'Laurence Lebihan', 'Marseille'),
('BOTTM', 'Bottom-Dollar Markets', 'Elizabeth Lincoln', 'Tsawassen');

-- Employees(5 rows)
INSERT INTO Employees VALUES
(1, 'Davolio', 'Nancy', 'Sales Representative'),
(2, 'Fuller', 'Andrew', 'Vice President'),
(3, 'Leverling', 'Janet', 'Sales Representative'),
(4, 'Peacock', 'Margaret', 'Sales Representative'),
(5, 'Buchanan', 'Steven', 'Sales Manager');

-- categories(3 rows)
INSERT INTO Categories VALUES
(1, 'Beverages'),
(2, 'Condiments'),
(3, 'Confections');

-- suppliers (5 rows)
INSERT INTO Suppliers VALUES
(1, 'Exotic Liquids', 'London'),
(2, 'New Orleans Cajun', 'New Orleans'),
(3, 'Grandma Kelly''s', 'Ann Arbor'),
(4, 'Tokyo Traders', 'Tokyo'),
(5, 'Cooperativa de Quesos', 'Oviedo');

-- products (15 rows)
INSERT INTO Products VALUES
(1, 'Chai', 1, 1, 18.00),
(2, 'Chang', 1, 1, 19.00),
(3, 'Aniseed Syrup', 1, 2, 10.00),
(4, 'Chef Anton''s Cajun Seasoning', 2, 2, 22.00),
(5, 'Chef Anton''s Gumbo Mix', 2, 2, 21.35),
(6, 'Grandma''s Boysenberry Spread', 3, 2, 25.00),
(7, 'Uncle Bob''s Organic Dried Pears', 3, 3, 30.00),
(8, 'Northwoods Cranberry Sauce', 3, 2, 40.00),
(9, 'Mishi Kobe Niku', 4, 3, 97.00),
(10, 'Ikura', 4, 3, 31.00),
(11, 'Queso Cabrales', 5, 3, 21.00),
(12, 'Queso Manchego La Pastora', 5, 3, 38.00),
(13, 'Konbu', 4, 1, 6.00),
(14, 'Tofu', 4, 1, 23.25),
(15, 'Genen Shouyu', 4, 2, 15.50);

-- orders(25 rows)
INSERT INTO Orders VALUES
(1001, 'ALFKI', 1, '2024-01-15'),
(1002, 'ANATR', 2, '2024-01-18'),
(1003, 'ANTON', 1, '2024-01-19'),
(1004, 'AROUT', 4, '2024-02-01'),
(1005, 'BERGS', 3, '2024-02-12'),
(1006, 'BLAUS', 5, '2024-02-14'),
(1007, 'BLONP', 1, '2024-02-15'),
(1008, 'BOLID', 2, '2024-02-20'),
(1009, 'BONAP', 3, '2024-03-01'),
(1010, 'BOTTM', 4, '2024-03-03'),
(1011, 'ALFKI', 5, '2024-03-10'),
(1012, 'ANATR', 1, '2024-03-11'),
(1013, 'ANTON', 2, '2024-03-13'),
(1014, 'AROUT', 4, '2024-03-15'),
(1015, 'BERGS', 3, '2024-03-20'),
(1016, 'BLAUS', 5, '2024-03-22'),
(1017, 'BLONP', 1, '2024-03-23'),
(1018, 'BOLID', 2, '2024-03-25'),
(1019, 'BONAP', 3, '2024-03-27'),
(1020, 'BOTTM', 4, '2024-03-28'),
(1021, 'ALFKI', 5, '2024-04-01'),
(1022, 'ANATR', 1, '2024-04-03'),
(1023, 'ANTON', 2, '2024-04-05'),
(1024, 'AROUT', 4, '2024-04-07'),
(1025, 'BERGS', 3, '2024-04-08');


INSERT INTO OrderDetails VALUES
(1001, 1, 5, 18.00),
(1001, 2, 2, 19.00),
(1002, 3, 10, 10.00),
(1002, 4, 3, 22.00),
(1003, 5, 1, 21.35),
(1004, 6, 2, 25.00),
(1004, 7, 5, 30.00),
(1005, 8, 4, 40.00),
(1006, 9, 2, 97.00),
(1007, 10, 6, 31.00),
(1008, 11, 3, 21.00),
(1009, 12, 2, 38.00),
(1010, 13, 1, 6.00),
(1011, 14, 3, 23.25),
(1012, 15, 4, 15.50),
(1013, 1, 5, 18.00),
(1014, 2, 6, 19.00),
(1015, 3, 2, 10.00),
(1016, 4, 3, 22.00),
(1017, 5, 7, 21.35),
(1018, 6, 5, 25.00),
(1019, 7, 4, 30.00),
(1020, 8, 3, 40.00),
(1021, 9, 2, 97.00),
(1022, 10, 1, 31.00),
(1023, 11, 6, 21.00),
(1024, 12, 3, 38.00),
(1025, 13, 5, 6.00),
(1002, 14, 2, 23.25),
(1004, 15, 1, 15.50),
(1006, 1, 3, 18.00),
(1007, 2, 4, 19.00),
(1008, 3, 2, 10.00);

select*from customers;

-- customers with missing company name or contactname
select*from customers
where CompanyName is null or ContactName is null;

select*from products
where SupplierID is null or CategoryID is null;

-- check for negatives or zero unit prices
select * from Products
where UnitPrice<=0;

select*from OrderDetails
where UnitPrice <=0 or Quantity <=0;

-- check for orders without order details
select o.OrderID
FROM Orders o
LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
Where od.OrderID IS NULL;

-- Detect Products Without a Category or Supplier
SELECT ProductID, ProductName
From Products
WHERE CategoryID NOT IN (select CategoryID from Categories)
 or SupplierID not in (select SupplierID FROM Suppliers);
 
-- orders with invalid employeeID or customerID
-- orders referencing non-existent employees
select*from Orders
where EmployeeID NOT IN (SELECT EmployeeID from Employees);

-- orders referencing non-existent customers
select*from Orders
Where CustomerID NOT IN (SELECT CustomerID from Customers);

-- Data Integrity Validation Queries
-- Detect Duplicate Primary Keys
-- orderdetails duplicate check(composite key)

select OrderID, ProductID, COUNT(*)
FROM OrderDetails
group by OrderID, ProductID
Having Count(*) >1;

-- check for referential integrity violations
-- orderdetails referencing non-existent orders or products

select * from OrderDetails
WHERE OrderID NOT IN (SELECT OrderID FROM Orders)
	or ProductID NOT IN (SELECT ProductID FROM Products);
    
-- Producty assigned to non-existent categories or suppliers
SELECT*FROM Products
WHERE CategoryID NOT IN (SELECT CategoryID FROM Categories)
	OR SupplierID NOT IN (SELECT SupplierID FROM Suppliers);

-- orders with incorrect total (Manual Validation)
-- compare actaul order total (manual ) with expected sum (e. g form a column if it existed)
SELECT o.OrderID, SUM(od.Quantity* od.UnitPrice) AS CalculatedTotal
from Orders o
join OrdersDetails od ON o.OrderID = od.OrderID
group by o.OrderID;



-- categories with no products
select * from Categories
Where CategoryID NOT IN (SELECT DISTINCT CategoryID FROM Products);

-- Orders placed in the future
SELECT * FROM Orders
WHERE OrderDate> current_date;

-- Products with unusually high prices (outlier detection)
-- Assuming 1000 is an unsually high prices threshold

select * from Products
WHERE UnitPrice> 1000;

-- customers with no orders
select c.CustomerID, c.CompanyName
from Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

-- employees iwth no orders assigned
select e.EmployeeID, e.FirstName, e.LastName
FROM Employees e
LEFT JOIN Orders o ON e.EmployeeID = o.EmployeeID
WHERE o.OrderID is null;

-- Products That were never orders
select p.ProductID, p.ProductName
FROM Products p
LEFT JOIN OrderDetails od ON p.ProductID = od.ProductID
WHERE od.OrderID is null;

-- Orders with More Than 10 Products (Bulk Orders)
SELECT OrderID, COUNT(*) AS ProductCount
FROM OrderDetails
GROUP BY OrderID
HAVING COUNT(*) > 10;

-- Orders with High Total Value (Suspicious or Premium)
SELECT o.OrderID, SUM(od.Quantity * od.UnitPrice) AS TotalValue
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY o.OrderID
HAVING TotalValue > 5000;

-- Employees with Overlapping Titles
SELECT Title, COUNT(*) AS CountByTitle
FROM Employees
GROUP BY Title
HAVING COUNT(*) > 1;

 -- Products with Missing Price (Nulls or Zero)
SELECT * FROM Products
WHERE UnitPrice IS NULL OR UnitPrice = 0;
    
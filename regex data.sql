create database regexsql;
use regexsql;

-- create departments
Create table departments(
	dept_id INT PRIMARY KEY auto_increment,
	dept_name VARCHAR(100) NOT NULL
);

-- create employees
CREATE TABLE employees(
	emp_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR (50),
    hire_date DATE,
    salary DECIMAL(12, 2),
    dept_id INT,
    FOREIGN KEY (dept_id) references departments (dept_id)
		ON UPDATE CASCADE
        ON DELETE SET NULL
	);
    
    --  UPDATE CASCADE -- If the primary key value in the parent table changes, 
-- the foreign key values in the child table will be updated automatically to match.

-- DELETE SET NULL -- If the parent row is deleted, 
-- the foreign key column in the child table is set to NULL (instead of being deleted or causing an error).
    
    -- CREATE PROJECTS
    CREATE TABLE projects(
		project_id INT PRIMARY KEY AUTO_INCREMENT,
        project_name VARCHAR (100),
        start_date DATE,
        end_date DATE,
        budget DECIMAL(14, 2)
	);
    
    -- assignment table (many - to - many)
    CREATE TABLE employee_projects (
		emp_id INT NOT NULL,
        project_id INT NOT NULL, 
        assigned_on DATE DEFAULT (CURRENT_DATE),
        PRIMARY KEY (emp_id, project_id),
        FOREIGN KEY (emp_id) REFERENCES employees (emp_id)
			ON UPDATE CASCADE
            ON DELETE CASCADE,
		FOREIGN KEY (project_id) REFERENCES projects (project_id)
			ON UPDATE CASCADE
            ON DELETE CASCADE
);

select*from employees
-- delete cascade -- complete row will be deleted

-- sales table
CREATE TABLE sales (
	sale_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT, 
    sale_date DATE,
    amount DECIMAL (12, 2),
    FOREIGN KEY (emp_id) REFERENCES employees (emp_id)
		ON UPDATE CASCADE
        ON DELETE SET NULL
);

-- department 
INSERT INTO departments (dept_id, dept_name)
VALUES
(1, "research"),
(2, 'sales'),
(3, 'HR');


select * from departments

INSERT INTO 
PROJECTS (project_id, project_name, start_date, end_date, budget)
VALUES 
(100, 'AI Platform', DATE '2024-01-01', DATE '2024-12-31', 500000),
(101, 'Sales Dashboard', DATE '2024-03-15', DATE '2024-09-30', 150000),
(102, 'HR Portal', DATE '2024-05-01', DATE '2024-11-30', 120000),
(103, 'Research Initiative', DATE '2023-10-01', DATE '2025-03-31', 800000),
(104, 'Legacy Migration', DATE '2024-07-01', DATE '2025-01-31', 200000);

select*from projects;


set sql_safe_updates = 0;
delete from employees;
ALTER TABLE employees AUTO_INCREMENT = 1;

INSERT INTO 
EMPLOYEES 
(first_name, last_name, hire_date, salary, dept_id)
VALUES 
('Alice', 'Wong', DATE '2023-01-15', 75000, 1),
('Bob', 'Patel', DATE '2022-06-01', 50000, 2),
('Charlie', 'Singh', DATE '2021-09-23', 120000, 1),
('Diana', 'Kumar', DATE '2024-03-10', 45000, 3),
('Ethan', 'Roy', DATE '2023-11-05', 68000, 2),
('Fiona', 'Desai', DATE '2020-12-30', 98000, 1),
('George', 'Mehta', DATE '2023-07-19', 39000, NULL),
('Hannah', 'Shah', DATE '2022-02-14', 54000, 3),
('Ian', 'Chopra', DATE '2023-05-30', 83000, 2),
('Jaya', 'Reddy', DATE '2021-08-08', 105000, NULL);

select*from employees

INSERT INTO
employee_projects (emp_id, project_id, assigned_on)
VALUES
(1, 100, DATE '2024-01-05'),
(3, 100, DATE '2024-01-10'),
(6, 103, DATE '2023-10-15'),
(2, 101, DATE '2024-03-20'),
(5, 101, DATE '2024-04-01'),
(4, 102, DATE '2024-05-05'),
(8, 102, DATE '2024-05-10'),
(9, 101, DATE '2024-06-01');

select*from employee_projects;

INSERT INTO 
SALES(sale_id, emp_id, sale_date, amount)
VALUES
(1000, 2, DATE '2024-01-10', 12000),
(1001, 2, DATE '2024-02-05', 8000),
(1002, 5, DATE '2024-03-12', 22000),
(1003, 9, DATE '2024-04-01', 15000),
(1004, 9, DATE '2024-05-10', 17000),
(1005, 1, DATE '2024-06-20', 5000),
(1006, 3, DATE '2024-07-01', 30000),
(1007, 3, DATE '2024-07-18', 18000),
(1008, 8, DATE '2024-02-28', 9000),
(1009, 4, DATE '2024-08-01', 11000);

select*from sales;

select emp_id, first_name,last_name from employees;

-- filter records with salary greater than 50000

select emp_id, first_name,last_name from employees
where salary > 50000

-- employees without dept

select*from employees where dept_id is null;

-- list all employees hirec after jan 1 2023
select*from employees where hire_date> "2023-01-01";
 
 -- retrive all employes with salary between 40000 and 90000
 select*from employees where salary between 40000 and 90000;
 
 -- sort employees based on hire date: desc
select*from employees order by hire_date desc

-- list all employees with their dept names
SELECT e.emp_id, 
       e.first_name, 
       e.last_name, 
       d.dept_name
FROM employees e
Left JOIN departments d ON e.dept_id = d.dept_id;

-- list of all employees including the ones without department
SELECT e.emp_id, 
       e.first_name, 
       e.last_name, 
       d.dept_name
FROM employees e
left JOIN departments d ON e.dept_id = d.dept_id;

-- find average salary per dept
SELECT avg(e.salary) as average_salary,
       d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name;

-- Find average salary per department.
select AVG(salary) as AvgSalary,
d.dept_name
from employees e
join deptartments d ON e.dept_id = d.dept_id

-- List departments where total salary exceeds 200,000.
select dept_name, 
	SUM(e.salary) 
	from departments d
	Left Join employees e ON e.dept_id = d.dept_id
	Group by d. dept_name
	Having SUM(e.salary) > 200000
    
-- Count how many projects each employee is assigned to; display only those with 2+ projects.
SELECT 
    e.emp_id,
    e.first_name,
    e.last_name,
    COUNT(p.project_id) AS project_count
FROM employees e
JOIN employee_projects p 
    ON e.emp_id = p.emp_id
GROUP BY e.emp_id, employee_name
HAVING COUNT(p.project_id) >= 2;

-- List projects that have at least one employee assigned.
SELECT p.project_id, p.project_name, count(ep.emp_id) as employee_count
FROM projects p
JOIN employee_projects ep 
    ON p.project_id = ep.project_id
    group by p.project_id, p.project_name
    HAVING count(ep.emp_id)>=1;
    
-- Find employees not working on any project.
select e.emp_id, p.project_id
from employees e
left join employee_projects p on e.emp_id=p.emp_id
where p.project_id is null;
 
-- Show employees who share department with someone earning >100,000
select e.emp_id, e.salary, d.dept_name
from employees e
join departments d on d.dept_id = e.dept_id
where e.dept_id in (select dept_id
	from employees 
    where salary > 100000 AND dept_id is not null)

-- merge two columns (join first and last name along with salary rounded)

select e.emp_id as "Employee ID", concat(e.first_name, ' ',  e.last_name) as full_name,
round(e.salary, 0) as salary_rounded    
from employees e;

-- to add months (date_expr, n) returns a new date that is n months after date_expr
-- date_add(date, interval n month) -> to add months
-- date_format(date, format)--> to format the date
select emp_id, hire_date,
date_format(date_add(hire_date, interval 6 month), "%d-%b-%Y") as six_months_later
from employees;

-- show employees and their assigned projects
select e.emp_id, e.first_name, e.last_name, p.project_name
from employees e
join employee_projects ep
on e.emp_id = ep.emp_id
join projects p
on ep.project_id = p.project_id
order by emp_id

-- find projects with no employees assigned
select p.project_id, p.project_name
from projects p
left outer join employee_projects ep
on p.project_id = ep.project_id
where ep.emp_id is null;

-- employees in departments that have budgeted projects

select emp_id, first_name 
from employees
where dept_id in(select distinct d.dept_id
from departments d
join employees e on d.dept_id = e.dept_id
where salary < 60000)

-- or the other method for the above

select emp_id, first_name 
from employees e_outer
where exists (select 1 from employees e_inner
where e_inner.dept_id = e_outer.dept_id)

-- projects -- employee_projects
select project_id, project_name 
from projects p
where exists (select 1 from employee_projects ep
where p.project_id = ep.project_id)

-- employees exists in employees but bnot in employee_projects
SELECT e.emp_id, e.first_name
FROM employees e
WHERE NOT EXISTS (
    SELECT 1
    FROM employee_projects ep
    WHERE ep.emp_id = e.emp_id
);

-- or the other method for the above

SELECT e.emp_id, e.first_name
FROM employees e
LEFT JOIN employee_projects ep 
    ON e.emp_id = ep.emp_id
WHERE ep.emp_id IS NULL;

-- or the other method for the above
SELECT e.emp_id, e.first_name
FROM employees e
where e.emp_id not in(
	select ep.emp_id
    from employee_projects ep
);

-- salary rank within department
select e.emp_id, e.first_name, e.last_name, e.dept_id, d.dept_name, e.salary,
rank() over (partition by dept_id order by salary desc) as salary_rank
from employees e
left join departments d on d.dept_id = e.dept_id;

-- salary rank within department with coalesce
select e.emp_id, e.first_name, e.last_name, e.dept_id, e.salary,
coalesce(d.dept_name, "unassigned") as dept_name,
rank() over (partition by dept_id order by salary desc) as salary_rank
from employees e
left join departments d on d.dept_id = e.dept_id;

-- identify top 2 employees per department by salary
select * from(SELECT 
		e.emp_id,
        e.first_name ,
        e.last_name,
        e.dept_id,
        e.salary,
	RANK() OVER(PARTITION BY e.dept_id 
    ORDER BY salary DESC) AS salary_rank
	FROM employees e ) as t
	where t.salary_rank <=2 
	order by dept_id,salary_rank;

-- cumulative sales per employee over time
select sale_id,emp_id,sale_date,amount,
sum(amount) over (partition by emp_id order by sale_date) as total
from sales;

-- compute avg of sales employee over time
select sale_id,emp_id,sale_date,amount,
avg(amount) over (partition by emp_id order by sale_date) as total
from sales;

-- compute a 3-period moving avg of sales amount per employee
select sale_id,emp_id,sale_date,amount,
avg(amount) over (partition by emp_id order by sale_date
rows between 2 preceding and current row) as moving_avg
from sales;

-- Add three new employee to different departments
select * from departments;

INSERT INTO Employees (first_name, last_name, hire_date, salary, dept_id) VALUES
('Amit', 'Sharma', '2023-05-15', 50000.00, 1),   
('Divya', 'Khandelwal', '2023-07-01', 60000.00, 2), 
('Sneha', 'Kapoor', '2024-01-20', 70000.00, 3); 

set sql_safe_updates = 0;
-- give a 5 % raise to employees hired before a given date
UPDATE Employees
SET salary = salary * 1.05   
WHERE hire_date < '2023-01-10';

-- update a project  104 if it exists or insert otherwise
INSERT INTO projects (project_id,project_name,start_date,end_date,budget)
values (104,'legacy migrations',DATE '2024-07-01',DATE '2025-01-31',250000) as new
on duplicate key update
project_name = new.project_name,
start_date = new.start_date,
end_date = new.end_date,
budget = new.budget;

-- delete unassigned employees
delete from employees
where dept_id is null;

select*from employees

-- add a constraint so project budget must be >=0
ALTER TABLE projects
ADD CONSTRAINT chk_budget_nonnegative
CHECK (budget >= 0);

-- create an index
create index idx_employees_hire_date
on employees (hire_date);

select emp_id, first_name, last_name, salary
from employees
where hire_date between '2023-01-01' and '2023-12-31'
order by hire_date;

select emp_id, first_name, last_name, hire_date
from employees
where hire_date >= "2023-01-01";

explain
select emp_id, first_name, last_name, hire_date
from employees
where hire_date between '2023-01-01' and '2023-12-31';

-- composite key
create index idx_employees_dept_hiredate
on employees (dept_id, hire_date)

-- employees in sales (dept id=2) and hire date in 2023
SELECT emp_id, first_name, dept_id, hire_date
FROM employees
WHERE dept_id = 2 and hire_date>= '2023-01-01';

-- for multiple
SELECT emp_id, first_name, dept_id, hire_date
FROM employees
WHERE dept_id in (2,3)
  AND YEAR(hire_date) = 2023
  order by hire_date; 

-- returns employees hired within the past 12 months
select * from employees
where hire_date  >= date_sub(curdate(), interval 1 year);

-- lag
-- LAG(salary, 1) -> "give me the salary value from one row before the current row"
-- If you omit the 1, it defaults to one row propr anyway; the second arguments lets you look further back(e.g lag (salary, 2) for two rows

select emp_id, salary,
	LAG(salary, 1) over(order by salary) as prev_salary,
    lead(salary, 1) over (order by salary) as next_salary
from employees;




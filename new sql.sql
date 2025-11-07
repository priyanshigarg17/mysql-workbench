-- update salaries of sales employees
update employees e
JOIN departments d on e.dept_id = d.dept_id
set e.salary = e.salary * 1.05
where d.dept_name = 'sales';

-- depatment - wise headcount by salary band (cnditional aggregation)
select d.dept_name,
sum(salary < 50000) as below_50k,
sum(salary between 50000 and 100000) as _50_100k,
sum(salary > 100000) as _100k
from employees e join departments d on e.dept_id = d.dept_id
group by d.dept_name;

-- employees whose projects all end in 2024
SELECT e.emp_id,
       CONCAT(e.first_name, ' ', e.last_name) AS employee_name
FROM employees e
WHERE EXISTS (
    SELECT 1
    FROM employee_projects ep
    JOIN projects p ON ep.project_id = p.project_id
    WHERE ep.emp_id = e.emp_id
)  -- has at least one project
AND NOT EXISTS (
    SELECT 1
    FROM employee_projects ep
    JOIN projects p ON ep.project_id = p.project_id
    WHERE ep.emp_id = e.emp_id
      AND YEAR(p.end_date) <> 2024   -- any project not ending in 2024
);

select e.emp_id, e.first_name
from employees e 
join employee_projects ep on e.emp_id = ep.emp_id
join projects p on ep.project_id = p.project_id
group by e.emp_id, e.first_name
having
	count(*)>0 -- count(*) > 0-> must have projects
    and min(p.end_date) >= '2024-01-01'
    and max(p.end_date) < '2025-01-01';

-- the earliest (min) is not before 2024
-- the latest (max) is not after 2024. 

-- top earners per department
with ranked as 
(select e.*, row_number() over (partition by dept_id order by salary desc) rn
	from employees e)
select *
from ranked
where rn <=2;

-- calender
with recursive dates as (
	select date('2024-01-01') d
    union all
    select d+ interval 1 day
    from dates
    where d < '2024-12-31'
)
select d as calender_day
from dates;


-- dense rank / percent_rank
select emp_id,dept_id,salary,
dense_rank() over(partition by dept_id order by salary desc) as d_rnk
from employees;

select emp_id,dept_id,salary,
rank() over(partition by dept_id order by salary desc) as d_rnk
from employees;

select emp_id,dept_id,salary,
percent_rank() over(partition by dept_id order by salary desc) as d_rnk,
from employees;

select emp_id, sale_date, amount,
first_value(amount) over (partition by emp_id order by sale_date 
									rows between unbounded preceding and current row) as first_amt,
	last_value(amount) over (partition by emp_id order by sale_date 
									rows between unbounded preceding and current row) as last_amt
from sales
order by emp_id, sale_date;

-- roll up
-- what roll up does
-- normally, group by d.dept_name, yr--> gives total per department per year.

select 
	d.dept_name,
    year(s.sale_date) AS yr,
    sum(s.amount) as total
from sales s
left join employees e on s.emp_id = e.emp_id
left join departments d on e.dept_id= d.dept_id
group by d.dept_name, yr with rollup;

-- roll up without null

select 
	case when grouping (dept_name) = 1 THEN "ALL DEPARTMENTS" else dept_name end as dept_name,
    CASE WHEN GROUPING(yr) = 1 THEN "ALL YEARS" else CAST (Yr AS CHAR) END AS yr,
    SUM(amount) AS total
FROM (select 
	d.dept_name,
    year(s.sale_date) AS yr,
    sum(s.amount) as total
from sales s
left join employees e on s.emp_id = e.emp_id
left join departments d on e.dept_id= d.dept_id) AS t
group by d.dept_name, yr with rollup;

-- build quarterly totals: total sales quarter wise per employee
select emp_id,
	quarter(sale_date) as qtr,
    year(sale_date) as yr,
    SUM (amount) as q_amt
from sales
group by emp_id, yr, qtr
	
    
-- previous quarter sales
with q as(select emp_id,
	quarter(sale_date) as qtr,
    year(sale_date) as yr,
    SUM (amount) as q_amt
from sales
group by emp_id, yr, qtr)
select q.*,
LAG(q_amt) OVER (PARTITION BY emp_id, yr ORDER BY qtr) AS prev_q

-- calculate qoq growth %
round(00*(q_amt - LAG(q_amt) OVER (PARTITION BY emp_id, yr ORDER BY qtr))
/nullif(LAG(q_amt) OVER (PARTITION BY emp_id, yr ORDER BY qtr),0,2) as qoq_pct -- nullif sure that division by zero gives zero
from q;


WITH q AS (
   SELECT emp_id,
          QUARTER(sale_date) AS qtr,
          YEAR(sale_date) AS yr,
          SUM(amount) AS q_amt
   FROM sales
   GROUP BY emp_id, yr, qtr
)
-- calculate qoq growth %
SELECT q.*,
       LAG(q_amt) OVER (PARTITION BY emp_id, yr ORDER BY qtr) AS prev_q,
       ROUND(
         100*(q_amt - LAG(q_amt) OVER (PARTITION BY emp_id, yr ORDER BY qtr))
         / NULLIF(LAG(q_amt) OVER (PARTITION BY emp_id, yr ORDER BY qtr),0),
         2
       ) AS qoq_pct
FROM q;

-- find last names with two consecutive vowels
select * from employees
where last_name  REGEXP '[aeiou] {2}';

select emp_id, CONCAT(UCASE(LEFT(first_name, 1)), LCASE(SUBSTRING(first_name,2))) AS first_norm
from employees;

-- 
create or replace view v_emp_comp
as select emp_id, first_name, last_name, dept_id, salary from employees



-- stored function computes and return a single result
-- function: tenure in months
-- must declare deterministic or not deterministic
delimiter //
create function tenure_months(p_emp int) returns int deterministic
begin 
declare d date;
select hire_date into d
from employees
where emp_id = p_emp;
return timestampdiff(month,d,curdate());
end//
delimiter ;

select * from employees;

select tenure_months(6) as tenure_in_months;

-- function can be called inside sql query (inline in query)


-- stored procedure: award bonus for top N per dept

delimiter //
create procedure top_n_bonus(in p_n int, p_pct decimal(5,2))
begin
with ranked as (select emp_id, dept_id,
row_number() over(partition by dept_id order by salary desc) rn
from employees)
update employees e
join ranked r on e.emp_id = r.emp_id
set e.salary = e.salary * (1 + p_pct/100)
where r.rn <= p_n;
end//

show procedure status where db = 'regexsql'and name = 'top_n_bonus';

call top_n_bonus(2,10); -- explicit call

-- verify procedure result
SELECT emp_id, first_name, dept_id, salary
FROM employees
ORDER BY dept_id, salary DESC;

-- drop procedure top_n_bonus;


-- triggers: fires automatically when a row-level/table-level event occurs (insert,delete,update)

-- functions
-- Tenure band from hire date like junior, mid, senior etc 
delimiter //
create function tenure_band(p_emp_id int) returns int deterministic
begin
SELECT 
    e.emp_id,
    e.first_name,
    e.hire_date,
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) < 1 THEN 'Junior'
        WHEN TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) BETWEEN 1 AND 3 THEN 'Mid'
        ELSE 'Senior'
    END AS tenure_band
FROM employees e;
end//
delimiter ;


-- Department headcount (no. of employees per department)
SELECT 
    d.dept_id,
    d.dept_name, 
    COUNT(e.emp_id) AS headcount
FROM departments d
LEFT JOIN employees e 
    ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name;

-- Employee’s total sales for a year
select e.emp_id, e.first_name, sum(s.amount), year(s.sale_date) as yr
from employees e
join sales s on e.emp_id = s.emp_id
group by e.emp_id, yr, e.first_name;

-- Salary after hypothetical bonus %
SELECT 
    emp_id,
    first_name,
    salary AS original_salary,
    0.10 AS bonus_percent,   -- example: 10% bonus
    salary + (salary * 0.10) AS salary_after_bonus
FROM employees;

-- procedures
delimiter //
create procedure shw_emp()
begin
select * from employees;
end //
delimiter ;

call shw_emp();

-- show employees of department
delimiter //
create procedure shw_emp_dept(p_dept_id int)
begin
select emp_id, first_name from employees 
where dept_id = p_dept_id;
end //
delimiter ;

call shw_emp_dept(1);

-- show employees earning above the salary
delimiter //
create procedure shw_emp_salary(p_salary int)
begin
select emp_id, first_name from employees 
where salary > p_salary;
end //
delimiter ;

call shw_emp_salary(95033.40);

-- show sales of an employee
delimiter //
create procedure emp_sales(p_emp_id int)
begin
select sale_id, sale_date from sales
where emp_id = p_emp_id;
end //
delimiter ;

call emp_sales(4)

-- change department of an employee
DELIMITER //
CREATE PROCEDURE change_department(IN p_emp_id INT, IN p_dept_id INT)
BEGIN 
    UPDATE employees
    SET dept_id = p_dept_id
    WHERE emp_id = p_emp_id;
END //
DELIMITER ;

call change_department(4,2);

-- show average salary in the department
delimiter //
create procedure shw_avg_slry(p_depmt_id int)
begin
select dept_id, avg(salary)
from employees
where dept_id = p_depmt_id
group by dept_id;
end //
delimiter ;

call shw_avg_slry(3);

-- insert a new department
delimiter //
create procedure insert_dept()
begin
insert into departments (dept_id, dept_name)
values (4, "new_dept");
end //
delimiter ;

call insert_dept();

-- general syntax
create trigger triggger_name
before insert on table_name
for each row
begin
 -- logic here
end;

usage of trigger
1. data quality or validation: prevent injserting invalid data, ensure salary>0
2. auditing or logging(who changed what)
3. enforce business rule
4. cascading actions:

delimiter //
create trigger trg_sales
before insert on sales -- this means trigger fires befor insert
for each row
begin
if new.amount<= 0 then
signal sqlstate '45000' -- raise error 
set message_text = 'sale amount must be positive';
end if;
end//

insert into sales(emp_id, sale_date, amount)
values(2, '2025-09-08', -500);



-- tenure band
DROP FUNCTION IF EXISTS tenure_band//

DELIMITER //
CREATE FUNCTION tenure_band(p_emp INT)
RETURNS VARCHAR(20)
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE m INT DEFAULT NULL;

  SELECT TIMESTAMPDIFF(MONTH, hire_date, CURDATE())
    INTO m
  FROM employees
  WHERE emp_id = p_emp;

  RETURN (
    CASE
      WHEN m IS NULL THEN 'Unknown'
      WHEN m < 12   THEN 'Junior'
      WHEN m < 36   THEN 'Mid'
      WHEN m < 72   THEN 'Senior'
      ELSE 'Expert'
    END
  );
END//
DELIMITER ;

show function status where db = "regexsql" and name  = "tenure_band";

select tenure_band(2);

select emp_id, first_name, hire_date, tenure_band(emp_id) as band
from employees
order by emp_id;

-- department headcount
delimiter //
create function dept_headcount(p_dept int)
returns int deterministic
begin
return (select count(*) from employees where dept_id =  p_dept);
end//

select dept_id, dept_headcount(dept_id) from departments;

-- employee's total sales for a year
delimiter //
create function emp_sales_year(p_emp int, p_year int)
returns decimal(14,2) deterministic -- 14 is total digits 14 before after decmimal  and 2 after decimal 
begin
return coalesce((
select sum(amount) from sales
where emp_id = p_emp
and sale_date >= concat(p_year, '-01-01')
and sale_date < concat(p_year+1, '-01-01')), 0.00);
end//
delimiter ;

select emp_id, emp_sales_year(emp_id, 2024) as sale2024 from employees;

-- salary after hypothetical bonus%
delimiter //
create function salary_with_bonus(p_emp INT, p_pct DECIMAL(5,2))
returns decimal(12, 2) deterministic
begin
	return (select round(salary*(1+p_pct/100), 2)
    from employees where emp_id = p_emp);
end//
delimiter ;

-- do all projects end in 2024?
delimiter //
create function project_end(p_emp int)
returns int deterministic
begin 
	declare v_result tinyint default 0;
-- check if this employee has projects and all end in 2024
select
case
when count(*)>0
    and min(p.end_date) >= '2024-01-01'
    and max(p.end_date) < '2025-01-01'
    then 1 else 0
    end
into v_result
from employee_projects ep
join projects p on ep.project_id = p.project_id
where emp_id = p_emp;
return v_result;
end //
delimiter ; 

-- find employees who earn more than the average salary
    
select emp_id, first_name, avg(salary) as avg_salary 
from employees 
where salary in (select emp_id, first_name, avg(salary)
where salary>avg_salary

select dept_id from employees
group by dept_id
having count(emp_id)>5;





-- for ex -> let's design a trigger on your sales table that does two things:

-- prevent invalid inserts ( no sales with amount<=0)

-- logs changes when a sales's amount is updated.

select * from sales;

-- before trigger, create an audit table to store changes
create table sales_audit (
audit_id int auto_increment primary key,
sale_id int,
emp_id int,
old_amount decimal(12,2),
new_amount decimal(12,2),
changed_at timestamp default current_timestamp,
action varchar(20) -- 
);
-- trigger to block invalid sales amount
DELIMITER //
create trigger trg_sales_non_negative
before insert on sales -- This means the trigger fires before a new row is inserted into the sales table.
FOR EACH ROW
begin
if new.amount <= 0 then
signal sqlstate '45000'
SET MESSAGE_TEXT = 'Sale amount must be positive';
end if;
end//

-- trigger to log updates
DELIMITER //
create trigger trg_sales_audit_ai
after insert on sales -- The trigger fires automatically after an UPDATE occurs on the sales table
FOR EACH ROW -- So it only runs when a row in sales is updated.
begin
insert into sales_audit(sale_id,emp_id, old_amount,new_amount,action) -- to describe what kind of change happened
values(NEW.sale_id,NEW.emp_id,NULL,new.amount,'insert');
end//


-- log amount changes
create trigger trg_sales_audit_final
after update on sales
for each row
begin 
	if old.amount <> new.amount then
       insert into sales_audit (sale_id, emp_id, old_amount, new_amount, action)
       values (old.sale_id, old.emp_id, old.amount, new.amount, "update");
	end if;
    end//
    
    -- insert trigger: only new.* exists. we log the creation with old_amount = null, new_amount = new.amount
    
-- Insert (logs INSERT)
INSERT INTO sales (sale_id, emp_id, sale_date, amount) VALUES (4001, 2, '2025-09-11', 12000);

-- Update (logs UPDATE)
UPDATE sales SET amount = 15000 WHERE sale_id = 4001;

-- Negative test (blocked)
UPDATE sales SET amount = -1 WHERE sale_id = 4001;  -- should error with our message

-- See audit trail
SELECT * FROM sales_audit ORDER BY audit_id;

-- prevent inserting employees with salary below minimum
delimiter //
create trigger trg_min_salary
before insert on employees 
for each row
begin
if new.salary< 10000 then
signal sqlstate '45000' -- raise error 
set message_text = 'salary must be at least 10,000';
end if;
end//

-- auto-assign default department if null
-- Trigger: Auto-assign default department if null
DELIMITER //

create trigger auto_assign
before insert on employees
for each row 
begin
    if new.dept_id is null then
       set new.dept_id = 1; 
    end if;
end//

DELIMITER ;


alter table sales add column commission decimal(10,2);

-- auto calculate sales commission
delimiter //
create trigger sales_commission
before insert on sales
for each row 
begin
    set new.commission = new.amount * 0.50;
end//
delimiter ;

insert into sales (sale_id, emp_id, sale_date, amount)
values (5001, 2, "2025-09-11", 20000);

select*from sales;

-- prevent deleting a department with employees
delimiter //
create trigger prevent_dele
before delete on departments
for each row 
begin
    if (select count(*)from employees where dept_id = old.dept_id)  > 0  then
        signal sqlstate '45000'
        set message_text = 'Cant delete department';
   end if;
end//
delimiter ;

-- sql cursors in mysql

declare cursor_name CURSOR FOR
    select col1, col2 from table where condition

open cursor_name;
fetch cursor_name into variable_List;
close cursor_name

-- important pieces;
declare cursor: defines the query the cursor will run
open: executes the query
fetch: reads one row at a time into variables
close: releases resources

-- give 5% raise to employees earning < 5000
DELIMITER //

CREATE PROCEDURE raise_low_salary()
BEGIN
  DECLARE v_emp_id INT;
  DECLARE v_salary DECIMAL(12,2);
  DECLARE done INT DEFAULT 0;

  DECLARE cur CURSOR FOR
    SELECT emp_id, salary FROM employees WHERE salary < 50000;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  OPEN cur;

  loop_rows: LOOP
    FETCH cur INTO v_emp_id, v_salary;
    IF done = 1 THEN
      LEAVE loop_rows;
    END IF;

    UPDATE employees
    SET salary = v_salary * 1.05
    WHERE emp_id = v_emp_id;
end loop;
close cur;
end//

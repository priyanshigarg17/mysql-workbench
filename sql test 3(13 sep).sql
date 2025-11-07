--  Create a trigger on the sales table that prevents inserting a sale with a negative or zero amount. • Hint: Use BEFORE INSERT and SIGNAL SQLSTATE.
delimiter //
create trigger prevent_insertion
before insert on sales
for each row
begin
if new.amount<= 0 then
signal sqlstate '45000'
set message_text = 'insert a positive sales amount';
end if;
end//
delimiter ;

-- Create an AFTER UPDATE trigger on the employees table that logs old and new salary values into a separate salary_audit table whenever an employee’s salary changes. 
-- create audit table
drop table salary_audit;
create table salary_audit(
autid_id int auto_increment primary key,
emp_id int ,
old_salary decimal(12,2),
new_salary decimal(12,2),
changed_at timestamp default current_timestamp,
action varchar(20)
); 

-- create after trigger
delimiter //
create trigger salary_update
after update on employees
for each row
begin
if old.salary <> new.salary then
insert into salary_audit(emp_id,old_salary,new_salary,action)
values(old.emp_id,old.salary,new.salary,'UPDATE');
end if;
end //

-- update salary
update employees set salary = 9654262 where emp_id = 3;

select * from salary_audit;

-- procedures
-- Write a procedure increase_salary that takes two inputs: a department ID and a percentage. It should increase the salary of all employees in that department by the given percentage.
drop procedure increase_salary
delimiter //
create procedure increase_salary(p_dept_id int, p_percentage int)
begin
update employees 
set salary = salary + (1*p_percentage/100)
where p_dept_id = dept_id;
end//

-- calling procedure
call increase_salary(2, 10);
select*from employees;

--  Write a procedure delete_old_sales that deletes all sales records older than 2023.
drop procedure delete_old_sales
delimiter //
create procedure delete_old_sales()
begin
delete from sales where year(sale_date) < 2023;
end//
delimiter ;

set sql_safe_updates=0
call delete_old_sales()
select*from sales

-- functions
--  Create a function tenure_months(emp_id) that returns the total number of months an employee has worked since their hire date.
drop function tenure_month
delimiter //
create function tenure_months(p_emp_id int)
returns int deterministic
begin
return(
select timestampdiff(month, hire_date, curdate()) from employees
where emp_id = p_emp_id);
end//
delimiter ;

select tenure_months(3);

drop function tenure_months


--  Create a function annual_bonus(salary) that calculates and returns a bonus amount equal to 10% of the salary.
delimiter //
create function annual_bonus(p_salary decimal(12,2))
returns decimal(12,2)
deterministic
begin
    return p_salary * 1.10;
end//
delimiter ;


-- cursors
-- Write a stored procedure using a cursor that goes through all employees in the employees table and displays their emp_id and first_name.
delimiter //
create procedure disp_emp()
begin
	declare p_emp_id int;
	declare p_first_name varchar(20);
	declare done INT DEFAULT 0;  

-- create cursor
DECLARE cur CURSOR FOR
select emp_id, first_name from employees;
 
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

open cur;
loop_rows:LOOP
fetch cur into p_emp_id, p_first_name;
if done=1 then
leave loop_rows;
end if;

select p_emp_id as emp_id, p_first_name as first_name;
end loop;
close cur;
end//
delimiter ;

call disp_emp();

-- Write a cursor-based procedure to calculate the total salary of all employees. The result should be displayed as a single value.
drop procedure total_salary
delimiter //
create procedure total_salary()
begin
declare total int;
declare p_salary int;
declare done int default 0;

declare sal_cur cursor for
select salary, emp_id from employees;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

open sal_cur;
loop_rows: LOOP
fetch sal_cur into p_salary, total;
if done=1 then
leave loop_rows;
end if;

end loop;
close sal_cur;

select sum(total) as total_salary;
end//
delimiter ;

call total_salary();

-- exception handling
-- eg1- handle division by zero
-- without a handler- 

delimiter //
create function safe_divide(a int, b int)
returns decimal(10,2)
deterministic
begin
	declare result decimal(10,2) default 0;
	
    -- if any sql error happens, set result = 0 instead of falling
    declare continue handler for sqlexception set result = 0;
    
    set result = a/b;
    return result;
end//

select safe_divide(10, 0);

-- procedure with exit handler for bad insert
delimiter //
create procedure insert_safe_sale(p_amp int, p_amount decimal(12,2))
begin
declare exit handler for sqlexception
begin
select 'error: sale insert failed' as msg;
rollback; -- undo if part of a transaction
end;

start transaction; -- open a transaction so changes can be rolled back if something fails

insert into sales(emp_id, sale_date, amount)
values(p_amp, curdate(), p_amount);
commit; -- if insert succeed changes are saved permanently
end//

call insert_safe_sale(2, -1000);

delimiter //
create procedure insert_with_warning()
begin 
	declare continue handler for sqlwarning
     select'warning occured, but continuing...' as msg;
     
     -- this might cause a warning
	insert into departments(dept_name) values (repeat('a', 200));
end//
delimiter ;

-- "if" statement for binary situation



use regexsql;
select e.emp_id, concat(e.first_name, ' ',  e.last_name) as full_name, 
coalesce(d.dept_name, "unassigned") as dept_name
from employees e
join departments d on e.dept_id = d.dept_id;

select e.emp_id, concat(e.first_name, ' ',  e.last_name) as full_name, ep.project_id, p.project_name
from employees e
join employee_projects ep on ep.emp_id = e.emp_id
join projects p on p.project_id = ep.project_id;

select p.project_id,p.project_name
from projects p
left join employee_projects ep
on p.project_id = ep.project_id
where ep.project_id is null;

SELECT e.emp_id, concat(e.first_name, ' ',  e.last_name) as full_name
FROM employees e
WHERE NOT EXISTS (
    SELECT 1
    FROM employee_projects ep
    WHERE ep.emp_id = e.emp_id
);

select avg(salary), d.dept_name from employees e
join departments d on d.dept_id = e.dept_id
group by d.dept_name;

select e.emp_id, e.salary, d.dept_name
from employees e
join departments d on d.dept_id = e.dept_id
where e.dept_id in (select dept_id
	from employees 
    where salary > 100000 AND dept_id is not null)
    
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
    
select sale_id,emp_id,sale_date,amount,
AVG(amount) OVER (PARTITION BY emp_id ORDER BY sale_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as moving_avg
from sales;

select dept_name, 
	SUM(e.salary) 
	from departments d
	Join employees e ON e.dept_id = d.dept_id
	Group by d. dept_name
	Having SUM(e.salary) > 200000

ALTER TABLE projects
ADD CONSTRAINT chk_budget_nonnegative
CHECK (budget >= 0);

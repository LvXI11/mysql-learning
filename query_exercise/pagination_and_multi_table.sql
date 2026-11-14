
#1.LIKE补测
SELECT employee_id, last_name FROM employees
WHERE last_name LIKE 'K%';

#MySQL中不严格区分大小写
SELECT employee_id, last_name FROM employees
WHERE last_name LIKE 'k%';

SELECT employee_id, last_name FROM employees
WHERE last_name LIKE '%a%';

SELECT employee_id, email FROM employees
WHERE email LIKE 'S%';

# _能替代一个任何字母
SELECT employee_id, last_name FROM employees
WHERE last_name LIKE '_a%';

#2.LIMIT 分页(pagenation)
SELECT employee_id, salary FROM employees
ORDER BY salary DESC
LIMIT 5;

SELECT employee_id, salary FROM employees
ORDER BY salary DESC
LIMIT 5 OFFSET 5;

SELECT employee_id, department_id, salary FROM employees
ORDER BY department_id, salary DESC
LIMIT 10 OFFSET 10;

#多表查询练习
#内连接：只显示匹配的上的
SELECT e.employee_id, e.last_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

#左外连接：保左表
SELECT e.employee_id, e.last_name, d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id;

#右外连接：保右表 
SELECT e.employee_id, e.last_name, d.department_name
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id;

#自连接
SELECT e1.last_name '员工', e2.last_name '上司'
FROM employees e1
JOIN employees e2 ON e1.manager_id = e2.employee_id;

SELECT  e.last_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.employee_id = 100;

SELECT e.employee_id, e.last_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name LIKE 'Sal%';

SELECT e.employee_id, e.last_name, j.job_title
FROM employees e
JOIN jobs j ON e.job_id = j.job_id;

SELECT e.employee_id, e.last_name, d.department_name, e.salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name LIKE 'Sal%'
ORDER BY e.salary DESC
LIMIT 5 OFFSET 5;


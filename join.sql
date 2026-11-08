#两表联查
SELECT e.employee_id, e.last_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

SELECT e.employee_id, e.last_name, d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id;

SELECT e.employee_id, e.last_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name LIKE 'Sal%';

SELECT e.last_name, d.department_name, e.salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
ORDER BY e.salary DESC
LIMIT 5 OFFSET 0;

SELECT e.employee_id, e.last_name, d.department_id
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
WHERE e.department_id IS NULL;

#三表联查
SELECT e.employee_id, e.last_name, d.department_name, j.job_title
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN jobs j ON e.job_id = j.job_id;

SELECT e.employee_id, e.last_name, d.department_name, j.job_title
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN jobs j ON e.job_id = j.job_id
WHERE salary > 8000;

#非等值连接 + USING
SELECT e.employee_id, e.last_name, e.salary, j.grade_level
FROM employees e
JOIN job_grades j ON e.salary BETWEEN j.lowest_sal AND j.highest_sal;

SELECT e.employee_id, e.last_name, e.salary, j.grade_level
FROM employees e
JOIN job_grades j ON e.salary BETWEEN j.lowest_sal AND j.highest_sal
WHERE e.salary BETWEEN 15000 AND 24999;

SELECT e.employee_id, e.last_name, d.department_name
FROM employees e
JOIN departments d USING(department_id);

SELECT e.employee_id, e.last_name, d.department_name
FROM employees e
RIGHT JOIN departments d USING(department_id)
WHERE e.employee_id IS NULL;

#7种JOIN

#7.1内连接
SELECT e.employee_id, e.last_name, d.department_name
FROM employees e
JOIN departments d USING(department_id);

#7.2左外连接
SELECT e.employee_id, e.last_name, d.department_name
FROM employees e
LEFT JOIN departments d USING(department_id);

#7.3右外连接
SELECT e.employee_id, e.last_name, d.department_name
FROM employees e
RIGHT JOIN departments d USING(department_id);

#7.4.左独
SELECT e.employee_id, e.last_name, d.department_name
FROM employees e
LEFT JOIN departments d USING(department_id)
WHERE d.department_id IS NULL;

#7.5右独
SELECT e.employee_id, e.last_name, d.department_name
FROM employees e
RIGHT JOIN departments d USING(department_id)
WHERE e.department_id IS NULL;

#7.6满连接 = 内连接 + 左独 + 右独
SELECT e.employee_id, e.last_name, d.department_name
FROM employees e
JOIN departments d USING(department_id)
UNION ALL 
SELECT e.employee_id, e.last_name, d.department_name
FROM employees e
RIGHT JOIN departments d USING(department_id)
WHERE e.department_id IS NULL
UNION ALL
SELECT e.employee_id, e.last_name, d.department_name
FROM employees e
LEFT JOIN departments d USING(department_id)
WHERE e.department_id IS NULL;

#7.7外部排除连接 = 左独 + 右独
SELECT e.employee_id, e.last_name, d.department_name
FROM employees e
LEFT JOIN departments d USING(department_id)
WHERE e.department_id IS NULL
UNION ALL
SELECT e.employee_id, e.last_name, d.department_name
FROM employees e
RIGHT JOIN departments d USING(department_id)
WHERE e.department_id IS NULL;


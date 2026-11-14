# 1	查询工资最低的员工信息：last_name、salary	1 行：Olson 2100

SELECT last_name, salary
FROM employees 
WHERE salary = (SELECT MIN(salary)
				FROM employees );

# 2	查询平均工资最低的部门信息	部门 50（avg 3475.56）

SELECT *
FROM departments 
WHERE department_id = (SELECT department_id
FROM employees 
GROUP BY department_id 
ORDER BY AVG(salary) ASC 
LIMIT 1);

# 3	查询平均工资最低的部门信息和该部门的平均工资	部门 50 + 3475.56

SELECT *, (SELECT ROUND(AVG(salary), 2) FROM employees WHERE department_id = d.department_id ) AS avg
FROM departments d
WHERE department_id = (SELECT department_id
FROM employees 
GROUP BY department_id 
ORDER BY AVG(salary) ASC 
LIMIT 1);

# 4	查询平均工资最高的 job 信息	AD_PRES（avg 24000）

SELECT *
FROM jobs
WHERE job_id = (SELECT job_id
FROM employees 
GROUP BY job_id
ORDER BY AVG(salary) DESC 
LIMIT 1 );

# 5	查询平均工资高于公司平均工资的部门有哪些	8 行（NULL、20、40、70、80、90、100、110）

SELECT department_id 
FROM employees 
GROUP BY department_id 
HAVING AVG(salary) > (SELECT AVG(salary) FROM employees)

# 6	查询公司中所有 manager 的详细信息	18 人（manager_id 去重后再查员工）

SELECT *
FROM employees 
WHERE employee_id IN (SELECT DISTINCT manager_id
					FROM employees 
					WHERE manager_id IS NOT NULL );
 
# 7	各部门中最高工资中最低的那个部门的最低工资	4400（部门 10）

SELECT MIN(salary) 
FROM employees 
WHERE department_id = (SELECT department_id
FROM employees 
GROUP BY department_id 
ORDER BY MAX(salary) ASC
LIMIT 1 );

# 8	查询平均工资最高的部门的 manager 的详细信息：last_name、department_id、email、salary	K_ing / 90 / SKING / 24000 
SELECT last_name, department_id, email, salary
FROM employees 
WHERE employee_id = (SELECT manager_id 
						FROM departments 
						WHERE department_id = (SELECT department_id
												FROM employees 
												GROUP BY department_id 
												ORDER BY AVG(salary) DESC
												LIMIT 1 ) 
					);

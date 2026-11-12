#1.单行子查询

#1.1 WHERE里的单行子查询
SELECT employee_id, last_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary)
				FROM employees
				);

SELECT employee_id, last_name, salary
FROM employees
WHERE salary = (SELECT MIN(salary) FROM employees);

SELECT employee_id, last_name, salary
FROM employees
WHERE salary > (SELECT salary FROM employees WHERE employee_id = 100);


SELECT employee_id, last_name, job_id
FROM employees
WHERE job_id = (SELECT job_id FROM employees WHERE employee_id = 100);

SELECT employee_id, last_name
FROM employees
WHERE department_id = (SELECT department_id FROM employees WHERE employee_id = 100);

SELECT employee_id, salary
FROM employees
WHERE salary > (SELECT salary FROM employees WHERE employee_id = 132);

SELECT employee_id, last_name
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees WHERE department_id = 90);

#1.2 SELECT里的标量子查询
SELECT employee_id, salary, (SELECT AVG(salary) FROM employees) AS 全公司平均工资
FROM employees
LIMIT 5;

SELECT employee_id, (SELECT COUNT(*) FROM employees) AS 总人数
FROM employees
LIMIT 5;

#1.3 FROM里的派生表子查询
SELECT department_id, 人数, 平均工资
FROM (
	  SELECT department_id,
			 COUNT(*) AS 人数,
			 ROUND(AVG(salary), 2) AS 平均工资
	  FROM employees
	  GROUP BY department_id
) t
WHERE t.平均工资 > 10000;

SELECT department_id, 人数
FROM (
		SELECT department_id,
		COUNT(*) AS 人数
		FROM employees
		GROUP BY department_id
) t
WHERE t.人数 > 30;
#1.4 HAVING里的子表查询

SELECT department_id
FROM employees
GROUP BY department_id
HAVING AVG(salary) > (SELECT AVG(salary)
					  FROM employees);

SELECT department_id
FROM employees
GROUP BY department_id
HAVING count(*) > 5 AND AVG(salary) > (SELECT AVG(salary)
									   FROM employees);
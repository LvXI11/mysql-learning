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

#review
SELECT employee_id, last_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary)
			    FROM employees);

SELECT department_id, last_name
FROM employees
WHERE department_id = (SELECT department_id
					   FROM employees
					   WHERE employee_id = 100);

SELECT department_id , 人数
FROM (SELECT department_id, COUNT(*) AS 人数
	  FROM employees
	  GROUP BY department_id) t
WHERE t.人数 > 30;

#2.多行子查询

# M1. 查工资等于部门 90 任意员工工资的员工（用 IN 子查询）→ 3 行

SELECT employee_id, last_name, salary
FROM employees
WHERE salary IN (SELECT salary
				 FROM employees
				 WHERE department_id = 90);

# M2. 查工资高于部门 90 任一员工工资（> ANY）→ 1 行（只有 King）

SELECT employee_id, last_name, salary
FROM employees
WHERE salary > ANY (SELECT salary
					FROM employees
					WHERE department_id = 90);

# M3. 查工资高于部门 90 所有员工工资（> ALL）→ 0 行

SELECT employee_id, last_name, salary
FROM employees
WHERE salary > ALL (SELECT salary
					FROM employees
					WHERE department_id = 90);

# M4. 查工资低于部门 90 所有员工工资（< ALL）→ 104 行

SELECT employee_id, last_name, salary
FROM employees
WHERE salary < ALL (SELECT salary
					FROM employees
					WHERE department_id = 90);

# M5. 查部门 60 的员工（子查询：IN (SELECT department_id FROM employees WHERE job_id = 'IT_PROG')）→ 5 行

SELECT department_id, last_name
FROM employees
WHERE department_id  IN (select department_id
						FROM employees
						WHERE job_id = 'IT_PROG');

# M6. 查部门编号出现在 departments 106 行

SELECT department_id
FROM employees e1
WHERE EXISTS (SELECT department_id
							FROM employees e2
							WHERE e2.department_id = e1.department_id);
#这个不会

# M7. 查不在部门 90 的员工（NOT IN）→ 103 行（注意：比"107−90 部门的 3 人"少 1，因为 NULL 部门那人不满足 NOT IN）
SELECT employee_id
FROM employees 
WHERE department_id  NOT IN (SELECT department_id 
						  FROM employees 
						  WHERE department_id = 90);

# M8. 查不在部门 90 且工资 > 8000 的员工 → 30 行

SELECT last_name, salary
FROM employees 
WHERE department_id NOT IN (SELECT department_id 
							FROM employees 
							WHERE department_id = 90)
AND salary > 8000;

# M9. 查工资等于部门 90 工资集合、但部门本身不是 90 的员工 → 0 行
SELECT last_name, salary
FROM employees 
WHERE salary IN (SELECT salary
				  FROM employees
				  WHERE department_id = 90
				  AND department_id <> 90);
#这个不会

# M10. 把 M1 改写成 = ANY (子查询)，结果应和 M1 一样 → 3 行

SELECT employee_id, last_name, salary
FROM employees
WHERE salary = ANY (SELECT salary
				 FROM employees
				 WHERE department_id = 90);

#1	查询和 Zlotkey 相同部门的员工姓名和工资	34 行（Zlotkey 在部门 80，部门 80 共 34 人，含本人）
SELECT last_name, salary
FROM employees 
WHERE department_id = (SELECT department_id 
					   FROM employees 
					   WHERE employees.last_name = 'Zlotkey');

#2	查询工资比公司平均工资高的员工的员工号、姓名和工资	51 行（结合聚合子查询）
SELECT employee_id, last_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary)
				FROM employees);

#3	查询各部门中工资比本部门平均工资高的员工的员工号、姓名和工资	38 行（相关子查询）
SELECT employee_id, last_name, salary
FROM employees e1
WHERE salary > (SELECT AVG(salary)
				FROM employees e2
				WHERE e1.department_id = e2.department_id );
#不会

#4	查询和姓名中包含字母 u 的员工在相同部门的员工的员工号和姓名	姓名含 u 的有 19 人；答案 96 行（IN 多行子查询）
SELECT employee_id, last_name
FROM employees 
WHERE department_id IN (SELECT department_id 
						FROM employees 
						WHERE last_name LIKE '%u%');

#不会

#5	查询在部门 location_id 为 1700 的部门工作的员工的员工号	18 行（IN + 子查询找部门号）
SELECT employee_id
FROM employees
WHERE department_id in (SELECT department_id 
					   FROM departments 
					   WHERE location_id = 1700);
#不会

#6	查询管理者是 King 的员工姓名和工资	14 行 ⚠️ 注意：本库中 King 的 last_name 是 K_ing（带下划线），
#	写 = 'King' 子查询返回空 → 0 行；用 last_name = 'K_ing' 或 employee_id = 100

SELECT last_name, salary
FROM employees 
WHERE manager_id = (SELECT employee_id 
					FROM employees 
					WHERE employee_id = 100);

/*7
 *查询工资最高的员工的姓名，要求 first_name 和 last_name 显示为一列，列名为「姓名」	1 行，
 *姓名 = StevenK_ing（CONCAT(first_name, last_name)，中间要不要空格看你）
 */

SELECT CONCAT(first_name, ' ', last_name) AS  姓名
FROM employees 
WHERE salary >= (SELECT MAX(salary)
				 FROM employees);

SELECT CONCAT(first_name, ' ', last_name) AS  姓名
FROM employees 
WHERE salary >= ALL (SELECT salary
				 FROM employees);
#相关查询
#C1. 查工资等于本部门最高工资的员工（employee_id、last_name、salary）→ 11 行

SELECT employee_id, last_name, salary
FROM employees e1
WHERE salary = (SELECT MAX(salary)
					 FROM employees e2
					 WHERE e1.department_id = e2.department_id );

SELECT employee_id, last_name, salary
FROM employees e1
WHERE salary >= ALL (SELECT salary
					 FROM employees e2
					 WHERE e1.department_id = e2.department_id );
#怎么这里有12行
#解释：salary > 空集 恒为TRUE (178	Grant	7000.0) 的department_id = NULL 
#空集 != NULL NULL参与运算值为NULL

#C2. 查工资高于本部门最高工资的员工 → 0 行（请思考：为什么必然是 0）

SELECT employee_id, last_name, salary
FROM employees e1
WHERE salary > (SELECT MAX(salary)
					 FROM employees e2
					 WHERE e1.department_id = e2.department_id );
#因为最高工资的员工工资已经是最高的了，没有比他的工资高的了

#C3. 查工资低于本部门平均工资的员工 → 65 行 
#（和今天作业 Q3 的 38 行正好互补：高于 38 + 低于 65 = 103，剩下的 4 人是"恰好等于本部门平均"或部门为 NULL 被排除）

SELECT employee_id
FROM employees e1
WHERE salary < (SELECT AVG(salary)
				FROM employees e2
				WHERE e1.department_id = e2.department_id );

#C4. 查工资等于本部门最低工资的员工 → 12 行

SELECT department_id, salary 
FROM employees e1
WHERE salary = (SELECT MIN(salary)
				FROM employees e2
				WHERE e1.department_id = e2.department_id );

#C5. 查所在部门人数 > 5 的员工（子查询里用 COUNT(*)）→ 91 行 （提示：部门 30/50/80/100 人数超过 5）
SELECT employee_id
FROM employees
WHERE department_id IN (SELECT department_id 
					   FROM employees
					   GROUP BY department_id 
					   HAVING COUNT(*) > 5);

#C6. 查有员工的部门（用 EXISTS，从 departments 视角）→ 11 行

SELECT  d.department_id
FROM  departments d
WHERE EXISTS (SELECT *  
			  FROM employees e2
			  WHERE d.department_id = e2.department_id 
			  );

#C7. 查没有员工的部门（用 NOT EXISTS）→ 16 行

SELECT department_id
FROM departments d
WHERE NOT EXISTS (SELECT *
				  FROM employees e2 
				  WHERE d.department_id = e2.department_id );
#这个不会

#C8. 查「同部门里存在比自己工资高的人」的员工（用 EXISTS）→ 95 行 （提示：部门内工资不是最高的那些人）

SELECT employee_id, salary
FROM employees e1
WHERE EXISTS (SELECT *
			  FROM employees e2
			  WHERE e1.department_id = e2.department_id 
			  AND e1.salary < e2.salary );

#不会

#C9. 查「工资 > 本部门平均」且「本部门人数 > 5」的员工 → 33 行

SELECT employee_id, salary
FROM employees e1
WHERE salary > (SELECT AVG(salary)
				FROM employees e2
				WHERE e1.department_id = e2.department_id )
AND (SELECT COUNT(*)
	 FROM employees e3
	 WHERE e1.department_id = e3.department_id ) > 5;


#不会

#C10. 每个员工显示 employee_id、salary、本部门平均工资（相关子查询放 SELECT 列表）→ 107 行
SELECT employee_id, salary, (SELECT ROUND(AVG(salary), 2)
							FROM employees e2
							WHERE e1.department_id = e2.department_id ) AS 本部门平均工资 
FROM employees e1;

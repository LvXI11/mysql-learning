#基础的查询操作
SELECT * FROM employees;

SELECT employee_id '员工编号', first_name '名', last_name '姓', salary  "Annual Salary"
FROM employees;

SELECT employee_id '员工编号', first_name '名', last_name '姓', salary '月薪'
FROM employees;

SELECT department_id
FROM employees;

SELECT DISTINCT department_id
FROM employees;

SELECT COUNT(DISTINCT department_id)
FROM employees;

SELECT DISTINCT department_id, job_id
FROM employees;

SELECT salary * 12 * (1 + commission_pct)
FROM employees;

SELECT salary * 12 * (1 + IFNULL(commission_pct, 0))
FROM employees;

SELECT * FROM employees
WHERE commission_pct IS NULL;

SELECT * FROM employees
WHERE commission_pct IS NOT NULL;

SELECT * FROM employees
WHERE commission_pct IS NOT NULL OR commission_pct IS NULL;

SELECT COUNT(*)  FROM (SELECT commission_pct IS NOT NULL FROM employees) t;

SELECT employee_id '工号', salary '薪资'
FROM employees
ORDER BY salary DESC;

SELECT employee_id '工号', salary '薪资'
FROM employees
ORDER BY salary;

SELECT department_id '部门', employee_id '工号', salary '薪资'
FROM employees
ORDER BY department_id, salary DESC;

SELECT salary FROM employees
WHERE salary > 8000
ORDER BY salary;

SELECT job_id FROM employees
WHERE job_id != 'IT_PROG';

SELECT job_id FROM employees
WHERE job_id <> 'IT_PROG';

SELECT salary FROM employees
WHERE salary BETWEEN 3000 AND 7000
ORDER BY salary ;

SELECT department_id FROM employees
WHERE department_id IN (10, 20, 30);

SELECT salary, department_id FROM employees
WHERE salary > 8000 AND department_id = 90;

SELECT salary, department_id FROM employees
WHERE salary > 10000 OR department_id = 90;

SELECT employee_id, last_name, salary, department_id FROM employees
WHERE (department_id = 90 OR salary > 8000) AND job_id <> 'IT_PROG'
ORDER BY salary DESC;

#基于基础查询练习后的混合查询操作

#1.NULL + 逻辑 + 排序
SELECT employee_id, last_name, salary, commission_pct FROM employees
WHERE salary > 8000 AND commission_pct IS NOT NULL
ORDER BY salary DESC;

#2.IN + 比较 + 双字段排序
SELECT employee_id, department_id, salary FROM employees
WHERE (department_id = 80 OR department_id = 90) AND salary > 10000
ORDER BY department_id ASC, salary DESC ;

#3.BETWEEN + 排序
SELECT employee_id, commission_pct FROM employees
WHERE commission_pct BETWEEN 0.15 AND 0.3
ORDER BY commission_pct DESC;

#4.复合逻辑
SELECT employee_id, job_id, salary, commission_pct FROM employees
WHERE job_id <> 'IT_PROG' AND job_id <> 'SA_REP' AND (salary > 9000 OR commission_pct IS NOT NULL);

#5.DISTINCT + WHERE
SELECT DISTINCT department_id FROM employees
WHERE salary > 15000;

SELECT employee_id, last_name, salary
FROM employees
WHERE salary > 15000;

#6.算术表达式
SELECT employee_id, salary, salary * 12 '年薪' FROM employees
WHERE salary * 12 > 120000
ORDER BY salary * 12 DESC;
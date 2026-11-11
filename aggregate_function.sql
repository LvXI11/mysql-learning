#1.COUNT 计算多少行 COUNT 计算的是非NULL的行数
SELECT COUNT(employee_id)
FROM employees;

SELECT COUNT(*)
FROM employees;

SELECT COUNT(IFNULL(commission_pct, 0))
FROM employees;

SELECT COUNT(commission_pct)
FROM employees;

SELECT COUNT(DISTINCT department_id)
FROM employees;

#2.在列表中找最值 MAX / MIN
SELECT MAX(salary) AS 最高工资, MIN(salary) AS 最低工资
FROM employees;

#3.AVG 求列表的平均值
SELECT ROUND(AVG(salary), 2)
FROM employees;

#4.SUM 计算列表的总和
SELECT SUM(salary)
FROM employees;

SELECT AVG(salary), SUM(salary) / COUNT(*), SUM(salary) / COUNT(commission_pct)
FROM employees;

#5.GROUP BY
#这个有点不明白，给我讲讲sql语句的执行顺序
SELECT department_id, COUNT(*) AS 人数
FROM employees
GROUP BY department_id
ORDER BY department_id ASC;

SELECT job_id, COUNT(*) AS 人数
FROM employees
GROUP BY job_id;


SELECT department_id, job_id, COUNT(employee_id) AS 人数
FROM employees
GROUP BY department_id, job_id;

SELECT department_id, COUNT(employee_id) AS 人数, SUM(salary) AS 总工资, ROUND(AVG(salary), 2) AS 平均工资
FROM employees
GROUP BY department_id;

#6.HAVING
SELECT department_id, COUNT(*) AS 人数
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 10;

SELECT department_id, COUNT(*) AS 人数
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 40;

SELECT department_id, COUNT(*) AS 人数
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
HAVING COUNT(*) > 30;

SELECT department_id, AVG(salary) AS 平均工资
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 12000;
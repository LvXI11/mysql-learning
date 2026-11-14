#1.IF
SELECT employee_id, salary, IF(salary >= 8000, '高薪', '普通') AS 挡位
FROM employees LIMIT 5;

#2.IFNULL
SELECT employee_id, commission_pct, IFNULL(commission_pct, 0) AS 提成
FROM employees LIMIT 5;

#3. CASE WHEN
SELECT employee_id, salary,
	CASE WHEN salary < 5000 THEN '低'
		 WHEN salary < 10000 THEN '中'
		 ELSE '高' END AS 工资档
FROM employees LIMIT 10;


#1.当前时间
SELECT NOW(), SYSDATE(), CURDATE(), CURTIME(), CURRENT_TIMESTAMP;

#2.提取日期的属性
SELECT employee_id, hiredate, YEAR(hiredate), MONTH(hiredate), DAY(hiredate), DAYOFWEEK(hiredate)
FROM employees
WHERE employee_id = 100;

#3.格式化
SELECT DATE_FORMAT('2006-11-11', '%Y年%m月%d日'), DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s');

#4.字符串转日期 + 相隔天数
SELECT STR_TO_DATE('2006-11-11', '%Y-%m-%d'), DATEDIFF('2006-11-11','2003-06-13');

#5.日期相加减
SELECT hiredate, DATE_ADD(hiredate, INTERVAL 1 YEAR) AS 一年后,
	   DATE_SUB(hiredate, INTERVAL 30 DAY) AS 30天前
FROM employees
WHERE employee_id = 100;

#6.时间戳互转
SELECT UNIX_TIMESTAMP('2026-11-10 00:00:00'), FROM_UNIXTIME(UNIX_TIMESTAMP());

